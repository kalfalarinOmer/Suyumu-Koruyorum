

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';

class NotificationsPage extends StatefulWidget {
  final user_map; final user_id;
  const NotificationsPage({super.key, this.user_map, this.user_id});

  @override
  State<StatefulWidget> createState() {

    return NotificationsPageState (this.user_map, this.user_id);
  }

}

class NotificationsPageState extends State<NotificationsPage>{
  final user_map; final user_id;
  NotificationsPageState(this.user_map, this.user_id);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Bildirimler"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10, right: 20, bottom: 10),
            child: Text("* Bildirimleriniz sondan başa doğru listelenmektedir. Okunmamış bildirimleriniz "
                "Turuncu renklidir. İlgili başvuruda işlem yapmak için başvurular ekranına gidiniz.",
              style: TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("municipality").doc(MyInheritor.of(context)?.uid)
                .collection("notifications").orderBy("applyDate", descending: true).snapshots(),
            builder: (context, snapshot){
              if(snapshot.data?.size == 0){return const Center( child: Text("Veri Bulunamadı",
                style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),
              ));}
              if(snapshot.hasError){return const Center( child: Icon(Icons.warning_amber, size: 50,));}
              else if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                return const Center(child: CircularProgressIndicator(),);}

              else {
                QuerySnapshot querySnapshot = snapshot.data!;

                return SizedBox( height: 700,
                  child: ListView.builder(
                    itemCount: querySnapshot.size,
                    itemBuilder: (context, index){

                      dynamic not_map = querySnapshot.docs[index].data()!;
                      dynamic not_id = querySnapshot.docs[index].id;

                      dynamic isSeen = querySnapshot.docs.elementAt(index).get("isSeen");

                      return Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: ListTile(
                          leading: Text("${index +1}.", style: const TextStyle(color: Colors.indigo,
                              fontWeight: FontWeight.bold, fontSize: 30),),
                          tileColor: isSeen == false ? Colors.orangeAccent : Colors.blue[100],
                          title: Text(not_map["applyType"], style: const TextStyle(fontWeight: FontWeight.w700,
                              fontSize: 18, fontStyle: FontStyle.italic),),
                          subtitle: Wrap( direction: Axis.vertical,
                            children: [
                                  Wrap( direction: Axis.horizontal, spacing: 4,
                                  children: [
                                    Text("Tarih: "),
                                    Text(not_map["applyDate"].toString().substring(0, 16), style: const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold, fontSize: 15,
                                        decoration: TextDecoration.underline, decorationThickness: 3),),
                                  ]),
                                ],
                          ),
                          trailing: SizedBox( width: 60, height: 30,
                            child: Text( not_map["isSolved"] == true ? "ÇÖZÜLDÜ" : "ÇÖZÜLMEDİ",
                              style: TextStyle(color: not_map["isSolved"] == true ? Colors.indigo : Colors.red[800],
                                  fontWeight: FontWeight.bold, fontSize: 10),),
                          ),
                          onTap: () async {

                            if (isSeen == false ){
                              await FirebaseFirestore.instance.collection("municipality").doc(user_id).update({
                                "unseenNotifications" : user_map["unseenNotifications"] -1
                              });
                              querySnapshot.docs.elementAt(index).reference.update({
                                "isSeen": true
                              });
                            }

                            seeNotification(not_map, not_id);
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void seeNotification(dynamic not_map, dynamic not_id){
    AlertDialog alertDialog = AlertDialog(
      title: Text( not_map["applyType"] ),
      content: SizedBox( height: 300, width: 500,
        child: ListView(
          children: [
            Visibility( visible: not_map["applyType"] == "Su Kaçağı İhbarı" ? false : true,
              child: ListTile(
                title: const Text("Kaçak Kullanım Türü: ", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Wrap( direction: Axis.vertical, spacing: 5,
                  children: [
                    Text(
                        not_map["isIllegalDrilling"] == true ? "Kaçak Sondaj"
                            : not_map["isIllegalMeter"] == true ? "Sayaç Bozuk Yok"
                            : not_map["isForbiddenUse"] == true ? "Yasaklanmış KUllanım"
                            : "Diğer"),
                    Visibility( visible: not_map["isOtherIllegal"] == true ? true : false,
                      child: Text(not_map["otherIllegalText"] ?? ""),
                    ),
                      ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Gönderen: ", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Wrap( direction: Axis.vertical, spacing: 5,
                children: [
                  Text(not_map["isNameless"] == true ? "AdSoyad: Gizlenmiş" : "AdSoyad: "+ not_map["senderName"]),
                  Text(not_map["isNameless"] == true ? "Adsoyad: Gizlenmiş" : "Email: "+ not_map["senderMail"]),
                ],
              ),
            ),

            ListTile(
              title: const Text("Mahalle/ Sokak:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(not_map["street"], ),
            ),
            ListTile(
              title: const Text("Detaylar", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(not_map["details"], ),
            ),
/*
            ListTile(
              title: const Text("Görseller:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: selectedImages.pickedImages.isNotEmpty
                  ? Text("${selectedImages.pickedImages.length} adet görsel eklediniz. Görmek için tıklayınız.")
                  : const Text("Görsel Eklemediniz."),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage())),
            ),
*/
          ],
        ),
      ),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

}