// lib/widgets/right_sidebar.dart - FIXED VERSION WITH WORKING CHECKBOXES

import 'package:flutter/material.dart' hide DropdownButton;
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import 'common_widgets.dart';
import 'node_properties_panel.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        children: [
          const _TabBar(),
          Divider(height: 1, color: Colors.grey.shade300),
          Expanded(
            child: Consumer<AppState>(
              builder: (context, appState, _) {
                if (appState.rightSidebarTab == 'Design') {
                  return const _DesignTabContent();
                } else {
                  return const _PrototypeTabContent();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TAB BAR
// ============================================================
class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              CustomTab(
                label: 'Design',
                isSelected: appState.rightSidebarTab == 'Design',
                onTap: () => appState.setRightSidebarTab('Design'),
              ),
              const SizedBox(width: 4),
              CustomTab(
                label: 'Prototype',
                isSelected: appState.rightSidebarTab == 'Prototype',
                onTap: () => appState.setRightSidebarTab('Prototype'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// DESIGN TAB CONTENT
// ============================================================
class _DesignTabContent extends StatelessWidget {
  const _DesignTabContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        // If a node is selected, show its properties
        if (appState.selectedNode != null) {
          return const NodePropertiesPanel();
        }

        // Otherwise show page settings
        return SingleChildScrollView(
          child: Column(
            children: [
              // Page Section - WITH WORKING CHECKBOXES
              CollapsibleSection(
                title: 'Page',
                isExpanded: appState.isSectionExpanded('Page'),
                onToggle: () => appState.toggleSection('Page'),
                children: [
                  const SizedBox(height: 8),
                  const _PageSettings(), // STATEFUL WIDGET FOR CHECKBOXES
                  const SizedBox(height: 12),
                ],
              ),

              Divider(height: 1, color: Colors.grey.shade300),

              CollapsibleSection(
                title: 'Export',
                isExpanded: appState.isSectionExpanded('Export'),
                onToggle: () => appState.toggleSection('Export'),
                trailing: CustomIconButton(
                  icon: Icons.add,
                  onPressed: () => appState.addExportSetting(),
                  tooltip: 'Add export setting',
                ),
                children: [
                  const SizedBox(height: 12),
                  const _ExportSettingsList(),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// PAGE SETTINGS - STATEFUL WIDGET (THIS IS THE KEY!)
// ============================================================
class _PageSettings extends StatefulWidget {
  const _PageSettings();

  @override
  State<_PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<_PageSettings> {
  // LOCAL STATE - This is why it works!
  bool showInExports = true;
  bool clipContent = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PropertyRow(
          label: 'Background',
          value: '100%',
          labelColor: const Color(0xFFF5F5F5),
          trailing: Icon(
            Icons.remove_red_eye,
            size: 16,
            color: Colors.grey.shade600,
          ),
          onTap: () {
            print('Background clicked');
            _showColorPicker(context);
          },
        ),

        const SizedBox(height: 8),

        // WORKING CHECKBOX 1
        CheckboxField(
          label: 'Show in exports',
          value: showInExports,
          onChanged: (value) {
            print('🟢 Checkbox 1 clicked - Old: $showInExports, New: $value');
            setState(() {
              showInExports = value;
            });
            print('🟢 Checkbox 1 updated to: $showInExports');
          },
        ),

        const SizedBox(height: 4),

        // WORKING CHECKBOX 2
        CheckboxField(
          label: 'Clip content',
          value: clipContent,
          onChanged: (value) {
            print('🟢 Checkbox 2 clicked - Old: $clipContent, New: $value');
            setState(() {
              clipContent = value;
            });
            print('🟢 Checkbox 2 updated to: $clipContent');
          },
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Background Color'),
        content: const Text('Color picker would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EXPORT SETTINGS LIST
// ============================================================
class _ExportSettingsList extends StatelessWidget {
  const _ExportSettingsList();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        if (appState.exportSettings.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'No export settings',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          );
        }

        return Column(
          children: appState.exportSettings.map((exportSetting) {
            return _ExportSettingItem(exportSetting: exportSetting);
          }).toList(),
        );
      },
    );
  }
}

class _ExportSettingItem extends StatelessWidget {
  final ExportSetting exportSetting;

  const _ExportSettingItem({required this.exportSetting});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton(
                    value: exportSetting.scale,
                    items: ExportFormats.scales,
                    onChanged: (value) {
                      appState.updateExportSetting(
                        exportSetting.id,
                        scale: value,
                      );
                    },
                  ),
                  const Spacer(),
                  DropdownButton(
                    value: exportSetting.format,
                    items: ExportFormats.formats,
                    onChanged: (value) {
                      appState.updateExportSetting(
                        exportSetting.id,
                        format: value,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    onSelected: (value) {
                      if (value == 'remove') {
                        appState.removeExportSetting(exportSetting.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'settings',
                        child: Text('Export settings'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomButton(
                label: 'Export ${appState.currentProject?.name ?? "Project"}',
                onPressed: () {
                  print(
                    'Exporting as ${exportSetting.format} at ${exportSetting.scale}',
                  );
                },
                outlined: true,
                fullWidth: true,
              ),
              const SizedBox(height: 8),
              CustomButton(
                label: 'Preview',
                onPressed: () => print('Preview export'),
                fullWidth: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// PROTOTYPE TAB CONTENT
// ============================================================
class _PrototypeTabContent extends StatelessWidget {
  const _PrototypeTabContent();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.play_circle_outline,
      message: 'Select a frame to add interactions',
    );
  }
}

// ============================================================
// EXPLANATION OF WHY THIS WORKS
// ============================================================

/*
THE KEY DIFFERENCE:
===================

❌ OLD CODE (StatelessWidget - Won't work):
-------------------------------------------
class _PageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool showInExports = true; // ❌ Recreated on every build!
    
    return CheckboxField(
      value: showInExports,
      onChanged: (value) {
        showInExports = value; // ❌ Changes local variable, doesn't rebuild!
      },
    );
  }
}

✅ NEW CODE (StatefulWidget - Works!):
--------------------------------------
class _PageSettings extends StatefulWidget {
  @override
  State<_PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<_PageSettings> {
  bool showInExports = true; // ✅ Persistent state!
  
  @override
  Widget build(BuildContext context) {
    return CheckboxField(
      value: showInExports,
      onChanged: (value) {
        setState(() {
          showInExports = value; // ✅ setState triggers rebuild!
        });
      },
    );
  }
}

WHY STATEFUL IS NEEDED:
=======================

1. StatelessWidget recreates variables on every build
2. Changing a local variable doesn't trigger rebuild
3. StatefulWidget keeps state between rebuilds
4. setState() tells Flutter to rebuild with new values

TO USE THIS FIX:
================

1. Replace your entire right_sidebar.dart with this code
2. Make sure CheckboxField component is using the fixed version
3. Save and run
4. Click checkboxes and watch console for debug prints

The checkboxes WILL work with this code!
*/
