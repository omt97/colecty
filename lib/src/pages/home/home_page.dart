import 'package:admob_flutter/admob_flutter.dart';
import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/provider/admob_service.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:colecty/src/widgets/barra_buscadora.dart';
import 'package:colecty/src/widgets/collection_cards.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final coleccionesBloc = new ColeccionesBloc();
  final ams = AdmobService();

  final userBloc = new UserBloc();

  @override
  void initState() {
    super.initState();
    Admob.initialize();
    //com.finishcollections.colecty
    /*FirebaseAdMob.instance.initialize(appId: ams.getAdMobAppId());
    _bannerAd = BannerAd(
      adUnitId: ams.getBannerAdId(),
      size: AdSize.banner,
    );
    _loadBannerAd();*/
  }

  @override
  void dispose() { 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    

    final _screenSize = MediaQuery.of(context).size;

    coleccionesBloc.modificarFiltro('todas');

    return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: getAppColor(userBloc.color, 100),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [getAppColor(userBloc.color, 200), Colors.white]
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            BarraBuscadora(),
            SizedBox(height: 0.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10), 
              child: AdmobBanner(adUnitId: ams.getBannerAdId(), adSize: AdmobBannerSize.FULL_BANNER,)),
            Row(children: <Widget>[
              Expanded(child: SizedBox(width: double.infinity,)),
              IconButton(icon: Icon(Icons.filter_alt, color: getAppColor(userBloc.color, 700),), onPressed: (){
                _opcionesFilter(context);
              }),
              SizedBox(width: 10)
            ]),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: _screenSize.width,
              height: _screenSize.height - 255.0, //255
              child: CollectionCards(),
            )
          ],
        ),
      ),
    );
  }

  _opcionesFilter(BuildContext context, ){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: getAppColor(userBloc.color, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Ordenar Por', style: TextStyle(color: getAppColor(userBloc.color, 500),),),
          content: Container(
            height: 250,
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('todas');
                    Navigator.of(context).pop();
                  }, 
                  child: Text(
                    'Todos', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'todas' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('favoritas');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Favoritas', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'favoritas' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('asc');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mas completa', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'asc' ? getAppColor(userBloc.color, 500) : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('desc');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Menos completa', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'desc' ? getAppColor(userBloc.color, 500) : Colors.grey),)),

              ]
            ),
          )
        );
      }
    );
  }

  /*void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.top);
  }*/

  /*Widget _banner(){
    return AdmobBanner(
      adUnitId: ams.getBannerAdId(), 
      adSize: AdmobBannerSize.FULL_BANNER
    );
  }*/
}