/// Frequency encoding helper.
///
/// The freq_num / freq_den pair encodes all frequency patterns:
///
/// | User Selection       | freq_num | freq_den |
/// |----------------------|----------|----------|
/// | Every day            | 1        | 1        |
/// | Every week           | 1        | 7        |
/// | Every month          | 1        | 30       |
/// | X times per week     | X        | 7        |
/// | X times per month    | X        | 30       |
/// | Every X days         | 1        | X        |
enum FrequencyPreset {
  daily(1),
  weekly(7),
  monthly(30);

  const FrequencyPreset(this.denominator);
  final int denominator;

  String get label {
    switch (this) {
      case FrequencyPreset.daily:
        return 'day';
      case FrequencyPreset.weekly:
        return 'week';
      case FrequencyPreset.monthly:
        return 'month';
    }
  }

  /// Determines the preset from a given denominator value.
  static FrequencyPreset fromDenominator(int den) {
    if (den == 7) return FrequencyPreset.weekly;
    if (den == 30) return FrequencyPreset.monthly;
    return FrequencyPreset.daily;
  }
}
