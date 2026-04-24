import 'package:flutter/material.dart';
import '../../../../domain/models/palette_color.dart';

/// Inline 20-color grid for selecting a habit color.
///
/// Shows all palette colors as 32dp circular swatches with a selection
/// ring on the currently selected color.
class ColorPickerField extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const ColorPickerField({
    super.key,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(PaletteColor.colors.length, (index) {
            final color = PaletteColor.colors[index];
            final isSelected = index == selectedIndex;
            final colorName = PaletteColor.getName(index);

            return Semantics(
              label:
                  'Color ${index + 1}: $colorName, ${isSelected ? "selected" : "unselected"}',
              button: true,
              selected: isSelected,
              child: GestureDetector(
                onTap: () => onColorSelected(index),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                            color: const Color(0xFF212121),
                            width: 3,
                          )
                        : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
