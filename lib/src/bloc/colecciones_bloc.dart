
import 'dart:async';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:colecty/src/provider/database.dart';

class ColeccionesBloc {

  static final ColeccionesBloc _singleton = new ColeccionesBloc._internal();

  String filtro = 'todas';
  String filtroItem = 'todas';
  bool vista = true;

  UserBloc ub = new UserBloc();


  factory ColeccionesBloc(){
    return _singleton;
  }

  ColeccionesBloc._internal(){
    obtenerColecciones();
    //obtenerColeccion('pedos2');
  }

  final _coleccionesController = StreamController<List<CollectionModel>>.broadcast();
  final _coleccionesControllerSearch = StreamController<List<CollectionModel>>.broadcast();
  final _coleccionController = StreamController<CollectionModel>.broadcast();

  Stream<List<CollectionModel>> get collectionsStream => _coleccionesController.stream;
  Stream<List<CollectionModel>> get collectionsStreamSearch => _coleccionesControllerSearch.stream;
  Stream<CollectionModel> get collectionStream => _coleccionController.stream;

  dispose(){
    _coleccionesController?.close();
    _coleccionesControllerSearch?.close();
    _coleccionController?.close();
  }

  obtenerColecciones() async{
    if (filtro == 'favoritas') _coleccionesController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionesFav());
    else if (filtro == 'asc') _coleccionesController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionesAsc());
    else if (filtro == 'desc') _coleccionesController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionesDesc());
    else _coleccionesController.sink.add(await DatabaseProvider(uid: ub.uid).colecciones());
    /*if (filtro == 'favoritas') _coleccionesController.sink.add(await DBProvider.db.getCollectionsFav());
    
    else if (filtro == 'desc') _coleccionesController.sink.add(await DBProvider.db.getCollectionsDesc());
    else _coleccionesController.sink.add(await DBProvider.db.getCollections());*/
  }

  obtenerColeccionesSearch(String word) async{
    _coleccionesControllerSearch.sink.add(await DatabaseProvider(uid: ub.uid).coleccionesSearch(word));
  }

  obtenerColeccion(CollectionModel cm) async{
    print(filtroItem);
    if (filtroItem == 'tengis') _coleccionController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionTenguis(cm));
    else if (filtroItem == 'faltis') _coleccionController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionFaltis(cm));
    else if (filtroItem == 'repes') _coleccionController.sink.add(await DatabaseProvider(uid: ub.uid).coleccionRepes(cm));
    else {
      CollectionModel c = await DatabaseProvider(uid: ub.uid).coleccion(cm);
      print(c.noFaltas);
      _coleccionController.sink.add(c);
    }
    /*if (filtroItem == 'tengis') _coleccionController.sink.add(await DBProvider.db.getCollectionId(title, ' > 0'));
    else if (filtroItem == 'faltis') _coleccionController.sink.add(await DBProvider.db.getCollectionId(title, ' = 0'));
    else if (filtroItem == 'repes') _coleccionController.sink.add(await DBProvider.db.getCollectionId(title, ' > 1'));
    else _coleccionController.sink.add(await DBProvider.db.getCollectionId(title, ' > -1'));*/
    
  }

  agregarColeccion(CollectionModel collectionModel) async{
    await DatabaseProvider(uid: ub.uid).nuevaColeccion(collectionModel);
    //await DBProvider.db.nuevaColeccionRaw(collectionModel);
    obtenerColecciones();
  }

  editarColeccion(CollectionModel collectionModel, String oldTitle, int oldTotal, String oldPhoto) async{
    await DatabaseProvider(uid: ub.uid).editarColeccion(collectionModel, oldTitle, oldTotal, oldPhoto);
    //if (oldTotal != collectionModel.total) await DBProvider.db.updateColeccionTotal(oldTitle, 'total', collectionModel.total, collectionModel.total-oldTotal);
    //if (oldTitle != collectionModel.title) await DBProvider.db.updateColeccionTitle(oldTitle, 'title', collectionModel.title);
    
    //await DBProvider.db.updateColeccionVariable(oldTitle, 'title', collectionModel.title);
    obtenerColecciones();
  }

  editarItem(Item ci, String oldName, String oldPhoto, CollectionModel cm) async{
    await DatabaseProvider(uid: ub.uid).editarItem(ci, oldName, oldPhoto, cm.uid);
    //if (oldTotal != collectionModel.total) await DBProvider.db.updateColeccionTotal(oldTitle, 'total', collectionModel.total, collectionModel.total-oldTotal);
    //if (oldTitle != collectionModel.title) await DBProvider.db.updateColeccionTitle(oldTitle, 'title', collectionModel.title);
    
    //await DBProvider.db.updateColeccionVariable(oldTitle, 'title', collectionModel.title);
    obtenerColeccion(cm);
    obtenerColecciones();
  }

  borrarColeccion(String uidCol) async{
    await DatabaseProvider(uid: ub.uid).borrarColeccion(uidCol);
    //await DBProvider.db.deleteColeccion(titleColeccion);
    obtenerColecciones();
  }

  sumarItemCantidad(CollectionModel cm, Item item, int noFaltas) async{
    CollectionModel newCm = await DatabaseProvider(uid: ub.uid).sumarItem(cm, item, noFaltas);
   /* await DBProvider.db.updateItem(titleColeccion, name, '+', 1);
    if (cantidad == 0){
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'noFaltas', 'noFaltas + 1');
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'Faltas', 'Faltas - 1');
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'porcentage', por);
    }else{
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'repes', 'repes + 1');
    }*/
    obtenerColecciones();
    obtenerColeccion(newCm);
  }

  restarItemCantidad(CollectionModel cm, Item item, int noFaltas) async{
    CollectionModel newCm = await DatabaseProvider(uid: ub.uid).restarItem(cm, item, noFaltas);
   /* await DBProvider.db.updateItem(titleColeccion, name, '+', 1);
    if (cantidad == 0){
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'noFaltas', 'noFaltas + 1');
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'Faltas', 'Faltas - 1');
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'porcentage', por);
    }else{
      await DBProvider.db.updateColeccionVariable(titleColeccion, 'repes', 'repes + 1');
    }*/
    obtenerColecciones();
    obtenerColeccion(newCm);
  }

  /*Future<List<CollectionModel>> getColecciones() async{
    return await DBProvider.db.getCollections();
  }*/

  /*Future<CollectionModel> getColeccion(String title) async{
    return await DBProvider.db.getCollectionId(title, ' > -1');
  }*/

  coleccionFavorita(String uidCol, bool favorita) async{
    await DatabaseProvider(uid: ub.uid).editarFavColeccion(uidCol, favorita);
    //await DBProvider.db.updateColeccionVariable(titleColeccion, 'favourite', '$favorita');
    obtenerColecciones();
  }

  modificarFiltro(String filtro) {
    this.filtro = filtro;
    obtenerColecciones();
  }

  modificarFiltroItem(String filtro, CollectionModel cm) {
    
    this.filtroItem = filtro;
    
    obtenerColeccion(cm);
  }

  modificarVista(String eleccion) {
    
    if (eleccion == 'botones') vista = true;
    else vista = false;
  }





}