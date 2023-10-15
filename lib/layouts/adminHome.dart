// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Screens/AddScreen.dart';
import '../Screens/register/register_screen.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import '../shared/cache_helper.dart';
import '../shared/components/components.dart';
import 'adminScreens/updatephone.dart';
import 'adminScreens/usersScreen.dart';

class adminhome_Screen extends StatefulWidget {
  @override
  State<adminhome_Screen> createState() => _adminhome_ScreenState();
}

class _adminhome_ScreenState extends State<adminhome_Screen> {
  var addressController = TextEditingController();


  void add(String address) {
    setState(() {
      addressController.text=address ;
    });
  }
  @override

  Widget build(BuildContext context) {
    var uId=CacheHelper.getData(key: 'uId');

    MainCubit.get(context).getUser(uId);
    MainCubit.get(context).get_phone_number();

    var formKey = GlobalKey<FormState>();



    return BlocConsumer<MainCubit, MainStates>(

      listener: (context, state) => {

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
              leading: IconButton(onPressed: () { MainCubit.get(context).userLogout(); }, icon: Icon(Icons.logout_outlined),color: Colors.red,),
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
                IconButton(onPressed: (){navigateTo(context, updatePhoneScreen(phone: MainCubit.get(context).number.phone!,));}, icon: Icon(Icons.phone),color: Colors.cyan,),
                IconButton(onPressed: (){navigateTo(context, UsersScreen());}, icon: Icon(Icons.groups_rounded),color: Colors.cyan,)],
            ),
            body:cubit.adminscreens[cubit.currentIndex],
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

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.currentIndex==0) name='البان';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==1) name='مشروبات';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==2) name='منظفات';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==3) name='فطور';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==4) name='حبوب';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==5) name='سمن';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==6) name='توابل';  navigateTo(context, AddScreen(category_name: name,));
                if(cubit.currentIndex==7) name='خبز';  navigateTo(context, AddScreen(category_name: name,));




              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            )
        );
      },
    );
  }
}
