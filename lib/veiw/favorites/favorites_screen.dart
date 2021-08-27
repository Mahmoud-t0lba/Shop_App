// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/veiw/layout/cubit/cubit.dart';
import 'package:shop_app/veiw/layout/cubit/states.dart';
import 'package:shop_app/controller/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
          context: context,
          conditionBuilder: (context) => state is! ShopLoadingGetFavoritesState,
          widgetBuilder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildListProduct(
                ShopCubit.get(context)
                    .favoritesModel
                    .data!
                    .data![index]
                    .product,
                context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: ShopCubit.get(context).favoritesModel.data!.data!.length,
          ),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
