

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/layouts/adminScreens/productsScreen.dart';
import '../../cubit/cubit.dart';
import '../../cubit/state.dart';
import '../../models/categoriesModel.dart';
import '../../models/productsModel.dart';
import '../../shared/components/components.dart';
import 'edittScreen.dart';

class adminBreakFastScreen extends StatelessWidget {
  const adminBreakFastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var c=MainCubit.get(context);
    var category_name='فطور';



    return BlocConsumer<MainCubit, MainStates>(

      listener: (context, state) {
        if(state is GetCategoriesSuccessStates|| state is deleteProductsSuccessStates ||state is UpdateProductSuccessStates) {
          c.ItemsPro.clear();
          c.getAllItems(category_name: category_name,Itemm:c.BreakFastItems);}
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:  state is ProductSuccessStates || state is! deleteproductLoadingStates  ,
          builder: ( contex)=>SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: 140.0,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Scrollbar(
                    thickness: 1,
                    child: ListView.separated(
                      padding:
                      EdgeInsetsDirectional.only(start: 10.0, top: 10),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => CategoriesItem(
                          c.BreakFastItems[index],category_name, context),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: c.BreakFastItems.length,
                    ),
                  ),
                ),
                Column(
                  children: [
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1 / 1.75,
                      children: List.generate(

                        MainCubit.get(context).ItemsPro.length,(index) => GridProducts(MainCubit.get(context).ItemsPro[index],category_name ,context,),
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
  Widget GridProducts(productsModel model, String oldcatname,context) => InkWell(
    onTap: () {


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

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Image(
                  image:  NetworkImage(model.image!,),
                  width: double.infinity,
                  height: 120.0,
                ),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      model.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${model.price!}\LE',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),




                      ],
                    ),

                    SizedBox(height: 10,),

                    defaultMaterialButton(

                      function: () {
                        navigateTo(context, editScreen(
                          catname: model.catname!,
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
                onPressed: (){MainCubit.get(context).deleteProducts(name: model.name!, catnamee: model.catname!, oldcategory:oldcatname);}, icon:Icon( Icons.delete,color: Colors.red,)),
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


  Widget CategoriesItem(categoriesModel model,String category_name, context) => InkWell(
    onTap: () {
      var c=MainCubit.get(context);
      if( c.ItemsPro.isNotEmpty){
        c.ItemsPro.clear();
        c.getProductss(name: model.name!, category_name:category_name );
      }
      else{

        c.getProductss(name: model.name!, category_name: category_name);

      }
      navigateTo(context, ProductssScreen(catname: model.name!, oldcatname: category_name,));

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
