

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Screens/register/register_screen.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../models/categoriesModel.dart';
import '../../models/productsModel.dart';
import '../../shared/components/components.dart';
import 'customerProductssScreen.dart';

class GheeScreen extends StatefulWidget {
  const GheeScreen({Key? key}) : super(key: key);

  @override
  State<GheeScreen> createState() => _GheeScreenState();
}

class _GheeScreenState extends State<GheeScreen> {
  var category_name='سمن';

  @override
  Widget build(BuildContext context) {

    var c=MainCubit.get(context);





    return BlocConsumer<MainCubit, MainStates>(


      listener: (context, state) {
        if(state is ChangeNavBarItem){
        }
        if(state is GetCategoriesSuccessStates||state is SendtoWhatsSuccessState) {
          c.ItemsPro.clear();
          c.getAllItems(category_name: category_name,Itemm:c.GheeItems);


        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is ProductSuccessStates||state is UpdateuserSuccessStates||state is UpdateProductSuccessStates|| state is addSuccessStates  ,
          builder: ( contex)=>SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 140.0,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Scrollbar(
                    thickness: 1,
                    child: ListView.separated(
                      padding:
                      EdgeInsetsDirectional.only(start: 10.0, top: 10),
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => CategoriesItem(
                          c.GheeItems[index], category_name,context),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: c.GheeItems.length,
                    ),
                  ),
                ),

                Column(
                  children: [
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1 / 1.75,
                      children: List.generate(

                        MainCubit.get(context).ItemsPro.length,(index) =>
                          GridProducts(MainCubit.get(context).ItemsPro[index],context ,TextEditingController(),category_name),
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
          fallback: ( context) => Center(child: CircularProgressIndicator()),);


      },
    );
  }

  Widget GridProducts(productsModel model,context,TextEditingController text,String category_name,) => InkWell(
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
                SizedBox(height: 5,),
                Expanded(
                  child: Column(
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
                                  old_cat: category_name, old_amount: model.amount!)
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
                              MainCubit.get(context).emit(addSuccessStates());

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

  Widget CategoriesItem(categoriesModel model, String category_name,context) => InkWell(
    onTap: () {
      var c=MainCubit.get(context);
      if( c.ItemsPro.isNotEmpty){
        c.ItemsPro.clear();
        c.getProductss(name: model.name!, category_name:category_name );
      }
      else{

        c.getProductss(name: model.name!, category_name: category_name);

      }
      navigateTo(context, CustomerProductssScreen(catname: model.name!, oldcatname: category_name,));
    },
    child: Container(
      width: 105,
      child: Column(
        children: [
          Container(
            width: 95.0,
            height: 74.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyan, width: 2),
              image: DecorationImage(
                image: NetworkImage(
                  model.image!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            model.name!.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
