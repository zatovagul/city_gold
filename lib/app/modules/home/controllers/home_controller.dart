import 'dart:convert';
import 'dart:io';

import 'package:city_gold/app/constants/api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxString url=''.obs;
  RxInt index = 0.obs;
  WebViewController? webController;
  late TextEditingController textEditingController;

  RxBool searchOpen = false.obs;
  RxBool isLoading = false.obs, isError = false.obs;

  RxString dollar=''.obs, gold = ''.obs;
  final client = http.Client();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    getData();

    textEditingController = TextEditingController();
    url.value = pathBulderAPI("").toString();
    print(url);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
  setIndex(int index){
    this.index.value = index;
    setUrl(index);
  }
  setUrl(int index)async{
    String text = "";
    print(index);
    switch(index){
      case 1:
        text = "catalog-page";
        break;
      case 2:
        text = "shops";
        break;
      case 3:
        text = "for-manufacturers";
        break;
      case 4:
        text = "media";
        break;
    }
    setLink(pathBulderAPI(text).toString());
  }
  
  searchText()async{
    if(textEditingController.text.isNotEmpty){
      searchOpen.value=false;
      setLink(pathBulderAPI("catalog",{'search':textEditingController.text}).toString());
    }
  }

  setUrlLink(String link){
    setLink(pathBulderAPI(link).toString());
  }

  setLink(String link)async{
    url.value = link;
    await webController!.loadUrl(link);
  }

  getData()async{
    try{
      final url = Uri.parse("https://api.citygold.uz/api/settings/info");
      final body = await client.get(url);
      Map map = json.decode(body.body);
      dollar.value = map['dollar'];
      gold.value = map['gold'];
    }
    catch(err){
      print(err);
    }
  }

  checkConnection()async{
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if(result==ConnectivityResult.none)
      isError.value = true;
    else isError.value = false;
  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
