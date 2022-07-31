import 'package:flutter/material.dart';
import '../../../../components/apis/dio_helper.dart';
import '../../../../components/apis/end_points.dart';
import '../../../../models/login_model.dart';
import 'shop_login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);

      emit(ShopLoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changeIcon() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopLoginIsPassword());
  }
}
