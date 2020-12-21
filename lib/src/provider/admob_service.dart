
import 'dart:io';

class AdmobService {

  String getAdMobAppId(){
    if (Platform.isIOS){
      return null;
    }
    else if (Platform.isAndroid) return "ca-app-pub-1638571766725022~8808896333";
    else return null;
  }

  String getBannerAdId(){
    if (Platform.isIOS){
      return null;
    }
    else if (Platform.isAndroid) return "ca-app-pub-1638571766725022/2243487982";
    else return null;
  }

  getBannerItemAdId() {
    if (Platform.isIOS){
      return null;
    }
    else if (Platform.isAndroid) return "ca-app-pub-1638571766725022/5551863948";
    else return null;
  }

}