import 'package:car_wash/common/widgets/upwardMenu.dart';
import 'package:car_wash/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerWidget {
  final String txt;

  const Header({super.key, required this.txt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 100.h,
      width: 360.w,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: const [
            Color.fromARGB(255, 0, 52, 182),
            AppTemplate.bgClr,
            AppTemplate.bgClr,
            AppTemplate.bgClr,
            AppTemplate.bgClr
          ],
          focal: Alignment(0.8.w, -0.1.h),
          radius: 1.5.r,
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 35.h),
          Stack(
            children: [
              ListTile(
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/svg/backward.svg'),
                ),
                title: Text(
                  txt,
                  style: GoogleFonts.inter(
                    color: AppTemplate.primaryClr,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Positioned(
                right: 5.w,
                bottom: -2.5.h,
                child: GestureDetector(
                  onTap: () => Menu.showMenu(context, ref),
                  child: SizedBox(
                    height: 50.h,
                    width: 60.w,
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: SvgPicture.asset('assets/svg/hamburger.svg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
