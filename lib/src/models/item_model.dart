import 'dart:convert';

Item itemsFromJson(String str) => Item.fromJson(json.decode(str));

String itemsToJson(Item data) => json.encode(data.toJson());

class Item {
    Item({
        this.uid,
        this.name,
        this.photo,
        this.position,
        this.quantity,
        this.titlecollection,
    });

    String uid;
    String name;
    String photo;
    int position;
    int quantity;
    String titlecollection;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
      uid: json["uid"],
      name: json["nombreItem"],
      photo: json["photo"],
      position: json["posicion"],
      quantity: json["cuantos"],
      titlecollection: json["titleCollection"],
    );

    Map<String, dynamic> toJson() => {
      "uid": uid,
      "nombreItem": name,
      "photo": photo,
      "posicion": position,
      "cuantos": quantity,
      "titleCollection": titlecollection,
    };
}