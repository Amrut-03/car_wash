class IncentiveData {
  final String assignedDate;
  final dynamic dailyIncentive;
  final String washIncentive;
  final String kmIncentive;

  IncentiveData({
    required this.assignedDate,
    required this.dailyIncentive,
    required this.washIncentive,
    required this.kmIncentive,
  });

  factory IncentiveData.fromJson(Map<String, dynamic> json) {
    return IncentiveData(
      assignedDate: json['assigned_date'] ?? '',
      dailyIncentive: json['daily_incentive'] ?? 0,
      washIncentive: json['wash_incentive'] ?? '',
      kmIncentive: json['km_incentive'] ?? '',
    );
  }
}

class IncentiveResponse {
  final List<IncentiveData> data;
  final dynamic additionalIncentive;
  final dynamic count;
  final String status;
  final String remarks;

  IncentiveResponse({
    required this.data,
    required this.additionalIncentive,
    required this.count,
    required this.status,
    required this.remarks,
  });

  factory IncentiveResponse.fromJson(Map<String, dynamic> json) {
    var dataFromJson = json['data'] as List<dynamic>? ?? [];
    List<IncentiveData> incentiveDataList = dataFromJson
        .map((i) => IncentiveData.fromJson(i as Map<String, dynamic>))
        .toList();

    return IncentiveResponse(
      data: incentiveDataList,
      additionalIncentive: json['additional_incentive'],
      count: json['count'] ?? 0,
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}

class IncentiveRecord {
  final String washDate;
  final int incentive;

  IncentiveRecord({
    required this.washDate,
    required this.incentive,
  });

  Map<String, dynamic> toJson() {
    return {
      'washDate': washDate,
      'incentive': incentive,
    };
  }
}
