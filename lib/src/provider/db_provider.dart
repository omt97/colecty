import 'dart:io';
 
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';




class DBProvider {

  static Database _database;

  static final DBProvider db = DBProvider._private();

  DBProvider._private();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async{

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    var a = await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {

        await db.execute(
          'CREATE TABLE Colecciones ('
          ' photo TEXT,'
          ' title TEXT PRIMARY KEY,'
          ' total INTEGER,'
          ' porcentage REAL,'
          ' repes INTEGER,'
          ' faltas INTEGER,'
          ' noFaltas INTEGER,'
          ' favourite TEXT'
          ')'
        );
        await db.execute(
          'CREATE TABLE Items ('
          ' nombreItem TEXT,'
          ' titleColeccion TEXT,'
          ' posicion INTEGER,'
          ' cuantos INTEGER,'
          ' PRIMARY KEY (titleColeccion, posicion)'
          ')'
        );
      }
    );


    return a;

  }

  //meter información

  Future<int> nuevaColeccionRaw(CollectionModel nuevaColeccion) async{

    

    final db = await database;


    for (int i = 0; i < nuevaColeccion.total; i++){
      String query = "INSERT INTO Items "
        "VALUES ('$i', '${nuevaColeccion.title}', $i, 0)";
      await db.rawInsert(query);
    }

    
    String query = "INSERT INTO Colecciones "
      "VALUES ('${nuevaColeccion.photo}', '${nuevaColeccion.title}', ${nuevaColeccion.total}, ${nuevaColeccion.porcentage}, ${nuevaColeccion.repes}, ${nuevaColeccion.faltas}, ${nuevaColeccion.noFaltas}, '${nuevaColeccion.favourite}')";

    var res = await db.rawInsert(query);

    return res;

  }

  //Obetner info

  Future<CollectionModel> getCollectionId(String title, String filtro) async{

    final db = await database;

    final res = await db.rawQuery("SELECT * "
                                  "FROM Colecciones "
                                  "WHERE title='$title'");

    final res2 = await db.rawQuery("SELECT * "
                                  "FROM Items "
                                  "WHERE titleColeccion='$title' "
                                  "AND cuantos$filtro");

    print("SELECT * "
                                  "FROM Items "
                                  "WHERE titleColeccion='$title' "
                                  "AND cuantos$filtro");

    CollectionModel coleccion =  res.isNotEmpty ? CollectionModel.fromJson(res.first) : null;

    List<Item> listaItems = new List(res2.length);

    for (int i = 0; i < res2.length; i++){
      print(res2[i].toString());
      
      listaItems[i] = Item.fromJson(res2[i]);
    }


    coleccion.tenguis = listaItems;

    return coleccion;

  }

  Future<List<CollectionModel>> getCollectionsSearch(String word) async {

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Colecciones WHERE title LIKE '$word%' ORDER BY title ASC");

    return res.isNotEmpty ? res.map((c) => CollectionModel.fromJson(c)).toList() : [];

  }

  Future<List<CollectionModel>> getCollections() async{

    final db = await database;

    final res = await db.rawQuery('SELECT * FROM Colecciones ORDER BY title ASC');
 
    return res.isNotEmpty ? res.map((c) => CollectionModel.fromJson(c)).toList() : [];
  }

  Future<List<CollectionModel>> getCollectionsFav() async{

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Colecciones WHERE favourite = 'true'");
    //print(res.toString() + 'asa');
    return res.isNotEmpty ? res.map((c) => CollectionModel.fromJson(c)).toList() : [];
  }

  Future<List<CollectionModel>> getCollectionsAsc() async{

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Colecciones ORDER BY porcentage DESC, title ASC");
    return res.isNotEmpty ? res.map((c) => CollectionModel.fromJson(c)).toList() : [];
  }

  Future<List<CollectionModel>> getCollectionsDesc() async{

    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Colecciones ORDER BY porcentage ASC, title ASC");
    return res.isNotEmpty ? res.map((c) => CollectionModel.fromJson(c)).toList() : [];
  }

  //actualizar db

  Future<int> updateItem(String titleColeccion, String name, String accion, int cantidad) async{

    final db = await database;
    final query = "UPDATE Items "
                  "SET cuantos = cuantos $accion $cantidad "
                  "WHERE titleColeccion = '$titleColeccion' "
                  "AND nombreItem = '$name'";

    final res = await db.rawUpdate(query);


    return res;

  }

  Future<int> updateItemText(String titleColeccion, int posicion, String nombre) async{

    final db = await database;

    final res = await db.rawUpdate("UPDATE Items "
                                   "SET nombreItem = $nombre "
                                   "WHERE titleColeccion = '$titleColeccion' "
                                   "AND posicion = $posicion");

    return res;

  }

  Future<int> updateColeccionVariable(String title, String variable, var valor) async{
    final db = await database;
    final query = "UPDATE Colecciones "
                  "SET $variable = $valor "
                  "WHERE title='$title'";
    final res = await db.rawUpdate(query);
    return res;
  }

  Future<int> updateColeccionTitle(String title, String variable, var valor) async{
    final db = await database;
    final query = "UPDATE Colecciones "
                  "SET $variable = '$valor' "
                  "WHERE title='$title'";
    final res = await db.rawUpdate(query);
    return res;
  }

  Future<int> updateColeccionTotal(String title, String variable, var valor, int diferencia) async{
    final db = await database;
    final query = "UPDATE Colecciones "
                  "SET $variable = $valor "
                  "AND faltas = $valor "
                  "WHERE title='$title'";
    print(query);
    final res = await db.rawUpdate(query);

    print(res);

    /*if (diferencia > 0){
      for (int i = 0; i < diferencia; i++){
        String query = "INSERT INTO Items "
          "VALUES ('$i', '$title', $i, 0)";
        await db.rawInsert(query);
      }
    }*/

    return res;
  }


  //eliminar

    Future<int> deleteColeccion(String title) async{

    final db = await database;
    await db.delete('Colecciones', where: 'title=?', whereArgs: [title]);
    final res = await db.delete('Items', where: 'titleColeccion=?', whereArgs: [title]);
    //final res = await db.delete('Colecciones', where: 'title=?', whereArgs: [title]);

    return res;

  }


}