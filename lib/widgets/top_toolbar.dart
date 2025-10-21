// lib/widgets/top_toolbar.dart

import 'package:flutter/material.dart';
import 'package:planogram_generator/state/app_state.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'common_widgets.dart';

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
              tooltip: 'Menu',
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
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final projectName = appState.currentProject?.name ?? 'Untitled';

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
            const PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.content_copy, size: 16),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, size: 16),
                  SizedBox(width: 8),
                  Text('Export'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 16),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Project Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update project name
              print('New name: ${controller.text}');
              Navigator.pop(context);
            },
            child: const Text('Rename'),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Prototype button
        TextButton.icon(
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Prototype'),
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
            child: const Row(
              children: [
                Text(
                  'Share',
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
            const PopupMenuItem(
              value: 'copy_link',
              child: Row(
                children: [
                  Icon(Icons.link, size: 16),
                  SizedBox(width: 8),
                  Text('Copy link'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'invite',
              child: Row(
                children: [
                  Icon(Icons.person_add, size: 16),
                  SizedBox(width: 8),
                  Text('Invite collaborators'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'publish',
              child: Row(
                children: [
                  Icon(Icons.public, size: 16),
                  SizedBox(width: 8),
                  Text('Publish to web'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, size: 16),
                  SizedBox(width: 8),
                  Text('Export'),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

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
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, size: 16),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 16),
                  SizedBox(width: 8),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help, size: 16),
                  SizedBox(width: 8),
                  Text('Help'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 16),
                  SizedBox(width: 8),
                  Text('Logout'),
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
