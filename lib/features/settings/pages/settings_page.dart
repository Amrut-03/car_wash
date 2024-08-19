import 'dart:convert';

import 'package:car_wash/common/utils/constants.dart';
import 'package:car_wash/common/widgets/header.dart';
import 'package:car_wash/features/settings/model/price_model.dart';
import 'package:car_wash/features/settings/widget/custom_washtype_widget.dart';
import 'package:car_wash/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Map<String, List<PriceModel>> groupedPrices = {};

  @override
  void initState() {
    super.initState();
    getPrice();
  }

  Future<void> getPrice() async {
    final admin = ref.read(authProvider);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://wash.sortbe.com/API/Admin/Settings/Get-Pricing'),
    );
    request.fields.addAll({'enc_key': encKey, 'emp_id': admin.admin!.id});

    http.StreamedResponse response = await request.send();
    String temp = await response.stream.bytesToString();
    var body = jsonDecode(temp);

    if (response.statusCode == 200) {
      List<dynamic> data = body['data'];
      List<PriceModel> prices =
          data.map((e) => PriceModel.fromJson(e)).toList();

      // Grouping the prices by wash_types
      groupedPrices = {};
      for (var price in prices) {
        if (!groupedPrices.containsKey(price.washType)) {
          groupedPrices[price.washType] = [];
        }
        groupedPrices[price.washType]!.add(price);
      }

      setState(() {}); // To trigger a rebuild with the grouped data
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTemplate.primaryClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(txt: 'Settings'),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price List',
                    style: GoogleFonts.inter(
                      color: AppTemplate.textClr,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.h),
              child: Container(
                height: 0.8 * MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupedPrices.length,
                  itemBuilder: (context, index) {
                    String washType = groupedPrices.keys.elementAt(index);
                    List<PriceModel> prices = groupedPrices[washType]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: CustomWashtypeWidget(
                        washType: washType,
                        prices: prices,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
