import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scanify/app/modules/splash/controllers/splash_controller.dart';
import 'package:scanify/app/static/constants.dart';
import 'package:flutter/services.dart';
import 'package:scanify/app/widgets/my_network_image.dart';


class SplashView extends StatefulWidget {

  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>{

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Stack(
              alignment: Alignment.center,
              children: [
                MyNetworkImage(
                  imageUrl: 'assets/images/app_logo.png',
                  imageType: ImageType.asset,
                  height: 48,
                  width: 177,
                ),
                Positioned(
                  bottom: 40.h,
                  child: loader
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
