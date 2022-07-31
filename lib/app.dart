import 'package:flutter/material.dart';
import 'components/themes.dart';
import 'view/auth/login/cubit/shop_login_cubit.dart';
import 'view/home/cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    Key? key,
    required this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ShopLoginCubit()),
        BlocProvider(
          create: (context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..userData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: startWidget,
      ),
    );
  }
}
