class CleanedPhoto {
  String cleanDuration;
  String viewName;
  String carImage;
  String whatsapp_msg;

  CleanedPhoto({
    required this.cleanDuration,
    required this.viewName,
    required this.carImage,
    required this.whatsapp_msg,
  });

  factory CleanedPhoto.fromJson(Map<String, dynamic> json) {
    return CleanedPhoto(
      cleanDuration: json['clean_duration'],
      viewName: json['view_name'],
      carImage: json['car_image'],
      whatsapp_msg: json['wa_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clean_duration': cleanDuration,
      'view_name': viewName,
      'car_image': carImage,
      'wa_text': whatsapp_msg,
    };
  }
}

class Ticket {
  String ticketContent;
  String status;
  String ticketId;

  Ticket({
    required this.ticketContent,
    required this.status,
    required this.ticketId,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketContent: json['ticket_content'],
      status: json['status'],
      ticketId: json['ticket_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ticket_content': ticketContent,
      'status': status,
      'ticket_id': ticketId,
    };
  }
}

class WashResponse {
  final String assignedDate;
  final String cleanedTime;
  final String washStatus;
  final String cleanerName;
  final String washType;
  final String? cancelReason;
  final String? cancelProof;
  final String clientName;
  final String mobileNo;
  final List<CleanedPhoto> cleanedPhotos;
  final List<Ticket> ticket;
  final String status;
  final String remarks;

  WashResponse({
    required this.assignedDate,
    required this.cleanedTime,
    required this.washStatus,
    required this.cleanerName,
    required this.washType,
    required this.cancelReason,
    required this.cancelProof,
    required this.clientName,
    required this.mobileNo,
    required this.cleanedPhotos,
    required this.ticket,
    required this.status,
    required this.remarks,
  });

  factory WashResponse.fromJson(Map<String, dynamic> json) {
    return WashResponse(
      assignedDate: json['assigned_date'] ?? '',
      cleanedTime: json['cleaned_time'] ?? '',
      washStatus: json['wash_status'] ?? '',
      cleanerName: json['cleaner_name'] ?? '',
      washType: json['wash_type'] ?? '',
      cancelReason: json['cancel_reason'],
      cancelProof: json['cancel_proof'],
      clientName: json['client_name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      cleanedPhotos: (json['cleaned_photos'] as List)
          .map((photo) => CleanedPhoto.fromJson(photo))
          .toList(),
      ticket:
          (json['ticket'] as List).map((tkt) => Ticket.fromJson(tkt)).toList(),
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
    );
  }
}
