import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }

}

class ProfilePageState extends State<ProfilePage>{
  XFile? _imageSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyInheritor.of(context)?.userName),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0, right: 40, top: 10),
            child: Card(
              elevation: 50,
              child: GestureDetector(
                onLongPress: (){
                  imageFromGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                //Codes of the big picture
                    image: DecorationImage(
                        image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/"
                            "suyumukoruyorum.firebasestorage.app/o/suyumuKoruyorumLogo.jpg?alt="
                            "media&token=ac2794ae-3b81-4d8d-bb72-820420e1c4f9"),
                        fit: BoxFit.cover),
                  ),
                //Codes of avatar pic
                  child: GestureDetector(
                    onLongPress: (){
                      imageFromGallery();
                    },
                    child: Card( elevation: 10, color: Colors.transparent,
                      child: Container( alignment: Alignment.bottomLeft,
                        child: CircleAvatar( radius: 75,
                          child: ClipOval(
                              child: Image.network("https://firebasestorage.googleapis.com/v0/b/"
                                  "suyumukoruyorum.firebasestorage.app/o/suyumuKoruyorumLogo.jpg?alt="
                                  "media&token=ac2794ae-3b81-4d8d-bb72-820420e1c4f9",
                                fit: BoxFit.cover, width: 200, height: 200,)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            child: Divider(height: 2, color: Colors.blueGrey, thickness: 2,),),
          ListTile(
            title: const Center(
              child: Column(
                children: [
                  Text("Hakkında:", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,
                      fontSize: 18, decoration: TextDecoration.underline),
                  ),
                  Text("Güncellemek için tıklayınız.",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),),
                ],
              ),
            ),
            subtitle: const Text("Veritabanından getirilecek.", style: TextStyle(fontSize: 15, color: Colors.blue,
                fontWeight: FontWeight.bold),
            ),
            onTap: (){
              updateInfos();
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 8),
            child: Divider(height: 2, color: Colors.blueGrey, thickness: 2,),),
          ListTile(
            title: const Center(
              child: Column(
                children: [
                  Text("İletişim:", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,
                      fontSize: 18, decoration: TextDecoration.underline),
                  ),
                  Text("Güncellemek için tıklayınız.",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12),),
                ],
              ),
            ),
            subtitle: Wrap( direction: Axis.vertical, spacing: 5,
              children: [
                const Wrap(children: [
                  Text("Telefon: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? true: false,
                    child: const Wrap(children: [
                      Text("Web Adresi: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                      Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                    ]),
                ),
                const Wrap(children: [
                  Text("E-mail: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                const Wrap(children: [
                  Text("Adres: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                const Wrap(children: [
                  Text("İl/ilçe: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
              ],
            ),
            onTap: (){
              updateInfos();
            },
          ),
          const Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 8),
            child: Divider(height: 2, color: Colors.blueGrey, thickness: 2,),),

          Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? true : false,
            child: const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 15),
              child: Center(
                child: Text("Bölgenize kayıtlı toplam *1000* kullanıcı vardır.",
                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 20, ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? false : true,
            child: ListTile(
              title: const Center(
                child: Text("Su Kullanım Biligileriniz:", style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,
                    fontSize: 15, decoration: TextDecoration.underline),
                ),
              ),
              subtitle: Wrap( direction: Axis.vertical, spacing: 5,
                children: [
//                  const Text("Bilgilerinizin detaylarını görmek için ilgili alana tıklayınız.", style: TextStyle(color: Colors.blueGrey),),
                  const Wrap(children: [
                    Text("Son girdiğiniz ay: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15,
                        color: Colors.blue, fontWeight: FontWeight.bold),),
                  ]),
                  const Wrap(children: [
                    Text("Son Kullanım Miktarı: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15,
                        color: Colors.blue, fontWeight: FontWeight.bold),),
                  ]),
                  Wrap(children: [
                    const Text("Son Ay Sıralamanız: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    GestureDetector(
                      child: const Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15,
                          color: Colors.blue, fontWeight: FontWeight.bold),),
                      onTap: (){},
                    ),
                  ]),
                  Wrap(children: [
                    const Text("Ortalama Kullanım: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    GestureDetector(
                      child: const Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15,
                          color: Colors.blue, fontWeight: FontWeight.bold),),
//                      onTap: (){},
                    ),
                  ]),
                  Wrap(children: [
                    const Text("Güncel Genel Sıralamanız: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                    GestureDetector(
                      child: const Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15,
                          color: Colors.blue, fontWeight: FontWeight.bold),),
                      onTap: (){},
                    ),
                  ]),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 8),
            child: Divider(height: 2, color: Colors.blueGrey, thickness: 2,),),

          ListTile(
            title: Center(
              child: Text(MyInheritor.of(context)?.isMunicipality == true ? "Su İsrafına Karşı Müdahaleleriniz:"
                  : "Su İsrafına Karşı Başvurularınız:",
                style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,
                  fontSize: 15, decoration: TextDecoration.underline),
              ),
            ),
            subtitle: const Wrap( direction: Axis.vertical, spacing: 5,
              children: [
//                Text("Bilgilerinizin detaylarını görmek için ilgili alana tıklayınız.",
//                  style: TextStyle(color: Colors.blueGrey, fontSize: 12),),
                Wrap(children: [
                  Text("TOPLAM BAŞVURU SAYISI: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                Wrap(children: [
                  Text("ÇÖZÜMLENMİŞ BAŞVURULAR: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                Wrap(children: [
                  Text("SU KAÇAĞI İHBAR: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
                Wrap(children: [
                  Text("KAÇAK KULLANIM İHBAR: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),),
                  Text("Veritabanında getirilecek: ", style: TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),)
                ]),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 8),
            child: Divider(height: 2, color: Colors.blueGrey, thickness: 2,),),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }

  Future updateInfos() async {
    GlobalKey formkey = GlobalKey();
    TextEditingController telefonController = TextEditingController();
    TextEditingController mailController = TextEditingController();
    TextEditingController webController = TextEditingController();
    TextEditingController adresController = TextEditingController();
    TextEditingController ilceController = TextEditingController();
    TextEditingController ilController = TextEditingController();
    TextEditingController hakkindaController = TextEditingController();

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Bilgileri Güncelle"),
      content: Form(
        key: formkey,
        child: SizedBox(height: 300, width: 500,
          child: ListView(
            children: [
              TextFormField(
                controller: hakkindaController,
                maxLines: null,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Hakkında",
                ),
                validator: (value){},
              ),
              TextFormField(
                controller: telefonController,
                maxLines: null,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Telefon",
                ),
                validator: (value){},
              ),
              Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? true : false,
                child: TextFormField(
                  controller: webController,
                  maxLines: null,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: "web",
                  ),
                  validator: (value){},
                ),
              ),
              TextFormField(
                controller: mailController,
                maxLines: null,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (value){},
              ),
              TextFormField(
                controller: adresController,
                maxLines: null,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  labelText: "Adres",
                ),
                validator: (value){},
              ),
              TextFormField(
                controller: ilController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "İl",
                ),
                validator: (value){},
              ),
              TextFormField(
                controller: ilceController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "İlçe",
                ),
                validator: (value){},
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Güncelle", style: TextStyle(fontSize: 18, color: Colors.blue,
              fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
          onPressed: () async {
            String about = hakkindaController.text.trim();
            String phoneNumber = telefonController.text.trim();
            String web = webController.text.trim();
            String adress = adresController.text.trim();
            String city = ilController.text.trim();
            String town = ilceController.text.trim();

            try{
              await FirebaseFirestore.instance.collection("citizen")
                  .where("userMail", isEqualTo: MyInheritor.of(context)?.userMail).get().then((users) => users.docs.forEach((user){
                user.reference.update({
                  "about": hakkindaController.value == null ? user.data()["about"] : about,
                  "phoneNumber": telefonController.value == null ? user.data()["phoneNumber"] : phoneNumber,
                  "web": webController.value == null ? user.data()["web"] : web,
                  "adress": adresController.value == null ? user.data()["adress"] : adress,
                  "city": ilController.value == null ? user.data()["city"] : city,
                  "town": ilceController.value == null ? user.data()["town"] : town,
                });
              }));

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green, elevation: 50,
                content: const Text( "İŞLEMİNİZ BAŞARIYLA GERÇEKLEŞTİRİLDİ.",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                duration: const Duration(seconds: 15),
                action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
              ));

              Navigator.of(context, rootNavigator: true).pop("dialog");
            } catch(e) {
              AlertDialog alertDialog = AlertDialog(
                title: const Text("Hata"),
                content: Text(e.toString(),
                  style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
                ),
              ); showDialog(context: context, builder: (_) => alertDialog);
            }

          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  Future imageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    _imageSelected = image;
//    setState(() {});
    uploadImage();
  }

  void uploadImage() async {

    Widget _uploadImageAlertDialog() {
      return Container(height: 300, width: 400,
        child: Column(children: [
          Flexible(
            child: Container(
                child: _imageSelected == null
                    ? const Center(
                    child: Text("Resim seçilmedi. Yükleme yapılması yeniden resim seçimi yapılmalıdır.",
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ))
                    : Image.file(File(_imageSelected!.path), fit: BoxFit.contain,)
            ),
          ),

          const SizedBox(height: 10,),
          const Text("**Resmin yüklenme süresi boyutuna ve internet hızınıza bağlıdır.**",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.orange), textAlign: TextAlign.center,),
        ]),
      );
    }
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        title: const Text("Profil Resimini Güncelle: ", style: TextStyle(color: Colors.indigo),
        ),
        content: _uploadImageAlertDialog(),
        actions: [
          Wrap( direction: Axis.horizontal, spacing: 150,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(onDoubleTap: (){},
                  child: ElevatedButton(
                    child: const Text("Yükle"),
                    onPressed: () async {
/*
                      if (_imageSelected == null) {return null;
                      } else {

                        final Reference ref = await FirebaseStorage.instance.ref().child("users").child(AtaWidget.of(context).kullaniciadi).child("avatar");

                        await ref.putFile(_imageSelected);
                        var downloadUrl = await ref.getDownloadURL();
                        String url = downloadUrl.toString();

                        await FirebaseFirestore.instance.collection("users").doc(doc_id).update({"avatar": url,});

//                  setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Avatarınız başarıyla güncellendi."),
                          action: SnackBarAction(
                            label: 'Gizle',
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ));
                        Navigator.of(context, rootNavigator: true).pop('dialog');

                      }
*/
                    },
                  ),
                ),
              ),
            ],
          ),

        ],
      );
    });
  }


}