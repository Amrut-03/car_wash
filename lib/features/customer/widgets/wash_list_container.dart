import 'package:car_wash/features/customer/model/wash_info_model.dart';
import 'package:car_wash/features/customer/widgets/wash_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WashListContainer extends StatelessWidget {
  const WashListContainer({
    super.key,
    required this.beforeWashPhotos,
    required this.midWashPhotos,
    required this.afterWashPhotos,
    required this.mobileNo,
    required this.washType,
  });
  final List<CleanedPhoto> beforeWashPhotos;
  final List<CleanedPhoto> midWashPhotos;
  final List<CleanedPhoto> afterWashPhotos;
  final String mobileNo;
  final String washType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WashList(
          washPhotos: beforeWashPhotos,
          mobileNo: mobileNo,
          listTitle: "Before Wash",
        ),
        SizedBox(
          height: 10.h,
        ),
        washType == 'Pressure Wash'
            ? WashList(
                washPhotos: midWashPhotos,
                mobileNo: mobileNo,
                listTitle: "Mid Wash",
              )
            : SizedBox(),
        SizedBox(
          height: 10.h,
        ),
        WashList(
          washPhotos: afterWashPhotos,
          mobileNo: mobileNo,
          listTitle: "After Wash",
        ),
      ],
    );
  }
}
