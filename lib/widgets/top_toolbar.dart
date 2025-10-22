// lib/widgets/top_toolbar.dart

import 'package:figma_editor/l10n/app_localizations.dart';

import '../state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/locale_provider.dart';
import '../models/models.dart';
import 'common_widgets.dart';
import 'language_selector.dart';

class TopToolbar extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;
  final VoidCallback onMenuTap;

  const TopToolbar({
    Key? key,
    required this.isTablet,
    required this.isDesktop,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Menu button (mobile)
          if (!isTablet)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
              tooltip: localizations.menu,
            ),

          // File name dropdown
          _FileNameDropdown(),

          const Spacer(),

          // Center tools (desktop only)
          if (isDesktop) const _CenterToolsBar(),

          const Spacer(),

          // Right actions
          const _RightActions(),
        ],
      ),
    );
  }
}

// ============================================================
// FILE NAME DROPDOWN
// ============================================================
class _FileNameDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final projectName =
            appState.currentProject?.name ?? localizations.untitled;

        return PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'rename':
                _showRenameDialog(context, projectName);
                break;
              case 'duplicate':
                print('Duplicate project');
                break;
              case 'export':
                print('Export project');
                break;
              case 'settings':
                print('Project settings');
                break;
            }
          },
          offset: const Offset(0, 45),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.grid_view, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  projectName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 16),
                  const SizedBox(width: 8),
                  Text(localizations.rename),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  const Icon(Icons.content_copy, size: 16),
                  const SizedBox(width: 8),
                  Text(localizations.duplicate),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  const Icon(Icons.download, size: 16),
                  const SizedBox(width: 8),
                  Text(localizations.export),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  const Icon(Icons.settings, size: 16),
                  const SizedBox(width: 8),
                  Text(localizations.settings),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, String currentName) {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.renameProject),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: localizations.projectName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              // Update project name
              print('New name: ${controller.text}');
              Navigator.pop(context);
            },
            child: Text(localizations.rename),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CENTER TOOLS BAR
// ============================================================
class _CenterToolsBar extends StatelessWidget {
  const _CenterToolsBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ToolConstants.allTools.map((tool) {
              return ToolButton(
                icon: tool.icon,
                tooltip: '${tool.name} (${tool.shortcut})',
                isSelected: appState.selectedTool == tool.type,
                onTap: () {
                  appState.selectTool(tool.type);
                  print('Selected tool: ${tool.name}');
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// ============================================================
// RIGHT ACTIONS
// ============================================================
class _RightActions extends StatelessWidget {
  const _RightActions();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Prototype button
        TextButton.icon(
          icon: const Icon(Icons.play_arrow, size: 18),
          label: Text(localizations.prototype),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          onPressed: () {
            print('Prototype mode');
            // Navigate to prototype mode
          },
        ),

        const SizedBox(width: 8),

        // Share button
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'copy_link':
                print('Copy link to clipboard');
                break;
              case 'invite':
                print('Invite collaborators');
                break;
              case 'publish':
                print('Publish to web');
                break;
              case 'export':
                print('Export project');
                break;
            }
          },
          offset: const Offset(0, 45),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Text(
                  localizations.share,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'copy_link',
              child: Row(
                children: [
                  Icon(Icons.link, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.copyLink),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'invite',
              child: Row(
                children: [
                  Icon(Icons.person_add, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.inviteCollaborators),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'publish',
              child: Row(
                children: [
                  Icon(Icons.public, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.publishToWeb),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.export),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Language selector
        const CompactLanguageSelector(iconColor: Colors.grey),

        // User profile menu
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'profile':
                print('Open profile');
                break;
              case 'settings':
                print('Open settings');
                break;
              case 'help':
                print('Open help');
                break;
              case 'logout':
                print('Logout');
                break;
            }
          },
          offset: const Offset(0, 45),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.purple.shade400,
            child: const Text(
              'Y',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.profile),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.settings),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.help),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 16),
                  SizedBox(width: 8),
                  Text(localizations.logout),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
