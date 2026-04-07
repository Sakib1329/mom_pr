import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DisplayErrorWidget extends StatelessWidget {
  final String errorMessage;

  const DisplayErrorWidget({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == 'offline') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 60.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text('connection_unavailable'.tr, style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          ],
        ),
      );
    }
    
    if (errorMessage.contains('502')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build_circle, size: 60.sp, color: Colors.orange),
            SizedBox(height: 16.h),
            Text('server_maintenance'.tr, style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          ],
        ),
      );
    }

    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        textAlign: TextAlign.center,
      ),
    );
  }
}
