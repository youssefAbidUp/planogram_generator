// lib/widgets/canvas_node_renderer.dart
// COMPLETE VERSION - Renders nodes on the canvas

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class CanvasNodeRenderer extends StatelessWidget {
  final FigmaNode node;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final Function(DragUpdateDetails) onDrag;
  final Function(DragEndDetails) onDragEnd;
  final Function(Offset delta, String handle)? onResize;

  const CanvasNodeRenderer({
    Key? key,
    required this.node,
    required this.isSelected,
    required this.onTap,
    this.onDoubleTap,
    required this.onDrag,
    required this.onDragEnd,
    this.onResize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onPanUpdate: onDrag,
        onPanEnd: onDragEnd,
        child: Stack(
          children: [
            _buildNodeContent(),
            if (isSelected) _buildSelectionOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeContent() {
    if (node is RectangleNode) {
      return _buildRectangle(node as RectangleNode);
    } else if (node is EllipseNode) {
      return _buildEllipse(node as EllipseNode);
    } else if (node is TextNode) {
      return _buildText(node as TextNode);
    }

    return Container(
      width: node.size.width,
      height: node.size.height,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildRectangle(RectangleNode rect) {
    return Container(
      width: rect.size.width,
      height: rect.size.height,
      decoration: BoxDecoration(
        color: rect.fillType == FillType.solid ? rect.fillColor : null,
        gradient: rect.fillType == FillType.gradient ? rect.gradient : null,
        image: rect.fillType == FillType.image && rect.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(rect.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: rect.borderRadius,
        border: rect.strokeColor != null && rect.strokeWeight > 0
            ? Border.all(color: rect.strokeColor!, width: rect.strokeWeight)
            : null,
      ),
    );
  }

  Widget _buildEllipse(EllipseNode ellipse) {
    return Container(
      width: ellipse.size.width,
      height: ellipse.size.height,
      decoration: BoxDecoration(
        color: ellipse.fillType == FillType.solid ? ellipse.fillColor : null,
        gradient: ellipse.fillType == FillType.gradient
            ? ellipse.gradient
            : null,
        image: ellipse.fillType == FillType.image && ellipse.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(ellipse.imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        shape: BoxShape.circle,
        border: ellipse.strokeColor != null && ellipse.strokeWeight > 0
            ? Border.all(
                color: ellipse.strokeColor!,
                width: ellipse.strokeWeight,
              )
            : null,
      ),
    );
  }

  Widget _buildText(TextNode textNode) {
    return Container(
      width: textNode.size.width,
      height: textNode.size.height,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(4),
      child: Text(
        textNode.text,
        style: TextStyle(
          fontFamily: textNode.fontFamily,
          fontSize: textNode.fontSize,
          fontWeight: textNode.fontWeight,
          color: textNode.color,
        ),
        textAlign: textNode.textAlign,
      ),
    );
  }

  Widget _buildSelectionOverlay() {
    return Stack(
      children: [
        Container(
          width: node.size.width,
          height: node.size.height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: node is RectangleNode
                ? (node as RectangleNode).borderRadius
                : null,
          ),
        ),
        if (onResize != null) ..._buildResizeHandles(),
      ],
    );
  }

  List<Widget> _buildResizeHandles() {
    const handleSize = 8.0;
    final width = node.size.width;
    final height = node.size.height;

    return [
      _ResizeHandle(
        position: const Offset(-handleSize / 2, -handleSize / 2),
        cursor: SystemMouseCursors.resizeUpLeft,
        handle: 'topLeft',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(width - handleSize / 2, -handleSize / 2),
        cursor: SystemMouseCursors.resizeUpRight,
        handle: 'topRight',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(-handleSize / 2, height - handleSize / 2),
        cursor: SystemMouseCursors.resizeDownLeft,
        handle: 'bottomLeft',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(width - handleSize / 2, height - handleSize / 2),
        cursor: SystemMouseCursors.resizeDownRight,
        handle: 'bottomRight',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(width / 2 - handleSize / 2, -handleSize / 2),
        cursor: SystemMouseCursors.resizeUp,
        handle: 'top',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(width / 2 - handleSize / 2, height - handleSize / 2),
        cursor: SystemMouseCursors.resizeDown,
        handle: 'bottom',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(-handleSize / 2, height / 2 - handleSize / 2),
        cursor: SystemMouseCursors.resizeLeft,
        handle: 'left',
        onDrag: onResize!,
      ),
      _ResizeHandle(
        position: Offset(width - handleSize / 2, height / 2 - handleSize / 2),
        cursor: SystemMouseCursors.resizeRight,
        handle: 'right',
        onDrag: onResize!,
      ),
    ];
  }
}

class _ResizeHandle extends StatelessWidget {
  final Offset position;
  final SystemMouseCursor cursor;
  final String handle;
  final Function(Offset delta, String handle) onDrag;

  const _ResizeHandle({
    required this.position,
    required this.cursor,
    required this.handle,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          onPanUpdate: (details) {
            onDrag(details.delta, handle);
          },
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
