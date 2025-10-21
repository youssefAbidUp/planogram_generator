// lib/main.dart

import 'package:figma_editor/screens/figma_editor.dart';
import 'package:figma_editor/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';

void main() {
  runApp(const FigmaEditorApp());
}

class FigmaEditorApp extends StatelessWidget {
  const FigmaEditorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..initializeWithDemoData(),
      child: MaterialApp(
        title: 'Figma Editor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          fontFamily: 'Inter',
        ),
        home: const FigmaEditorScreen(),
      ),
    );
  }
}

// ============================================================
// EXTENSION TO INITIALIZE DEMO DATA
// ============================================================
extension AppStateDemo on AppState {
  void initializeWithDemoData() {
    // Create demo project
    final project = FigmaProject(
      id: '1',
      name: 'gym app Dorra',
      pages: [
        FigmaPage(
          id: 'page-1',
          name: 'Main Page',
          backgroundColor: const Color(0xFFF5F5F5),
        ),
      ],
    );

    setProject(project);
    setCurrentPage(project.pages.first);

    // Set demo libraries
    setLibraries([
      LibraryModel(
        id: 'lib-1',
        name: 'Created in this file',
        description: '163 components',
        color: Colors.orange.shade100,
        componentCount: 163,
      ),
      LibraryModel(
        id: 'lib-2',
        name: 'iOS and iPadOS 26',
        description: '165 components',
        color: Colors.blue.shade700,
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.teal.shade400],
        ),
        componentCount: 165,
      ),
      LibraryModel(
        id: 'lib-3',
        name: 'Material 3 Design Kit',
        description: '342 components',
        color: Colors.purple.shade300,
        componentCount: 342,
      ),
      LibraryModel(
        id: 'lib-4',
        name: 'Simple',
        description: '88 components',
        color: Colors.black,
        componentCount: 88,
      ),
    ]);

    // Set demo plugins
    setPlugins([
      PluginModel(
        id: 'plugin-1',
        name: 'html.to.design',
        icon: Icons.code,
        onTap: () => print('html.to.design plugin activated'),
      ),
      PluginModel(
        id: 'plugin-2',
        name: 'Unsplash',
        icon: Icons.image,
        onTap: () => print('Unsplash plugin activated'),
      ),
    ]);

    // Add initial export setting
    addExportSetting();
  }
}
