import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/RegisterLoginPage.dart';
import 'package:url_launcher/url_launcher.dart';


class LandingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LandingPageState();
  }

}

class LandingPageState extends State<LandingPage>{

  bool isMunicipality = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Suyumu Koruyorum", style: TextStyle(fontSize: 25,
              color: Colors.white, fontWeight: FontWeight.w600),),
        ),
        backgroundColor: Colors.blue[300],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 20,),
              Center(
                child: Card( elevation: 50,
                  child: Container(
                    height: 300, width: 300,
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/"
                        "suyumukoruyorum.firebasestorage.app/o/suyumuKoruyorumLogo.jpg?alt="
                        "media&token=ac2794ae-3b81-4d8d-bb72-820420e1c4f9",
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(width: 100, height: 80,
                    child: FittedBox(
                      child: FloatingActionButton.extended(
                        heroTag: "kurum", elevation: 10,
                        backgroundColor:isMunicipality == true ? Colors.indigo : Colors.blue[300],
                        label: const Text("KURUM", style: TextStyle(color: Colors.white, fontSize: 20),),
                        icon: const Icon(Icons.account_balance_outlined, size: 30, color: Colors.white,),
                        onPressed: () {
                          if(isMunicipality == false){
                            isMunicipality = true;
                          } else if(isMunicipality == true) {
                            isMunicipality = false;
                          }
                          setState(() {});

                        },
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login, color: Colors.white,),
                    style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll<double>(20),
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    label: const Text("KAYIT/GİRİŞ", style: TextStyle(fontSize: 25, color: Colors.white), ),
                    onPressed: () {
                      MyInheritor.of(context)?.isMunicipality = isMunicipality;

                      print(MyInheritor.of(context)?.isMunicipality);

                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterLoginPage()));
                    },
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8),
                child: Text("Su sağlayıcı Kurumlar önce KURUM butonuna tıklamalıdır.",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12,), textAlign: TextAlign.center,),
              ),
            ]
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Wrap(
                direction: Axis.vertical, spacing: 4,
                children: [
                  const Column(
                    children: [
                      Text("'Su İsrafını Önlemede Halk Duyarlılıgını Arttırıcı Unsur,",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,
                            fontSize: 15),),
                  /*
                      Text(,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,
                            fontSize: 15),),
                  */
                      Text("Mobil Uygulama Kullanımı' Projesi - 2025",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,
                            fontSize: 15),),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15),
                    child: Column(
                      children: [
                        Text("Tefenni Anadolu İmam Hatip Lisesi - Tefenni/Burdur",
                          style: TextStyle(color: Colors.blue, fontSize: 13),),
                        Text("iletişim: omerkalfa1@gmail.com",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 12),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text("Bu mobil uygulama, 2024-2025 yılı Lise Öğrencileri Araştırma "
                  "Projeleri Yarışmasına katılan *Su İsrafını Önlemede Halk Duyarlılıgını Arttırıcı Unsur, "
                  "Mobil Uygulama Kullanımı* Projesi kapsamında gelitirilmiştir.",
                style: TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.justify,),),),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Container(
                color: Colors.amber,
                child: Text("* UYGULAMAMIZ RESMİ YADA ÖZEL HERHANGİ BİR KURUMA AİT DEĞİLDİR.",
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.justify,),),
            ),),
          SizedBox(height: 12,),
          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align( alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text("Gizlilik Politikamız",
                      style: TextStyle(fontSize: 15, color: Colors.blue[900],
                          decoration: TextDecoration.underline, decorationThickness: 3),),
                    onPressed: () {_launchUrl();}
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align( alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text("Detaylar",
                      style: TextStyle(fontSize: 20, color: Colors.blue[900],
                          decoration: TextDecoration.underline, decorationThickness: 3),),
                    onPressed: ()=> detaylarDialog(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void detaylarDialog() {
    AlertDialog alertDialog = const AlertDialog(
      title: Center(child: Text("Gelişticilerimiz: "),),
      content: SizedBox(
        height: 150, width: 500,
        child: Column(
          children: [
            Text("İbrahim Ünlü", style: TextStyle(fontFamily: "Play",
                fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 18),),
            Text("Servinaz Ercankaya", style: TextStyle(fontFamily: "Play",
                fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 18),),
            Text("Sultan Kara", style: TextStyle(fontFamily: "Play",
                fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, fontSize: 18),),
            SizedBox( height: 30,),
            Text("Danışman Öğretmen: Ömer Kalfa", style: TextStyle(fontFamily: "Play", fontSize: 15),),
          ],
        ),
      ),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://doc-hosting.flycricket.io/suyumu-koruyorum-mobil-'
        'uygulamasi-gizlilik-politika-beyannamesi/9ee170e9-c53c-4ab2-9346-23c84f3380a8/privacy');

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}