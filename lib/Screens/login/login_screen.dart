import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../layouts/homepage.dart';
import '../../shared/cache_helper.dart';
import '../../shared/components/components.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';



class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
         if (state is LoginSuccessState) {

           CacheHelper.saveData(key: 'uId', value: state.uId);


               MainCubit
                   .get(context)
                   .MilkItems
                   .clear();
               MainCubit.get(context).getMilkItems();
               navigateAndFinish(context, home_Screen());






      };},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,

          // appBar: AppBar(
          //   elevation: 0,
          //   systemOverlayStyle: SystemUiOverlayStyle(
          //     statusBarColor: Colors.white,
          //     statusBarIconBrightness: Brightness.dark,
          //     statusBarBrightness: Brightness.light,
          //   ),
          //   backgroundColor: Colors.white,
          // ),
          body: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
              },
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/loginn.jpg'),fit: BoxFit.cover),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Login Now to get our hot offers!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              LoginCubit.get(context).emit(LoginInitialState());
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            label: 'Email',
                            hint: 'Enter your email',
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              LoginCubit.get(context).emit(LoginInitialState());
                            },
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.key,
                            suffix: LoginCubit.get(context).suffix,
                            isPassword: LoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              LoginCubit.get(context).ChangePassword();
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            label: 'Password',
                            hint: 'Enter your password',
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => Center(
                              child: defaultMaterialButton(

                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);

                                  }
                                },
                                text: 'Login',
                                radius: 20,
                              ),
                            ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Don\'t have an account?',
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          defaultTextButton(
                            function: () {
                             navigateTo(context, RegisterScreen());
                            },
                            text: 'Register Now!',
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
