import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditItem extends StatefulWidget {

  final Item itemModel;
  final CollectionModel cm;

  EditItem(this.itemModel, this.cm);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final formKey = GlobalKey<FormState>();

  String title;
  String photo;
  String numero;

  final coleccionesBloc = new ColeccionesBloc();

  @override
  void initState() {
    super.initState();
    photo = widget.itemModel.photo;
    title = widget.itemModel.name;
    numero = getNumeroName(widget.itemModel.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
          backgroundColor: Colors.deepPurple[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Nueva Coleccion', style: TextStyle(color: Colors.deepPurple,),),
          content: Container(
            height: 400,
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _crearNombre(),
                  Expanded(child: SizedBox(height: double.infinity,)),
                  _crearFoto(),
                  SizedBox(height: 30.0),
                  _botonEditar(context)
                ],
              )
            ),
          ),
        )
    );
  }

  //espacio nombre item
  Widget _crearNombre(){
    return Row(
      children: [
        Icon(Icons.title, color: Colors.deepPurple,),
        Expanded(child: SizedBox(width: double.infinity,)),
        Container(
          width: 200,
          child: TextFormField(
            //expands: true,
            initialValue: (title == null) ? '': getNameSinNumero(title),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Nombre Item'
            ),
            onSaved: (title) => this.title = numero + ': ' + title ,
            validator: (title){
              if(title.length > 0){
                return null;
              } else {
                return 'Introducir nombre';
              }
            }
          ),
        ),
      ],
    );
  }


  Widget _crearFoto(){

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple[100],
          width: 2
        ),
        borderRadius: BorderRadius.circular(20)
      
      ),
      child: (photo == null) ? Row(
        children: [
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(
            icon : Icon(Icons.image),
            color: Colors.deepPurple,
            onPressed: ()async{ await _takePhoto(ImageSource.gallery);},
          ),
          Expanded(child: SizedBox(width: double.infinity,)),
          VerticalDivider(thickness: 2,),
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(
            icon : Icon(Icons.camera),
            color: Colors.deepPurple,
            onPressed: () async{ await _takePhoto(ImageSource.camera);},
          ),
          Expanded(child: SizedBox(width: double.infinity,)),
        ]
      ):
      Stack(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image(
              image: AssetImage(photo),
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

  RaisedButton _botonEditar(BuildContext context){
    return RaisedButton.icon(
      onPressed: () async{

        if (!formKey.currentState.validate()) return;
        formKey.currentState.save();

        Item itemFinal = new Item(
          uid: widget.itemModel.uid,
          name: this.title,
          photo: this.photo,
          position: widget.itemModel.position,
          quantity: widget.itemModel.quantity,
          titlecollection: widget.itemModel.titlecollection
        );

        await coleccionesBloc.editarItem(itemFinal, widget.itemModel.name, widget.itemModel.photo, widget.cm);
        Navigator.of(context).pop();

        /*if (!formKey.currentState.validate()) return;
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
        
        //collectionProvider.crearColeccion(collectionModel);*/
      },
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  Future _takePhoto(ImageSource origen) async{
    final _picker = ImagePicker();

    final imageFile = await _picker.getImage(source: origen);

    if (imageFile == null) return null;

    print(imageFile.path);

    setState(() {
      photo = imageFile.path;
    });
    
  }

}