import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AgriHelplineButton extends StatelessWidget {
  final String phoneNumber;
  final String label;

  const AgriHelplineButton({
    super.key,
    required this.phoneNumber,
    this.label = "Call Agriculture Helpline",
  });

  Future<void> _call(BuildContext context) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to make a phone call"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _call(context),
      icon: const Icon(Icons.call),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
