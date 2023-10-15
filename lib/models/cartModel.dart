class CartModel{

  String image;
  String name;
  String cat;
  num amount_orderd;
  num old_amount;

  String price;
  String phone;
  String username;
String old_cat;







  CartModel({
    required this.amount_orderd,
    required this.image,
    required this.name,
    required this.cat,
    required this.old_cat,
    required this.price,
    required this.phone,
    required this.username,
    required this.old_amount




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

      'image':image,
      'name':name,
      'cat':cat,
      'price':price,
      'phone':phone,
      'username':username,
      'amount_orderd':amount_orderd,
      'old_cat':old_cat,
      'old_amount':old_amount








    };
  }
}