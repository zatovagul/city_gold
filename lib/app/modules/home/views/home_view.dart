import 'package:city_gold/app/constants/app_colors.dart';
import 'package:city_gold/app/constants/app_sizes.dart';
import 'package:city_gold/app/constants/app_textstyles.dart';
import 'package:city_gold/app/widgets/drawer_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final webView = Obx(()=>WebView(
      initialUrl: controller.url.value,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: {
        JavascriptChannel(
          name: "alert",
          onMessageReceived: (message){}
        )
      },
      onWebViewCreated: (controller){
        print("CONTROLLER CREATED");
        this.controller.webController = controller;
        controller.clearCache();
      },
      navigationDelegate: (NavigationRequest request){
        print(request);
        if(request.url.startsWith("tel") || request.url.startsWith("mailto")){
          launch(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onPageStarted: (s){
        print("Started $s");
        controller.isLoading.value = true;
      },
      onPageFinished: (s){
        print("Finished $s");
        controller.isLoading.value = false;
        controller.checkConnection();
        controller.checkGoBack();
      },
    ));
    return Obx(()=>Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=>_scaffoldKey.currentState!.openDrawer(),
          icon: Icon(CupertinoIcons.bars, color: AppColors.darkGrey,),
          iconSize: AppSizes.w1 * 30,
        ),
        title: Image.asset("assets/images/logo-old.png", width: AppSizes.w1 * 70,),
        centerTitle: true,
        actions: [
          if(2==3)
          IconButton(
            onPressed: ()async{
              if(await controller.webController!.canGoBack())
                controller.webController!.goBack();
            },
            icon: Icon(Icons.arrow_back_ios_outlined, color: AppColors.darkGrey,),
          ),
          IconButton(
            onPressed: ()=>controller.searchOpen.value = !controller.searchOpen.value,
            icon: Icon(CupertinoIcons.search, color: AppColors.darkGrey,),
          ),
          // if(2==3)
            IconButton(
              onPressed: (){},
              icon: Icon(CupertinoIcons.person_alt_circle, color: AppColors.darkGrey,),
            ),
        ],
      ),
      drawer: _getDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height:controller.searchOpen.value ? 50 : 0,
                decoration: BoxDecoration(color: AppColors.blueGrey),
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w1 * 10),
                child: Center(
                  child: CupertinoTextField(
                    controller: controller.textEditingController,
                    placeholder: "Поиск",
                    onSubmitted: (text)=>controller.searchText(),
                  ),
                ),
              ),
              Expanded(
                child: webView,
              ),
            ],
          ),
          // if(controller.cangoBack.value)
          Positioned(
              bottom: AppSizes.w1 * 12.5,
              right: AppSizes.w1 * 9,
              child: SizedBox(
            width: AppSizes.w1 * 38,
            height: AppSizes.w1 * 38,
            child: ElevatedButton(
              onPressed: ()async{
                if(await controller.webController!.canGoBack())
                  controller.webController!.goBack();
              },
              style: ElevatedButton.styleFrom(primary: AppColors.yellow, shape: CircleBorder(), padding: EdgeInsets.zero),
              child: Center(child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,)),
            ),
          )),
          if(controller.isLoading.value)
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.blueGrey,
              ),
            ),
          ),
          if(controller.isError.value && !controller.isLoading.value)
            Container(
              color: AppColors.white,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.w1 * 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, primary: AppColors.yellow, elevation: 10),
                    onPressed: () {
                      controller.setLink(controller.url.value);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.w1 * 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.refresh, color: AppColors.white,size: AppSizes.w1 * 30,),
                          SizedBox(height: AppSizes.w1 * 5,),
                          Text("Обновить", style: AppTextStyles.white13,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: AppTextStyles.white13.copyWith(fontSize: AppSizes.w1 * 11),
        unselectedLabelStyle: AppTextStyles.white13.copyWith(fontSize: AppSizes.w1 * 9),
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.darkGrey,
        items: _navBarsItems(),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: controller.index.value,
        onTap: (index){
          controller.setIndex(index);
        },
      ),
      // Container(
      //   padding: EdgeInsets.symmetric(vertical: AppSizes.w1 * 10),
      //   color: Colors.white,
      //   child: SafeArea(
      //     child: GNav(
      //       selectedIndex: controller.index.value,
      //         activeColor: CupertinoColors.white,
      //         padding: EdgeInsets.symmetric(horizontal: AppSizes.w1 * 5, vertical: AppSizes.h1 * 5),
      //         duration: Duration(milliseconds: 400),
      //         tabBackgroundColor: AppColors.yellow,
      //         gap: AppSizes.w1 * 5,
      //         iconSize: AppSizes.w1 * 20,
      //         tabMargin: EdgeInsets.all(0),
      //         color: Colors.black,
      //         tabs: _navBarsItems(),
      //         tabBorderRadius: AppSizes.w1 * 10,
      //         onTabChange: (index){
      //           controller.setIndex(index);
      //       },
      //     ),
      //   ),
      // ),
    ));
  }
  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      _getItem(CupertinoIcons.home, "Главная", 0,EdgeInsets.only(left: AppSizes.w1 * 10)),
      _getItem(CupertinoIcons.shopping_cart, "Каталог", 1),
      _getItem(Icons.storefront_outlined, "Магазины", 2),
      _getItem(Icons.apartment, "Производителям", 3),
      _getItem(Icons.messenger_outline, "Блог", 4, EdgeInsets.only(right: AppSizes.w1 * 10)),
    ];
  }
  _getItem(IconData icon, String title, int index, [EdgeInsetsGeometry? margin] )=>
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
          icon: Icon(icon, color: index==controller.index.value ? AppColors.yellow : AppColors.darkGrey ,
            size: index==controller.index.value ? 30 : 22,
          ),
        label: title,
      );
  //     GButton(
  //     margin: margin,
  //     icon: icon,
  //     text: title,
  //     textStyle: AppTextStyles.white13.copyWith(color: CupertinoColors.white),
  //     iconColor: AppColors.white,
  //   iconSize: AppSizes.w1 * 19.5,
  // );
  _getDrawer()=>Drawer(
    child: DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: 0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
                child: Image.asset("assets/images/logo-old.png", width: AppSizes.h1 * 100,))),
          DrawerItemWidget(asset:'assets/images/hand-shake.png',text: "Сотрудничество", onPressed: (){
            Get.back();controller.setUrlLink("page/cooperation");
          }),
          DrawerItemWidget(icon:Icons.apartment,text: "Производителям", onPressed: (){
            Get.back();controller.setIndex(3);
          }),
          DrawerItemWidget(icon:CupertinoIcons.person_2,text: "О нас", onPressed: (){
            Get.back();controller.setUrlLink("page/about");
          }),
          DrawerItemWidget(icon:Icons.messenger_outline,text: "Блог", onPressed: (){
            Get.back();controller.setIndex(4);
          }),
          DrawerItemWidget(icon:Icons.feedback_outlined,text: "Обратная связь", onPressed: (){
            Get.back();controller.setUrlLink("page/call-me");
          }),
          DrawerItemWidget(icon:CupertinoIcons.doc,text: "Пол. соглашение", onPressed: (){
            Get.back();controller.setUrlLink("page/privacy");
          }),
          ...divider,
          DrawerItemWidget(icon:CupertinoIcons.share,text: "Поделиться", onPressed: (){
            Share.share("text");
          }),
          DrawerItemWidget(asset: "assets/images/icon_instagram.png",text: "Instagram", onPressed: ()=>launch("https://www.instagram.com/citygold.uz/")),
          DrawerItemWidget(asset: "assets/images/icon_facebook.png",text: "Facebook", onPressed: ()=>launch("https://www.facebook.com/citygold.uz/")),
          DrawerItemWidget(asset: "assets/images/icon_telegram.png",text: "Telegram", onPressed: ()=>launch("https://t.me/citygold_uz")),
          ...divider,
          if(controller.dollar.value.isNotEmpty)
          ...[
            DrawerItemWidget(icon:CupertinoIcons.money_dollar_circle,text: "Курс валют", onPressed: (){}, showArrow: false,height: 30,),
            Padding(padding: EdgeInsets.only(left: AppSizes.w1 * 42, right: AppSizes.w1 * 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "USD: ${controller.dollar.value} сум",
                        style: AppTextStyles.white13.copyWith(color: AppColors.darkGrey, fontSize: AppSizes.w1 * 11)
                      ),
                      TextSpan(
                          text: "\nЗолото: ${controller.gold.value}",
                          style: AppTextStyles.white13.copyWith(color: AppColors.darkGrey, fontSize: AppSizes.w1 * 11)
                      )
                    ]
                  ),
                ),
            ),
            SizedBox(height: 50,),
          ]
        ],
      ),
    ),
  );
}
get divider =>[SizedBox(height: AppSizes.w1 * 10,), Divider(color: CupertinoColors.black.withOpacity(0.2),), SizedBox(height: AppSizes.w1 * 10,),];