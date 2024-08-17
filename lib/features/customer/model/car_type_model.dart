class CarType {
  final String typeId;
  final String carType;

  CarType({
    required this.typeId,
    required this.carType,
  });

  factory CarType.fromJson(Map<String, dynamic> json) {
    return CarType(
      typeId: json['type_id'] as String,
      carType: json['car_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type_id': typeId,
      'car_type': carType,
    };
  }
}

class ResponseModel {
  final List<CarType> data;
  final String status;
  final String remarks;

  ResponseModel({
    required this.data,
    required this.status,
    required this.remarks,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((item) => CarType.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
      remarks: json['remarks'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((carType) => carType.toJson()).toList(),
      'status': status,
      'remarks': remarks,
    };
  }
}
