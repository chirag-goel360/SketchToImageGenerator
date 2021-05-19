
class KeyValueData {
  final String key;
  final dynamic value;

  KeyValueData(this.key, this.value);

  KeyValueData.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}

class KeyLabelData {
  final String key;
  final String label;

  KeyLabelData(this.key, this.label);

  KeyLabelData.fromJson(Map<String, dynamic> json)
      : key = json['key'],
        label = json['label'];

  Map<String, String> toJson() => {
        'key': key,
        'value': label,
      };
}

class KeyValueWithDisabled extends KeyValueData {
  bool disabled;
  String key;
  dynamic value;

  KeyValueWithDisabled(this.key, this.value, [this.disabled = false])
      : super(key, value);
}

class KeyValueDisableWithExtraDetails extends KeyValueData {
  bool disabled;
  Map<String, dynamic> extraDetails;
  String key;
  dynamic value;

  KeyValueDisableWithExtraDetails(this.key, this.value,
      [this.disabled = false, this.extraDetails = const {}])
      : super(key, value);
}

/// we can use this class in the case where we have to display some metrics in some form field
/// but at the same time we need to translate that field too
class KeyValueDataWithMetrics extends KeyValueData {
  int metricData;
  String key;
  String value;

  KeyValueDataWithMetrics(
    this.key,
    this.value, {
    this.metricData,
  }) : super(key, value);

  // KeyValueWithDisabled translateValueAndAppendMetrics(
  //         AppLocalization localization) =>
  //     KeyValueWithDisabled(
  //         key, '${localization.translate(value)} (${metricData.toString()})');
}
