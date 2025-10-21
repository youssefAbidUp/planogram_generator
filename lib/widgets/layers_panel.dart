// lib/widgets/layers_panel.dart
// Layers/Hierarchy Panel - Shows all elements in tree structure

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class LayersPanel extends StatelessWidget {
  const LayersPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final page = appState.currentPage;

        if (page == null || page.children.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.layers_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No elements yet',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create elements on canvas',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: page.children.length,
          itemBuilder: (context, index) {
            // Reverse order to show top elements first
            final node = page.children[page.children.length - 1 - index];
            final isSelected = appState.selectedNodes.contains(node);

            return _LayerItem(
              node: node,
              isSelected: isSelected,
              onTap: () {
                appState.selectNode(node);
              },
              onVisibilityToggle: () {
                node.visible = !node.visible;
                appState.notifyListeners();
              },
              onLockToggle: () {
                node.locked = !node.locked;
                appState.notifyListeners();
              },
            );
          },
        );
      },
    );
  }
}

class _LayerItem extends StatefulWidget {
  final FigmaNode node;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onLockToggle;

  const _LayerItem({
    required this.node,
    required this.isSelected,
    required this.onTap,
    required this.onVisibilityToggle,
    required this.onLockToggle,
  });

  @override
  State<_LayerItem> createState() => _LayerItemState();
}

class _LayerItemState extends State<_LayerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFE3F2FD)
                : _isHovered
                ? const Color(0xFFF5F5F5)
                : Colors.transparent,
            border: widget.isSelected
                ? const Border(
                    left: BorderSide(color: Color(0xFF0D99FF), width: 2),
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getNodeColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Icon(_getNodeIcon(), size: 12, color: Colors.white),
              ),

              const SizedBox(width: 8),

              // Name
              Expanded(
                child: Text(
                  widget.node.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.node.visible
                        ? const Color(0xFF333333)
                        : const Color(0xFF999999),
                    fontWeight: widget.isSelected
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Actions (show on hover or selected)
              if (_isHovered || widget.isSelected) ...[
                // Lock toggle
                IconButton(
                  icon: Icon(
                    widget.node.locked ? Icons.lock : Icons.lock_open,
                    size: 14,
                  ),
                  color: widget.node.locked
                      ? const Color(0xFF666666)
                      : const Color(0xFF999999),
                  onPressed: widget.onLockToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  tooltip: widget.node.locked ? 'Unlock' : 'Lock',
                ),

                // Visibility toggle
                IconButton(
                  icon: Icon(
                    widget.node.visible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 14,
                  ),
                  color: widget.node.visible
                      ? const Color(0xFF666666)
                      : const Color(0xFF999999),
                  onPressed: widget.onVisibilityToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  tooltip: widget.node.visible ? 'Hide' : 'Show',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNodeIcon() {
    if (widget.node is RectangleNode) return Icons.crop_square;
    if (widget.node is EllipseNode) return Icons.circle;
    if (widget.node is TextNode) return Icons.text_fields;
    return Icons.widgets;
  }

  Color _getNodeColor() {
    if (widget.node is RectangleNode) return const Color(0xFF0D99FF);
    if (widget.node is EllipseNode) return const Color(0xFF9C27B0);
    if (widget.node is TextNode) return const Color(0xFF4CAF50);
    return const Color(0xFF999999);
  }
}
