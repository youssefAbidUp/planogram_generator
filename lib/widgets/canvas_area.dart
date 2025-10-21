// lib/widgets/canvas_area.dart
// COMPLETE WORKING VERSION

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import 'grid_painter.dart';
import 'canvas_node_renderer.dart';

class CanvasArea extends StatefulWidget {
  const CanvasArea({Key? key}) : super(key: key);

  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  Offset _startFocalPoint = Offset.zero;
  Offset _lastOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Container(
          color: const Color(0xFFE5E5E5),
          child: Stack(
            children: [
              _buildCanvas(appState),
              _buildZoomControls(appState),
              _buildResetButton(appState),
              _buildBottomToolbar(appState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCanvas(AppState appState) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          double zoomDelta = pointerSignal.scrollDelta.dy > 0 ? -0.1 : 0.1;
          appState.setCanvasZoom(appState.canvasZoom + zoomDelta);
        }
      },
      child: GestureDetector(
        onScaleStart: (details) {
          _startFocalPoint = details.focalPoint;
          _lastOffset = appState.canvasOffset;
        },
        onScaleUpdate: (details) {
          if (appState.selectedTool == ToolType.hand) {
            Offset newOffset =
                _lastOffset + (details.focalPoint - _startFocalPoint);
            appState.setCanvasOffset(newOffset);
          } else if (details.scale != 1.0) {
            double newScale = appState.canvasZoom * details.scale;
            appState.setCanvasZoom(newScale);
          }
        },
        onTapDown: (details) {
          _handleCanvasTap(details.localPosition, appState);
        },
        child: Container(
          color: Colors.transparent,
          child: CustomPaint(
            painter: appState.showGrid ? GridPainter() : null,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        appState.canvasOffset.dx,
                        appState.canvasOffset.dy,
                      )
                      ..scale(appState.canvasZoom),
                    alignment: Alignment.center,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (appState.currentPage != null)
                          ..._buildNodes(appState),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleCanvasTap(Offset position, AppState appState) {
    final canvasPos = _screenToCanvas(position, appState);

    bool clickedOnNode = false;
    if (appState.currentPage != null) {
      for (var node in appState.currentPage!.children.reversed) {
        if (_isPointInNode(canvasPos, node)) {
          appState.selectNode(node);
          clickedOnNode = true;
          print('Selected: ${node.name}');
          break;
        }
      }
    }

    if (!clickedOnNode) {
      appState.clearSelection();
      _createNodeAtPosition(canvasPos, appState);
    }
  }

  Offset _screenToCanvas(Offset screenPos, AppState appState) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return Offset(
      (screenPos.dx - centerX - appState.canvasOffset.dx) /
              appState.canvasZoom +
          centerX,
      (screenPos.dy - centerY - appState.canvasOffset.dy) /
              appState.canvasZoom +
          centerY,
    );
  }

  bool _isPointInNode(Offset point, FigmaNode node) {
    return point.dx >= node.position.dx &&
        point.dx <= node.position.dx + node.size.width &&
        point.dy >= node.position.dy &&
        point.dy <= node.position.dy + node.size.height;
  }

  void _createNodeAtPosition(Offset position, AppState appState) {
    final tool = appState.selectedTool;
    FigmaNode? newNode;

    switch (tool) {
      case ToolType.rectangle:
        newNode = RectangleNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Rectangle ${(appState.currentPage?.children.length ?? 0) + 1}',
          position: position,
          size: const Size(100, 100),
          fillColor: Colors.blue.shade200,
        );
        break;

      case ToolType.ellipse:
        newNode = EllipseNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Ellipse ${(appState.currentPage?.children.length ?? 0) + 1}',
          position: position,
          size: const Size(100, 100),
          fillColor: Colors.purple.shade200,
        );
        break;

      case ToolType.text:
        newNode = TextNode(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Text ${(appState.currentPage?.children.length ?? 0) + 1}',
          position: position,
          size: const Size(200, 50),
          text: 'Double click to edit',
          fontSize: 16,
          color: Colors.black,
        );
        break;

      default:
        return;
    }

    if (newNode != null) {
      appState.addNodeToCurrentPage(newNode);
      appState.selectTool(ToolType.move);
      print('Created ${newNode.name}');
    }
  }

  List<Widget> _buildNodes(AppState appState) {
    return appState.currentPage!.children.map((node) {
      final isSelected = appState.selectedNodes.contains(node);

      return CanvasNodeRenderer(
        node: node,
        isSelected: isSelected,
        onTap: () {
          appState.selectNode(node);
          print('Selected: ${node.name}');
        },
        onDoubleTap: () {
          if (node is TextNode) {
            _showTextEditor(context, node, appState);
          }
        },
        onDrag: (details) {
          final newPosition =
              node.position + details.delta / appState.canvasZoom;
          appState.updateNodePosition(node, newPosition);
        },
        onDragEnd: (details) {
          print('Drag ended for ${node.name}');
        },
        onResize: (delta, handle) {
          _handleResize(node, delta, handle, appState);
        },
      );
    }).toList();
  }

  void _showTextEditor(
    BuildContext context,
    TextNode textNode,
    AppState appState,
  ) {
    final controller = TextEditingController(text: textNode.text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter text...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.updateNodeProperty(textNode, 'text', controller.text);
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _handleResize(
    FigmaNode node,
    Offset delta,
    String handle,
    AppState appState,
  ) {
    final scaledDelta = delta / appState.canvasZoom;
    Size newSize = node.size;
    Offset newPosition = node.position;

    switch (handle) {
      case 'topLeft':
        newSize = Size(
          (node.size.width - scaledDelta.dx).clamp(20, double.infinity),
          (node.size.height - scaledDelta.dy).clamp(20, double.infinity),
        );
        newPosition = Offset(
          node.position.dx + (node.size.width - newSize.width),
          node.position.dy + (node.size.height - newSize.height),
        );
        break;
      case 'topRight':
        newSize = Size(
          (node.size.width + scaledDelta.dx).clamp(20, double.infinity),
          (node.size.height - scaledDelta.dy).clamp(20, double.infinity),
        );
        newPosition = Offset(
          node.position.dx,
          node.position.dy + (node.size.height - newSize.height),
        );
        break;
      case 'bottomLeft':
        newSize = Size(
          (node.size.width - scaledDelta.dx).clamp(20, double.infinity),
          (node.size.height + scaledDelta.dy).clamp(20, double.infinity),
        );
        newPosition = Offset(
          node.position.dx + (node.size.width - newSize.width),
          node.position.dy,
        );
        break;
      case 'bottomRight':
        newSize = Size(
          (node.size.width + scaledDelta.dx).clamp(20, double.infinity),
          (node.size.height + scaledDelta.dy).clamp(20, double.infinity),
        );
        break;
      case 'top':
        newSize = Size(
          node.size.width,
          (node.size.height - scaledDelta.dy).clamp(20, double.infinity),
        );
        newPosition = Offset(
          node.position.dx,
          node.position.dy + (node.size.height - newSize.height),
        );
        break;
      case 'bottom':
        newSize = Size(
          node.size.width,
          (node.size.height + scaledDelta.dy).clamp(20, double.infinity),
        );
        break;
      case 'left':
        newSize = Size(
          (node.size.width - scaledDelta.dx).clamp(20, double.infinity),
          node.size.height,
        );
        newPosition = Offset(
          node.position.dx + (node.size.width - newSize.width),
          node.position.dy,
        );
        break;
      case 'right':
        newSize = Size(
          (node.size.width + scaledDelta.dx).clamp(20, double.infinity),
          node.size.height,
        );
        break;
    }

    appState.updateNodeSize(node, newSize);
    if (newPosition != node.position) {
      appState.updateNodePosition(node, newPosition);
    }
  }

  Widget _buildZoomControls(AppState appState) {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 16),
              onPressed: () =>
                  appState.setCanvasZoom(appState.canvasZoom - 0.1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Zoom out',
            ),
            PopupMenuButton<double>(
              onSelected: (value) {
                if (value == -1) {
                  appState.resetCanvasView();
                } else {
                  appState.setCanvasZoom(value);
                }
              },
              offset: const Offset(0, 35),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  '${(appState.canvasZoom * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              itemBuilder: (context) => [
                _buildZoomMenuItem('25%', 0.25),
                _buildZoomMenuItem('50%', 0.5),
                _buildZoomMenuItem('75%', 0.75),
                _buildZoomMenuItem('100%', 1.0),
                _buildZoomMenuItem('150%', 1.5),
                _buildZoomMenuItem('200%', 2.0),
                const PopupMenuDivider(),
                const PopupMenuItem(value: -1, child: Text('Zoom to fit')),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 16),
              onPressed: () =>
                  appState.setCanvasZoom(appState.canvasZoom + 0.1),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Zoom in',
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<double> _buildZoomMenuItem(String label, double value) {
    return PopupMenuItem<double>(value: value, child: Text(label));
  }

  Widget _buildResetButton(AppState appState) {
    return Positioned(
      top: 16,
      left: 180,
      child: Tooltip(
        message: 'Reset view',
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.center_focus_strong, size: 18),
            onPressed: () => appState.resetCanvasView(),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToolbar(AppState appState) {
    final tools = [
      ToolType.move,
      ToolType.frame,
      ToolType.rectangle,
      ToolType.ellipse,
      ToolType.pen,
      ToolType.text,
      ToolType.comment,
    ];

    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: tools.map((toolType) {
              final tool = ToolConstants.allTools.firstWhere(
                (t) => t.type == toolType,
              );
              return Tooltip(
                message: tool.name,
                child: IconButton(
                  icon: Icon(tool.icon, size: 20),
                  color: appState.selectedTool == toolType
                      ? Colors.blue
                      : Colors.grey.shade700,
                  onPressed: () {
                    appState.selectTool(toolType);
                    print('Tool: ${tool.name}');
                  },
                  padding: const EdgeInsets.all(8),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
