class WashListItem {
  String id;
  String? washDate;
  String washStatus;
  String? assignedDate;

  WashListItem({
    required this.id,
    this.washDate,
    required this.washStatus,
    required this.assignedDate,
  });

  factory WashListItem.fromJson(Map<String, dynamic> json) {
    return WashListItem(
      id: json['id'],
      washDate: json['wash_date'],
      washStatus: json['wash_status'],
      assignedDate: json['assigned_date'],
    );
  }
  static List<WashListItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => WashListItem.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wash_date': washDate,
      'wash_status': washStatus,
      'assigned_date': assignedDate,
    };
  }
}

class CarItem {
  String modelName;
  String carId;
  String vehicleNo;
  String latitude;
  String longitude;
  String carImage;

  CarItem({
    required this.modelName,
    required this.carId,
    required this.vehicleNo,
    required this.latitude,
    required this.longitude,
    required this.carImage,
  });

  factory CarItem.fromJson(Map<String, dynamic> json) {
    return CarItem(
      modelName: json['model_name'],
      carId: json['car_id'],
      vehicleNo: json['vehicle_no'],
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      carImage: json['car_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_name': modelName,
      'car_id': carId,
      'vehicle_no': vehicleNo,
      'latitude': latitude,
      'longitude': longitude,
      'car_image': carImage,
    };
  }
}

class CustomerData {
  String customerName;
  String mobileNo;
  String dateTime;
  List<WashListItem> washList;
  List<CarItem> carList;
  String status;
  String remarks;

  CustomerData({
    required this.customerName,
    required this.mobileNo,
    required this.dateTime,
    required this.washList,
    required this.carList,
    required this.status,
    required this.remarks,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    var washList = json['wash_list'] as List;
    var carList = json['car_list'] as List;

    return CustomerData(
      customerName: json['customer_name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      dateTime: json['dateTime'] ?? '',
      washList: washList.map((i) => WashListItem.fromJson(i)).toList(),
      carList: carList.map((i) => CarItem.fromJson(i)).toList(),
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'mobile_no': mobileNo,
      'dateTime': dateTime,
      'wash_list': washList.map((i) => i.toJson()).toList(),
      'car_list': carList.map((i) => i.toJson()).toList(),
      'status': status,
      'remarks': remarks,
    };
  }
}
