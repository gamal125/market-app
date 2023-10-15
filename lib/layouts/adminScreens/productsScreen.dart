
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../homepage.dart';
import 'addproductScreen.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../models/productsModel.dart';
import '../../shared/components/components.dart';
import 'edittScreen.dart';








class ProductssScreen extends StatelessWidget {
     ProductssScreen({required this.catname,required this.oldcatname});
     String catname;
     String oldcatname;

  @override
  Widget build(BuildContext context,) {


    var c= MainCubit.get(context);

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is deleteProductsSuccessStates) {
          if( c.ItemsPro.isNotEmpty){
            c.ItemsPro.clear();
            c.getProductss(name: catname, category_name: oldcatname);
         }
          else{

            c.getProductss(name: catname, category_name: oldcatname);

          }


        };},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: (){
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
          body: ConditionalBuilder(
            builder:(context) =>  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1 / 1.5,
                          children: List.generate(

                              MainCubit.get(context).ItemsPro.length
                                ,(index) =>
                              GridProducts(MainCubit.get(context).ItemsPro[index], context),
                          ),
                        ),
                        defaultMaterialButton(

                          function: () {
                            navigateTo(context, AddProductScreen(catname:  catname, oldcatname: oldcatname,));

                          },
                          text: 'اضافه',
                          radius: 20,
                        ),
                      ],
                    ),
                  ), condition: state is! deleteproductLoadingStates,
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),





        );
      },
    );
  }

  Widget GridProducts(productsModel model, context) => InkWell(
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
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //  IconButton(onPressed: (){MainCubit.get(context).deleteProducts(name: model.name!, catnamee: model.catname!);}, icon:Icon( Icons.delete,color: Colors.red,)),

                Image(
                  image:  NetworkImage(model.image!,),
                  width: double.infinity,
                  height: 120.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.price!}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),



                      ],
                    ),


                    defaultMaterialButton(

                      function: () {
                        navigateTo(context, editScreen(
                          catname: catname,
                          name: model.name!,
                          price: model.price!,
                          amount: model.amount!,
                          image: model.image!, oldcatname: oldcatname,));

                      },
                      text: 'تعديل',
                      radius: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: IconButton(
                alignment: AlignmentDirectional.bottomCenter,
                onPressed: (){}, icon:Icon( Icons.delete,color: Colors.red,)),
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
