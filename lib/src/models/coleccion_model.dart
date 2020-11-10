import 'dart:convert';

import 'package:colecty/src/models/item_model.dart';

CollectionModel productoModelFromJson(String str) => CollectionModel.fromJson(json.decode(str));

String productoModelToJson(CollectionModel data) => json.encode(data.toJson());

class CollectionModel {
    CollectionModel({
        this.uid,
        this.photo,
        this.title,
        this.total,
        this.tenguis,
        this.porcentage,
        this.repes,
        this.faltas,
        this.noFaltas,
        this.favourite
    });

    String uid;
    String photo;
    String title;
    int total;
    List<Item> tenguis;
    double porcentage;
    int repes;
    int faltas;
    int noFaltas;
    bool favourite;

    factory CollectionModel.fromJson(Map<String, dynamic> json) => CollectionModel(
        uid: json['uid'],
        photo: json["photo"],
        title: json["title"],
        total: json["total"],
        tenguis: null,
        porcentage: json["porcentage"],
        repes: json["repes"],
        faltas: json["faltas"],
        noFaltas: json["noFaltas"],
        favourite: json["favourite"].toLowerCase() == 'true'
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "photo": photo,
        "title": title,
        "total": total,
        //"tenguis": List<dynamic>.from(tenguis.map((x) => x)),
        "porcentage": porcentage,
        "repes": repes,
        "faltas": faltas,
        "noFaltas": noFaltas,
        "favourite": favourite
    };

    set lista(List<Item> lista){
      this.tenguis = lista;
    }
}