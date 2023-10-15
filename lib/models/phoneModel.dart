

class phoneModel{


  String? phone;


  phoneModel({
    this.phone,





  });

  phoneModel.fromjson(Map<String,dynamic>json){
    phone=json['phone'];






  }
  Map<String,dynamic> Tomap(){
    return{
      'phone':phone,





    };
  }


}