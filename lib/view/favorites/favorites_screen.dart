import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../home/cubit/cubit.dart';
import '../home/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      builder: (context, state) {
        return BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var fav = ShopCubit.get(context).favoritesModel!.data!.data!;
            return Conditional.single(
              context: context,
              conditionBuilder: (context) {
                return state is! ShopLoadingGetFavoritesState;
              },
              widgetBuilder: (context) {
                return fav.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('No item added'),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) =>
                            buildListProduct(fav[index].product, context),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: fav.length,
                      );
              },
              fallbackBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        );
      },
    );
  }
}
