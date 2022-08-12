import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/view/auth/login/shop_login_screen.dart';
import 'package:shop_app/view/home/cubit/cubit.dart';
import 'package:shop_app/view/home/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    // var passwordController = TextEditingController();

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;

        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
        // passwordController.text = model.data!.password!;

        return Center(
          child: SingleChildScrollView(
            child: Conditional.single(
              context: context,
              conditionBuilder: (context) {
                return ShopCubit.get(context).userModel != null;
              },
              widgetBuilder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: state is ShopLoadingUpdateUserState
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              child: defaultFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                validate: 'name must not be empty',
                                label: 'Name',
                                prefix: Icons.person,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              child: defaultFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: 'email must not be empty',
                                label: 'Email Address',
                                prefix: Icons.email,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              child: defaultFormField(
                                controller: phoneController,
                                type: TextInputType.phone,
                                validate: 'phone must not be empty',
                                label: 'Phone',
                                prefix: Icons.phone,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // SizedBox(
                            //   child: defaultFormField(
                            //     controller: passwordController,
                            //     suffix: ShopLoginCubit.get(context).suffix,
                            //     isPassword:
                            //         ShopLoginCubit.get(context).isPassword,
                            //     suffixPressed: () =>
                            //         ShopLoginCubit.get(context).changeIcon(),
                            //     validate: 'password is too short',
                            //     label: 'Password',
                            //     prefix: Icons.lock_outline,
                            //   ),
                            // ),
                            // const SizedBox(height: 20),
                            SizedBox(
                              child: defaultButton(
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopCubit.get(context).updateUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      // password: passwordController.text,
                                    );
                                  }
                                },
                                text: 'update',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              child: defaultButton(
                                function: () {
                                  signOut(
                                    context,
                                    const ShopLoginScreen(),
                                  );
                                  ShopCubit.get(context).currentIndex = 0;
                                },
                                text: 'Logout',
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              fallbackBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
