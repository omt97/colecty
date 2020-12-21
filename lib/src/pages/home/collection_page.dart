import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/provider/admob_service.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:colecty/src/widgets/item_list.dart';
import 'package:colecty/src/widgets/iteminfo_list.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CollectionPage extends StatefulWidget {

  static final routeName = 'collection';

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  ScrollController _scrollController;

  //ScrollController _scrollControllerList;

  bool lastStatus = true;

  final coleccionesBloc = new ColeccionesBloc();
  final userBloc = new UserBloc();
  final ams = AdmobService();

  @override
  void initState() {
    Admob.initialize();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
        _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    //final String title = ModalRoute.of(context).settings.arguments;

    final _screenSize = MediaQuery.of(context).size;
    
    //coleccionesBloc.modificarFiltroItem('todas', title);

    return StreamBuilder<CollectionModel>(
      stream: coleccionesBloc.collectionStream,
      builder: (BuildContext context, AsyncSnapshot<CollectionModel> snapshot){
        if(!snapshot.hasData) {
          return Scaffold();
        }
        if (snapshot.hasData){
          final collectionModel = snapshot.data;

          return  WillPopScope(
            onWillPop: () { coleccionesBloc.obtenerColecciones(); Navigator.pop(context); return null;},
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Container(
                child: Column(
                  children: [
                    _crearAppBar(context, collectionModel, _screenSize.width),
                    _tipoVista(_screenSize.width, coleccionesBloc.vista),
                    SingleChildScrollView(
                      child: Container(

                          //color: Colors.green,
                          height: _screenSize.height - 308, //308
                          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          child: Center(child: (coleccionesBloc.vista)?ItemList(collectionModel: collectionModel): ItemInfoList(collectionModel: collectionModel))
                        ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10), 
                      child: AdmobBanner(adUnitId: ams.getBannerItemAdId(), adSize: AdmobBannerSize.FULL_BANNER,)),
                  ],
                )
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
          
    );
  }

  //selecciona si es item o info item
  Widget _tipoVista(double width, bool vista){
    return Row(
      children: <Widget>[
        ButtonTheme(buttonColor: Colors.transparent, 
        shape: Border(
          bottom: BorderSide(
               width:3,
               color : vista ? getAppColor(userBloc.color, 400) : Colors.transparent
         ),
        ), 
        minWidth: width/2, 
        child: RaisedButton(
          child: Text('Ítem', style: TextStyle(color: vista ?  getAppColor(userBloc.color, 400) : Colors.grey[600]),),
          disabledElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          elevation: 0, 
          onPressed: () {
          setState(() {
            coleccionesBloc.modificarVista('botones');
          });  
        }
        )),
        ButtonTheme(buttonColor: Colors.transparent, 
        shape: Border(
          bottom: BorderSide(
               width:3,
               color : vista ? Colors.transparent : getAppColor(userBloc.color, 400)
         ),
        ), 
        minWidth: width/2, 
        child: RaisedButton(
          child: Text('Info Ítem', style: TextStyle(color: vista ? Colors.grey[600] : getAppColor(userBloc.color, 400)),),
          disabledElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          hoverElevation: 0,
          elevation: 0, 
          onPressed: () {
          setState(() {
            coleccionesBloc.modificarVista('info');
          });  
        }
        )),
      ],
    );
  }

  //crea un widget donde se ve foto y info de la coleccion
  Widget _crearAppBar(BuildContext context, CollectionModel coleccion, double width) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 200,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        color: getAppColor(userBloc.color, 100),
      ),
      
      child: Stack(children: [
        Row(children: [
          IconButton(color: getAppColor(userBloc.color, 800), icon: Icon(Icons.arrow_circle_down), onPressed: (){coleccionesBloc.obtenerColecciones(); Navigator.pop(context);}),
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(color: getAppColor(userBloc.color, 800), icon: Icon(Icons.filter_alt_rounded), onPressed: (){_opcionesFilter(context, coleccion);}),
        ],),
        _infoColeccion(coleccion, width),
      ],)
          //Expanded(child: SizedBox(height: 100)),
          
        
      
    );
  }

  //te pone la variable y valor
  Widget _numeroTexto(String nombre, int total){

    final TextStyle textStyleNumeros = new TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.bold);
    final TextStyle textStyleTexto = new TextStyle(color: Colors.grey[700], fontSize: 14);


    return Column(
      children: <Text>[
        Text(nombre, style: textStyleTexto,),
        Text(total.toString(), style: textStyleNumeros,)
      ],
    );
  }

  //no se si se usa
  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  //creo que se puede borrar TODO
  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  //informacion sobre la coleccion
  Widget _infoColeccion(CollectionModel coleccion, double width){
    return Container(
          margin: EdgeInsets.only(top: 25.0),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Hero(
                  tag: coleccion.title,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: coleccion.photo != null ? Image.file(
                      File(coleccion.photo),
                      fit: BoxFit.cover,
                      width: 80,
                      height: 200,
                    ): Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                      width: 80,
                      height: 200,
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: SizedBox(height: double.infinity,)),
                    Text(coleccion.title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(child: SizedBox(height: double.infinity,)),
                    Container(
                      width: width - 166,
                      child: Row(
                        children: <Widget>[
                          _numeroTexto('Total', coleccion.total),
                          Expanded(child: SizedBox(width: double.infinity,)),
                          _numeroTexto('Marcados', coleccion.noFaltas),
                          Expanded(child: SizedBox(width: double.infinity,)),
                          _numeroTexto('Faltas', coleccion.faltas),
                        ],
                      ),
                    ),
                    //Text('Cantidad: 200/300' , style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                    Expanded(child: SizedBox(height: double.infinity,)),
                    LinearPercentIndicator(
                      width: width - 165,
                      lineHeight: 14.0,
                      percent: coleccion.porcentage,
                      backgroundColor: Colors.white,
                      progressColor: Colors.lightGreen[500],
                    ),
                    Expanded(child: SizedBox(height: double.infinity,)),
                  ]
                ),
              )
            ]
          ),
        );
  }

  //seleccionar las opciones de filtro
  _opcionesFilter(BuildContext context, CollectionModel cm ){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: getAppColor(userBloc.color, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Mostrar', style: TextStyle(color: getAppColor(userBloc.color, 500),),),
          content: Container(
            height: 250,
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('todas', cm);
                    Navigator.of(context).pop();
                  }, 
                  child: Text(
                    'Todos', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'todas' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('tengis', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Marcados', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'tengis' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('faltis', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Faltas', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'faltis' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('repes', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Repetidos', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'repes' ? getAppColor(userBloc.color, 500) : Colors.grey),)),

              ]
            ),
          )
        );
      }
    );
  }
}