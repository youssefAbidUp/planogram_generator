// lib/widgets/language_selector.dart
// Reusable language selector component

import 'package:figma_editor/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  final bool showLabel;
  final bool isCompact;
  final Color? iconColor;
  final Color? textColor;

  const LanguageSelector({
    Key? key,
    this.showLabel = true,
    this.isCompact = false,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final currentLocale =
            localeProvider.locale ?? Localizations.localeOf(context);

        if (isCompact) {
          return _buildCompactSelector(context, localeProvider, currentLocale);
        } else {
          return _buildFullSelector(context, localeProvider, currentLocale);
        }
      },
    );
  }

  Widget _buildCompactSelector(
    BuildContext context,
    LocaleProvider localeProvider,
    Locale currentLocale,
  ) {
    return PopupMenuButton<Locale>(
      icon: Icon(
        Icons.language,
        color: iconColor ?? Colors.grey.shade700,
        size: 20,
      ),
      tooltip: AppLocalizations.of(context)!.selectLanguage,
      onSelected: (locale) {
        localeProvider.setLocale(locale);
      },
      itemBuilder: (context) => _buildLanguageMenuItems(context, currentLocale),
    );
  }

  Widget _buildFullSelector(
    BuildContext context,
    LocaleProvider localeProvider,
    Locale currentLocale,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            color: iconColor ?? Colors.grey.shade700,
            size: 18,
          ),
          if (showLabel) ...[
            const SizedBox(width: 8),
            Text(
              _getLanguageDisplayName(context, currentLocale),
              style: TextStyle(
                color: textColor ?? Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(width: 4),
          PopupMenuButton<Locale>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: iconColor ?? Colors.grey.shade700,
              size: 18,
            ),
            tooltip: AppLocalizations.of(context)!.selectLanguage,
            onSelected: (locale) {
              localeProvider.setLocale(locale);
            },
            itemBuilder: (context) =>
                _buildLanguageMenuItems(context, currentLocale),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<Locale>> _buildLanguageMenuItems(
    BuildContext context,
    Locale currentLocale,
  ) {
    final languages = [
      {
        'locale': const Locale('en'),
        'name': AppLocalizations.of(context)!.english,
        'flag': '🇺🇸',
      },
      {
        'locale': const Locale('fr'),
        'name': AppLocalizations.of(context)!.french,
        'flag': '🇫🇷',
      },
      {
        'locale': const Locale('ar'),
        'name': AppLocalizations.of(context)!.arabic,
        'flag': '🇸🇦',
      },
    ];

    return languages.map((lang) {
      final locale = lang['locale'] as Locale;
      final isSelected = locale.languageCode == currentLocale.languageCode;

      return PopupMenuItem<Locale>(
        value: locale,
        child: Row(
          children: [
            Text(lang['flag'] as String, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Text(
              lang['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : null,
              ),
            ),
            if (isSelected) ...[
              const Spacer(),
              Icon(Icons.check, color: Colors.blue, size: 16),
            ],
          ],
        ),
      );
    }).toList();
  }

  String _getLanguageDisplayName(BuildContext context, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizations.of(context)!.english;
      case 'fr':
        return AppLocalizations.of(context)!.french;
      case 'ar':
        return AppLocalizations.of(context)!.arabic;
      default:
        return AppLocalizations.of(context)!.english;
    }
  }
}

// Compact version for use in toolbars
class CompactLanguageSelector extends StatelessWidget {
  final Color? iconColor;

  const CompactLanguageSelector({Key? key, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LanguageSelector(
      isCompact: true,
      showLabel: false,
      iconColor: iconColor,
    );
  }
}

// Full version for use in settings or dedicated language selection areas
class FullLanguageSelector extends StatelessWidget {
  final bool showLabel;
  final Color? iconColor;
  final Color? textColor;

  const FullLanguageSelector({
    Key? key,
    this.showLabel = true,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LanguageSelector(
      isCompact: false,
      showLabel: showLabel,
      iconColor: iconColor,
      textColor: textColor,
    );
  }
}
