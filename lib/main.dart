// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/app.dart';
import 'package:shop_app/view/shop_layout.dart';

import 'components/apis/cache_helper.dart';
import 'components/apis/dio_helper.dart';
import 'components/bloc_observer.dart';
import 'components/constants.dart';
import 'view/auth/login/shop_login_screen.dart';
import 'view/auth/on_boarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  loginToken = CacheHelper.getData(key: 'token');

  print('onBoarding ======>$onBoarding');
  print('token ======>$loginToken');

  // if (onBoarding != null) {
  //   if (loginToken == null) {
  //     widget = const ShopLoginScreen();
  //   } else {
  //     widget = const ShopLayout();
  //   }
  // } else {
  //   widget = const OnBoardingScreen();
  // }

  switch (onBoarding) {
    case null:
      widget = const OnBoardingScreen();
      break;
    case null:
      widget = const ShopLoginScreen();
      break;
    default:
      widget = const ShopLayout();
  }

  BlocOverrides.runZoned(
    () {
      runApp(
        MyApp(
          startWidget: widget,
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}
