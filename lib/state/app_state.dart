// lib/state/app_state.dart

import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // ============================================================
  // PROJECT STATE
  // ============================================================
  FigmaProject? _currentProject;
  FigmaProject? get currentProject => _currentProject;

  void setProject(FigmaProject project) {
    _currentProject = project;
    notifyListeners();
  }

  // ============================================================
  // CURRENT PAGE
  // ============================================================
  FigmaPage? _currentPage;
  FigmaPage? get currentPage => _currentPage;

  void setCurrentPage(FigmaPage page) {
    _currentPage = page;
    notifyListeners();
  }

  // ============================================================
  // SELECTED TOOL
  // ============================================================
  ToolType _selectedTool = ToolType.move;
  ToolType get selectedTool => _selectedTool;

  void selectTool(ToolType tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  // ============================================================
  // SELECTED NODES
  // ============================================================
  List<FigmaNode> _selectedNodes = [];
  List<FigmaNode> get selectedNodes => List.unmodifiable(_selectedNodes);

  FigmaNode? get selectedNode =>
      _selectedNodes.isNotEmpty ? _selectedNodes.first : null;

  void selectNode(FigmaNode node, {bool addToSelection = false}) {
    if (addToSelection) {
      if (!_selectedNodes.contains(node)) {
        _selectedNodes.add(node);
      }
    } else {
      _selectedNodes = [node];
    }
    notifyListeners();
  }

  void deselectNode(FigmaNode node) {
    _selectedNodes.remove(node);
    notifyListeners();
  }

  void clearSelection() {
    _selectedNodes.clear();
    notifyListeners();
  }

  // ============================================================
  // NODE OPERATIONS
  // ============================================================
  void addNodeToCurrentPage(FigmaNode node) {
    if (_currentPage != null) {
      _currentPage!.children.add(node);
      selectNode(node);
      notifyListeners();
    }
  }

  void updateNodePosition(FigmaNode node, Offset newPosition) {
    node.position = newPosition;
    notifyListeners();
  }

  void updateNodeSize(FigmaNode node, Size newSize) {
    node.size = newSize;
    notifyListeners();
  }

  void updateNodeProperty(FigmaNode node, String property, dynamic value) {
    if (node is RectangleNode) {
      switch (property) {
        case 'fillType':
          node.fillType = value as FillType;
          break;
        case 'fillColor':
          node.fillColor = value as Color;
          break;
        case 'gradient':
          node.gradient = value as Gradient?;
          break;
        case 'imageUrl':
          node.imageUrl = value as String?;
          break;
        case 'strokeColor':
          node.strokeColor = value as Color?;
          break;
        case 'strokeWeight':
          node.strokeWeight = value as double;
          break;
        case 'borderRadius':
          node.borderRadius = value as BorderRadius;
          break;
        case 'uniformCornerRadius':
          node.uniformCornerRadius = value as double;
          break;
      }
    } else if (node is EllipseNode) {
      switch (property) {
        case 'fillType':
          node.fillType = value as FillType;
          break;
        case 'fillColor':
          node.fillColor = value as Color;
          break;
        case 'gradient':
          node.gradient = value as Gradient?;
          break;
        case 'imageUrl':
          node.imageUrl = value as String?;
          break;
        case 'strokeColor':
          node.strokeColor = value as Color?;
          break;
        case 'strokeWeight':
          node.strokeWeight = value as double;
          break;
      }
    } else if (node is TextNode) {
      switch (property) {
        case 'text':
          node.text = value as String;
          break;
        case 'fontSize':
          node.fontSize = value as double;
          break;
        case 'color':
          node.color = value as Color;
          break;
      }
    }
    notifyListeners();
  }

  void deleteSelectedNodes() {
    if (_currentPage != null) {
      for (var node in _selectedNodes) {
        _currentPage!.children.remove(node);
      }
      clearSelection();
      notifyListeners();
    }
  }

  // ============================================================
  // CANVAS STATE
  // ============================================================
  double _canvasZoom = 1.0;
  double get canvasZoom => _canvasZoom;

  Offset _canvasOffset = Offset.zero;
  Offset get canvasOffset => _canvasOffset;

  void setCanvasZoom(double zoom) {
    _canvasZoom = zoom.clamp(0.1, 10.0);
    notifyListeners();
  }

  void setCanvasOffset(Offset offset) {
    _canvasOffset = offset;
    notifyListeners();
  }

  void resetCanvasView() {
    _canvasZoom = 1.0;
    _canvasOffset = Offset.zero;
    notifyListeners();
  }

  // ============================================================
  // LEFT SIDEBAR STATE
  // ============================================================
  String _leftSidebarTab = 'File';
  String get leftSidebarTab => _leftSidebarTab;

  void setLeftSidebarTab(String tab) {
    _leftSidebarTab = tab;
    notifyListeners();
  }

  List<LibraryModel> _libraries = [];
  List<LibraryModel> get libraries => List.unmodifiable(_libraries);

  void setLibraries(List<LibraryModel> libraries) {
    _libraries = libraries;
    notifyListeners();
  }

  String _librarySearchQuery = '';
  String get librarySearchQuery => _librarySearchQuery;

  void setLibrarySearchQuery(String query) {
    _librarySearchQuery = query;
    notifyListeners();
  }

  List<LibraryModel> get filteredLibraries {
    if (_librarySearchQuery.isEmpty) return _libraries;
    return _libraries
        .where(
          (lib) => lib.name.toLowerCase().contains(
            _librarySearchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  // ============================================================
  // RIGHT SIDEBAR STATE
  // ============================================================
  String _rightSidebarTab = 'Design';
  String get rightSidebarTab => _rightSidebarTab;

  void setRightSidebarTab(String tab) {
    _rightSidebarTab = tab;
    notifyListeners();
  }

  // Section expansion states
  Map<String, bool> _sectionExpanded = {
    'Page': true,
    'Variables': false,
    'Styles': false,
    'Export': true,
    'Plugin': false,
  };

  bool isSectionExpanded(String section) {
    return _sectionExpanded[section] ?? false;
  }

  void toggleSection(String section) {
    _sectionExpanded[section] = !(_sectionExpanded[section] ?? false);
    notifyListeners();
  }

  // ============================================================
  // EXPORT SETTINGS
  // ============================================================
  List<ExportSetting> _exportSettings = [];
  List<ExportSetting> get exportSettings => List.unmodifiable(_exportSettings);

  void addExportSetting() {
    _exportSettings.add(
      ExportSetting(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    notifyListeners();
  }

  void removeExportSetting(String id) {
    _exportSettings.removeWhere((setting) => setting.id == id);
    notifyListeners();
  }

  void updateExportSetting(String id, {String? scale, String? format}) {
    final index = _exportSettings.indexWhere((s) => s.id == id);
    if (index != -1) {
      if (scale != null) _exportSettings[index].scale = scale;
      if (format != null) _exportSettings[index].format = format;
      notifyListeners();
    }
  }

  // ============================================================
  // VARIABLES
  // ============================================================
  List<VariableModel> _variables = [];
  List<VariableModel> get variables => List.unmodifiable(_variables);

  void addVariable(VariableModel variable) {
    _variables.add(variable);
    notifyListeners();
  }

  void removeVariable(String id) {
    _variables.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  // ============================================================
  // STYLES
  // ============================================================
  List<StyleModel> _styles = [];
  List<StyleModel> get styles => List.unmodifiable(_styles);

  void addStyle(StyleModel style) {
    _styles.add(style);
    notifyListeners();
  }

  void removeStyle(String id) {
    _styles.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ============================================================
  // PLUGINS
  // ============================================================
  List<PluginModel> _plugins = [];
  List<PluginModel> get plugins => List.unmodifiable(_plugins);

  void setPlugins(List<PluginModel> plugins) {
    _plugins = plugins;
    notifyListeners();
  }

  // ============================================================
  // UI STATE
  // ============================================================
  bool _showGrid = true;
  bool get showGrid => _showGrid;

  void toggleGrid() {
    _showGrid = !_showGrid;
    notifyListeners();
  }

  bool _showRulers = true;
  bool get showRulers => _showRulers;

  void toggleRulers() {
    _showRulers = !_showRulers;
    notifyListeners();
  }

  // ============================================================
  // CONTEXT MENU STATE
  // ============================================================
  Offset? _contextMenuPosition;
  Offset? get contextMenuPosition => _contextMenuPosition;

  void showContextMenu(Offset position) {
    _contextMenuPosition = position;
    notifyListeners();
  }

  void hideContextMenu() {
    _contextMenuPosition = null;
    notifyListeners();
  }

  // ============================================================
  // MODAL/DIALOG STATE
  // ============================================================
  String? _activeModal;
  String? get activeModal => _activeModal;

  void showModal(String modalId) {
    _activeModal = modalId;
    notifyListeners();
  }

  void hideModal() {
    _activeModal = null;
    notifyListeners();
  }

  // ============================================================
  // HISTORY (Undo/Redo)
  // ============================================================
  List<String> _history = [];
  int _historyIndex = -1;

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void addToHistory(String action) {
    if (_historyIndex < _history.length - 1) {
      _history = _history.sublist(0, _historyIndex + 1);
    }
    _history.add(action);
    _historyIndex++;
    notifyListeners();
  }

  void undo() {
    if (canUndo) {
      _historyIndex--;
      // Implement undo logic
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _historyIndex++;
      // Implement redo logic
      notifyListeners();
    }
  }
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================
extension AppStateExtensions on AppState {
  // Get selected node properties (for property panel)
  FigmaNode? get firstSelectedNode {
    return selectedNodes.isNotEmpty ? selectedNodes.first : null;
  }

  // Check if multiple nodes selected
  bool get hasMultipleSelection => selectedNodes.length > 1;

  // Get tool by type
  Tool getToolByType(ToolType type) {
    return ToolConstants.allTools.firstWhere((tool) => tool.type == type);
  }
}
