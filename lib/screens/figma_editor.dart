// lib/screens/figma_editor_screen.dart

import '../state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/top_toolbar.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/right_sidebar.dart';
import '../widgets/canvas_area.dart';

class FigmaEditorScreen extends StatefulWidget {
  const FigmaEditorScreen({Key? key}) : super(key: key);

  @override
  State<FigmaEditorScreen> createState() => _FigmaEditorScreenState();
}

class _FigmaEditorScreenState extends State<FigmaEditorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 768;
        final isDesktop = constraints.maxWidth > 1024;

        return Consumer<AppState>(
          builder: (context, appState, _) {
            return Scaffold(
              key: _scaffoldKey,
              body: Column(
                children: [
                  // Top Toolbar
                  TopToolbar(
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  ),

                  // Main Content Area
                  Expanded(
                    child: Row(
                      children: [
                        // Left Sidebar (visible on tablet+)
                        if (isTablet) const LeftSidebar(),

                        // Canvas Area (center)
                        const Expanded(child: CanvasArea()),

                        // Right Sidebar (visible on desktop)
                        if (isDesktop) const RightSidebar(),
                      ],
                    ),
                  ),
                ],
              ),

              // Drawer (mobile only)
              drawer: !isTablet ? const Drawer(child: LeftSidebar()) : null,
            );
          },
        );
      },
    );
  }
}
