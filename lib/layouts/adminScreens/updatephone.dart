

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../shared/cache_helper.dart';
import '../adminHome.dart';



class updatePhoneScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();


  var phoneController = TextEditingController();

// Pick an image.


  updatePhoneScreen({

    required this.phone,

  });

  String? phone;



  @override
  Widget build(BuildContext context) {
    phoneController.text=phone!;

    var ud = CacheHelper.getData(key: 'uId');
    MainCubit.get(context).getUser(ud);
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is UpdateuserSuccessStates) {
          MainCubit.get(context).getUser(ud);
          navigateAndFinish(context,  adminhome_Screen());



        }
      },
      builder: (context, state) {

        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.cyan),
          ),
          body: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(

              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "تعديل",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.text,
                            prefix: Icons.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter phone ';
                              }
                              return null;
                            },
                            label: 'رقم الواتس اب',
                            hint: phone,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ConditionalBuilder(
                              condition: state is! UpdateuserLoadingStates,
                              builder: (context)=>defaultMaterialButton(

                                function: () {
                                  if (formKey.currentState!.validate()) {


                                    MainCubit.get(context).updateuser(

                                      phone:phoneController.text,
                                    ) ;
                                  }
                                },
                                text: 'حغظ',
                                radius: 20,
                              ),
                              fallback: (context) =>Center(child: CircularProgressIndicator(),),

                            )
                          ),
                          SizedBox(height: 30,),

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
