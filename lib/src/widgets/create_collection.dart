import 'dart:io';

import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as p;

class CreateCollection extends StatefulWidget {

  final bool editar;
  final CollectionModel collectionModel;

  CreateCollection(this.collectionModel, this.editar);

  @override
  _CreateCollectionState createState() => _CreateCollectionState();
}

class _CreateCollectionState extends State<CreateCollection> {
  final formKey = GlobalKey<FormState>();

  final coleccionesBloc = new ColeccionesBloc();
  final userBloc = new UserBloc();

  String title;
  String photo;
  int total;

  @override
  @override
  void initState() { 
    super.initState();
    photo = widget.collectionModel.photo;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: AlertDialog(
          backgroundColor: getAppColor(userBloc.color, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Nueva Coleccion', style: TextStyle(color: getAppColor(userBloc.color, 500),),),
          content: Container(
            height: 400,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _crearNombre(),
                  _crearTotal(),
                  Expanded(child: SizedBox(height: double.infinity,)),
                  _crearFoto(),
                  SizedBox(height: 30.0),
                  _crearBoton(context)
                ],
              )
            ),
          ),
        )
    );
  }

  //espacio nombre coleccion
  Widget _crearNombre(){
    return Row(
      children: [
        Icon(Icons.title, color: getAppColor(userBloc.color, 500),),
        Expanded(child: SizedBox(width: double.infinity,)),
        Container(
          width: 200,
          child: TextFormField(
            //expands: true,
            initialValue: (widget.collectionModel.title == null) ? '': widget.collectionModel.title,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Titulo Coleccion'
            ),
            onSaved: (title) => this.title = title ,
            validator: (title){
              if(title.length > 0){
                return null;
              } else {
                return 'Introducir titulo';
              }
            }
          ),
        ),
      ],
    );
  }

  //espacio añadir foto coleccion
  Widget _crearFoto(){

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: getAppColor(userBloc.color, 100),
          width: 2
        ),
        borderRadius: BorderRadius.circular(20)
      
      ),
      child: (photo == null) ? Row(
        children: [
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(
            icon : Icon(Icons.image),
            color: getAppColor(userBloc.color, 500),
            onPressed: ()async{ await _takePhoto(ImageSource.gallery);},
          ),
          Expanded(child: SizedBox(width: double.infinity,)),
          VerticalDivider(thickness: 2,),
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(
            icon : Icon(Icons.camera),
            color: getAppColor(userBloc.color, 500),
            onPressed: () async{ await _takePhoto(ImageSource.camera);},
          ),
          Expanded(child: SizedBox(width: double.infinity,)),
        ]
      ):
      Stack(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image.file(
              File(photo),
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              disabledColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.red[800],
              icon: Icon(Icons.close),
              onPressed: (){
                setState(() {
                  photo = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearTotal(){

    print(widget.collectionModel.total.toString());

    return Row(
      children: [
        Icon(Icons.format_list_numbered, color: getAppColor(userBloc.color, 500),),
        Expanded(child: SizedBox(width: double.infinity,)),
        Container(
          width: 200,
          child: TextFormField(
            initialValue: (widget.collectionModel.total.toString() == 'null') ? '': widget.collectionModel.total.toString(),
            //textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            //initialValue: '0',
            decoration: InputDecoration(
              labelText: 'Total elementos'
            ),
            onSaved: (total) => this.total = int.parse(total) ,
            validator: (cantidad){
              if(cantidad.contains('.')) return 'Introducir valor correcto';
              if(cantidad.contains(',')) return 'Introducir valor correcto';
              if (int.parse(cantidad) > 0){
                return null;
              } else {
                return 'Introducir valor correcto';
              }
            },
          )
        )
      ]
    );

  }

  Widget _crearBoton(BuildContext context) {
    return (widget.editar) ? Row(
      children: [
        _botonEditar(context),
        Expanded(child: SizedBox(width: double.infinity,)),
        RaisedButton(
          elevation: 0,
          disabledElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          child: Text('Eliminar'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            coleccionesBloc.borrarColeccion(widget.collectionModel.uid);
            Navigator.of(context).pop();
          } 
        ),
      ],

    ) : _botonEditar(context);

  }

  RaisedButton _botonEditar(BuildContext context){
    return RaisedButton.icon(
      onPressed: () async{

        if (!formKey.currentState.validate()) return;
        formKey.currentState.save();

        CollectionModel collectionModelfinal = new CollectionModel(
          uid: widget.editar ? widget.collectionModel.uid : '',
          photo: photo, 
          title: this.title, 
          total: this.total, 
          porcentage: 0.0, 
          repes: 0, 
          faltas: this.total, 
          noFaltas: 0,
          favourite: false
        );
        (widget.editar)
        ?await coleccionesBloc.editarColeccion(collectionModelfinal, widget.collectionModel.title, widget.collectionModel.total, widget.collectionModel.photo)
        :await coleccionesBloc.agregarColeccion(collectionModelfinal);

        Navigator.of(context).pop();
        
        //collectionProvider.crearColeccion(collectionModel);
      },
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: getAppColor(userBloc.color, 500),
      textColor: Colors.white,
    );
  }

  Future _takePhoto(ImageSource origen) async{
    final _picker = ImagePicker();

    final imageFile = await _picker.getImage(source: origen);

    if (imageFile == null) return null;

    final appDir = await syspaths.getExternalStorageDirectory();
    final fileName = p.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');

    print(savedImage.path);


    //print(imageFile.path);

    setState(() {
      photo = savedImage.path;
    });
    
  }
}