import 'package:flutter/material.dart';
import '../components/components.dart';
import '../components/constants.dart';
import 'home/cubit/cubit.dart';
import 'home/cubit/states.dart';
import 'search/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.white,
            title: const Text(
              'Salla',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    navigateTo(
                      context,
                      const SearchScreen(),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: defaultColor,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              cubit.changeBottom(index);
            },
            currentIndex: cubit.currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
