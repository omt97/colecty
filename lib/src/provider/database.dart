import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';

class DatabaseProvider {

  final String uid;
  DatabaseProvider({@required this.uid});

  //collection reference
  final CollectionReference collectionCollection = FirebaseFirestore.instance.collection('usuarioColeccion');

  //al crear usuario
  Future updateUserData(String user) async{

    return await collectionCollection.doc(uid).set({
      'email' : user,
      'color' : 'lila'
    }).then((value) { 
      /*collectionCollection
      .doc(uid)
      .collection("collections")
      .add({
        'title'     : 'example Collection',
        'photo'     : 'assets/gorm.jpg',
        'favourite' : false,
        'noFaltas'  : 0,
        'total'     : 1
      }).then((value2){
        collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value2.id)
        .collection('items')
        .add({
          'name'     : '1: item1',
          'cantidad' : 0,
          'photo'     : 'assets/gorm.jpg',
        });
      });

      collectionCollection
      .doc(uid)
      .collection("collections")
      .add({
        'title'     : 'axample Collection',
        'photo'     : 'assets/gorm.jpg',
        'favourite' : false,
        'noFaltas'  : 2,
        'total'     : 3
      }).then((value2){
        collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value2.id)
        .collection('items')
        .add({
          'name'     : '1: item1',
          'cantidad' : 1,
          'photo'     : 'assets/gorm.jpg',
        });
        collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value2.id)
        .collection('items')
        .add({
          'name'     : '2: item2',
          'cantidad' : 0,
          'photo'     : 'assets/gorm.jpg',
        });
        collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value2.id)
        .collection('items')
        .add({
          'name'     : '3: item3',
          'cantidad' : 3,
          'photo'     : 'assets/gorm.jpg',
        });
      });


    */});
  }
      
  //existe user
  Future<bool> existUser() async{

    bool existe = false;

    await collectionCollection
      .doc(uid).get().then((value) async{
        existe = (value.data() != null);
      });
    return existe;
  }

  //crear nueva coleccion
  Future nuevaColeccion(CollectionModel cm) async {
    await collectionCollection
      .doc(uid)
      .collection("collections")
      .add({
        'title'     : cm.title,
        'photo'     : cm.photo,
        'favourite' : cm.favourite,
        'noFaltas'  : 0,
        'total'     : cm.total
      }).then((value) {
        for (int i = 1; i <= cm.total; ++i) {_addItems(value, i); print(i.toString());}
      });
  }

  //editar coleccion
  Future editarColeccion(CollectionModel cm, String oldTitle, int oldTotal, String oldPhoto) async {
    if (cm.total != oldTotal){
      await collectionCollection
        .doc(uid)
        .collection('collections')
        .doc(cm.uid)
        .update({
          'total' : cm.total,
        }).then((value) {
          DocumentReference docRef = collectionCollection.doc(uid).collection('collections').doc(cm.uid);
          if (cm.total > oldTotal) for (int i = oldTotal; i <= cm.total; ++i) _addItems(docRef, i);
          else if (cm.total < oldTotal) for (int i = oldTotal; i > cm.total; --i) _deleteItems(docRef, i);
            
        });
    }
    if (cm.title != oldTitle){
      await collectionCollection
        .doc(uid)
        .collection('collections')
        .doc(cm.uid)
        .update({
          'title' : cm.title,
        });
    }
    if (cm.photo != oldPhoto){
      await collectionCollection
        .doc(uid)
        .collection('collections')
        .doc(cm.uid)
        .update({
          'photo' : cm.photo,
        });
    }
  }

  //editar campo favorito coleccion
  Future editarFavColeccion(String uidCol, bool favorita) async {
    await collectionCollection
      .doc(uid)
      .collection('collections')
      .doc(uidCol)
      .update({
        'favourite' : favorita,
      });
  }

  //editar item
  Future editarItem(Item item, String oldName, String oldPhoto, String cmUid) async{
    if (oldName != item.name){
      await collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(cmUid)
        .collection('items')
        .doc(item.uid)
        .update({
          'name' : item.name
        });
    }
    if (oldPhoto != item.photo){
      await collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(cmUid)
        .collection('items')
        .doc(item.uid)
        .update({
          'photo' : item.photo
        });
    }
  }

