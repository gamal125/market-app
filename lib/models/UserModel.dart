

class UserModel{
   String? uId;
   String? name;
   String? phone;

   UserModel({
     this.name,
     this.phone,
     this.uId,


});

   UserModel.fromjson(Map<String,dynamic>json){
     name=json['name'];
     phone=json['phone'];
     uId=json['uId'];




   }
   Map<String,dynamic> Tomap(){
     return{
       'name':name,
       'phone':phone,
       'uId':uId,




     };
   }


}