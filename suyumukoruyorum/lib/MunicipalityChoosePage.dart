import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/HomePage.dart';
import 'package:suyumukoruyorum/LandingPage.dart';
import 'package:suyumukoruyorum/MuniHomePage.dart';

class MunicipalityChoosePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MunicipalityChoosePageState();
  }

}

class MunicipalityChoosePageState extends State<MunicipalityChoosePage>{

  bool isStateChosen = false;

  List<String> metropolitanList = ["Adana", "Ankara", "Antalya", "Aydın", "Balıkesir", "Bursa", "Denizli", "Diyarbakır",
    "Erzurum", "Eskişehir", "Gaziantep", "Hatay", "İstanbul", "İzmir", "Kahramanmaraş", "Kayseri", "Kocaeli", "Konya",
    "Malatya", "Manisa", "Mardin", "Mersin", "Muğla", "Ordu", "Sakarya", "Samsun", "Şanlıurfa", "Tekirdağ", "Trabzon", "Van"];

  List<String> cityList = ["Adana","Adıyaman", "Afyonkarahisar", "Aksaray", "Amasya", "Ankara", "Antalya", "Ardahan", "Artvin",
    "Aydın", "Ağrı", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa",
    "Çanakkale",  "Çankırı", "Çorum", "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
    "Gaziantep", "Giresun", "Gümüşhane", "Hakkâri","Hatay", "Isparta", "Iğdır", "İstanbul", "İzmir", "Kahramanmaraş",
    "Karabük", "Karaman", "Kars", "Kastamonu", "Kayseri", "Kilis", "Kocaeli", "Konya", "Kütahya", "Kırklareli", "Kırıkkale",
    "Kırşehir", "Malatya", "Manisa", "Mardin", "Mersin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Osmaniye", "Rize",
    "Sakarya", "Samsun", "Siirt", "Sinop", "Sivas", "Şanlıurfa", "Şırnak", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Uşak",
    "Van", "Yalova", "Yozgat", "Zonguldak"];

  List<String> adana = ["Aladağ", "Ceyhan", "Çukurova", "Feke", "İmamoğlu", "Karaisalı", "Karataş", "Kozan", "Pozantı",
    "Saimbeyli", "Sarıçam", "Seyhan", "Tufanbeyli", "Yumurtalık", "Yüreğir"];

