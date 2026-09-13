import 'package:flutter/material.dart';

class ColorDotSelector extends StatelessWidget {
  final List<String> hexColors;
  final String? selectedColor;
  final ValueChanged<String>? onColorSelected;
  final double dotSize;

  const ColorDotSelector({
    Key? key,
    required this.hexColors,
    this.selectedColor,
    this.onColorSelected,
    this.dotSize = 14.0,
  }) : super(key: key);

  Color _parseColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hexColors.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: hexColors.map((colorHex) {
        final color = _parseColor(colorHex);
        final isSelected = selectedColor == colorHex;

        return GestureDetector(
          onTap: onColorSelected != null ? () => onColorSelected!(colorHex) : null,
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            width: dotSize + (isSelected ? 4 : 0),
            height: dotSize + (isSelected ? 4 : 0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.black12,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
