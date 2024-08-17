class ClientData {
  final CustomerDetails customerData;
  final String status;
  final String remarks;

  ClientData({
    required this.customerData,
    required this.status,
    required this.remarks,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      customerData: CustomerDetails.fromJson(json['customer_data']),
      status: json['status'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_data': customerData.toJson(),
      'status': status,
      'remarks': remarks,
    };
  }
}

class CustomerDetails {
  final String clientName;
  final String mobileNo;

  CustomerDetails({
    required this.clientName,
    required this.mobileNo,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      clientName: json['client_name'],
      mobileNo: json['mobile_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_name': clientName,
      'mobile_no': mobileNo,
    };
  }
}

class NewCar {
  final String carId;
  final String modelName;
  final String vehicleNo;
  final String address;
  final String carType;
  final String carImage;
  final String latitude;
  final String longitude;
  final String type;

  NewCar({
    required this.carId,
    required this.modelName,
    required this.vehicleNo,
    required this.address,
    required this.carType,
    required this.carImage,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory NewCar.fromJson(Map<String, dynamic> json) {
    return NewCar(
      carId: json['car_id'],
      modelName: json['model_name'],
      vehicleNo: json['vehicle_no'],
      address: json['address'],
      carType: json['car_type'],
      carImage: json['car_image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: 'New',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'model_name': modelName,
      'vehicle_no': vehicleNo,
      'address': address,
      'car_type': carType,
      'car_image': carImage,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    };
  }

  NewCar copyWith({
    String? carId,
    String? modelName,
    String? vehicleNo,
    String? address,
    String? carType,
    String? carImage,
    String? latitude,
    String? longitude,
    String? type,
  }) {
    return NewCar(
      carId: carId ?? this.carId,
      modelName: modelName ?? this.modelName,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      address: address ?? this.address,
      carType: carType ?? this.carType,
      carImage: carImage ?? this.carImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
    );
  }
}

class AvailableCar {
  final String carId;
  final String modelName;
  final String vehicleNo;
  final String address;
  final String carType;
  final String carImage;
  final String latitude;
  final String longitude;
  final String status;
  final String type;

  AvailableCar({
    required this.carId,
    required this.modelName,
    required this.vehicleNo,
    required this.address,
    required this.carType,
    required this.carImage,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.type,
  });

  factory AvailableCar.fromJson(Map<String, dynamic> json) {
    return AvailableCar(
      carId: json['car_id'],
      modelName: json['model_name'],
      vehicleNo: json['vehicle_no'],
      address: json['address'],
      carType: json['car_type'],
      carImage: json['car_image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: 'Active',
      type: 'Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'model_name': modelName,
      'vehicle_no': vehicleNo,
      'address': address,
      'car_type': carType,
      'car_image': carImage,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'type': type,
    };
  }

  AvailableCar copyWith({
    String? carId,
    String? modelName,
    String? vehicleNo,
    String? address,
    String? carType,
    String? carImage,
    String? latitude,
    String? longitude,
    String? status,
    String? type,
  }) {
    return AvailableCar(
      carId: carId ?? this.carId,
      modelName: modelName ?? this.modelName,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      address: address ?? this.address,
      carType: carType ?? this.carType,
      carImage: carImage ?? this.carImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

class RemovedCar {
  final String carId;
  final String status;

  RemovedCar({
    required this.carId,
    required this.status,
  });

  factory RemovedCar.fromJson(Map<String, dynamic> json) {
    return RemovedCar(
      carId: json['car_id'],
      status: 'Removed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'status': status,
    };
  }
}

class AvailableCarWOImg {
  final String carId;
  final String modelName;
  final String vehicleNo;
  final String address;
  final String carType;
  final String latitude;
  final String longitude;
  final String status;
  final String type;

  AvailableCarWOImg({
    required this.carId,
    required this.modelName,
    required this.vehicleNo,
    required this.address,
    required this.carType,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.type,
  });

  factory AvailableCarWOImg.fromJson(Map<String, dynamic> json) {
    return AvailableCarWOImg(
      carId: json['car_id'],
      modelName: json['model_name'],
      vehicleNo: json['vehicle_no'],
      address: json['address'],
      carType: json['car_type'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: 'Active',
      type: 'Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'model_name': modelName,
      'vehicle_no': vehicleNo,
      'address': address,
      'car_type': carType,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'type': type,
    };
  }
}