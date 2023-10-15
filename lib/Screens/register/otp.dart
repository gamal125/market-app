import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../cubit/cubit.dart';
import '../../layouts/homepage.dart';
import '../../shared/cache_helper.dart';
import '../../shared/components/components.dart';
import 'cubit/cubit.dart';

class otpScreen extends StatefulWidget {
   otpScreen( {required this.id,required this.name,required this.phone,Key? key}) : super(key: key);
  dynamic id;
   dynamic name;
   dynamic phone;

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  var formKey = GlobalKey<FormState>();

final FirebaseAuth auth=FirebaseAuth.instance;

  var emailController = TextEditingController();

bool showloading=true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: showloading? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              defaultTextFormField(
                onTap: (){

                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                prefix: Icons.email,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter code';
                  }
                  return null;
                },
                label: 'كود التفعيل',
                hint: 'Enter your code',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: ()async{
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+2${widget.phone}",
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {

                        navigateTo(context,otpScreen( id: verificationId, name: widget.name.text, phone: widget.phone,));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  }, child: Text('اعادة ارسال الكود')),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: defaultMaterialButton(

                  function: () async{
                    if (formKey.currentState!.validate()) {
                      setState(() {
                 showloading=false;

                      });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.id, smsCode: emailController.text);

    // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);
                  if(auth.currentUser!=null){
                    RegisterCubit.get(context).createUser(
                        uId:auth.currentUser!.uid , name: widget.name, phone:widget.phone);
                    CacheHelper.saveData(key: 'uId', value:auth.currentUser!.uid);
                    var uId=CacheHelper.getData(key: 'uId');
                    MainCubit.get(context).getUser(uId);


                    MainCubit.get(context).MilkItems.clear();
                    MainCubit.get(context).getMilkItems();
                    navigateAndFinish(context, home_Screen());
                  }
                    }
                  },
                  text: 'تاكيد',
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
      ):Center(child: CircularProgressIndicator()),
    );
  }
}
