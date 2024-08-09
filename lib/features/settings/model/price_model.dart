
class PriceModel {
  final String priceId;
  final String incentive;
  final String washType;
  final String carType;

  PriceModel({
    required this.priceId,
    required this.incentive,
    required this.washType,
    required this.carType,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      priceId: json['price_id'],
      incentive: json['incentive'],
      washType: json['wash_types'],
      carType: json['car_type'],
    );
  }
}
