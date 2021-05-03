class CodeNameData {
  final String code;
  final String name;

  CodeNameData(this.code, this.name);

  CodeNameData.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
      };
}
