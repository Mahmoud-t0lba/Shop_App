import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import '../login/shop_login_screen.dart';
import '../../controller/components/components.dart';
import '../../controller/components/constants.dart';
import '../layout/cubit/cubit.dart';
import '../layout/cubit/states.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return Conditional.single(
          context: context,
          conditionBuilder: (context) =>
              // ignore: unnecessary_null_comparison
              ShopCubit.get(context).userModel != null,
          widgetBuilder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (state is ShopLoadingUpdateUserState)
                    LinearProgressIndicator(),
                  SizedBox(height: 20.0),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                    label: 'Name',
                    prefix: Icons.person,
                  ),
                  SizedBox(height: 20.0),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'email must not be empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefix: Icons.email,
                  ),
                  SizedBox(height: 20.0),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'phone must not be empty';
                      }
                      return null;
                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(height: 20.0),
                  defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        ShopCubit.get(context).updateUserData(
                          name: nameController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                        );
                      }
                    },
                    text: 'update',
                  ),
                  SizedBox(height: 20.0),
                  defaultButton(
                    function: () {
                      signOut(
                        context,
                        ShopLoginScreen(),
                      );
                    },
                    text: 'Logout',
                  ),
                ],
              ),
            ),
          ),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
