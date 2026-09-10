enum FarmType {
  egg,
  meat,
  both;

  bool get hasEggs => this == egg || this == both;
  bool get hasMeat => this == meat || this == both;

  String toJson() => name;

  static FarmType fromJson(String value) =>
      FarmType.values.firstWhere((e) => e.name == value, orElse: () => FarmType.egg);
}
