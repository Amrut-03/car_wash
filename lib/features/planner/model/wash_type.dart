class WashType {
  final String washId;
  final String washName;

  WashType({
    required this.washId,
    required this.washName,
  });

  factory WashType.fromJson(Map<String, dynamic> json) {
    return WashType(
      washId: json['wash_id'],
      washName: json['wash_types'],
    );
  }
}
