import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceGradeWidget extends StatelessWidget {
  const ResourceGradeWidget({
    super.key,
    required this.title,
    required this.icon,
    this.downloader,
  });
  final String title;
  final IconData icon;
  final VoidCallback? downloader;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          GestureDetector(
            onTap: downloader,
            child: Icon(icon),
          )
          ,
        ],
      ),
    );
  }
}
