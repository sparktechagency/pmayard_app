import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pmayard_app/custom_assets/assets.gen.dart';
import 'package:pmayard_app/widgets/custom_app_bar.dart';
import 'package:pmayard_app/widgets/custom_scaffold.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      body: Column(
        children: [
          Image.asset(Assets.images.notFound.path),
          // SvgPicture.asset(Assets.icons.notFound.path),
          Spacer(),
          Text(
            'Oops!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0XFF305CDE)),
          ),
          Text(' Something Went Wrong',style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0XFF305CDE)),),
          Spacer(),
        ],
      ),
    );
  }
}
