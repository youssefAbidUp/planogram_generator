// lib/widgets/node_properties_panel.dart
// Properties panel for selected nodes - COMPLETE VERSION

import 'package:figma_editor/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import 'common_widgets.dart';

class NodePropertiesPanel extends StatelessWidget {
  const NodePropertiesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final selectedNode = appState.selectedNode;

        if (selectedNode == null) {
          return EmptyState(
            icon: Icons.ads_click,
            message: AppLocalizations.of(context)!.selectElementToEdit,
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Node info section
              CollapsibleSection(
                title: AppLocalizations.of(context)!.element,
                isExpanded: true,
                onToggle: () {},
                children: [
                  const SizedBox(height: 8),
                  _NodeInfoSection(node: selectedNode),
                  const SizedBox(height: 12),
                ],
              ),

              Divider(height: 1, color: Colors.grey.shade300),

              // Position & Size
              CollapsibleSection(
                title: AppLocalizations.of(context)!.positionAndSize,
                isExpanded: true,
                onToggle: () {},
                children: [
                  const SizedBox(height: 8),
                  _PositionSizeSection(node: selectedNode),
                  const SizedBox(height: 12),
                ],
              ),

              Divider(height: 1, color: Colors.grey.shade300),

              // Appearance (for shapes)
              if (selectedNode is RectangleNode ||
                  selectedNode is EllipseNode) ...[
                CollapsibleSection(
                  title: AppLocalizations.of(context)!.appearance,
                  isExpanded: true,
                  onToggle: () {},
                  children: [
                    const SizedBox(height: 8),
                    _AppearanceSection(node: selectedNode),
                    const SizedBox(height: 12),
                  ],
                ),
                Divider(height: 1, color: Colors.grey.shade300),
              ],

              // Corner Radius (for rectangles)
              if (selectedNode is RectangleNode) ...[
                CollapsibleSection(
                  title: AppLocalizations.of(context)!.cornerRadius,
                  isExpanded: true,
                  onToggle: () {},
                  children: [
                    const SizedBox(height: 8),
                    _CornerRadiusSection(node: selectedNode as RectangleNode),
                    const SizedBox(height: 12),
                  ],
                ),
                Divider(height: 1, color: Colors.grey.shade300),
              ],

              // Actions
              Padding(
                padding: const EdgeInsets.all(12),
                child: CustomButton(
                  label: AppLocalizations.of(context)!.deleteElement,
                  onPressed: () {
                    Provider.of<AppState>(
                      context,
                      listen: false,
                    ).deleteSelectedNodes();
                  },
                  icon: Icons.delete_outline,
                  backgroundColor: Colors.red.shade50,
                  textColor: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// NODE INFO SECTION
// ============================================================
class _NodeInfoSection extends StatelessWidget {
  final FigmaNode node;

  const _NodeInfoSection({required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          controller: TextEditingController(text: node.name),
          style: const TextStyle(fontSize: 13),
          onChanged: (value) {
            node.name = value;
            Provider.of<AppState>(context, listen: false).notifyListeners();
          },
        ),
        const SizedBox(height: 8),
        PropertyRow(
          label: 'Type',
          value: node.runtimeType.toString().replaceAll('Node', ''),
          onTap: null,
        ),
      ],
    );
  }
}

// ============================================================
// POSITION & SIZE SECTION
// ============================================================
class _PositionSizeSection extends StatelessWidget {
  final FigmaNode node;

  const _PositionSizeSection({required this.node});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _NumberField(
                label: 'X',
                value: node.position.dx,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodePosition(node, Offset(value, node.position.dy));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NumberField(
                label: 'Y',
                value: node.position.dy,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodePosition(node, Offset(node.position.dx, value));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _NumberField(
                label: 'W',
                value: node.size.width,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodeSize(node, Size(value, node.size.height));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _NumberField(
                label: 'H',
                value: node.size.height,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodeSize(node, Size(node.size.width, value));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// APPEARANCE SECTION
// ============================================================
class _AppearanceSection extends StatelessWidget {
  final FigmaNode node;

  const _AppearanceSection({required this.node});

  @override
  Widget build(BuildContext context) {
    FillType fillType = FillType.solid;
    Color fillColor = Colors.grey;
    Gradient? gradient;
    String? imageUrl;
    Color? strokeColor;
    double strokeWeight = 0;

    if (node is RectangleNode) {
      final rect = node as RectangleNode;
      fillType = rect.fillType;
      fillColor = rect.fillColor;
      gradient = rect.gradient;
      imageUrl = rect.imageUrl;
      strokeColor = rect.strokeColor;
      strokeWeight = rect.strokeWeight;
    } else if (node is EllipseNode) {
      final ellipse = node as EllipseNode;
      fillType = ellipse.fillType;
      fillColor = ellipse.fillColor;
      gradient = ellipse.gradient;
      imageUrl = ellipse.imageUrl;
      strokeColor = ellipse.strokeColor;
      strokeWeight = ellipse.strokeWeight;
    }

    return Column(
      children: [
        // Fill Type Selector
        PropertyRow(
          label: 'Fill Type',
          value: fillType.toString().split('.').last.toUpperCase(),
          onTap: () {
            _showFillTypeSelector(context, fillType);
          },
        ),

        const SizedBox(height: 8),

        // Solid Color
        if (fillType == FillType.solid)
          PropertyRow(
            label: 'Fill Color',
            value: _colorToHex(fillColor),
            labelColor: fillColor,
            onTap: () {
              _showColorPicker(context, 'Fill Color', fillColor, (color) {
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).updateNodeProperty(node, 'fillColor', color);
              });
            },
          ),

        // Gradient
        if (fillType == FillType.gradient) ...[
          PropertyRow(
            label: 'Gradient',
            value: gradient != null ? 'Custom' : 'None',
            onTap: () {
              _showGradientPicker(context);
            },
          ),
        ],

        // Image URL
        if (fillType == FillType.image) ...[
          TextField(
            decoration: const InputDecoration(
              labelText: 'Image URL',
              hintText: 'https://example.com/image.jpg',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            controller: TextEditingController(text: imageUrl ?? ''),
            style: const TextStyle(fontSize: 12),
            onSubmitted: (value) {
              Provider.of<AppState>(
                context,
                listen: false,
              ).updateNodeProperty(node, 'imageUrl', value);
            },
          ),
        ],

        const SizedBox(height: 8),

        // Stroke Color
        PropertyRow(
          label: 'Stroke',
          value: strokeColor != null ? _colorToHex(strokeColor) : 'None',
          labelColor: strokeColor,
          onTap: () {
            _showColorPicker(
              context,
              'Stroke Color',
              strokeColor ?? Colors.black,
              (color) {
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).updateNodeProperty(node, 'strokeColor', color);
              },
            );
          },
        ),

        if (strokeColor != null) ...[
          const SizedBox(height: 8),
          _NumberField(
            label: 'Stroke Weight',
            value: strokeWeight,
            onChanged: (value) {
              Provider.of<AppState>(
                context,
                listen: false,
              ).updateNodeProperty(node, 'strokeWeight', value);
            },
          ),
        ],
      ],
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showFillTypeSelector(BuildContext context, FillType currentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.fillType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.solidColor),
              leading: Radio<FillType>(
                value: FillType.solid,
                groupValue: currentType,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodeProperty(node, 'fillType', value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.gradient),
              leading: Radio<FillType>(
                value: FillType.gradient,
                groupValue: currentType,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodeProperty(node, 'fillType', value);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.image),
              leading: Radio<FillType>(
                value: FillType.image,
                groupValue: currentType,
                onChanged: (value) {
                  Provider.of<AppState>(
                    context,
                    listen: false,
                  ).updateNodeProperty(node, 'fillType', value);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGradientPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.gradientPicker),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.linearGradient),
              subtitle: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () {
                const gradient = LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                );
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).updateNodeProperty(node, 'gradient', gradient);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.radialGradient),
              subtitle: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Colors.yellow, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () {
                const gradient = RadialGradient(
                  colors: [Colors.yellow, Colors.red],
                );
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).updateNodeProperty(node, 'gradient', gradient);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sunsetGradient),
              subtitle: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onTap: () {
                const gradient = LinearGradient(
                  colors: [Colors.orange, Colors.pink, Colors.purple],
                );
                Provider.of<AppState>(
                  context,
                  listen: false,
                ).updateNodeProperty(node, 'gradient', gradient);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(
    BuildContext context,
    String title,
    Color currentColor,
    Function(Color) onColorSelected,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Hex Color',
                hintText: '#FF0000',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: _colorToHex(currentColor),
              ),
              onSubmitted: (value) {
                try {
                  final color = Color(int.parse(value.replaceAll('#', '0xFF')));
                  onColorSelected(color);
                  Navigator.pop(context);
                } catch (e) {
                  print('Invalid color: $value');
                }
              },
            ),
            const SizedBox(height: 16),
            // Color presets
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                    Colors.pink,
                    Colors.grey,
                    Colors.black,
                    Colors.white,
                  ].map((color) {
                    return InkWell(
                      onTap: () {
                        onColorSelected(color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CORNER RADIUS SECTION
// ============================================================
class _CornerRadiusSection extends StatefulWidget {
  final RectangleNode node;

  const _CornerRadiusSection({required this.node});

  @override
  State<_CornerRadiusSection> createState() => _CornerRadiusSectionState();
}

class _CornerRadiusSectionState extends State<_CornerRadiusSection> {
  bool uniformRadius = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Uniform',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ),
            Switch(
              value: uniformRadius,
              onChanged: (value) {
                setState(() {
                  uniformRadius = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (uniformRadius)
          _NumberField(
            label: 'Radius',
            value: widget.node.uniformCornerRadius,
            onChanged: (value) {
              Provider.of<AppState>(
                context,
                listen: false,
              ).updateNodeProperty(widget.node, 'uniformCornerRadius', value);
            },
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _NumberField(
                      label: 'Top Left',
                      value: widget.node.borderRadius.topLeft.x,
                      onChanged: (value) {
                        final newRadius = BorderRadius.only(
                          topLeft: Radius.circular(value),
                          topRight: widget.node.borderRadius.topRight,
                          bottomLeft: widget.node.borderRadius.bottomLeft,
                          bottomRight: widget.node.borderRadius.bottomRight,
                        );
                        Provider.of<AppState>(
                          context,
                          listen: false,
                        ).updateNodeProperty(
                          widget.node,
                          'borderRadius',
                          newRadius,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: 'Top Right',
                      value: widget.node.borderRadius.topRight.x,
                      onChanged: (value) {
                        final newRadius = BorderRadius.only(
                          topLeft: widget.node.borderRadius.topLeft,
                          topRight: Radius.circular(value),
                          bottomLeft: widget.node.borderRadius.bottomLeft,
                          bottomRight: widget.node.borderRadius.bottomRight,
                        );
                        Provider.of<AppState>(
                          context,
                          listen: false,
                        ).updateNodeProperty(
                          widget.node,
                          'borderRadius',
                          newRadius,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _NumberField(
                      label: 'Bottom Left',
                      value: widget.node.borderRadius.bottomLeft.x,
                      onChanged: (value) {
                        final newRadius = BorderRadius.only(
                          topLeft: widget.node.borderRadius.topLeft,
                          topRight: widget.node.borderRadius.topRight,
                          bottomLeft: Radius.circular(value),
                          bottomRight: widget.node.borderRadius.bottomRight,
                        );
                        Provider.of<AppState>(
                          context,
                          listen: false,
                        ).updateNodeProperty(
                          widget.node,
                          'borderRadius',
                          newRadius,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: 'Bottom Right',
                      value: widget.node.borderRadius.bottomRight.x,
                      onChanged: (value) {
                        final newRadius = BorderRadius.only(
                          topLeft: widget.node.borderRadius.topLeft,
                          topRight: widget.node.borderRadius.topRight,
                          bottomLeft: widget.node.borderRadius.bottomLeft,
                          bottomRight: Radius.circular(value),
                        );
                        Provider.of<AppState>(
                          context,
                          listen: false,
                        ).updateNodeProperty(
                          widget.node,
                          'borderRadius',
                          newRadius,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

// ============================================================
// NUMBER INPUT FIELD
// ============================================================
class _NumberField extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      controller: TextEditingController(text: value.toStringAsFixed(0)),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))],
      style: const TextStyle(fontSize: 13),
      onChanged: (text) {
        final parsed = double.tryParse(text);
        if (parsed != null) {
          onChanged(parsed);
        }
      },
    );
  }
}