  //sumar item
  Future<CollectionModel> sumarItem( CollectionModel cm, Item item, int noFaltas)async{


    await collectionCollection
      .doc(uid)
      .collection("collections")
      .doc(cm.uid)
      .collection('items')
      .doc(item.uid)
      .update({'cantidad' : item.quantity + 1});

    if (item.quantity == 0) {
      await collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(cm.uid)
        .update({
          'noFaltas' : noFaltas + 1
        }).then((value) {
          cm.noFaltas = noFaltas + 1;
          cm.faltas = cm.faltas - 1;
          cm.porcentage = cm.noFaltas/cm.total;
          return cm;
        });
    }
    return cm;
  }

  //sumar item
  Future<CollectionModel> restarItem( CollectionModel cm, Item item, int noFaltas)async{


    await collectionCollection
      .doc(uid)
      .collection("collections")
      .doc(cm.uid)
      .collection('items')
      .doc(item.uid)
      .update({'cantidad' : item.quantity - 1});

    if (item.quantity == 1) {
      await collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(cm.uid)
        .update({
          'noFaltas' : noFaltas - 1
        }).then((value) {
          cm.noFaltas = noFaltas - 1;
          cm.faltas = cm.faltas + 1;
          cm.porcentage = cm.noFaltas/cm.total;
          return cm;
        });
    }
    return cm;
  }

  //borrar coleccion
  Future borrarColeccion(String uidCol) async {
    await collectionCollection
      .doc(uid)
      .collection("collections")
      .doc(uidCol)
      .delete();
  }

  //obtener colecicones
  Future<List<CollectionModel>> colecciones() async{

    List<CollectionModel> colecciones = []; 
      
    await collectionCollection.doc(uid).collection('collections').orderBy('title').get().then((value) {
      value.docs.forEach((element) {

        CollectionModel a = _crearCollectionModel(element.data(), [], element.id);

        colecciones.add(a);

      });
    });

    return colecciones;
    
  }

  //obtener colecicones Favoritas
  Future<List<CollectionModel>> coleccionesFav() async{

    List<CollectionModel> colecciones = []; 
      
    await collectionCollection.doc(uid).collection('collections').where('favourite', isEqualTo: true).get().then((value) {
      value.docs.forEach((element) {

        CollectionModel a = _crearCollectionModel(element.data(), [], element.id);

        colecciones.add(a);

      });
    });

    return colecciones;
    
  }

  //obtener colecciones asc
  Future<List<CollectionModel>> coleccionesAsc() async{

    List<CollectionModel> colecciones = []; 
      
    await collectionCollection.doc(uid).collection('collections').get().then((value) {
      value.docs.forEach((element) {

        CollectionModel a = _crearCollectionModel(element.data(), [], element.id);

        colecciones.add(a);

      });
    });

    colecciones.sort((a,b){
      return b.porcentage.compareTo(a.porcentage);
    });

    return colecciones;
    
  }

  //obtener colecciones desc
  Future<List<CollectionModel>> coleccionesDesc() async{

    List<CollectionModel> colecciones = []; 
      
    await collectionCollection.doc(uid).collection('collections').get().then((value) {
      value.docs.forEach((element) {

        CollectionModel a = _crearCollectionModel(element.data(), [], element.id);

        colecciones.add(a);

      });
    });

    colecciones.sort((a,b){
      return a.porcentage.compareTo(b.porcentage);
    });

    return colecciones;
    
  }

  //obtener colecciones por busqueda
  Future<List<CollectionModel>> coleccionesSearch(String word) async{

    List<CollectionModel> colecciones = []; 
      
    await collectionCollection.doc(uid).collection('collections').orderBy('title').startAt([word]).endAt([word+'\uf8ff']).get().then((value) {
      value.docs.forEach((element) {

        CollectionModel a = _crearCollectionModel(element.data(), [], element.id);

        colecciones.add(a);

      });
    });

    colecciones.sort((a,b){
      return a.porcentage.compareTo(b.porcentage);
    });

    return colecciones;
    
  }

  //obtener coleccion
  Future<CollectionModel> coleccion(CollectionModel cm) async{

    //List<CollectionModel> colecciones = []; 

    List<Item> items = [];

    await collectionCollection.doc(uid).collection('collections').doc(cm.uid).collection('items').get().then((valueItem) {
      int i = 0;
      valueItem.docs.forEach((elementItems) { 
        Item item = _crearItems(elementItems.data(), cm.title, i, elementItems.id);
        i += 1;
        items.add(item);
      });

    });

    items.sort((a,b) => int.parse(getNumeroName(a.name)).compareTo(int.parse(getNumeroName(b.name))));

    cm.tenguis = items;
    return cm;
  }

