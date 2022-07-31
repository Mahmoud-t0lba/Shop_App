import 'package:flutter/material.dart';
import '../../../components/apis/cache_helper.dart';
import '../../../components/components.dart';
import '../../../components/constants.dart';
import '../../shop_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'cubit/shop_register_cubit.dart';
import 'cubit/shop_register_states.dart';

class ShopRegisterScreen extends StatelessWidget {
  const ShopRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data!.token,
              ).then((value) {
                loginToken = state.loginModel.data!.token;

                navigateAndFinish(
                  context,
                  const ShopLayout(),
                );
              });
            } else {
              print(state.loginModel.message!);
              showToast(
                text: state.loginModel.message,
                state: ToastStates.error,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(elevation: 0),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          child: defaultFormField(
                            autocorrect: true,
                            controller: nameController,
                            type: TextInputType.name,
                            validate: 'please enter your name',
                            label: 'User Name',
                            prefix: Icons.person,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          child: defaultFormField(
                            autocorrect: true,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: 'please enter your email address',
                            label: 'Email Address',
                            prefix: Icons.email_outlined,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          child: defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: 'please enter your phone number',
                            label: 'Phone',
                            prefix: Icons.phone,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          child: defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            onSubmit: (v) {
                              if (formKey.currentState!.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            isPassword:
                                ShopRegisterCubit.get(context).isPassword,
                            suffixPressed: () {
                              ShopRegisterCubit.get(context).changeIcon();
                            },
                            validate: 'password is too short',
                            label: 'Password',
                            prefix: Icons.lock_outline,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) {
                            return state is! ShopRegisterLoadingState;
                          },
                          widgetBuilder: (context) {
                            return defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'register',
                            );
                          },
                          fallbackBuilder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
