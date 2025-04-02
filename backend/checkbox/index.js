import express from 'express';
import fs from 'fs/promises';
import path from 'path';
import process from 'process';
import { authenticate } from '@google-cloud/local-auth';
import { google } from 'googleapis';
const app = express();

// If modifying these scopes, delete token.json.
const SCOPES = ["https://www.googleapis.com/auth/script.external_request",
    "https://www.googleapis.com/auth/spreadsheets.currentonly",
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/script.scriptapp"];
// The file token.json stores the user's access and refresh tokens, and is
// created automatically when the authorization flow completes for the first
// time.
const TOKEN_PATH = path.join(process.cwd(), 'token.json');
const CREDENTIALS_PATH = path.join(process.cwd(), 'credentials.json');

/**
 * Reads previously authorized credentials from the save file.
 *
 * @return {Promise<OAuth2Client|null>}
 */
async function loadSavedCredentialsIfExist() {
    try {
        const content = await fs.readFile(TOKEN_PATH);
        const credentials = JSON.parse(content);
        return google.auth.fromJSON(credentials);
    } catch (err) {
        return null;
    }
}

/**
 * Serializes credentials to a file compatible with GoogleAuth.fromJSON.
 *
 * @param {OAuth2Client} client
 * @return {Promise<void>}
 */
async function saveCredentials(client) {
    const content = await fs.readFile(CREDENTIALS_PATH);
    const keys = JSON.parse(content);
    const key = keys.installed || keys.web;
    const payload = JSON.stringify({
        type: 'authorized_user',
        client_id: key.client_id,
        client_secret: key.client_secret,
        refresh_token: client.credentials.refresh_token,
    });
    await fs.writeFile(TOKEN_PATH, payload);
}

/**
 * Load or request or authorization to call APIs.
 *
 */
async function authorize() {
    let client = await loadSavedCredentialsIfExist();
    if (client) {
        return client;
    }
    client = await authenticate({
        scopes: SCOPES,
        keyfilePath: CREDENTIALS_PATH,
    });
    if (client.credentials) {
        await saveCredentials(client);
    }
    return client;
}

/**
 * 
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
async function callAppsScript(auth, rowNumber, value) {
    const scriptId = 'AKfycbyQEeRLMU5_lk7o7YmFwSGNQsARpmg2wbqM0oa1Puk_D0OJ-AqaTFxuqhmkigwtzTnGUA';
    const script = google.script({ version: 'v1', auth });
    try {
        // Make the API request. The request object is included here as 'resource'.
        const resp = await script.scripts.run({
            auth: auth,
            scriptId: scriptId,
            requestBody: {
                function: 'updateCheckbox',
                parameters: {
                    rowNumber,
                    value
                }
            }
        });
        if (resp.error) {
            // The API executed, but the script returned an error.

            // Extract the first (and only) set of error details. The values of this
            // object are the script's 'errorMessage' and 'errorType', and an array
            // of stack trace elements.
            const error = resp.error.details[0];
            console.log('Script error message: ' + error.errorMessage);
            console.log('Script error stacktrace:');

            if (error.scriptStackTraceElements) {
                // There may not be a stacktrace if the script didn't start executing.
                for (let i = 0; i < error.scriptStackTraceElements.length; i++) {
                    const trace = error.scriptStackTraceElements[i];
                    console.log('\t%s: %s', trace.function, trace.lineNumber);
                }
            }
        } else {
            console.log('Success!');
            //console.log(resp.data.error.details);
        }
    } catch (err) {
        // TODO(developer) - Handle error
        console.log(err);
    }
}

app.get('/', (req, res) => {
    authorize().then((auth) => {
        callAppsScript(auth, req.query.rowNumber, req.query.value)
    }).catch(console.error);
    res.send("Success");
});

const port = parseInt(process.env.PORT) || 8080;
app.listen(port, () => {
    console.log(`listening on port ${port}`);
});

