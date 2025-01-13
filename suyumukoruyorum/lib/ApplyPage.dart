import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/Helpers/SelectedImages.dart';
import 'package:suyumukoruyorum/MuniHomePage.dart';

class ApplyPage extends StatefulWidget{
  final user_map; final user_id;
  const ApplyPage({super.key, this.user_map, this.user_id});

  @override
  State<StatefulWidget> createState() {
    return ApplyPageState(user_map, user_id);
  }

}

class ApplyPageState extends State<ApplyPage>{
  final user_map; final user_id;
  ApplyPageState(this.user_map, this.user_id);

  int _selectedIndex = 0;

  SelectedImages selectedImages = SelectedImages();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Başvurular"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10, right: 20, bottom: 10),
            child: Text("* Başvurular sondan başa doğru listelenmektedir. Çözülmemiş başvurular "
                "Turuncu renklidir. İlgili başvuru detayını görmek ve işlem yapmak için başvuruya tıklayınız..",
              style: TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
            ),
          ),
          Center(
            child: StreamBuilder(
              stream: _selectedIndex == 0 ? FirebaseFirestore.instance.collection("municipality")
                  .doc(MyInheritor.of(context)?.uid).collection("leakageApplies").orderBy("applyDate", descending: true).snapshots()
                  : FirebaseFirestore.instance.collection("municipality").doc(MyInheritor.of(context)?.uid)
                  .collection("illegalUseApplies").orderBy("applyDate", descending: true).snapshots(),
              builder: (context, snapshot){

                if(snapshot.data?.size == 0){return const Center( child: Text("Veri Bulunamadı",
                  style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.bold),
                ));}
                if(snapshot.hasError){return const Center( child: Icon(Icons.warning_amber, size: 50,));}
                else if(snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                  return const Center(child: CircularProgressIndicator(),);}

                else {
                  QuerySnapshot querySnapshot = snapshot.data!;

                  return SizedBox( height: 600,
                    child: ListView.builder(
                      itemCount: querySnapshot.size,
                      itemBuilder: (context, index){

                        dynamic apply_map = querySnapshot.docs[index].data()!;
                        dynamic apply_id = querySnapshot.docs[index].id;
                        dynamic isSolved = querySnapshot.docs.elementAt(index).get("isSolved");
                        dynamic isSeen = querySnapshot.docs.elementAt(index).get("isSeen");

                        DocumentReference applyRef = querySnapshot.docs[index].reference;

                        return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),

                          child: ListTile(
                            leading: Text("${index +1}.", style: const TextStyle(color: Colors.indigo,
                                fontWeight: FontWeight.bold, fontSize: 30),),
                            tileColor: isSolved == false ? Colors.orangeAccent : Colors.blue[100],
                            title: Text(_selectedIndex == 0 ? "Su Kaçak İhbarı"
                                : apply_map["isForbiddenUse"] == true ? "Yasaklanmış Kullanım"
                                : apply_map["isIllegalDrilling"] == true ? "Kaçak Sondaj"
                                : apply_map["isIllegalMeter"] == true ? "Sayaç Bozuk/Yok"
                                : "Diğer-",
                              style: const TextStyle(fontWeight: FontWeight.w700,
                                fontSize: 18, fontStyle: FontStyle.italic),),
                            subtitle: Wrap( direction: Axis.vertical,
                              children: [
                                Visibility( visible: _selectedIndex ==1
                                    ? apply_map["isOtherIllegal"] == true ? true : false : false,
                                  child: Text(apply_map["otherIllegalText"] == null ? ""
                                      : apply_map["otherIllegalText"].toString().length > 20
                                      ? "${apply_map["otherIllegalText"].toString().substring(0, 19)}..."
                                      : apply_map["otherIllegalText"],
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),),
                                ),
                                const SizedBox(height: 10,),
                                Wrap( direction: Axis.horizontal, spacing: 4,
                                    children: [
                                      Text("Tarih: "),
                                      Text(apply_map["applyDate"].toString().substring(0, 16), style: const TextStyle(color: Colors.black,
                                          fontWeight: FontWeight.bold, fontSize: 15,
                                          decoration: TextDecoration.underline, decorationThickness: 3),),
                                    ]),
                              ],
                            ),
                            trailing: SizedBox( width: 60, height: 30,
                              child: Text( apply_map["isSolved"] == true ? "ÇÖZÜLDÜ" : "ÇÖZÜLMEDİ",
                                style: TextStyle(color: apply_map["isSolved"] == true ? Colors.indigo : Colors.red[800],
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

                              seeApply(apply_map, apply_id, applyRef);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Su Kaçakları"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Kaçak Kullanımlar"
          )
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 15, selectedItemColor: Colors.indigo,
        selectedLabelStyle: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),

    );
  }

  void seeApply(dynamic apply_map, dynamic apply_id, DocumentReference<Object?> applyRef){
    AlertDialog alertDialog = AlertDialog(
      title: Text(_selectedIndex == 0 ? "Su Kaçak İhbarı"
          : "Kaçak Kullanım İhbarı",),
      content: SizedBox( height: 400, width: 500,
        child: ListView(
          children: [
            Visibility( visible: apply_map["applyType"] == "Su Kaçağı İhbarı" ? false : true,
              child: ListTile(
                title: const Text("Kaçak Kullanım Türü: ", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Wrap( direction: Axis.vertical, spacing: 5,
                  children: [
                    Text(
                        apply_map["isIllegalDrilling"] == true ? "Kaçak Sondaj"
                            : apply_map["isIllegalMeter"] == true ? "Sayaç Bozuk Yok"
                            : apply_map["isForbiddenUse"] == true ? "Yasaklanmış KUllanım"
                            : "Diğer"),
                    Visibility( visible: apply_map["isOtherIllegal"] == true ? true : false,
                      child: Text(apply_map["otherIllegalText"] ?? ""),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text("Gönderen: ", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Wrap( direction: Axis.vertical, spacing: 5,
                children: [
                  Text(apply_map["isNameless"] == true ? "AdSoyad: Gizlenmiş" : "AdSoyad: "+ apply_map["senderName"]),
                  Text(apply_map["isNameless"] == true ? "Adsoyad: Gizlenmiş" : "Email: "+ apply_map["senderMail"]),
                ],
              ),
            ),
            ListTile(
              title: const Text("Mahalle/ Sokak:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(apply_map["street"], ),
            ),
            ListTile(
              title: const Text("Detaylar", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(apply_map["details"], ),
            ),
            ListTile(
              title: const Text("Görseller:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: apply_map["imageUrl"] != "no pic"
                  ? const Text("1 adet görsel eklenmiştir. Görmek için tıklayınız.",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),)
                  : const Text("Başvuruya görsel eklenmemiştir."),
              onTap: () => apply_map["imageUrl"] != "no pic" ? seeImage(apply_map, apply_id) : SizedBox.shrink,
            ),
          ],
        ),
      ),
      actions: [
        Visibility( visible: apply_map["isSolved"] == true ? false : true,
          child: MaterialButton(
            color: Colors.teal, elevation: 10,
            onPressed: () async {
              try{
                await applyRef.update({
                  "isSolved" : true,
                });

                DocumentReference docRef= FirebaseFirestore.instance.collection("municipality").doc(user_id);
                await docRef.update({
                  "solvedApply": user_map["solvedApply"] +1,
                });
                await docRef.collection("notifications").where("applyDate", isEqualTo: apply_map["applyDate"]).get()
                    .then((nots) => nots.docs.forEach((not){
                      not.reference.update({"isSolved": true});
                }));

                Navigator.of(context, rootNavigator: true).pop("dialog");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green, elevation: 50,
                  content: const Text( "İşlem Başarılı",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  duration: const Duration(seconds: 15),
                  action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
                ));

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MuniHomePage()));
              } catch(e) {
                AlertDialog alertDialog = AlertDialog(
                  title: const Text("Hata", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                  content: Text(e.toString(),
                    style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
                  ),
                ); showDialog(context: context, builder: (_) => alertDialog);
              }

            },
            child: const Text("Çözüldü Olarak İşaretle",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
          ),
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void seeImage(dynamic apply_map, dynamic apply_id) {
    showDialog(context: context, builder: (_){
      return Container( height: 400, width: 400,
        child: Image.network(apply_map["imageUrl"], fit: BoxFit.contain,),
      );
    });
  }

}