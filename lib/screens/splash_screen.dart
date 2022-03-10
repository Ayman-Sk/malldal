import 'dart:async';

import 'package:dal/network/local_host.dart';
import 'package:dal/screens/homescreen_with_tabbar_view_controller.dart';
import 'package:dal/screens/introduction_screen.dart';
import 'package:dal/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Timer _timer;
  // int _start = -300;
  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start++;
  //         });
  //       }
  //     },
  //   );
  // }
  // _time() async {
  //   await Future.delayed(Duration());
  // }
  // double _start = (-1 * (width / 2));

  bool isMounted = true;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double _start = 0;
  double pxl = -206;
  @override
  Widget build(BuildContext context) {
    if (!isMounted) return Container();
    final width = MediaQuery.of(context).size.width;
    final allTime = 10;
    Timer _timer;
    // double pxl = -1 * width / 2;
    // print(_start);
    const oneSec = const Duration(
      seconds: 1,
    );
    @override
    void dispose() {
      _timer.cancel();
      isMounted = false;
      super.dispose();
    }

    if (isMounted)
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (_start == allTime) {
            setState(() {
              // isMounted = false;
              // timer.cancel();
              dispose();
              if (CachHelper.getData(key: 'token') == null)
                Navigator.of(context)
                    .pushReplacementNamed(IntroductionScreen.routeName);
              else {
                Navigator.of(context)
                    .pushReplacementNamed(MainTabBarViewController.routeName);
              }
            });
          } else if (_start % 2 == 0) {
            setState(() {
              pxl += (width / allTime) * 2;
              _start += 1;
              print(pxl);
            });
          } else {
            setState(() {
              _start++;
            });
          }
        },
      );

    // _time() async {
    //   await Future.delayed(Duration(seconds: 5));
    // }

    // print(width);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: EdgeInsets.all(50),
              child: Image.asset(
                'img/logo.png',
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 10000),
                  right: pxl,
                  // left: _start,
                  bottom: 20,
                  child: Image.asset(
                    'img/Loader.gif',
                    // fit: BoxFit.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
