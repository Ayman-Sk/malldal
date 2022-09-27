import 'package:dal/data_layer/data_providers/get_data.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:dal/network/local_host.dart';
import 'homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final asset = 'Videos/splash.mp4';

  VideoPlayerController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => {})
      ..setLooping(false)
      ..initialize().then((_) => controller.play());

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 6), () {});
    CachHelper.getData(key: 'token') == null
        ? Navigator.of(context)
            .pushReplacementNamed(IntroductionScreen.routeName)
        : Navigator.of(context)
            .pushReplacementNamed(MainTabBarViewController.routeName);
  }

  Future<void> getData() async {
    GetData getInitData =
        GetData(context: context, postPageSize: 7, categoriesPageSize: 8);
    await getInitData.getPostData();
    await getInitData.getCategoriesData();
  }

  @override
  Widget build(BuildContext context) {
    print('splashhhhhhhhh');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer(controller)),
      ),
      // body: Column(
      //   children: [
      //     // VideoPlayer(controller)
      //     Expanded(flex: 1, child: Container()),
      //     Expanded(flex: 1, child: VideoPlayer(controller)),
      //     Expanded(flex: 1, child: Container())
      //   ],
      // ),
    );
  }
}
