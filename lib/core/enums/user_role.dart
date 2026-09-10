enum UserRole {
  owner,
  worker;

  bool get canViewFinance => this == owner;
  bool get canExportReports => this == owner;
  bool get canManageUsers => this == owner;
  bool get canManageBackup => this == owner;
  bool get canDeleteRecords => this == owner;
  bool get canEditRecords => this == owner;
  bool get canChangeFarmSettings => this == owner;

  // Workers can do data entry only
  bool get canAddRecords => true;
  bool get canViewRecords => true;

  String toJson() => name;

  static UserRole fromJson(String value) =>
      UserRole.values.firstWhere((e) => e.name == value, orElse: () => UserRole.worker);
}
