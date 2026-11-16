import 'package:flutter/material.dart';

import 'labels.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(text.privacyPolicy)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final paragraph in [
            text.policyData,
            text.localPrivacy,
            text.policyNotifications,
            text.policyWeb,
            text.backupPlaintext,
            text.policyDeletion,
            text.appProtection,
            text.policyMedicalLimitations,
            text.policyContact,
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SelectableText(paragraph),
            ),
        ],
      ),
    );
  }
}
