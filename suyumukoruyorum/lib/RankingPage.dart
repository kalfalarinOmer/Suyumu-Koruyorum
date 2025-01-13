// * kişi kendi girişine tıkladığında düzenleme yapabilecek.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';

class RankingPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return RankingPageState();
  }

}

class RankingPageState extends State<RankingPage>{

  final List<String> _months= ["OCAK", "ŞUBAT", "MART", "NİSAN", "MAYIS", "HAZİRAN", "TEMMUZ",
    "AĞUSTOS", "EYLÜL", "EKİM", "KASIM", "ARALIK", ];

  int _selectedIndex = 0;
  String usageName = "${DateTime.now().year}-${DateTime.now().month}";

  @override
  Widget build(BuildContext context) {

    String currentMonth = _months[DateTime.now().month -1];


    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "Su Tasarruf Sıralaması -$currentMonth"
            : _selectedIndex == 1 ? "Su Tasarruf Sıralaması -${DateTime.now().year}"
            : "Su Tasarruf Sıralaması -PUAN"
        ),
      ),
      body: ListView(
        children:[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 20),
            child: Text( _selectedIndex == 0 ? "* Kullanıcılar aylık bazda en az su kullanandan "
                "en çok kullanana doğru sıralanmaktadır. Sıralamanın kullanıcıların beyanlarına göre yapıldığını unutmayınız."
                : _selectedIndex == 1 ? "* Kullanıcılar tüm yaptıkları tüm girişlere göre en az su kullanandan "
                "en çok kullanana doğru sıralanmaktadır. Sıralamanın kullanıcıların beyanlarına göre yapıldığını unutmayınız."
                : "* Kullanıcılar uygulama üzerinden kazandıkları Su Tasarruf Puanlarına göre sıralanmıştır. "
                "Nasıl Puan kazanacağınızı bilmiyorsanız Anasayfada yer alan BİLGİLER butonuna tıklayınız. ",
              style: TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.w700),
              textAlign: TextAlign.justify,
            ),
          ),
          Visibility( visible: _selectedIndex == 0 ? true : false,
            child: const Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10, right: 20, bottom: 10),
              child: Text("** Doğrulama gerektiren girişler belirtilmiştir. Kullanım Doğrulama işlemi diğer"
                  " kullanıcılar tarafından eklenen kullanım görsellerine göre yapılır ve doğrulama yapan kişi "
                  "doğrulama başına 2 Su Tasarruf Puanı kazanır. Doğrulama yapmak için Doğrulama Gerekli yazan "
                  "girişin üzerine tıklamanız yeterlidir.",
                style: TextStyle(color: Colors.indigo, fontSize: 13, fontWeight: FontWeight.w700),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Center(
            child: StreamBuilder(
              stream: _selectedIndex == 0 ? FirebaseFirestore.instance.collection("citizen")
                    .where("lastMonth", isEqualTo: currentMonth).orderBy("lastUsage", descending: false).snapshots()
                  : _selectedIndex == 1 ? FirebaseFirestore.instance.collection("citizen")
                    .orderBy("averageUse", descending: false).snapshots()
                  : FirebaseFirestore.instance.collection("citizen").orderBy("score", descending: true).snapshots(),
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

                        dynamic user_map = querySnapshot.docs[index].data()!;
                        dynamic user_id = querySnapshot.docs[index].id;

                        List <dynamic> usagesConfirmed = [];
                        user_map["usagesConfirmed"] != null
                            ? usagesConfirmed = user_map["usagesConfirmed"] : [];

                        return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Card( elevation: 10,
                            child: ListTile(
                              leading: Text("${index +1}.", style: const TextStyle(color: Colors.indigo,
                                  fontWeight: FontWeight.bold, fontSize: 30),),
                              tileColor: usagesConfirmed.contains(usageName) ? Colors.blue[100] : Colors.orangeAccent,
                              title: Text(user_map["userName"], style: const TextStyle(fontWeight: FontWeight.w700,
                                  fontSize: 18, fontStyle: FontStyle.italic),),
                              subtitle: Wrap( direction: Axis.horizontal, spacing: 4,
                                  children: [
                                    Text(_selectedIndex == 2 ? "Puan: " : "Kullanım"),
                                    Text( style: const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold, fontSize: 20,
                                        decoration: TextDecoration.underline, decorationThickness: 3),
                                      _selectedIndex == 0 ? "${user_map["lastUsage"]} m3"
                                        : _selectedIndex == 1 ? "${user_map["averageUse"]} m3"
                                        : "${user_map["score"]}"),
                                  ]),
                              trailing: SizedBox( width: 60, height: 30,
                                child: Text(_selectedIndex == 0
                                    ? usagesConfirmed.contains(usageName) ? "Doğrulandı" : "Doğrulama Gerekli" : "",
                                  style: const TextStyle(color: Colors.indigo,
                                      fontWeight: FontWeight.bold, fontSize: 10),),
                              ),
                              onTap: () async {
                                _selectedIndex == 0 ?
                                await querySnapshot.docs[index].reference.collection("usages")
                                   .where("name", isEqualTo: usageName).get().then((_usages) {
                                     _usages.docs.forEach((_usage){
                                       dynamic usage_map = _usage.data();
                                       dynamic usage_id = _usage.id;
                                        seeUsageDialog(user_map, user_id, usage_map, usage_id, usagesConfirmed);

                                     });
                                   }) : const SizedBox.shrink();

                              },
                            ),
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
            label: "Aylık Kullanım"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Ortalama Kulanım"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.scoreboard_outlined),
              label: "Puan Sıralaması"
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 15, selectedItemColor: Colors.indigo,
        selectedLabelStyle: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }

  void seeUsageDialog( dynamic user_map, dynamic user_id, dynamic usage_map, dynamic usage_id, List<dynamic> usagesConfirmed ) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.blue[100],
      title: Text("${user_map["userName"]}"),
      content: SizedBox(
        height: usage_map["usePic"] == "no pic" ? 200 : 350,
        width: 350,
        child: ListView(
          children: [
            Wrap( direction: Axis.horizontal, spacing: 4,
                children: [
                  const Text("Kullanım: "),
                  Text("${user_map["lastUsage"]} m3", style: const TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold, fontSize: 20,
                      decoration: TextDecoration.underline, decorationThickness: 3),),
                ]),
            const SizedBox(height: 20,),
            Card( elevation: 10,
              child: usage_map["usePic"] == "no pic" ? const Center( child: Text("Bu giriş için görsel eklenmemiştir. "
                  "Lütfen sadece kanıtlanabilir girişler için doğrulama yapınız.", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),))
                  : Image.network(usage_map["usePic"].toString(),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Visibility( visible: usage_map["isConfirmed"] == true
            || user_map["userMail"] == MyInheritor.of(context)?.userMail ? false : true,
          child: TextButton(
            child: const Text("DOĞRULA",
                style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline, decorationThickness: 3)),
            onPressed: () => _confirmUsage(user_map, user_id, usage_map, usage_id, usagesConfirmed),
          ),
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void _confirmUsage( dynamic user_map, dynamic user_id, dynamic usage_map, dynamic usage_id, List<dynamic> usagesConfirmed ) async {

    try{
      usagesConfirmed.add(usageName);
      DocumentReference docRef = FirebaseFirestore.instance.collection("citizen").doc(user_id);
      await docRef.update({
        "score": user_map["score"] +2,
        "usagesConfirmed": usagesConfirmed,
      });
      await docRef.collection("usages").get().then((_usages) => _usages.docs.forEach((_usage){
        _usage.reference.update({ "isConfirmed": true });
      }));

      Navigator.of(context, rootNavigator: true).pop("dialog");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, elevation: 50,
        content: const Text( "Doğrulama için teşekkür ederiz. Doğrulama sonucu 2 Su Tasarruf Puanı kazandınız.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        duration: const Duration(seconds: 15),
        action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
      ));

    } catch(e){
      AlertDialog alertDialog = AlertDialog(
        title: const Text("Hata", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        content: Text(e.toString(),
          style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
        ),
      ); showDialog(context: context, builder: (_) => alertDialog);
    }

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}