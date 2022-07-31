import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: defaultColor,
                  ),
                ),
              ),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: defaultFormField(
                        autocorrect: true,
                        controller: searchController,
                        type: TextInputType.text,
                        validate: 'enter text to search',
                        onSubmit: (String text) {
                          SearchCubit.get(context).search(text);
                        },
                        label: 'Search',
                        prefix: Icons.search,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state is SearchLoadingState)
                      // const LinearProgressIndicator(),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return buildListProduct(
                              SearchCubit.get(context)
                                  .model!
                                  .data!
                                  .data![index],
                              context,
                              isOldPrice: false,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return myDivider();
                          },
                          itemCount: SearchCubit.get(context)
                              .model!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
