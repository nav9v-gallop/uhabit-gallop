import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/models/palette_color.dart';

/// Grouped card for measurable habit fields.
///
/// Contains target value, unit, and target type (At least / At most)
/// in a tinted card with a "MEASUREMENT" header.
class MeasurementSection extends StatelessWidget {
  final double targetValue;
  final String unit;
  final int targetType;
  final int colorIndex;
  final String? targetValueError;
  final ValueChanged<double> onTargetValueChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<int> onTargetTypeChanged;

  const MeasurementSection({
    super.key,
    required this.targetValue,
    required this.unit,
    required this.targetType,
    required this.colorIndex,
    required this.onTargetValueChanged,
    required this.onUnitChanged,
    required this.onTargetTypeChanged,
    this.targetValueError,
  });

  @override
  Widget build(BuildContext context) {
    final habitColor = PaletteColor.getColor(colorIndex);

    return Container(
      decoration: BoxDecoration(
        color: habitColor.withOpacity(0.05),
        border: Border.all(color: habitColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MEASUREMENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: habitColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          // Target + Unit row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Target
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Target',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        isDense: true,
                        errorText: targetValueError,
                        hintText: '0',
                      ),
                      controller: TextEditingController(
                        text: targetValue > 0
                            ? (targetValue == targetValue.roundToDouble()
                                ? targetValue.toInt().toString()
                                : targetValue.toString())
                            : '',
                      ),
                      onChanged: (value) {
                        final parsed = double.tryParse(value) ?? 0.0;
                        onTargetValueChanged(parsed);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Unit
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Unit',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        isDense: true,
                        hintText: 'e.g. glasses',
                      ),
                      controller: TextEditingController(text: unit),
                      onChanged: onUnitChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Target type segmented control
          const Text(
            'Target type',
            style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: habitColor, width: 1.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _TargetTypeButton(
                  label: 'At least',
                  isSelected: targetType == 0,
                  isFirst: true,
                  color: habitColor,
                  onTap: () => onTargetTypeChanged(0),
                ),
                _TargetTypeButton(
                  label: 'At most',
                  isSelected: targetType == 1,
                  isFirst: false,
                  color: habitColor,
                  onTap: () => onTargetTypeChanged(1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isFirst;
  final Color color;
  final VoidCallback onTap;

  const _TargetTypeButton({
    required this.label,
    required this.isSelected,
    required this.isFirst,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        selected: isSelected,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              borderRadius: BorderRadius.horizontal(
                left: isFirst
                    ? const Radius.circular(22)
                    : Radius.zero,
                right: !isFirst
                    ? const Radius.circular(22)
                    : Radius.zero,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
