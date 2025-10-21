// lib/models/models.dart

import 'package:flutter/material.dart';

// ============================================================
// PROJECT MODEL
// ============================================================
class FigmaProject {
  String id;
  String name;
  List<FigmaPage> pages;
  String? thumbnailUrl;

  FigmaProject({
    required this.id,
    required this.name,
    required this.pages,
    this.thumbnailUrl,
  });
}

// ============================================================
// PAGE MODEL
// ============================================================
class FigmaPage {
  String id;
  String name;
  Color backgroundColor;
  List<FigmaNode> children; // FIXED: Now mutable
  bool showInExports;

  FigmaPage({
    required this.id,
    required this.name,
    this.backgroundColor = const Color(0xFFF5F5F5),
    List<FigmaNode>? children, // FIXED: Optional parameter
    this.showInExports = true,
  }) : children = children ?? []; // FIXED: Initialize as empty mutable list
}

// ============================================================
// NODE MODEL (Base for all design elements)
// ============================================================
abstract class FigmaNode {
  String id;
  String name;
  Offset position;
  Size size;
  double rotation;
  double opacity;
  bool visible;
  bool locked;

  FigmaNode({
    required this.id,
    required this.name,
    this.position = Offset.zero,
    this.size = const Size(100, 100),
    this.rotation = 0,
    this.opacity = 1.0,
    this.visible = true,
    this.locked = false,
  });
}

// Frame/Group
class FrameNode extends FigmaNode {
  List<FigmaNode> children;
  Color? backgroundColor;
  double cornerRadius;

  FrameNode({
    required super.id,
    required super.name,
    super.position,
    super.size,
    this.children = const [],
    this.backgroundColor,
    this.cornerRadius = 0,
  });
}

// ============================================================
// FILL TYPE ENUM
// ============================================================
enum FillType { solid, gradient, image }

// Rectangle
class RectangleNode extends FigmaNode {
  FillType fillType;
  Color fillColor;
  Gradient? gradient;
  String? imageUrl; // URL or asset path
  Color? strokeColor;
  double strokeWeight;
  BorderRadius borderRadius;

  RectangleNode({
    required super.id,
    required super.name,
    super.position,
    super.size,
    this.fillType = FillType.solid,
    this.fillColor = Colors.grey,
    this.gradient,
    this.imageUrl,
    this.strokeColor,
    this.strokeWeight = 0,
    BorderRadius? borderRadius,
  }) : borderRadius = borderRadius ?? BorderRadius.zero;

  double get uniformCornerRadius {
    if (borderRadius == BorderRadius.zero) return 0;
    final topLeft = (borderRadius as BorderRadius?)?.topLeft.x ?? 0;
    return topLeft;
  }

  set uniformCornerRadius(double value) {
    borderRadius = BorderRadius.circular(value);
  }
}

// Ellipse
class EllipseNode extends FigmaNode {
  FillType fillType;
  Color fillColor;
  Gradient? gradient;
  String? imageUrl;
  Color? strokeColor;
  double strokeWeight;

  EllipseNode({
    required super.id,
    required super.name,
    super.position,
    super.size,
    this.fillType = FillType.solid,
    this.fillColor = Colors.blue,
    this.gradient,
    this.imageUrl,
    this.strokeColor,
    this.strokeWeight = 0,
  });
}

// Text
class TextNode extends FigmaNode {
  String text;
  String fontFamily;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  TextAlign textAlign;

  TextNode({
    required super.id,
    required super.name,
    super.position,
    super.size,
    required this.text,
    this.fontFamily = 'Roboto',
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
  });
}

// ============================================================
// TOOL MODEL
// ============================================================
enum ToolType {
  move,
  frame,
  rectangle,
  ellipse,
  polygon,
  pen,
  text,
  hand,
  comment,
}

class Tool {
  final ToolType type;
  final String name;
  final IconData icon;
  final String shortcut;

  const Tool({
    required this.type,
    required this.name,
    required this.icon,
    required this.shortcut,
  });
}

// ============================================================
// LIBRARY MODEL
// ============================================================
class LibraryModel {
  String id;
  String name;
  String description;
  Color color;
  Gradient? gradient;
  int componentCount;
  String? thumbnailUrl;

  LibraryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.gradient,
    required this.componentCount,
    this.thumbnailUrl,
  });
}

// ============================================================
// EXPORT SETTINGS MODEL
// ============================================================
class ExportSetting {
  String id;
  String scale; // "1x", "2x", "3x", etc.
  String format; // "PNG", "JPG", "SVG", "PDF"
  String? suffix;

  ExportSetting({
    required this.id,
    this.scale = '1x',
    this.format = 'PNG',
    this.suffix,
  });
}

// ============================================================
// VARIABLE MODEL
// ============================================================
class VariableModel {
  String id;
  String name;
  String type; // "Color", "Number", "String", "Boolean"
  dynamic value;

  VariableModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
  });
}

// ============================================================
// STYLE MODEL
// ============================================================
class StyleModel {
  String id;
  String name;
  String type; // "Color", "Text", "Effect", "Grid"
  dynamic properties;

  StyleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.properties,
  });
}

// ============================================================
// PLUGIN MODEL
// ============================================================
class PluginModel {
  String id;
  String name;
  IconData icon;
  VoidCallback onTap;

  PluginModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

// ============================================================
// CONSTANTS - Tool Definitions
// ============================================================
class ToolConstants {
  static const List<Tool> allTools = [
    Tool(type: ToolType.move, name: 'Move', icon: Icons.near_me, shortcut: 'V'),
    Tool(
      type: ToolType.frame,
      name: 'Frame',
      icon: Icons.crop_square,
      shortcut: 'F',
    ),
    Tool(
      type: ToolType.rectangle,
      name: 'Rectangle',
      icon: Icons.rectangle_outlined,
      shortcut: 'R',
    ),
    Tool(
      type: ToolType.ellipse,
      name: 'Ellipse',
      icon: Icons.circle_outlined,
      shortcut: 'O',
    ),
    Tool(
      type: ToolType.polygon,
      name: 'Polygon',
      icon: Icons.star_outline,
      shortcut: '',
    ),
    Tool(type: ToolType.pen, name: 'Pen', icon: Icons.edit, shortcut: 'P'),
    Tool(
      type: ToolType.text,
      name: 'Text',
      icon: Icons.text_fields,
      shortcut: 'T',
    ),
    Tool(
      type: ToolType.hand,
      name: 'Hand',
      icon: Icons.pan_tool_outlined,
      shortcut: 'H',
    ),
    Tool(
      type: ToolType.comment,
      name: 'Comment',
      icon: Icons.comment_outlined,
      shortcut: 'C',
    ),
  ];
}

// ============================================================
// EXPORT FORMAT OPTIONS
// ============================================================
class ExportFormats {
  static const List<String> formats = ['PNG', 'JPG', 'SVG', 'PDF'];
  static const List<String> scales = [
    '0.5x',
    '0.75x',
    '1x',
    '1.5x',
    '2x',
    '3x',
    '4x',
  ];
}
