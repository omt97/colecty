import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
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

  @override
  void initState() {
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

          return  Scaffold(
            body: Container(
              child: Column(
                children: [
                  _crearAppBar(context, collectionModel, _screenSize.width),
                  _tipoVista(_screenSize.width, coleccionesBloc.vista),
                  SingleChildScrollView(
                    child: Container(

                        //color: Colors.green,
                        height: _screenSize.height - 248,
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                        child: Center(child: (coleccionesBloc.vista)?ItemList(collectionModel: collectionModel): ItemInfoList(collectionModel: collectionModel))
                      ),
                  )
                ],
              )
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

  Widget _tipoVista(double width, bool vista){
    return Row(
      children: <Widget>[
        ButtonTheme(buttonColor: Colors.transparent, 
        shape: Border(
          bottom: BorderSide(
               width:3,
               color : vista ? Colors.deepPurple[400] : Colors.transparent
         ),
        ), 
        minWidth: width/2, 
        child: RaisedButton(
          child: Text('Item', style: TextStyle(color: vista ?  Colors.deepPurple[400] : Colors.grey[600]),),
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
               color : vista ? Colors.transparent : Colors.deepPurple[400]
         ),
        ), 
        minWidth: width/2, 
        child: RaisedButton(
          child: Text('Info Item', style: TextStyle(color: vista ? Colors.grey[600] : Colors.deepPurple[400]),),
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

  Widget _crearAppBar(BuildContext context, CollectionModel coleccion, double width) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: 200,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        color: Colors.deepPurple[100],
      ),
      
      child: Stack(children: [
        Row(children: [
          IconButton(color: Colors.deepPurple[800], icon: Icon(Icons.arrow_circle_down), onPressed: (){Navigator.pop(context);}),
          Expanded(child: SizedBox(width: double.infinity,)),
          IconButton(color: Colors.deepPurple[800], icon: Icon(Icons.filter_alt_rounded), onPressed: (){_opcionesFilter(context, coleccion);}),
        ],),
        _infoColeccion(coleccion, width),
      ],)
          //Expanded(child: SizedBox(height: 100)),
          
        
      
    );
  }

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

    _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

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
                    child: FadeInImage(
                      placeholder: AssetImage(coleccion.photo), 
                      image: AssetImage(coleccion.photo),
                      fadeInDuration: Duration(milliseconds: 150),
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
                          _numeroTexto('Marcada', coleccion.noFaltas),
                          Expanded(child: SizedBox(width: double.infinity,)),
                          _numeroTexto('Faltas', coleccion.faltas),
                          Expanded(child: SizedBox(width: double.infinity,)),
                          _numeroTexto('Repetidas', coleccion.repes),
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

  _opcionesFilter(BuildContext context, CollectionModel cm ){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Mostrar', style: TextStyle(color: Colors.deepPurple,),),
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
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'todas' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('tengis', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Marcadas', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'tengis' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('faltis', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Faltas', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'faltis' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltroItem('repes', cm);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Repetidas', 
                    style: TextStyle(color: coleccionesBloc.filtroItem == 'repes' ? Colors.deepPurple : Colors.grey),)),

              ]
            ),
          )
        );
      }
    );
  }
}