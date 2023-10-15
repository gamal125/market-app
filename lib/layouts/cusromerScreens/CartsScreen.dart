
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../models/cartModel.dart';
import '../../shared/components/components.dart';
import '../homepage.dart';




class CartsScreen extends StatelessWidget {
   CartsScreen( {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    MainCubit.get(context).get_phone_number();
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.cyan),
            title: Text("سلة المشتريات",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            leading: IconButton(onPressed: (){
              MainCubit.get(context).emit(GetCategoriesSuccessStates());
              navigateAndFinish(context, home_Screen());
            }, icon: Icon(Icons.arrow_back_ios)),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(

              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
          ),
          body: ConditionalBuilder(
            condition:State is! remove_from_cart_loading_stat,
            builder: ( context)=> SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => catList(
                        MainCubit.get(context).cartmodel[index], context),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: MainCubit.get(context).cartmodel.length,
                  ),
                  defaultMaterialButton(

                      function: () {
                        if(MainCubit.get(context).address != null&&MainCubit.get(context).address !='') {
                          MainCubit
                              .get(context)
                              .cartmodel
                              .forEach((element) {
                            MainCubit.get(context).updateProducts(
                              image: element.image,
                              name: element.name,
                              catnamee: element.cat,
                              amount: element.old_amount -
                                  element.amount_orderd,
                              price: element.price,
                              old_catnamee: element.old_cat,);
                          });

                          MainCubit
                              .get(context)
                              .cartmodel
                              .forEach((element) {
                            MainCubit.get(context).add_to_whatsapp(
                                name: element.name,
                                amount: element.amount_orderd,
                                price: element.price);
                          });

                          var x = MainCubit
                              .get(context)
                              .whatsappmodel;
                          MainCubit.get(context).ItemsPro.clear();
                          MainCubit.get(context).sendToWhatsApp(x, MainCubit.get(context).address!);
                          MainCubit.get(context).cartmodel.clear();
                          MainCubit.get(context).whatsappmodel.clear();

                          navigateAndFinish(context, home_Screen());
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "من فضلك ادخل العنوان",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0
                          );

                        }
                      },

                      text: "تاكيد"),




                ],
              ),

            ),
            fallback:(context) => Center(child: CircularProgressIndicator()),

          )

        );
      },
    );
  }

  Widget catList(CartModel model, context) => InkWell(
    onTap: () {




    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(7),
          color: Colors.cyan[100]
        ),
        child: Row(
          children: [
            Container(
              width:100.0,
              height: 100.0,
              decoration: BoxDecoration(

                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.cyan, width: 2),

                image: DecorationImage(
                  image: NetworkImage(
                    model.image,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
        Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(

                  " الصنف:${model.name}",
                  style:TextStyle( fontWeight: FontWeight.bold,),
                  maxLines: 1,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(

                      "${model.amount_orderd.toString().toUpperCase()} ",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ": العدد",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      textDirection: TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(

                      "${model.price.toString().toUpperCase()}\ LE ",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(

                      ": السعر",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(

                      "${model.amount_orderd*int.parse(model.price)}\ LE",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(

                      ":الاجمالي",
                      style:TextStyle( fontWeight: FontWeight.bold,),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
              ],
            ),



           IconButton(
              onPressed: () {
                MainCubit.get(context).remove_from_cart(model: model);

              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
