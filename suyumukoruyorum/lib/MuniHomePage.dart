import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suyumukoruyorum/ApplyPage.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/LandingPage.dart';
import 'package:suyumukoruyorum/NotificationsPage.dart';
import 'package:suyumukoruyorum/ProfilePage.dart';
import 'package:suyumukoruyorum/RankingPage.dart';

class MuniHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MuniHomePageState();
  }

}

class MuniHomePageState extends State<MuniHomePage>{

  @override
  Widget build(BuildContext context) {

    String name = MyInheritor.of(context)?.userName;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        title: GestureDetector(
          child: Wrap( spacing: 4, direction: Axis.horizontal,
            children: [
              const Icon(Icons.account_balance_sharp, size: 25,),
              Column(
                children: [
                  Text(name.length>20 ? "${name.substring(0, 19)}..." : name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  const Text("Profilinize gitmek için adınıza tıklayınız.",
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12))
                ],
              ),
            ],
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logOut(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("municipality")
            .where("userAuthid", isEqualTo: "FYmKPsTRcQbA08LPVG4uRZ0tFBZ2").snapshots(),
        builder: (context, snapshot){

          if(snapshot.hasError){return const Center( child: Icon(Icons.warning_amber, size: 50,));}
          else if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
            return const Center(child: CircularProgressIndicator(),);}
          else {
            QuerySnapshot querySnapshot = snapshot.data!;
            print(MyInheritor.of(context)?.uid);

            return SizedBox(height: 600,
              child: ListView.builder(
                itemCount: querySnapshot.size,
                itemBuilder: (context, index){

                  dynamic user_map = querySnapshot.docs[index].data()!;
                  dynamic user_id = querySnapshot.docs[index].id;

                  return SizedBox(height: 600,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                          child: Container( color: Colors.blue[100],
                            child: ListTile(
                              leading: const Icon(Icons.book, size: 30, color: Colors.indigo,),
                              title: const Center(child: Text("Bilgilendime", style: TextStyle(fontWeight: FontWeight.w700),)),
                              subtitle: const Text("Suyumu Koruyorum Mobil Uygulaması genel bilgilendirme için tıklayınız."),
                              onTap: (){

                              },
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only( top: 20.0, bottom: 20),
                          child: Column(
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.notification_important,
                                    size: user_map["unseenNotifications"] != 0 ? 30 : 20,
                                    color: user_map["unseenNotifications"] != 0 ? Colors.red : Colors.blueGrey[600],
                                ),
                                label: Text("Bildirimler",
                                    style: TextStyle( fontWeight: FontWeight.bold,
                                        color: user_map["unseenNotifications"] != 0 ? Colors.red : Colors.blueGrey[600],
                                        fontSize: user_map["unseenNotifications"] != 0 ? 20 : 15,
                                        decoration: user_map["unseenNotifications"] != 0 ? TextDecoration.underline
                                            : TextDecoration.none)),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(
                                    user_map: user_map, user_id: user_id,
                                  )));
                                },
                              ),
                              Text(user_map["unseenNotifications"] != 0 ? "* ${user_map["unseenNotifications"]} adet "
                                  "Okunmamış bildirimleriniz bulunmaktadır!" : "Tüm bildirimilerinizi okudunuz.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: user_map["unseenNotifications"] != 0 ? Colors.red : Colors.blueGrey[600],
                                    fontSize: 15, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                        Card( elevation: 10,
                          child: ListTile(
                            title: const Center(child: Text("Sıralamayı Gör",
                              style: TextStyle(fontWeight: FontWeight.w700),)),
                            subtitle: const Text("Buraya tıklayarak bölgenizdeki tüm kullanıcıların "
                                "aylık girdikleri su kullanımlarını, su tasarruf sıralamasını, bölgenizin aylık "
                                "ortalama su kullanım ortalamasını görebilirsiniz."),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RankingPage()));
                            },
                            tileColor: Colors.blue.shade100,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Card( elevation: 10,
                          child: ListTile(
                            title: const Text("Çözümlenmemiş Başvuru/ Toplam Başvuru",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                            subtitle: const Text("Detayları görmek için tıklayınız.",),
                            tileColor: Colors.blue.shade100,
                            trailing: Text("${(user_map["totalApply"] - user_map["solvedApply"])}/${user_map["totalApply"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.underline,
                                color: Colors.indigo),),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyPage(
                                user_map: user_map, user_id: user_id,
                              )));
                            },
                          ),
                        ),

/*
                        SizedBox(height: 10,),
                        Card( elevation: 10,
                          child: ListTile(
                            title: const Text("Çözümlenmemiş Kaçak Kullanım Sayısı",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                            subtitle: const Wrap( direction: Axis.vertical, spacing: 5,
                              children: [
                                Text("Görmek için tıklayınız.",),
                                Text("KAÇAK SONDAJ: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                Text("SAYAÇ BOZUK/YOK: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                Text("YASAKLANMIŞ KULLANIM: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                                Text("DİĞER: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                              ],
                            ),
                            tileColor: Colors.blue.shade100,
                            trailing: Text("1200",  style: const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.underline,
                                color: Colors.indigo),),
                            onTap: (){},
                          ),
                        ),
*/
                      ],
                    ),
                  );
                },

              ),
            );
          }


        },
      )
    );
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

