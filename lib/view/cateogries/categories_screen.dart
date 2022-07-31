import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../models/categories_model.dart';
import '../home/cubit/cubit.dart';
import '../home/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var categories = ShopCubit.get(context).categoriesModel!.data!.data;
        return ListView.separated(
          itemBuilder: (context, index) {
            return buildCatItem(
              model: categories[index],
            );
          },
          separatorBuilder: (context, index) {
            return myDivider();
          },
          itemCount: categories.length,
        );
      },
    );
  }

  Widget buildCatItem({required DataModel model}) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            Text(
              model.name!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      );
}
