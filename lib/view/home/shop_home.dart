import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import '../../models/categories_model.dart';
import '../../models/home_model.dart';
import 'cubit/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'cubit/states.dart';

class ShopHome extends StatelessWidget {
  const ShopHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            showToast(
              text: state.model.message!,
              state: ToastStates.error,
            );
          }
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).homeModel;
        var categoriesModel = ShopCubit.get(context).categoriesModel;

        return Conditional.single(
          context: context,
          conditionBuilder: (context) => model != null,
          widgetBuilder: (context) => builderWidget(
            model: model!,
            categoriesModel: categoriesModel!,
            context: context,
          ),
          fallbackBuilder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  Widget builderWidget({
    required HomeModel model,
    required CategoriesModel categoriesModel,
    context,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data!.banners
                .map(
                  (e) => Image(
                    image: NetworkImage(e.image!),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1,
              enlargeCenterPage: false,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildCategoryItem(
                        model: categoriesModel.data!.data[index],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: categoriesModel.data!.data.length,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'New Products',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.5,
              children: List.generate(
                model.data!.products.length,
                (index) {
                  return buildGridProduct(
                    model: model.data!.products[index],
                    context,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem({required DataModel model}) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image: NetworkImage(model.image!),
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(.8),
          width: 100,
          child: Text(
            model.name!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              // fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGridProduct(context, {required ProductModel model}) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(model.image!),
                width: double.infinity,
                height: 200,
              ),
              if (model.discount != 0)
                Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                ),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice.round()}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).changeFavorites(model.id!);
                        print(model.id);
                      },
                      icon: CircleAvatar(
                        backgroundColor:
                            ShopCubit.get(context).favorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                        child: const Icon(
                          Icons.favorite_border,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
