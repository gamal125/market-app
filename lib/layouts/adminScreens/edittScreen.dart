

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../shared/components/components.dart';
import '../homepage.dart';



class editScreen extends StatelessWidget {

String oldcatname;
  var formKey = GlobalKey<FormState>();

  var amountController = TextEditingController();

  var imageController = TextEditingController();
  var priceController = TextEditingController();

// Pick an image.


  editScreen({
    required this.catname,
    required this.name,
    required this.price,
    required this.amount,
    required this.image,
    required this.oldcatname});
  String catname;
  String name;
  String image;
  String price;
  num amount;


  @override
  Widget build(BuildContext context) {
    imageController.text=image;
    priceController.text=price;
    amountController.text=amount.toString();
    var c= MainCubit.get(context);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
         if (state is UpdateProductSuccessStates) {
        navigateAndFinish(context, home_Screen());


        };
      },
      builder: (context, state) {
        var Image=c.PickedFile;
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

                          InkWell(
                            onTap: (){
                              c.getImage();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 300,

                              decoration: Image != null ?
                              BoxDecoration(image: DecorationImage(image: FileImage(Image) ))
                                  : BoxDecoration(image: DecorationImage(image: NetworkImage(
                             image) ))
                              ,
                            ),
                          ) ,
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              MainCubit.get(context).emit(UpdateCartLoadingStates());
                            },
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            prefix: Icons.image,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter amount ';
                              }
                              return null;
                            },
                            label: 'الكميه',
                            hint: amount.toString(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              MainCubit.get(context).emit(UpdateCartLoadingStates());
                            },
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            prefix: Icons.price_change,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter price ';
                              }
                              return null;
                            },
                            label: 'السعر',
                            hint: price,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(condition: state is! ImageintStates,
                              builder: (context)=>Center(
                                child: defaultMaterialButton(

                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      if(Image!=null) {
                                        MainCubit.get(context).editProductImage(
                                            name: name,
                                            cat: catname,
                                            amount:num.parse( amountController.text),
                                            price: priceController.text, old_cat: oldcatname);
                                      }
                                      else{
                                        MainCubit.get(context).updateProducts(image: image, name: name, catnamee: catname, amount:num.parse( amountController.text), price: priceController.text, old_catnamee: oldcatname);
                                      }
                                    }
                                  },
                                  text: 'تعديل',
                                  radius: 20,
                                ),
                              ),
                              fallback: (context)=>const Center(child: CircularProgressIndicator(),)),
                          const SizedBox(
                            height: 20,
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
