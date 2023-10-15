class productsModel{

  String? image;
  String? name;
  String? catname;
  num? amount;
  String? price;
  num? count=0;






  productsModel({

    this.image,
    this.name,
    this.catname,
    this.amount,
    this.price,
     this.count



  });


  productsModel.fromjson(Map<String,dynamic>json){

    image=json['image'];
    name=json['name'];
    catname=json['catname'];
    amount=json['amount'];
    price=json['price'];






  }
  Map<String,dynamic>Tomap(){
    return{

      'image':image,
      'name':name,
      'catname':catname,
      'amount':amount,
      'price':price,




    };
  }
}