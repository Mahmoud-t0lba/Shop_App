import 'package:flutter/material.dart';
import '../../../components/apis/cache_helper.dart';
import '../../../components/components.dart';
import '../../../components/constants.dart';
import 'cubit/shop_login_cubit.dart';
import 'cubit/shop_login_state.dart';
import '../register/shop_register_screen.dart';
import '../../shop_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class ShopLoginScreen extends StatelessWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status!) {
              print(state.loginModel.message);
              print(state.loginModel.data!.token);

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
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const Text(
                'Login Screen',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        defaultFormField(
                          autocorrect: true,
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                          validate: 'please enter your email address',
                        ),
                        const SizedBox(height: 15),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          onSubmit: (v) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          suffixPressed: () {
                            ShopLoginCubit.get(context).changeIcon();
                          },
                          validate: 'Enter your password',
                        ),
                        const SizedBox(height: 30),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (context) {
                            return state is! ShopLoginLoadingState;
                          },
                          widgetBuilder: (context) {
                            return defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'login',
                            );
                          },
                          fallbackBuilder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            defaultTextButton(
                              function: () {
                                navigateTo(
                                  context,
                                  const ShopRegisterScreen(),
                                );
                              },
                              text: 'register',
                            ),
                          ],
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
