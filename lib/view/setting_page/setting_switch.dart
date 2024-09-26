import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingSwitch extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final ThemeMode currentMode; // Thay đổi từ bool thành ThemeMode
  final Function(ThemeMode mode)
      onModeChange; // Thay đổi từ bool thành ThemeMode
  final VoidCallback onSystemModeTap;

  const SettingSwitch({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.currentMode,
    required this.onModeChange,
    required this.onSystemModeTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              PopupMenuButton<ThemeMode>(
                onSelected: onModeChange,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ThemeMode.light,
                    child: Text(AppLocalizations.of(context)!.lightMode),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.dark,
                    child: Text(AppLocalizations.of(context)!.darkMode),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.system,
                    child: Text(AppLocalizations.of(context)!.deviceMode),
                  ),
                ],
                child: Row(
                  children: [
                    Text(
                      _getModeText(context, currentMode),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getModeText(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkMode;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightMode;
      case ThemeMode.system:
        return AppLocalizations.of(context)!.deviceMode;
      default:
        return AppLocalizations.of(context)!.defaultMode;
    }
  }
}