  //obtener coleccion por tenguis
  Future<CollectionModel> coleccionTenguis(CollectionModel cm) async{

    //List<CollectionModel> colecciones = []; 

    List<Item> items = [];

    await collectionCollection
      .doc(uid)
      .collection('collections')
      .doc(cm.uid)
      .collection('items')
      .where('cantidad', isGreaterThan: 0)
      .get().then((valueItem) {
        int i = 0;
        valueItem.docs.forEach((elementItems) { 
          Item item = _crearItems(elementItems.data(), cm.title, i, elementItems.id);
          i += 1;
          items.add(item);
      });

    });

    items.sort((a,b) => int.parse(getNumeroName(a.name)).compareTo(int.parse(getNumeroName(b.name))));

    cm.tenguis = items;
    return cm;
  }

  //obtener coleccion por faltis
  Future<CollectionModel> coleccionFaltis(CollectionModel cm) async{

    //List<CollectionModel> colecciones = []; 

    List<Item> items = [];

    await collectionCollection
      .doc(uid)
      .collection('collections')
      .doc(cm.uid)
      .collection('items')
      .where('cantidad', isEqualTo: 0)
      .get().then((valueItem) {
        int i = 0;
        valueItem.docs.forEach((elementItems) { 
          Item item = _crearItems(elementItems.data(), cm.title, i, elementItems.id);
          i += 1;
          items.add(item);
      });

    });

    items.sort((a,b) => int.parse(getNumeroName(a.name)).compareTo(int.parse(getNumeroName(b.name))));

    cm.tenguis = items;
    return cm;
  }

  //obtener coleccion por repes
  Future<CollectionModel> coleccionRepes(CollectionModel cm) async{

    //List<CollectionModel> colecciones = []; 

    List<Item> items = [];

    await collectionCollection
      .doc(uid)
      .collection('collections')
      .doc(cm.uid)
      .collection('items')
      .where('cantidad', isGreaterThan: 1)
      .get().then((valueItem) {
        int i = 0;
        valueItem.docs.forEach((elementItems) { 
          Item item = _crearItems(elementItems.data(), cm.title, i, elementItems.id);
          i += 1;
          items.add(item);
      });

    });

    items.sort((a,b) => int.parse(getNumeroName(a.name)).compareTo(int.parse(getNumeroName(b.name))));

    cm.tenguis = items;
    return cm;
  }

  //obtener color usuario
  Future<String> obtenerColor() async{

    String color = 'lila';

    await collectionCollection
      .doc(uid)
      .get().then((value) {
        color = value.data()['color'];
      });
    
    return color;
  }

  //modificar color usuario
  Future modificarColor(String colorNuevo) async{
    await collectionCollection
      .doc(uid)
      .update({
        'color' : colorNuevo
      });
  }

  CollectionModel _crearCollectionModel(Map<String, dynamic> data, List<Item> items, String id) {
    return new CollectionModel(
      uid         : id,
      photo       : data['photo'], 
      title       : data['title'], 
      total       : data['total'], 
      tenguis     : items, 
      porcentage  : data['noFaltas']/data['total'],
      repes       : 0,
      faltas      : data['total'] - data['noFaltas'],
      noFaltas    : data['noFaltas'],
      favourite   : data['favourite'],
      modificable : true 
    );
  }

  Item _crearItems(Map<String, dynamic> data, String title, int i, String id) {
    return new Item(
      uid: id,
      name: data['name'],
      photo: data['photo'],
      position: i,
      quantity: data['cantidad'],
      titlecollection: title
    );
  }

  Future<DocumentReference> _addItems(DocumentReference value, int i){
    return collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value.id)
        .collection('items')
        .add({
          'name'     : i.toString() + ': ' + i.toString(),
          'cantidad' : 0,
          'photo'    : null
        });
  }

  Future<DocumentReference> _deleteItems(DocumentReference value, int i){
    return collectionCollection
        .doc(uid)
        .collection("collections")
        .doc(value.id)
        .collection('items')
        .get().then((valueInt) {
            valueInt.docs.forEach((element) {
              if(int.parse(getNumeroName(element.data()['name'])) == i)
                collectionCollection.doc(uid).collection("collections").doc(value.id).collection('items').doc(element.id).delete();
            });
            return null;
        });
  }




}