
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
    
  }

  agregarColeccion(CollectionModel collectionModel) async{
    await DatabaseProvider(uid: ub.uid).nuevaColeccion(collectionModel);
    obtenerColecciones();
  }

  editarColeccion(CollectionModel collectionModel, String oldTitle, int oldTotal, String oldPhoto) async{
    await DatabaseProvider(uid: ub.uid).editarColeccion(collectionModel, oldTitle, oldTotal, oldPhoto);
    obtenerColecciones();
  }

  editarItem(Item ci, String oldName, String oldPhoto, CollectionModel cm) async{
    await DatabaseProvider(uid: ub.uid).editarItem(ci, oldName, oldPhoto, cm.uid);
    obtenerColeccion(cm);
    obtenerColecciones();
  }

  borrarColeccion(String uidCol) async{
    await DatabaseProvider(uid: ub.uid).borrarColeccion(uidCol);
    obtenerColecciones();
  }

  sumarItemCantidad(CollectionModel cm, Item item, int noFaltas) async{
    CollectionModel newCm = await DatabaseProvider(uid: ub.uid).sumarItem(cm, item, noFaltas);
    obtenerColecciones();
    obtenerColeccion(newCm);
  }

  restarItemCantidad(CollectionModel cm, Item item, int noFaltas) async{
    CollectionModel newCm = await DatabaseProvider(uid: ub.uid).restarItem(cm, item, noFaltas);
    obtenerColecciones();
    obtenerColeccion(newCm);
  }

  coleccionFavorita(String uidCol, bool favorita) async{
    await DatabaseProvider(uid: ub.uid).editarFavColeccion(uidCol, favorita);
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