  List<String> burdur = ["Burdur (İl merkezi)", "Ağlasun", "Altınyayla", "Bucak", "Çavdır", "Çeltikçi", "Gölhisar",
    "Karamanlı", "Kemer", "Tefenni", "Yeşilova"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bölge Seç"),
      ),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox( height: 800,
          child: ListView(
            children: [
              Row( children: [
                  const Text("!!Son bir adım: Bölgeni seç.",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),),
                  TextButton(
                    child: const Text("NEDEN?",
                      style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
                          color: Colors.indigo, decorationThickness: 3, fontSize: 12)),
                    onPressed: () => nedenDialog()
                  ),
                ],
              ),
              SizedBox( height: 600, width: 300,
                child: Card( elevation: 50, color: Colors.blue[200],
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: 81, itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox( height: 10, width: 10,
                            child: Card( elevation: 20, color: Colors.blue[900],
                              child: TextButton(
                                child: Text(cityList[index],
                                  style: const TextStyle(color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  ilceGetir(cityList[index]);
                                },
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? false : true,
                child: Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  const Text("Bölge seçmeden",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),),
                  TextButton(
                      child: const Text("KAYDOL",
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
                              color: Colors.indigo, decorationThickness: 3, fontSize: 18)),
                      onPressed: () {
                        isStateChosen = false;
                        register("tanımlanmadı", "tanımlanmadı");
                      }
                  ),],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void nedenDialog() {
    AlertDialog alertDialog = const AlertDialog(
      title: Center(child: Text("Suyumu Koruyorum mobil uygulamamız kapsamında", style: TextStyle( fontWeight: FontWeight.bold),)),
      content: SizedBox(
        height: 500, width: 500,
        child: Column(
          children: [
            Text("1. Kendi tüketim ortalamanızı aynı belediyeye bağlı diğer kullanıcılar ile karşılaştırabilir, "
                "tasarruf sıralamanızı öğrenebilirsiniz.",
              style: TextStyle(fontFamily: "Play", fontStyle: FontStyle.italic, fontSize: 18),),
            SizedBox(height: 10,),
            Text("2. Su kaçaklarını, kaçak kullanımları, kaçak sondaj veya kuyuları bağlı bulunduğunuz belediyeye"
                " kolayca bildirebilirsiniz.",
              style: TextStyle(fontFamily: "Play", fontStyle: FontStyle.italic, fontSize: 18),),
            SizedBox(height: 10,),
            Text("3. Anlaşmalı belediyeler tasarruf sıralamaları sonucunda kullanıcılarını kendileri belirleyecekleri "
                "koşullarda ödüllendirebileceklerdir. Bu ödüllendirmeler maddi yada farklı şekllerde olabilir.",
              style: TextStyle(fontFamily: "Play", fontStyle: FontStyle.italic, fontSize: 18),),
            SizedBox( height: 30,),
            Text("Bu ve daha sonra güncelleme ile gelebilecek özelliklerden faydalanabilmek için şimdi bölgenizi seçebilirsiniz."
              , style: TextStyle(fontFamily: "Play", fontSize: 15),),
          ],
        ),
      ),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void ilceGetir(String city){

    AlertDialog alertDialog = AlertDialog(
      title: Center(child: Text( "Bağlı bulunduğunuz ${city.toUpperCase()} ilinin ilçeleri listelenmektedir. ilçenizi "
          "seçiniz", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 15),)),
      content: SizedBox(
        height: MyInheritor.of(context)?.isCity == true ? 100 : 500,
        width: 500,
        child: ListView.builder(
          itemCount: city == "Adana" ? 15 : city == "Burdur" ? 10 : 1,
          itemBuilder: (context, index){

            return Visibility( visible: MyInheritor.of(context)?.isCity == true ? index == 0 ? true : false : true,
              child: TextButton(
                child: Text( city == "Adana" ? adana[index] : city == "Burdur" ? burdur[index]
                    : "Demo sürümde sadece Adana ve Burdur illerinin ilçeleri mevcuttur. Lütfen güncellemeyi bekleyiniz.",
                    style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
                    color: Colors.indigo, decorationThickness: 3, fontSize: 15,), textAlign: TextAlign.center,),
                onPressed: (){
                  isStateChosen = true;
                  city == "Adana" ? register(city, adana[index])
                      : city == "Burdur" ? register(city, burdur[index])
                      : null;
                },
              ),
            );
          },
        ),
      ),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void register(String city, String town) {

    AlertDialog alertDialog = AlertDialog(
      title: Center(child: Text(
        isStateChosen == true
            ? MyInheritor.of(context)?.isMunicipality != true ?
        "*!!Bağlı bulunduğunuz kurum ${city.toUpperCase()} ili ${town.toUpperCase()} ilçe bel. olacaktır."
            : MyInheritor.of(context)?.isCity == true ? "Bölgeniz ${city.toUpperCase()} ili olacaktır."
            : "Bölgeniz ${city.toUpperCase()} ili ${town.toUpperCase()} ilçesi olacaktır."
            : "Bölge seçmediniz. Bağlı bulunduğunuz kurum bilgisi olmadan kayıt işleminiz tamamlanacaktır. "
            "Dilediğiniz zaman profil sayfanızdan bu bilgiyi güncelleyebilirsiniz.",
        style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15),)),
      actions: [
        ElevatedButton(
          style: const ButtonStyle(
            elevation: WidgetStatePropertyAll<double>(20),
            backgroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: const Text("Kayıt İşlemini Tamamla", style: TextStyle(fontSize: 20, color: Colors.blue), ),
          onPressed: () async {
            String municipality;
            city == null && town == null ? municipality = "tanımlanmadı"
                : city == "Adana" ? municipality = "$city $town Bel."
                : city == "Burdur" ? town == "Burdur (İl merkezi)" ? municipality = "Burdur Bel."
                : municipality = "Burdur $town Bel."
                : municipality = "tanımlanmadı";

            try {
              final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: MyInheritor.of(context)?.userMail, password: MyInheritor.of(context)?.userPass
              );
              final User? user = userCredential.user;
              if(user != null){
                String userAuthid = user.uid;

                if(MyInheritor.of(context)?.isMunicipality == true){
                  DocumentReference ref_user = await FirebaseFirestore.instance.collection("municipality")
                      .add({"userName": MyInheritor.of(context)?.userName, "userMail": MyInheritor.of(context)?.userMail,
                    "userAuthid": userAuthid, "registerDate": DateTime.now().toString().substring(0, 10),
                    "city": city, "town": town, "municipality": municipality,
                    "avatar": "", "decorationPic": "", "about": "", "phoneNumber": "", "adress": "",
                    "averageUse": 0, "illegalUseApply": 0, "leakageApply": 0, "solvedApply": 0, "totalApply": 0,
                    "usageCount": 0, "totalNotifications": 0, "unseenNotifications": 0,
                  });
                } else {
                  DocumentReference ref_user = await FirebaseFirestore.instance.collection("citizen")
                      .add({"userName": MyInheritor.of(context)?.userName, "userMail": MyInheritor.of(context)?.userMail,
                    "userAuthid": userAuthid, "registerDate": DateTime.now().toString().substring(0, 10),
                    "city": city, "town": town, "municipality": municipality,
                    "avatar": "", "decorationPic": "", "about": "", "usageCount": 0, "score": 0,
                    "phoneNumber": "", "adress": "", "lastMonth": "", "lastUsage": 0, "averageUse": 0,
                    "totalApply": 0, "solvedApply": 0, "leakageApply": 0, "illegalUseApply": 0,
                  });
                }


                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green, elevation: 50,
                  content: const Text( "KAYDINIZ BAŞARIYLA GERÇEKLEŞTİRİLDİ. ŞİMDİ UYGULAMAYA TEKRAR GİRİŞ "
                      "YAPARAK KULLANMAYA BAŞLAYABİLRİSNİZ.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  duration: const Duration(seconds: 15),
                  action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
                ));

                _logOut();
              }
            } catch(e) {
              AlertDialog alertDialog = AlertDialog(
                title: const Text("Hata"),
                content: Text(e.toString().contains("invalid-email") ? "Mail adresiniz uygun formatta yazılmamıştır!"
                    : e.toString().contains("weak-password") ? "şifreniz en az 6 haneden oluşmalıdır!"
                    : e.toString().contains("email-already-in-use") ? "Bu email adresi bir başka hesap tarafından kullanılmaktadır."
                    : "Bilinmeyen bir hata oluştu. İnternet bağlantınız ile ilgili yada sistemsel bir hata olabilir. "
                    "Lütfen daha sonra tekrar deneyiniz.",
                  style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
                ),
              ); showDialog(context: context, builder: (_) => alertDialog);

            }

          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  _logOut() async{
    await FirebaseAuth.instance.signOut();
    MyInheritor.of(context)?.userName = null;
    MyInheritor.of(context)?.userPass = null;
    MyInheritor.of(context)?.userMail = null;
    MyInheritor.of(context)?.isMunicipality = null;
    MyInheritor.of(context)?.isCity = null;
    MyInheritor.of(context)?.isMetropolitan = null;
    MyInheritor.of(context)?.isTown = null;
    MyInheritor.of(context)?.uid = null;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

}

