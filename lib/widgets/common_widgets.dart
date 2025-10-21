// lib/widgets/common_widgets.dart

import 'package:flutter/material.dart';

// ============================================================
// CUSTOM TAB - Reusable Tab Component
// ============================================================
class CustomTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomTab({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 36, // FIXED: Explicit height
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 0,
          ), // FIXED: No vertical padding
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isSelected ? Border.all(color: Colors.grey.shade300) : null,
          ),
          alignment: Alignment.center, // FIXED: Center content vertically
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey.shade600,
              height: 1.2, // FIXED: Line height to prevent cutting
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TOOL BUTTON - Reusable Tool Button with Tooltip
// ============================================================
class ToolButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const ToolButton({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade200 : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.blue : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COLLAPSIBLE SECTION - Expandable Section Component
// ============================================================
class CollapsibleSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsets? padding;

  const CollapsibleSection({
    Key? key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.trailing,
    required this.children,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
      ],
    );
  }
}

// ============================================================
// CHECKBOX FIELD - Reusable Checkbox
// ============================================================

class CheckboxField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CheckboxField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('🔵 Checkbox tapped!');
        print('🔵 Current value: $value');
        print('🔵 New value will be: ${!value}');
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Custom checkbox visual
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: value ? Colors.blue : Colors.transparent,
                border: Border.all(
                  color: value ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: value
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// PROPERTY ROW - Row with label, value, and optional trailing
// ============================================================
class PropertyRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? labelColor;

  const PropertyRow({
    Key? key,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
    this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            if (labelColor != null) ...[
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.grey.shade400, width: 0.5),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            Text(
              value,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DROPDOWN BUTTON - Reusable Dropdown
// ============================================================
class DropdownButton extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double? width;

  const DropdownButton({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        width: width,
        constraints: const BoxConstraints(
          minHeight: 32, // FIXED: Ensure minimum height
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ), // FIXED: More padding
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.2, // FIXED: Line height to prevent cutting
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => items.map((item) {
        final isSelected = item == value;
        return PopupMenuItem<String>(
          value: item,
          height: 40, // FIXED: Consistent height
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2, // FIXED: Prevent text cutting
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, size: 16, color: Colors.blue),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// CUSTOM BUTTON - Reusable Button
// ============================================================
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool outlined;
  final IconData? icon;
  final bool fullWidth;
  final bool small;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.outlined = false,
    this.icon,
    this.fullWidth = true,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          vertical: small ? 6 : 8,
          horizontal: small ? 10 : 12,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: outlined
              ? Colors.transparent
              : (backgroundColor ?? Colors.grey.shade100),
          border: outlined ? Border.all(color: Colors.grey.shade300) : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: small ? 14 : 16,
                color: textColor ?? Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: small ? 11 : 12,
                color: textColor ?? Colors.grey.shade700,
                fontWeight: small ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ICON BUTTON WIDGET - Reusable Icon Button
// ============================================================
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;
  final double? size;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size ?? 16),
      color: color ?? Colors.grey.shade600,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

// ============================================================
// SEARCH FIELD - Reusable Search Input
// ============================================================
class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const SearchField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.onFilterTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade600),
        suffixIcon: onFilterTap != null
            ? IconButton(
                icon: Icon(Icons.tune, size: 18, color: Colors.grey.shade600),
                onPressed: onFilterTap,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        isDense: true,
      ),
      style: const TextStyle(fontSize: 13),
    );
  }
}

// ============================================================
// LIBRARY ITEM - Card for Libraries
// ============================================================
class LibraryItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Gradient? gradient;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const LibraryItemCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.color,
    this.gradient,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: gradient == null ? color : null,
                gradient: gradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _getShortTitle(title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortTitle(String title) {
    final words = title.split(' ');
    if (words.length > 3) {
      return words.take(2).join('\n');
    } else if (title.length > 20) {
      return words.first;
    }
    return title;
  }
}

// ============================================================
// CONTEXT MENU - Right-click Menu
// ============================================================
class ContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;
  final Offset position;

  const ContextMenu({Key? key, required this.items, required this.position})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Invisible overlay to close menu
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        // Menu
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  if (item.isDivider) {
                    return Divider(height: 1, color: Colors.grey.shade300);
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      item.onTap?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              size: 16,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 13,
                                color: item.isDestructive
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          ),
                          if (item.shortcut != null)
                            Text(
                              item.shortcut!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContextMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? shortcut;
  final bool isDivider;
  final bool isDestructive;

  const ContextMenuItem({
    this.label = '',
    this.icon,
    this.onTap,
    this.shortcut,
    this.isDivider = false,
    this.isDestructive = false,
  });

  static const divider = ContextMenuItem(isDivider: true);
}

// ============================================================
// EMPTY STATE - When no items
// ============================================================
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            if (actionLabel != null && onActionTap != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                label: actionLabel!,
                onPressed: onActionTap!,
                fullWidth: false,
                small: true,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// LOADING INDICATOR
// ============================================================
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
