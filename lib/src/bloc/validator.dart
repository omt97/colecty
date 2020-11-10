import 'dart:async';

class Validators{

  final validarTitle = StreamTransformer<String, String>.fromHandlers(
    handleData: (title, sink){
      if(title.length > 0){
        sink.add(title);
      } else {
        sink.addError('Introducir titulo');
      }
    
    }
  );

    final validarCantidad = StreamTransformer<String, String>.fromHandlers(
    handleData: (cantidad, sink){
      if(int.parse(cantidad) > 0 || cantidad.contains('.')){
        sink.add(cantidad);
      } else {
        sink.addError('Introducir valor correcto');
      }
    
    }
  );

}