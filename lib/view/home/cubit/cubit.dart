import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/apis/dio_helper.dart';
import '../../../components/apis/end_points.dart';
import '../../../components/constants.dart';
import '../../../models/categories_model.dart';
import '../../../models/change_favorites_model.dart';
import '../../../models/favorites_model.dart';
import '../../../models/home_model.dart';
import '../../../models/login_model.dart';
import '../../cateogries/categories_screen.dart';
import '../../favorites/favorites_screen.dart';
import '../../settings/settings_screen.dart';
import '../shop_home.dart';
import 'states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  /// ========================================

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ShopHome(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  /// ========================================

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: loginToken,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      print(homeModel!.data!.banners[0].image);
      print(homeModel!.status);

      for (var element in homeModel!.data!.products) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      }
      print(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  /// ========================================

  CategoriesModel? categoriesModel;
  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  /// ========================================

  FavoritesModel? favoritesModel;

  void getFavorites() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: loginToken,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  /// ========================================

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: loginToken,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;

      emit(ShopErrorChangeFavoritesState());
    });
  }

  /// ============updateUserData============================

  ShopLoginModel? userModel;

  void userData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: PROFILE,
      token: loginToken,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      print(userModel!.data!.name);
      print(userModel.toString());

      emit(ShopSuccessUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  /// ========================================

  void updateUserData({
    required String name,
    required String email,
    required String phone,
    // required String password,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: loginToken,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        // 'password': password,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
