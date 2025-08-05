import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/profile/view_model/profile_view_model.dart';
import 'package:racecourse_tracks/utils/request_state.dart';

class DeleteAccountDialog extends StatefulWidget {
  final ProfileViewModel viewModel;

  const DeleteAccountDialog({
    super.key,
    required this.viewModel,
  });

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  @override
  void dispose() {
    widget.viewModel.passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteAccount() async {
    if (widget.viewModel.showPasswordField) {
      await widget.viewModel.reauthenticateWithPassword(
        widget.viewModel.passwordController.text,
      );
    }
    final deleted = await widget.viewModel.deleteAccount();
    if (mounted && deleted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete Account',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (widget.viewModel.showPasswordField) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'For security reasons, please enter your password:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: widget.viewModel.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (widget.viewModel.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Text(
                        widget.viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
      actions: [
        TextButton(
          onPressed: widget.viewModel.isReauthenticating
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              widget.viewModel.isReauthenticating ? null : _handleDeleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: widget.viewModel.isReauthenticating ||
                  widget.viewModel.deleteAccountRequestState ==
                      RequestState.pending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(widget.viewModel.showPasswordField
                  ? 'Confirm Delete'
                  : 'Delete Account'),
        ),
      ],
    );
  }
}
