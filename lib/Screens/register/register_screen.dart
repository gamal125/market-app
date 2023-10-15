import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';
import 'otp.dart';



class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();



  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  File? profileImage;
  bool showloading=true;

  var pickerController = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
       listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(

          body: Container(
        decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/loginn.jpg'),fit: BoxFit.cover),),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      defaultTextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        prefix: Icons.person,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter  name';
                          }
                          return null;
                        },
                        label: 'name',
                        hint: 'Enter your name',
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      defaultTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        prefix: Icons.phone,
                        validate: (String? value) {
                          if (value!.isEmpty&&value.length!=11) {
                            return 'Please right phone number';
                          }
                          return null;
                        },
                        label: 'Phone',
                        hint: 'Enter your phone',
                      ),
                      SizedBox(
                        height: 20,
                      ),


                      ConditionalBuilder(
                        condition: showloading,
                        builder: (context) => Center(
                          child: defaultMaterialButton(
                             function: ()async {


                               if (formKey.currentState!.validate()) {

                                 setState(() {
                                   showloading=false;

                                 });
                                 await FirebaseAuth.instance.verifyPhoneNumber(
                                   phoneNumber: "+2${phoneController.text}",
                                   verificationCompleted: (PhoneAuthCredential credential) {},
                                   verificationFailed: (FirebaseAuthException e) {},
                                   codeSent: (String verificationId, int? resendToken) {

                                     navigateAndFinish(context,otpScreen( id: verificationId, name: nameController.text, phone: phoneController.text,));
                                   },
                                   codeAutoRetrievalTimeout: (String verificationId) {},
                                 );

                              }
                             },
                            text: 'Register',
                            radius: 20,
                          ),
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                    ]),
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
