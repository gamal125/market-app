// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, unused_local_variable, prefer_const_constructors

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as Locationn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Screens/register/register_screen.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import '../shared/cache_helper.dart';
import '../shared/components/components.dart';
import 'cusromerScreens/CartsScreen.dart';
import 'package:permission_handler/permission_handler.dart';




class home_Screen extends StatefulWidget {

  @override
  State<home_Screen> createState() => _home_ScreenState();
}

class _home_ScreenState extends State<home_Screen> {

  var addressController = TextEditingController();

  void add(String address) {
    setState(() {
      addressController.text=address ;
    });
  }
  @override

  Widget build(BuildContext context) {
    Future<void> requestLocationPermission() async {
      final status = await Permission.location.request();

      if (status.isGranted) {
        // تم منح الإذن
      } else if (status.isDenied) {
        // عرض حوار توضيحي وطلب الإذن مرة أخرى
        if (await Permission.location.request().isGranted) {
          // تم منح الإذن بعد التوضيح
        } else {
          // تم رفض الإذن بعد التوضيح
        }
      } else if (status.isPermanentlyDenied) {
        // عرض حوار لتوجيه المستخدمإلى إعدادات التطبيق
        openAppSettings();
      }
    }

    var formKey = GlobalKey<FormState>();
Widget widgett=Stack(
    children:[


      FloatingActionButton(
        onPressed: (){
MainCubit.get(context).address=addressController.text;

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
);


    return BlocConsumer<MainCubit, MainStates>(

      listener: (context, state) => {
        if(state is SendtoWhatsSuccessState){
          MainCubit.get(context).ItemsPro.clear(),
        },
        if(state is addSuccessStates){

               widgett= Stack(
          children:[


          FloatingActionButton(
          onPressed: (){
MainCubit.get(context).address=addressController.text;

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
    )
        },
        if (state is LogOutSuccessState ){
          navigateAndFinish(context,RegisterScreen())
        }
      },
      builder: (context, state) {

        var cubit = MainCubit.get(context);

          var id=CacheHelper.getData(key: 'uId');
          var name="";
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title:
            Row(
              children: [
                Spacer(),
                Text(
                  'علاء الدين',style: TextStyle(color: Colors.indigo),
                ),
              ],
            ),

            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(

              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            actions: [


              id==null? IconButton(onPressed: (){
                navigateTo(context, RegisterScreen());
              }, icon: Icon(Icons.login_outlined,color: Colors.cyan,)):
              IconButton(onPressed: (){
                MainCubit.get(context).userLogout();
              }, icon: Icon(Icons.logout_outlined,color: Colors.cyan,)),

            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column( children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 280,
                      child: Form(
                        key: formKey,
                        child: defaultTextFormField(
onFieldSubmitted: (address){
  address=addressController.text;
  MainCubit.get(context).address =address;
},
                          controller: addressController,
                          keyboardType: TextInputType.name,
                          prefix: Icons.location_on,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'من فضلك ادخل العنوان';
                            }
                            return null;
                          },
                          label: 'العنوان',
                          hint: 'ادخل العنوان',
                        ),
                      ),
                    ),
                    IconButton(onPressed: () async{



                      requestLocationPermission();

                      Position position = await Geolocator.getCurrentPosition();
                      List<Locationn.Placemark> placemarks = await Locationn.placemarkFromCoordinates(position.latitude, position.longitude);
                      String address="${placemarks[0].name},${placemarks[0].locality}";
                    add(address);
                    MainCubit.get(context).address=address;
                    setState(() {
                      addressController.text=address;
                    });


                    }, icon: Icon(Icons.not_listed_location_sharp),color: Colors.green,),

                  ],
                ),
              ),
              cubit.screens[cubit.currentIndex]]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue, // <-- This works for fixed
            selectedItemColor: Colors.white,
            selectedFontSize: 14,
            unselectedFontSize: 13,
            unselectedItemColor: Colors.black,
            items: cubit.BottomItems,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
          ),

          floatingActionButton: MainCubit.get(context).cartmodel.isNotEmpty?
          widgett :  FloatingActionButton(
        onPressed: (){
MainCubit.get(context).address=addressController.text;
              navigateTo(context, CartsScreen());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_shopping_cart_outlined),
        )

        );
        },
    );
  }

}


