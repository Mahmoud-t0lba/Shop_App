import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller/bloc_observer.dart';
import 'controller/components/constants.dart';
import 'controller/cubit/cubit.dart';
import 'controller/cubit/states.dart';
import 'controller/network/local/cache_helper.dart';
import 'controller/network/remote/dio_helper.dart';
import 'controller/styles/themes.dart';
import 'veiw/layout/shop_layout.dart';
import 'veiw/login/shop_login_screen.dart';
import 'veiw/on_boarding/on_boarding_screen.dart';
import 'veiw/layout/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  // ignore: unnecessary_null_comparison
  if (onBoarding != null) {
    // ignore: unnecessary_null_comparison
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(
    MyApp(
      isDark: isDark,
      startWidget: widget,
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isDark;
  Widget startWidget;

  MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..changeAppMode(
              fromShared: isDark,
            ),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
