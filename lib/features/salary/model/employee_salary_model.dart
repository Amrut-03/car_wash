class EmployeeSalaryData {
  final String empId;
  final String name;
  final String employeePic;
  final String salary;

  EmployeeSalaryData({
    required this.empId,
    required this.name,
    required this.employeePic,
    required this.salary,
  });

  factory EmployeeSalaryData.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryData(
      empId: json['employee_id'],
      name: json['employee_name'],
      employeePic: json['employee_pic'],
      salary: json['salary'],
    );
  }
}

class EmployeeSalaryMonthData {
  final String employeeName;
  final String address;
  final String phone1;
  final String employeeId;
  final String empId;
  final String employeePic;
  final List<SalaryData> data;
  final int count;
  final String status;
  final String remarks;

  EmployeeSalaryMonthData({
    required this.employeeName,
    required this.address,
    required this.phone1,
    required this.employeeId,
    required this.empId,
    required this.employeePic,
    required this.data,
    required this.count,
    required this.status,
    required this.remarks,
  });

  factory EmployeeSalaryMonthData.fromJson(Map<String, dynamic> json) {
    var dataFromJson = json['data'] as List;
    List<SalaryData> salaryDataList = dataFromJson.map((i) => SalaryData.fromJson(i)).toList();

    return EmployeeSalaryMonthData(
      employeeName: json['employee_name'],
      address: json['address'],
      phone1: json['phone_1'],
      employeeId: json['employee_id'],
      empId: json['emp_id'],
      employeePic: json['employee_pic'],
      data: salaryDataList,
      count: json['count'],
      status: json['status'],
      remarks: json['remarks'],
    );
  }
}

class SalaryData {
  final String year;
  final dynamic month;
  final String salary;

  SalaryData({
    required this.year,
    required this.month,
    required this.salary,
  });

  factory SalaryData.fromJson(Map<String, dynamic> json) {
    return SalaryData(
      year: json['year'],
      month: json['month'],
      salary: json['salary'],
    );
  }
}

