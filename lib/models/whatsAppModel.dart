class WhatsappModel{


  String name;
  num amount_orderd;

  String price;









  WhatsappModel({
    required this.amount_orderd,

    required this.name,
    required this.price,





  });


  // CartModel.fromjson(Map<String,dynamic>json){
  //
  //   image=json['image'];
  //   name=json['name'];
  //   uId=json['uId'];
  //   amount_orderd=json['amount'];
  //   price=json['price'];
  //   state=json['state'];
  //
  //
  //
  //
  //
  //
  // }
  Map<String,dynamic>Tomap(){
    return{

      'اسم الصنف':name,


      'الكميه':amount_orderd,
      'السعر':price,







    };
  }
}