/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onCall } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const logger = require("firebase-functions/logger");
const axios = require('axios');
const { defineString } = require("firebase-functions/params");
const openWeatherApiKey = defineString("OPENWEATHER_API_KEY");

initializeApp();
const db = getFirestore();

exports.refreshRacecourse = onCall(async (request) => {
    logger.info("Refreshing racecourse data", { structuredData: true });
    if (request.auth === null || request.auth === undefined) {
        logger.error("Unauthorized access attempt", { structuredData: true });
        throw new Error("Unauthorized");
    }
    const racecourseId = request.data.racecourseId;
    const snapshot = await db.collection("racecourses").doc(racecourseId).get();
    if (!snapshot.exists) {
        logger.error(`Racecourse with ID ${racecourseId} does not exist`, { structuredData: true });
        throw new Error("Racecourse not found");
    }
    var racecourseData = snapshot.data();
    logger.info(`Refreshing racecourse data for ${racecourseId}`, { structuredData: true });
    const latitude = racecourseData.Latitude;
    const longitude = racecourseData.Longitude;
    const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${openWeatherApiKey.value()}`);
    if (response.status !== 200) {
        logger.error(`Failed to fetch weather data for racecourse ${racecourseId}`, { structuredData: true });
        throw new Error("Failed to fetch weather data");
    }
    const weatherData = response.data;
    const windDegree = weatherData.wind.deg;
    const windSpeed = weatherData.wind.speed * 3.6; // Convert m/s to km/h
    const windDirection = degreeToCardinal(windDegree);
    logger.info(`Wind degree: ${windDegree}`, { structuredData: true });
    const windArrow = getArrowSymbol(windDirection);

    // Update the designated columns in the same row
    const uom = "km/h"; // Unit of measurement for wind speed
    const windSpeedWithUOM = windSpeed.toFixed(1) + uom;
    const homeDirection = racecourseData.Home;
    const homeDeg = getAngleFromDirection(homeDirection);
    logger.info(`Wind direction: ${windDirection}`, { structuredData: true });
    const windRelHome = windDegree - homeDeg;
    logger.info(`Wind relative to home: ${windRelHome} degrees`, { structuredData: true });
    racecourseData = {
        ...racecourseData,
        "Wind Direction (Cardinals)": windDirection,
        "Wind Direction (Degrees)": windDegree,
        "Wind Direction Arrow": windArrow,
        "Wind Speed": windSpeedWithUOM,
        "Last updated": new Date().toISOString(),
        "HomeDeg": homeDeg,
        "WindRel_Home": windRelHome,
        "WindRel_HomeArrow": getArrowFromDegree(windRelHome),
        'weatherIcon': weatherData.weather[0].icon,
    };
    logger.info(`Updating racecourse data for ${racecourseId}:`, { structuredData: true });
    logger.info(racecourseData, { structuredData: true });
    await db.collection("racecourses").doc(racecourseId).update(racecourseData);
    return {...racecourseData, 'id': racecourseId};
});

function degreeToCardinal(windDegree) {
    if (windDegree === null || windDegree === undefined || isNaN(windDegree)) {
        logger.log("Don't run it manually. This function is intended to be triggered by another script or automation. Invalid or missing windDegree: " + windDegree);
        return "Unknown";
    }
    var directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
    var index = Math.round(windDegree / 22.5) % 16;
    return directions[index];
}

function getArrowSymbol(direction) {
    if (!direction) {
        logger.log("Don't run it manually. This function is intended to be triggered by another script or automation. No direction value provided.");
        return "→"; // Default to East
    }
    switch (direction) {
        case "N":
            return "↓";
        case "NNE":
            return "↙";
        case "NE":
            return "↙";
        case "ENE":
            return "↙";
        case "E":
            return "←";
        case "ESE":
            return "↖";
        case "SE":
            return "↖";
        case "SSE":
            return "↖";
        case "S":
            return "↑";
        case "SSW":
            return "↗";
        case "SW":
            return "↗";
        case "WSW":
            return "↗";
        case "W":
            return "→";
        case "WNW":
            return "↘";
        case "NW":
            return "↘";
        case "NNW":
            return "↘";
        default:
            return "→"; // Default to East if direction is not recognized
    }
}

function getAngleFromDirection(direction) {
    switch (direction) {
        case "N":
            return 0;
        case "NNE":
            return 22.5;
        case "NE":
            return 45;
        case "ENE":
            return 67.5;
        case "E":
            return 90;
        case "ESE":
            return 112.5;
        case "SE":
            return 135;
        case "SSE":
            return 157.5;
        case "S":
            return 180;
        case "SSW":
            return 202.5;
        case "SW":
            return 225;
        case "WSW":
            return 247.5;
        case "W":
            return 270;
        case "WNW":
            return 292.5;
        case "NW":
            return 315;
        case "NNW":
            return 337.5;
        default:
            logger.error("Invalid Home value", { structuredData: true });
            throw new Error("Invalid Home value");
    }
}

function getArrowFromDegree(degree) {
    const degrees = [0, 22.5, 45, 67.5, 90, 112.5, 135, 157.5, 180, 202.5, 225, 247.5, 270, 292.5, 315, 337.5];
    const closestDegree = degrees.reduce((prev, curr) => {
        return (Math.abs(curr - degree) < Math.abs(prev - degree) ? curr : prev);
    });
    switch(closestDegree) {
        case 0:
            return "↓";
        case 22.5:
            return "↙";
        case 45:
            return "↙";
        case 67.5:
            return "↙";
        case 90:
            return "←";
        case 112.5:
            return "↖";
        case 135:
            return "↖";
        case 157.5:
            return "↖";
        case 180:
            return "↑";
        case 202.5:
            return "↗";
        case 225:
            return "↗";
        case 247.5:
            return "↗";
        case 270:
            return "→";
        case 292.5:
            return "↘";
        case 315:
            return "↘";
        case 337.5:
            return "↘";
        case 360:
            return "↓";
        case 0:
            return "↓";
        case -22.5:
            return "↘";
        case -45:
            return "↘";
        case -67.5:
            return "↘";
        case -90:
            return "→";
        case -112.5:
            return "↗";
        case -135:
            return "↗";
        case -157.5:
            return "↗";
        case -180:
            return "↑";
        case -202.5:
            return "↖";
        case -225:
            return "↖";
        case -247.5:
            return "↖";
        case -270:
            return "←";
        case -292.5:
            return "↙";
        case -315:
            return "↙";
        case -337.5:
            return "↙";
        case -360:
            return "↓";
        default:
            return "→";
    }
}