
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Screens/register/register_screen.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';

import '../../models/productsModel.dart';
import '../../shared/components/components.dart';
import '../homepage.dart';
import 'CartsScreen.dart';





class CustomerProductssScreen extends StatefulWidget {
  CustomerProductssScreen({required this.catname,required this.oldcatname,});
  String catname;
  String oldcatname;


  @override
  State<CustomerProductssScreen> createState() => _CustomerProductssScreenState();
}

class _CustomerProductssScreenState extends State<CustomerProductssScreen> {
  var amountController = TextEditingController();

  @override
  Widget build(BuildContext context,) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
              MainCubit.get(context).emit(GetCategoriesSuccessStates());
               navigateAndFinish(context, home_Screen());
            }, icon: Icon(Icons.arrow_back_ios)),
            title: Text("المنتجات",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(

              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.cyan),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1 / 1.75,
                  children: List.generate(

                    MainCubit.get(context).ItemsPro.length,(index) => GridProducts(MainCubit.get(context).ItemsPro[index], context,TextEditingController(),widget.oldcatname),
                  ),
                ),

              ],
            ),
          ),



          floatingActionButton: MainCubit.get(context).cartmodel.isEmpty? FloatingActionButton(
            onPressed: (){
              if(MainCubit.get(context).address!=null){
                navigateTo(context, CartsScreen());}
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
            tooltip: 'Increment',
            child: const Icon(Icons.add_shopping_cart_outlined),
          ):Stack(
              children:[


                FloatingActionButton(
                  onPressed: (){


                    navigateTo(context, CartsScreen());

                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.add_shopping_cart_outlined),



                ),
                Container(height: 15,width: 15,


                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,

                  ),
                )
              ]
          ),

        );
      },
    );
  }

  Widget GridProducts(productsModel model, context,TextEditingController text,String old) => InkWell(
    onTap: () {


      // MainCubit.get(context)
      //     .getProductData(model.id)
      //     .then((value) => navigateTo(context, ProductDetailsScreen()));
    },
    child: Stack(
      children: [

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.none,
          elevation: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 10,
            ),
            child: Column(


              children: [

                Image(
                  image: NetworkImage(
                    model.image!,
                  ),
                  width: double.infinity,
                  height: 100.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price!} \LE',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),




                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(

                      children: [
                        Spacer(),
                        Container(

                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(9)),

                          child: Row(children: [  IconButton(onPressed: (){

                            setState(() {

                              model.count=model.count!+1;
                            });

                          }, icon: Icon(Icons.add),iconSize: 15,),


                            Text('${model.count}'),
                            IconButton(onPressed: (){
                              setState(() {
                                if(model.count!>=1){
                                model.count=model.count!-1;}
                              });


                            }
                              , icon: Icon(Icons.remove),iconSize: 15,),],),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    defaultMaterialButton(

                      function: () {

                        if(MainCubit.get(context).userdata!=null) {
                          if (model.count! !=0 && model.count! !=null) {

                            MainCubit.get(context).add_to_cart(
                                image: model.image!,
                                name: model.name!,

                                cat: model.catname!,
                                amount: model.count!,
                                price: model.price!,
                                old_cat: old, old_amount: model.amount!)
                            ;
                            Fluttertoast.showToast(
                                msg: "تم الاضافه الي السله",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                            setState(() {
                              model.amount =
                                  model.amount! -model.count!;
                              model.count=0;
                            });

                          }
                          else {
                            print("cancelled");
                          }
                        }
                        else{
                          navigateTo(context, RegisterScreen());
                        }
                      },
                      text: 'اضف الي السله',
                      radius: 20,
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),


        Positioned.fill(
          child: Align(
            alignment: Alignment(1, -1),
            child: ClipRect(
              child: Banner(
                message: '${model.amount!}\ PcS',
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
                location: BannerLocation.topStart,
                color: Colors.green,
                child: Container(
                  height: 100.0,
                ),
              ),
            ),
          ),
        ),

      ],
    ),
  );
}
