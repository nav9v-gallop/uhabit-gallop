import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../domain/models/frequency.dart';
import '../../../../domain/models/palette_color.dart';

/// Segmented frequency picker with inline number input.
///
/// Shows three segments (Daily / Weekly / Monthly) and a number input
/// below reading "X time(s) per [period]".
///
/// Emits frequency changes as (freqNum, freqDen) via [onChanged].
class FrequencyPicker extends StatefulWidget {
  final int freqNum;
  final int freqDen;
  final int colorIndex;
  final ValueChanged<(int, int)> onChanged;

  const FrequencyPicker({
    super.key,
    required this.freqNum,
    required this.freqDen,
    required this.colorIndex,
    required this.onChanged,
  });

  @override
  State<FrequencyPicker> createState() => _FrequencyPickerState();
}

class _FrequencyPickerState extends State<FrequencyPicker> {
  late TextEditingController _numController;
  late FrequencyPreset _selectedPreset;

  @override
  void initState() {
    super.initState();
    _numController =
        TextEditingController(text: widget.freqNum.toString());
    _selectedPreset = FrequencyPreset.fromDenominator(widget.freqDen);
  }

  @override
  void didUpdateWidget(FrequencyPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.freqNum != widget.freqNum) {
      _numController.text = widget.freqNum.toString();
    }
    if (oldWidget.freqDen != widget.freqDen) {
      _selectedPreset = FrequencyPreset.fromDenominator(widget.freqDen);
    }
  }

  @override
  void dispose() {
    _numController.dispose();
    super.dispose();
  }

  void _onPresetChanged(FrequencyPreset preset) {
    setState(() => _selectedPreset = preset);
    final num = int.tryParse(_numController.text) ?? 1;
    widget.onChanged((num < 1 ? 1 : num, preset.denominator));
  }

  void _onNumSubmitted() {
    final num = int.tryParse(_numController.text) ?? 1;
    final corrected = num < 1 ? 1 : num;
    if (corrected != num) {
      _numController.text = corrected.toString();
    }
    widget.onChanged((corrected, _selectedPreset.denominator));
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = PaletteColor.getColor(widget.colorIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequency',
          style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 6),
        // Segmented control
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: habitColor, width: 1.5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: FrequencyPreset.values.map((preset) {
              final isSelected = preset == _selectedPreset;
              final isFirst = preset == FrequencyPreset.values.first;
              final isLast = preset == FrequencyPreset.values.last;
              return Expanded(
                child: Semantics(
                  selected: isSelected,
                  child: GestureDetector(
                    onTap: () => _onPresetChanged(preset),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? habitColor : Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          left: isFirst
                              ? const Radius.circular(22)
                              : Radius.zero,
                          right: isLast
                              ? const Radius.circular(22)
                              : Radius.zero,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        preset.name[0].toUpperCase() +
                            preset.name.substring(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : habitColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        // Number input row
        Row(
          children: [
            SizedBox(
              width: 60,
              child: TextField(
                controller: _numController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  isDense: true,
                ),
                onEditingComplete: _onNumSubmitted,
                onChanged: (_) => _onNumSubmitted(),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'time(s) per ${_selectedPreset.label}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF616161),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
