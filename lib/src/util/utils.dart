  String getNumeroName(String palabra){

    for (int i = 0; i < palabra.length; ++i){
      if (palabra[i] == ':') return palabra.substring(0, i);
    }

    return '0';

  }

    String getNameSinNumero(String palabra){

    for (int i = palabra.length - 1; i >= 0; --i){
      if (palabra[i] == ':') return palabra.substring(i + 2, palabra.length);
    }

    return '0';

  }