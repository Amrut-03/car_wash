
import 'package:car_wash/common/widgets/cardLists.dart';
import 'package:car_wash/common/widgets/upwardMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:car_wash/common/utils/constants.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 180.h,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          colors: const [
                        Color.fromARGB(255, 0, 52, 182),
                        AppTemplate.bgClr,
                        AppTemplate.bgClr,
                        AppTemplate.bgClr,
                        AppTemplate.bgClr
                      ],
                          focal: Alignment(0.8.w, -0.2.h),
                          radius: 1.5.r,
                          tileMode: TileMode.clamp)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 0.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35.h,
                        ),
                        Stack(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 15.r,
                                child: const ClipOval(
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/profile2.png'),
                                  ),
                                ),
                              ),
                              title: Text(
                                'Hi Moideen',
                                style: GoogleFonts.inter(
                                    color: AppTemplate.primaryClr,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Positioned(
                              right: 5.w,
                              child: GestureDetector(
                                onTap: () => Menu.showMenu(context),
                                child: SizedBox(
                                  height: 50.h,
                                  width: 60.w,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Image(
                                      image: const AssetImage(
                                          'assets/images/menu1.png'),
                                      height: 22.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60.h,
                          ),
                          Text(
                            'Today\'s Wash',
                            style: GoogleFonts.inter(
                                color: AppTemplate.textClr,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          const Cardlists()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 100.h,
              left: 25.w,
              right: 25.w,
              bottom: 480.h,
              child: Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFFD4D4D4), width: 1.5.w),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4D4D4),
                      blurRadius: 2.r,
                      offset: Offset(0.w, 3.h),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppTemplate.primaryClr,
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Strength",
                        style: GoogleFonts.inter(
                            color: AppTemplate.textClr,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "30",
                                style: GoogleFonts.inter(
                                    color: AppTemplate.buttonClr,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Employee",
                                style: GoogleFonts.inter(
                                    color: AppTemplate.textClr,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            children: [
                              Text(
                                "150",
                                style: GoogleFonts.inter(
                                    color: AppTemplate.buttonClr,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Customers",
                                style: GoogleFonts.inter(
                                    color: AppTemplate.textClr,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
