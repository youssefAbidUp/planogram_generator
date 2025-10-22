// lib/widgets/left_sidebar.dart

import 'package:figma_editor/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import 'common_widgets.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Tabs
          const _TabBar(),

          // Search
          const _SearchBar(),

          // Content
          Expanded(
            child: Consumer<AppState>(
              builder: (context, appState, _) {
                if (appState.leftSidebarTab ==
                    AppLocalizations.of(context)!.file) {
                  return const _FileTabContent();
                } else {
                  return const _AssetsTabContent();
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
                label: AppLocalizations.of(context)!.file,
                isSelected:
                    appState.leftSidebarTab ==
                    AppLocalizations.of(context)!.file,
                onTap: () {
                  appState.setLeftSidebarTab(
                    AppLocalizations.of(context)!.file,
                  );
                  print('File tab selected');
                },
              ),
              const SizedBox(width: 4),
              CustomTab(
                label: AppLocalizations.of(context)!.assets,
                isSelected:
                    appState.leftSidebarTab ==
                    AppLocalizations.of(context)!.assets,
                onTap: () {
                  appState.setLeftSidebarTab(
                    AppLocalizations.of(context)!.assets,
                  );
                  print('Assets tab selected');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// SEARCH BAR
// ============================================================
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: SearchField(
            hintText: AppLocalizations.of(context)!.searchAllLibraries,
            onChanged: (value) {
              appState.setLibrarySearchQuery(value);
            },
            onFilterTap: () {
              _showFilterOptions(context);
            },
          ),
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _FilterBottomSheet(),
    );
  }
}

// ============================================================
// FILTER BOTTOM SHEET - STATEFUL FOR WORKING CHECKBOXES
// ============================================================
class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  // LOCAL STATE - This makes checkboxes work!
  bool showUIKits = true;
  bool showComponents = true;
  bool showIcons = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Libraries',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // WORKING CHECKBOX 1
          CheckboxField(
            label: AppLocalizations.of(context)!.showUIKits,
            value: showUIKits,
            onChanged: (value) {
              print('🔵 UI Kits: $value');
              setState(() {
                showUIKits = value;
              });
            },
          ),

          // WORKING CHECKBOX 2
          CheckboxField(
            label: AppLocalizations.of(context)!.showComponents,
            value: showComponents,
            onChanged: (value) {
              print('🔵 Components: $value');
              setState(() {
                showComponents = value;
              });
            },
          ),

          // WORKING CHECKBOX 3
          CheckboxField(
            label: AppLocalizations.of(context)!.showIcons,
            value: showIcons,
            onChanged: (value) {
              print('🔵 Icons: $value');
              setState(() {
                showIcons = value;
              });
            },
          ),

          const SizedBox(height: 16),

          CustomButton(
            label: AppLocalizations.of(context)!.applyFilters,
            onPressed: () {
              print('✅ Filters applied:');
              print('   - UI Kits: $showUIKits');
              print('   - Components: $showComponents');
              print('   - Icons: $showIcons');
              Navigator.pop(context);
            },
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FILE TAB CONTENT
// ============================================================
class _FileTabContent extends StatelessWidget {
  const _FileTabContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final filteredLibs = appState.filteredLibraries;

        if (filteredLibs.isEmpty && appState.librarySearchQuery.isNotEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            message: 'No libraries found for "${appState.librarySearchQuery}"',
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            // "All libraries" header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                AppLocalizations.of(context)!.allLibraries,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            // First library (Created in this file)
            if (filteredLibs.isNotEmpty)
              LibraryItemCard(
                title: filteredLibs[0].name,
                subtitle: filteredLibs[0].description,
                color: filteredLibs[0].color,
                gradient: filteredLibs[0].gradient,
                onTap: () {
                  print('Library clicked: ${filteredLibs[0].name}');
                  _showLibraryOptions(context, filteredLibs[0]);
                },
                onLongPress: () {
                  _showLibraryContextMenu(context, filteredLibs[0]);
                },
              ),

            // "UI kits" section
            if (filteredLibs.length > 1) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  AppLocalizations.of(context)!.uiKits,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              // Rest of libraries
              ...filteredLibs.skip(1).map((lib) {
                return LibraryItemCard(
                  title: lib.name,
                  subtitle: lib.description,
                  color: lib.color,
                  gradient: lib.gradient,
                  onTap: () {
                    print('Library clicked: ${lib.name}');
                    _showLibraryOptions(context, lib);
                  },
                  onLongPress: () {
                    _showLibraryContextMenu(context, lib);
                  },
                );
              }).toList(),
            ],

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  void _showLibraryOptions(BuildContext context, LibraryModel library) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              library.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              library.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Open Library',
              onPressed: () {
                Navigator.pop(context);
                print('Opening library: ${library.name}');
              },
              icon: Icons.folder_open,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
            const SizedBox(height: 8),
            CustomButton(
              label: 'View Details',
              onPressed: () {
                Navigator.pop(context);
                print('View details: ${library.name}');
              },
              icon: Icons.info_outline,
            ),
          ],
        ),
      ),
    );
  }

  void _showLibraryContextMenu(BuildContext context, LibraryModel library) {
    showDialog(
      context: context,
      builder: (context) => ContextMenu(
        position: const Offset(100, 200),
        items: [
          ContextMenuItem(
            label: AppLocalizations.of(context)!.open,
            icon: Icons.folder_open,
            onTap: () => print('Open: ${library.name}'),
          ),
          ContextMenuItem(
            label: AppLocalizations.of(context)!.addToFavorites,
            icon: Icons.star_outline,
            onTap: () => print('Add to favorites: ${library.name}'),
          ),
          ContextMenuItem.divider,
          ContextMenuItem(
            label: AppLocalizations.of(context)!.viewDetails,
            icon: Icons.info_outline,
            onTap: () => print('View details: ${library.name}'),
          ),
          ContextMenuItem(
            label: AppLocalizations.of(context)!.share,
            icon: Icons.share,
            onTap: () => print('Share: ${library.name}'),
          ),
          ContextMenuItem.divider,
          ContextMenuItem(
            label: AppLocalizations.of(context)!.remove,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: () => print('Remove: ${library.name}'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ASSETS TAB CONTENT
// ============================================================
class _AssetsTabContent extends StatelessWidget {
  const _AssetsTabContent();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.photo_library,
      message: AppLocalizations.of(context)!.noAssetsYet,
      actionLabel: AppLocalizations.of(context)!.importAssets,
    );
  }
}
