import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool _showQuickActions = true; // Trạng thái hiển thị của _buildQuickActions

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showQuickActions = false; // Ẩn _buildQuickActions khi bấm ra ngoài
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.support),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              if (_showQuickActions) _buildQuickActions(context), // Hiển thị QuickActions dựa trên trạng thái
              _buildFAQSection(context),
              _buildContactSupport(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      color: theme.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.howCanWeHelp,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.supportDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.quickActions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                icon: Ionicons.book_outline,
                label: localizations.userGuide,
                onTap: () {
                  // TODO: Implement user guide action
                },
              ),
              _buildActionButton(
                context,
                icon: Ionicons.videocam_outline,
                label: localizations.videoTutorials,
                onTap: () {
                  // TODO: Implement video tutorials action
                },
              ),
              _buildActionButton(
                context,
                icon: Ionicons.chatbubble_outline,
                label: localizations.liveChatSupport,
                onTap: () {
                  // TODO: Implement live chat support action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.frequentlyAskedQuestions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildFAQItem(context, localizations.faqQuestion1, localizations.faqAnswer1),
          _buildFAQItem(context, localizations.faqQuestion2, localizations.faqAnswer2),
          _buildFAQItem(context, localizations.faqQuestion3, localizations.faqAnswer3),
          TextButton(
            onPressed: () {
              // TODO: Implement view all FAQs action
            },
            child: Text(localizations.viewAllFAQs),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: Theme.of(context).textTheme.titleMedium),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      color: theme.colorScheme.secondaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localizations.stillNeedHelp,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Ionicons.mail_outline),
            label: Text(localizations.contactSupport),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              // TODO: Implement contact support action
            },
          ),
        ],
      ),
    );
  }
}
