
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/Helpers/SelectedImages.dart';
import 'package:suyumukoruyorum/LandingPage.dart';
import 'package:suyumukoruyorum/ProfilePage.dart';
import 'package:suyumukoruyorum/RankingPage.dart';
import 'package:suyumukoruyorum/RegisterLoginPage.dart';
import 'package:suyumukoruyorum/ShowImagesPage.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage>{

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController useAmountController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController otherIllegalController = TextEditingController();

  bool isLeakage =false;  bool isIllegalUse = false;

  bool isOtherIllegal = false; bool isIllegalDrilling = false;
  bool isIllegalMeter = false; bool isForbiddenUse = false;

  bool isNameless = false;

  SelectedImages selectedImages = SelectedImages();

  bool _saveNewUse = false;

  bool changeImage = false;

  late File _image;
  var downloadUrl = "no pic";

  List months = ['OCAK', 'ŞUBAT', 'MART', 'NİSAN', 'MAYIS','HAZİRAN','TEMMUZ',
    'AĞUSTOS','EYLÜL','EKİM','KASIM','ARALIK'];

  var current_month = DateTime.now().month;
  var current_year = DateTime.now().year;


  @override
  Widget build(BuildContext context) {

    String name = MyInheritor.of(context)?.userName;
    var monthName = months[current_month -1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[300],
        title: GestureDetector(
          child: Wrap( spacing: 4, direction: Axis.horizontal,
            children: [
              const Icon(Icons.account_circle, size: 25,),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const Text(" 'Ülkemiz ve Dünya' nın su varlıkları, Su Tasarrufu...' gibi konularda "
                "bilgilenmek, yapılmış araştırmalar, projeler, haberler ve daha pek çok "
                "kaynağa ulaşmak için aşağıdaki BİLGİLER butonuna tıklayınız." ,
              style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Container(width: 50, height: 50,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    heroTag: "bilgiler", backgroundColor: Colors.indigo, elevation: 10,
                    label: const Text("BİLGİLER", style: TextStyle(color: Colors.white),),
                    icon: const Icon(Icons.book, size: 30, color: Colors.white,),
                    onPressed: () {
                      AlertDialog alertDialog = AlertDialog(
                        title: const Text("Bu özellik demo sürümünün ardından güncelleme ile aktif olacaktır.",
                          style: const TextStyle(color: Colors.indigo), textAlign: TextAlign.center,),
                      ); showDialog(context: context, builder: (_) => alertDialog);
                    },
                  ),
                ),
              ),
            ),
            Container( color: Colors.blue[100],
              child: ListTile(
                title: const Center(child: Text("Aylık Su Kullanımını Gir", style: TextStyle(fontWeight: FontWeight.w700),)),
                subtitle: const Text("Yeni kullanım girmek için *TIKLAYINIZ."),
                onTap: (){
                  if(_saveNewUse == false){
                    selectedImages.pickedImages.clear();
                  }
                  _saveNewUse = true;
                  isLeakage = false;
                  isIllegalUse = false;
                  setState(() {});

                  saveNewUse(current_year.toString(), monthName.toString());
                },
              ),
            ),
            const Divider(height: 8,thickness: 2, color: Colors.black,),
            Container( color: Colors.blue[100],
              child: ListTile(
                title: const Center(child: Text("Sıralamayı Gör", style: TextStyle(fontWeight: FontWeight.w700),)),
                subtitle: const Text("Buraya tıklayarak seninle aynı bölgedeki diğer kullanıcıların aylık girdikleri su "
                    "kullanımlarını, su tasarruf sıralamasını, bölgenizin aylık ortalama su kullanım ortalamasını görebilirsiniz."),
                onTap: () {

                  Navigator.push(context, MaterialPageRoute(builder: (context) => RankingPage()));

                },
              ),),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Container(width: 50, height: 50,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    heroTag: "su kaçağı bildir", backgroundColor: Colors.orange, elevation: 10,
                    label: const Text("Su Kaçağı Bildir", style: TextStyle(color: Colors.white, fontSize: 20),),
                    icon: const Icon(Icons.warning, size: 30, color: Colors.white,),
                    onPressed: () {
                      setState(() {
                        selectedImages.pickedImages.clear();
                        isLeakage = true;
                        isIllegalUse = false;
                        _saveNewUse = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Container(width: 50, height: 50,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    heroTag: "kaçak kullanım ihbar", backgroundColor: Colors.deepOrangeAccent, elevation: 10,
                    label: const Text("Kaçak Kullanım İhbar Et", style: TextStyle(color: Colors.white, fontSize: 20),),
                    icon: const Icon(Icons.local_police_outlined, size: 30, color: Colors.white,),
                    onPressed: () {
                      setState(() {
                        selectedImages.pickedImages.clear();
                        isLeakage = false;
                        isIllegalUse = true;
                        _saveNewUse = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            Visibility( visible: isLeakage == false && isIllegalUse == false ? false : true,
              child: Card(
                elevation: 10,
                color: isLeakage == false && isIllegalUse == true ? Colors.deepOrangeAccent: Colors.orange,
                child: Container( height: 320, width: 300,
                  child: ListView(
                    children: [
                      Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text( isLeakage == true ? "SU KAÇAĞI BİLDİR" : "KAÇAK KULLANIM İHBAR",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                      )),
                      Form( key: _formKey1,
                          child: SizedBox( height: 250,
                            child: ListView(
                              children: <Widget>[
                                Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: TextFormField(
                                    controller: streetController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: "Mahalle ve Sokak"
                                    ),
                                    validator: (value) {
                                      if(value!.isNotEmpty){ "Mahalle ve sokak giriniz";}
                                      else { return null;}
                                    },
                                  ),
                                ),
                                Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: TextFormField(
                                    controller: detailController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: "Biraz Daha Detay(okulun arkası, marketin yanı...)"
                                    ),
                                    validator: (value) {
                                      if(value!.isNotEmpty){ "Detay girebilirsiniz.";}
                                      else { return null;}
                                    },
                                  ),
                                ),
                                Visibility( visible: isIllegalUse == true ? true : false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      tileColor: Colors.deepOrange[300],
                                      title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Wrap( direction: Axis.vertical,
                                            children: [
                                              Text("Kaçak Kullanım Türü", style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text("Aşağıdakilerden yalnızca birini seçiniz.",
                                                style: TextStyle(fontSize: 10),)
                                            ],
                                          ),
                                          SizedBox(width: 80, height: 30,
                                            child: FloatingActionButton(
                                              heroTag: "Detaylar", backgroundColor: Colors.indigo,
                                              onPressed: () {
                                                illegalUseDetails();
                                              },
                                              child: const Text("Detaylar", style: TextStyle(fontSize: 15, color: Colors.white),),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Wrap( spacing: 4, direction: Axis.horizontal,
                                        children: [
                                          TextButton(
                                            child: Text("KAÇAK SONDAJ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                                decoration: TextDecoration.underline, decorationThickness: 3,
                                                backgroundColor: isIllegalDrilling == true ? Colors.green : Colors.transparent),),
                                            onPressed: (){
                                              isOtherIllegal = false; isIllegalDrilling = true;
                                              isIllegalMeter = false; isForbiddenUse = false;
                                              setState(() {});
                                            },
                                          ),
                                          TextButton(
                                            child: Text("SAYAÇ BOZUK/YOK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                                decoration: TextDecoration.underline, decorationThickness: 3,
                                                backgroundColor: isIllegalMeter == true ? Colors.green : Colors.transparent),),
                                            onPressed: (){
                                              isOtherIllegal = false; isIllegalDrilling = false;
                                              isIllegalMeter = true; isForbiddenUse = false;
                                              setState(() {});
                                            },
                                          ),
                                          TextButton(
                                            child: Text("YASAKLANMIŞ KULLANIM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                                decoration: TextDecoration.underline, decorationThickness: 3,
                                                backgroundColor: isForbiddenUse == true ? Colors.green : Colors.transparent),),
                                            onPressed: (){
                                              isOtherIllegal = false; isIllegalDrilling = false;
                                              isIllegalMeter = false; isForbiddenUse = true;
                                              setState(() {});
                                            },
                                          ),
                                          TextButton(
                                            child: Text("DİĞER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                                decoration: TextDecoration.underline, decorationThickness: 3,
                                                backgroundColor: isOtherIllegal == true ? Colors.green : Colors.transparent),),
                                            onPressed: (){
                                              isOtherIllegal = true; isIllegalDrilling = false;
                                              isIllegalMeter = false; isForbiddenUse = false;
                                              setState(() {});
                                            },
                                          ),
                                          Visibility( visible: isOtherIllegal == false ? false : true,
                                            child: Padding( padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: TextFormField(
                                                controller: otherIllegalController,
                                                keyboardType: TextInputType.name,
                                                decoration: const InputDecoration(
                                                    labelText: "Diğer"
                                                ),
                                                validator: (value) {
                                                  if(value!.isNotEmpty){ "DİĞER kaçak kullanımlardan girebilirsiniz.";}
                                                  else { return null;}
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    tileColor: Colors.blueGrey[200],
                                    leading: const Icon(Icons.camera, size: 30, color: Colors.blueAccent,),
                                    title: const Center(child: Text("Fotoğraf Ekle/Değiştir", style: TextStyle(fontWeight: FontWeight.w700),)),
                                    subtitle: const Text("Fotoğraf ekleyerek başvurunuzu güçlendirebilir, müdahalenin daha "
                                        "hızlı ve etkili olmasını sağlayabilirsiniz."),
                                    onTap: (){
                                      addImagesDialog();
                                    },
                                  ),
                                ),
                                TextButton(
                                  child: const Text("Başvurunuzu görmek için tıklayın.", style: TextStyle(color: Colors.indigo,
                                      fontSize: 15, decoration: TextDecoration.underline, fontWeight: FontWeight.bold,
                                      decorationColor: Colors.blueGrey, decorationThickness: 3),),
                                  onPressed: (){
                                    seeApply();
                                  },
                                ),
                                Row( mainAxisAlignment: isIllegalUse == true ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceAround,
                                  children: [
                                    Visibility( visible: isIllegalUse == true ? true : false,
                                      child: SizedBox(width: 80, height: 80,
                                        child: FittedBox(
                                          child: FloatingActionButton.extended(
                                            heroTag: "isimsiz", elevation: 10,
                                            backgroundColor: isNameless == true ? Colors.green : Colors.blue[300],
                                            label: const Text("İsimsiz", style: TextStyle(color: Colors.white, fontSize: 20),),
                                            icon: isNameless == true ? const Icon(Icons.check_outlined) : const SizedBox.shrink(),
                                            onPressed: () {
                                              isNameless = !isNameless;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox( width: 120, height: 100,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: ElevatedButton.icon(
                                          icon: Icon(Icons.send,
                                            color: isIllegalUse == true ? Colors.deepOrangeAccent : Colors.orange,),
                                          style: const ButtonStyle(
                                            elevation: WidgetStatePropertyAll<double>(20),
                                            backgroundColor: WidgetStatePropertyAll(Colors.white),
                                          ),
                                          label: Text("Gönder", style: TextStyle(fontSize: 20,
                                              color: isIllegalUse == true ? Colors.deepOrangeAccent : Colors.orange), ),
                                          onPressed: () {
                                           if(streetController.text.trim().isEmpty){
                                             showDialog(context: context, builder: (_) =>
                                               const AlertDialog( title: Text("HATA: Mahalle ve sokak adı zorunludur.",
                                                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),)
                                             );
                                           } else {
                                             if(isIllegalUse == true){
                                               if(isIllegalMeter == false && isIllegalDrilling == false
                                                   && isForbiddenUse == false && isOtherIllegal == false){
                                                 showDialog(context: context, builder: (_) =>
                                                 const AlertDialog( title: Text("HATA: Bir tane Kaçak kullanım türünü seçilmelidir. "
                                                     "Eğer türünü bilmiyorsanız yada emin değilseniz DİĞER seçeneğini "
                                                     "işretleyerek kısaca tanımlayınız. Kaçak kullanım türleri hakkında bilgi almak "
                                                     "için  DETAYLAR' a tıklayınız.",
                                                   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),)
                                                 );
                                               } else if (isOtherIllegal == true){
                                                 if(otherIllegalController.text.trim().isEmpty){
                                                   showDialog(context: context, builder: (_) =>
                                                   const AlertDialog( title: Text("HATA: Diğer kaçak kullanımı türünü kısaca ve net ifadelerle "
                                                       "tarif ediniz. DETAYLAR butonuna basarak kullanım türleri hakkında bilgi alabilirsiniz.",
                                                     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),)
                                                   );
                                                 } else {
                                                   _sendApply();
                                                 }
                                               } else {
                                                 _sendApply();
                                               }
                                             } else if (isLeakage == true){
                                               _sendApply();
                                             }
                                           }

                                          },
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      child: const Text("Vazgeç", style: TextStyle(color: Colors.blueGrey,
                                          fontSize: 18, decoration: TextDecoration.underline, fontWeight: FontWeight.bold,
                                          decorationColor: Colors.blueGrey, decorationThickness: 3),),
                                      onPressed: (){
                                        isLeakage = false;
                                        isNameless = false;
                                        isIllegalUse = false;
                                        isOtherIllegal = false; isIllegalDrilling = false;
                                        isIllegalMeter = false; isForbiddenUse = false;
                                        selectedImages.pickedImages.clear();
                                        streetController.clear();
                                        detailController.clear();
                                        otherController.clear();
                                        setState(() {});

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: Colors.green, elevation: 50,
                                          content: const Text( "Başvurunuz iptal edilmiştir.",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          duration: const Duration(seconds: 15),
                                          action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  void illegalUseDetails() {
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Kaçak Kullanım Türleri"),
      content: SizedBox( height: 400, width: 500,
        child: ListView(
          children: const [
            Text("Bu uygulamanın yetkili kurum kullanıcısı bağlı bulunduğunuz belediyedir."
                " Yağtığınız her bildirim, ihbar yada başvuru *BELEDİYEYİ DURUMDAN"
                " HABERDAR ETME* anlamı taşımaktadır. HUKUKİ HİÇBİR GEÇERLİLİĞİ YOKTUR. Gereği "
                "belediyenin tasarrufuna bırakılmıştır.", textAlign: TextAlign.justify,),
            ListTile(
              title: Text("Kaçak Sondaj", style: TextStyle(decoration:  TextDecoration.underline,
                  color: Colors.black, decorationThickness: 3),),
              subtitle: Text("İlgili mevzuat gereğince yalnızca ilçe merkezdeki sondajlar ve "
                  "kuyular için ilçe belediyelerinden izin alınması gerekmektedir. Dolayısıyla "
                  "Kaçak Sondaj başvurusu yaparken adresin ilçe merkezinde olmasına dikkat ediniz.",
                style: TextStyle( color: Colors.blueGrey, fontSize: 12), textAlign: TextAlign.justify,),
            ),
            ListTile(
              title: Text("Sayaç Bozuk/Yok", style: TextStyle(decoration:  TextDecoration.underline,
                  color: Colors.black, decorationThickness: 3),),
              subtitle: Text("Sayacının bozuk olduğu yada hiç olmadığı, şebekeye direkt bağlantının yapıldığı gibi"
                  " durumlara şahit olduğunuzda bu ihbarı kullanabilirsiniz. Bu gibi durumlarda ücret ödeme olmadığı için"
                  "aşırı kullanım söz konusu olmaktadır.",
                style: TextStyle( color: Colors.blueGrey, fontSize: 12), textAlign: TextAlign.justify,),
            ),
            ListTile(
              title: Text("Yasaklanmış/Usülsüz Kullanım", style: TextStyle(decoration:  TextDecoration.underline,
                  color: Colors.black, decorationThickness: 3),),
              subtitle: Text("Suyun çok azaldığı zamanlarda (afet zamanları, yaz ayları gibi) belediyeler bazı alanlarda"
                  "(araba, merdiven, balkon yıkama, bahçe sulama gibi) şebeke suyunun kullanımını halkın zorunlu ihtiyaçlarına"
                  " yetişebilmek amacıyla yasaklamak yada sınırlandırmak zorunda kalmaktadır. Bu kişiler bu eylemlerini "
                  "tekrarlayacakları için bu zamanlarda bu kurala uymayan kişilerin ihbar edilmesi suyun herkese "
                  "yetmesi açısından önemldir. Ayrıca bu ihbarı şantiye hali bitmiş inşaatlarda hala inşaat tipi suyun "
                  "kullanılması gibi durumlarda da yapabilirsiniz.",
                style: TextStyle( color: Colors.blueGrey, fontSize: 12), textAlign: TextAlign.justify,),
            ),
            ListTile(
              title: Text("Diğer", style: TextStyle(decoration:  TextDecoration.underline,
                  color: Colors.black, decorationThickness: 3),),
              subtitle: Text("Yukarıdaki 3 durumun haricinde, belediyeyi ilgilendiren kaçak su kullanımı durumlarını "
                  "ihbar etmek için DİĞER butonunu kullanınız. Çıkan alana kaçak kullanım türünü kısa ve net bir şekilde "
                  "tarif ediniz",
                style: TextStyle( color: Colors.blueGrey, fontSize: 12), textAlign: TextAlign.justify,),
            ),
          ],
        ),
      ),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }
  void addImagesDialog() {
    AlertDialog alertDialog= AlertDialog(
      actions: [
        MaterialButton(
          color: Colors.teal,
          child: const Text("Galeriden Getir"),
          onPressed: (){
            changeImage == true ? selectedImages.pickedImages.clear() : null;
            pickSingleImage();
            Navigator.of(context, rootNavigator: true).pop("dialog");
            _saveNewUse == true ? Navigator.of(context, rootNavigator: true).pop("dialog") : null;
          },
        ),
        MaterialButton(
          color: Colors.indigo,
          child: const Text("Fotoğraf Çek", style: TextStyle(color: Colors.white),),
          onPressed: (){
            changeImage == true ? selectedImages.pickedImages.clear() : null;
            Navigator.of(context, rootNavigator: true).pop("dialog");
            captureImage();
          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }
  void pickSingleImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 20);

    if(image != null){
      selectedImages.pickedImages.add(image);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage()));

  }
  void captureImage() async{

    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 20);

    if(image != null){
      selectedImages.pickedImages.add(image);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage()));
/*
    var storageStatus = await Permission.storage.status;

    if(!storageStatus.isGranted){
      await Permission.storage.request();
      print("************************İZİN SORUNU");
    }
    if(storageStatus.isGranted){

      print("************************İZİN SORUNU YOK***********************");

      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if(image != null){
        selectedImages.pickedImages.add(image);
      }
    }
*/

  }
  void pickMultipleImage() async{

    final ImagePicker imagePicker = ImagePicker();
    final List<XFile> imageList = await imagePicker.pickMultiImage(imageQuality: 20);

    if(imageList.isNotEmpty){
      selectedImages.pickedImages.addAll(imageList);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage()));
/*
    var storageStatus = await Permission.storage.status;

    if(!storageStatus.isGranted){
      await Permission.storage.request();
      print("************************İZİN SORUNU");
    }
    if(storageStatus.isGranted){

      print("************************İZİN SORUNU YOK***********************");

      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

      if(image != null){
        selectedImages.pickedImages.add(image);
      }
    }
*/

  }
  void saveNewUse(String year, String month) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("$year yılı $month ayına ait su kullanım miktarınızı giriniz: ",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
      content: SizedBox( width: 500,
        height: _saveNewUse == true && selectedImages.pickedImages.isNotEmpty == true ? 100 : 250,
        child: ListView(
          children: [
            Form(
              key: _formKey2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: useAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "kullanımınızı miktarınızı m3 cinsinden giriniz.",
                  ),
                  validator: (value){
                    if(value!.isNotEmpty){ "kullanım miktarı giriniz.";}
                    else { return null;}
                  },
                ),
              ),
            ),
            TextButton(
              child: Text( _saveNewUse == true && selectedImages.pickedImages.isNotEmpty == true
                  ? "Eklediğiniz Görseli Görün" : "Kullanım bilgilerinizi doğrulamaya yardımcı olacak bir "
                  "görsel ekleyiniz. Bu faturanızın resmi olabilir. Doğrulanmayan girişler su tasarruf listesinde "
                  "*DOĞRULANMADI* etiketi ile görünür. Görsel eklerken lütfen sadece AdSoyadınız, kullanım "
                  "dönemi, kullanım miktarınızı görünür yapın. Adres, abone no... gibi diğer *KİŞİSEL BİLGİLERNİZİ"
                  " GİZLEYİNİZ*. Doğrulama işlemi eklediğiniz görsele bakarak diğer kullanıcılar tarafından yapılır.",
                style: TextStyle(
                    decoration: _saveNewUse == true && selectedImages.pickedImages.isNotEmpty == true ? TextDecoration.underline
                        : TextDecoration.none, decorationThickness: 3
                ), textAlign: TextAlign.justify,
              ),
              onPressed: (){
                Navigator.of(context, rootNavigator: true).pop("dialog");
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage()));
              },
            ),
          ],
        ),
      ),
      actions: [

        Wrap( direction: Axis.horizontal,
          children: [
            MaterialButton(
              child: Text(selectedImages.pickedImages.isNotEmpty ? "Görseli Değiştir" : "Görsel Ekle",
                  style: TextStyle(color: Colors.indigo,
                      fontSize: selectedImages.pickedImages.isNotEmpty ? 13 : 15,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                selectedImages.pickedImages.isNotEmpty ? changeImage = true : false;
                addImagesDialog();
              },
            ),
            FittedBox(
              child: MaterialButton(
                child: const Text("KAYDET",
                    style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, decorationThickness: 3)),
                onPressed: () async {
                  if(_formKey2.currentState!.validate()){
                    _formKey2.currentState!.save();
                    try{
                      String _usageName = "${DateTime.now().year}-${DateTime.now().month}";

                      if(selectedImages.pickedImages.isNotEmpty){
                        _image = File(selectedImages.pickedImages[0].path);
                        final Reference storageRef = await FirebaseStorage.instance.ref().child("citizen")
                            .child(MyInheritor.of(context)?.userMail).child("newUsages").child("$year - $month");
                        await storageRef.putFile(_image);
                        downloadUrl = await storageRef.getDownloadURL();
                      }

                      final DocumentReference docRef= await FirebaseFirestore.instance.collection("citizen")
                          .doc(MyInheritor.of(context)?.uid);
                      await docRef.get().then((DocumentSnapshot doc) async {
                        final data = doc.data() as Map<String, dynamic>;
                        final num? averageUse = data?["averageUse"];
                        final num? usageCount = data?["usageCount"];
                        final num? lastUsage_old = data?["lastUsage"];
                        final num? score = data?["score"];
                        final String? lastMonth = data?["lastMonth"];

                        num? lastUsage = num.parse(useAmountController.text.trim());

                        if (lastMonth != month){
                          num? newAverage = ((averageUse! * usageCount!) + lastUsage!) / (usageCount +1);

                          print("$newAverage****************");
                          print("$usageCount****************");

                          await docRef.update({
                            "lastMonth": month, "usageCount": (usageCount! +1),
                            "averageUse": newAverage, "lastUsage": lastUsage, "score": score! +5
                          });

                          await docRef.collection("usages").add({
                            "date": DateTime.now(), "name": _usageName,
                            "usageAmount": lastUsage, "isConfirmed": false,
                            "usePic": selectedImages.pickedImages.isNotEmpty ? downloadUrl.toString() : "no pic"
                          });
                        } else {
                          num? newAverage = ((averageUse! * usageCount!) - lastUsage_old! + lastUsage) / usageCount;

                          print("$newAverage");
                          print("$usageCount");

                          await docRef.update({
                            "averageUse": newAverage, "lastUsage": lastUsage
                          });
                          await docRef.collection("usages").where("name", isEqualTo: _usageName).get().then((_usages) =>
                              _usages.docs.forEach((_usage){
                                _usage.reference.update({
                                  "usageAmount": lastUsage,
                                  "usePic": selectedImages.pickedImages.isNotEmpty ? downloadUrl.toString() : _usage.data()["usePic"]
                                });
                              }));
                        }
                      });

                      _saveNewUse = false;
                      selectedImages.pickedImages.clear();

                      Navigator.of(context, rootNavigator: true).pop("dialog");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green, elevation: 50,
                        content: const Text( "Bilgileriniz kaydedildilmiştir.",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        duration: const Duration(seconds: 15),
                        action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
                      ));
                    } catch(e) {
                      AlertDialog alertDialog = AlertDialog(
                        title: const Text("Hata", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                        content: Text(e.toString(),
                          style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
                        ),
                      ); showDialog(context: context, builder: (_) => alertDialog);
                    }

                  }
                },
              ),
            ),
          ],
        ),
        MaterialButton(
          child: const Text("Vazgeç",
              style: TextStyle(color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold)),
          onPressed: () {
            selectedImages.pickedImages.clear();
            changeImage = false; _saveNewUse = false;
            useAmountController.clear();
            setState(() {});
            Navigator.of(context, rootNavigator: true).pop("dialog");
          },
        ),
      ],
    ); showDialog(context: context, builder: (_) => alertDialog);
  }


  void _sendApply() async {
    String _imageName = DateTime.now().hour.toString() + ":" + DateTime.now().minute.toString();
    Reference storageRef;

   try{
      if(selectedImages.pickedImages.isNotEmpty){
        _image = File(selectedImages.pickedImages[0].path);

        isLeakage == true ? storageRef = await FirebaseStorage.instance.ref().child("citizen")
            .child(MyInheritor.of(context)?.userMail).child("leakageApplies").child("${DateTime.now().year}")
            .child("${DateTime.now().month}").child(_imageName)
            : storageRef = await FirebaseStorage.instance.ref().child("citizen")
            .child(MyInheritor.of(context)?.userMail).child("illegalUseApplies").child("${DateTime.now().year}")
            .child("${DateTime.now().month}").child(_imageName);

        await storageRef.putFile(_image);
        downloadUrl = await storageRef.getDownloadURL();
      }

      final DocumentReference docRef= await FirebaseFirestore.instance.collection("citizen")
          .doc(MyInheritor.of(context)?.uid);
      await docRef.get().then((DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final num? leakageApply = data?["leakageApply"];
        final num? illegalUseApply = data?["illegalUseApply"];
        final num? solvedApply = data?["solvedApply"];
        final num? totalApply = data?["totalApply"];
        final num? score = data?["score"];
        final String municipality = data?["municipality"];

        if(isLeakage == true){
          await docRef.update({
            "leakageApply": leakageApply! +1, "totalApply": totalApply! +1, "score": score! +10
          });

          await docRef.collection("leakageApplies").add({"applyDate": DateTime.now().toString(),
            "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
            "details": detailController.text.trim(), "isSolved": false,
          });
          
          await FirebaseFirestore.instance.collection("municipality").where("municipality", isEqualTo: municipality)
              .get().then((munis) => munis.docs.forEach((muni){
                muni.reference.update({
                  "leakageApply" : muni.data()["leakageApply"] +1,
                  "totalApply" : muni.data()["totalApply"] +1,
                  "totalNotifications": muni.data()["totalNotifications"] +1,
                  "unseenNotifications": muni.data()["unseenNotifications"] +1,
                });
                muni.reference.collection("leakageApplies").add({
                  "senderName": MyInheritor.of(context)?.userName,
                  "senderMail": MyInheritor.of(context)?.userMail,
                  "applyDate": DateTime.now().toString(), "isSeen": false,
                  "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
                  "details": detailController.text.trim(), "isSolved": false,
                });
                muni.reference.collection("notifications").add({
                  "senderName": MyInheritor.of(context)?.userName,
                  "senderMail": MyInheritor.of(context)?.userMail,
                  "applyDate": DateTime.now().toString(),
                  "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
                  "details": detailController.text.trim(), "isSolved": false,
                  "applyType": "Su Kaçağı İhbarı", "isSeen": false,
                });
          }));

        } else if (isIllegalUse == true) {
          await docRef.update({
            "illegalUseApply": illegalUseApply! +1, "totalApply": totalApply! +1, "score": score! +10
          });

          await docRef.collection("illegalUseApplies").add({"applyDate": DateTime.now().toString(),
            "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
            "details": detailController.text.trim(), "isSolved": false, "isNameless": isNameless,
            "isIllegalMeter": isIllegalMeter, "isIllegalDrilling": isIllegalDrilling,
            "isForbiddenUse": isForbiddenUse, "isOtherIllegal": isOtherIllegal,
            "otherIllegalText": otherIllegalController.text.trim(), "isSeen": false,
          });

          await FirebaseFirestore.instance.collection("municipality").where("municipality", isEqualTo: municipality)
              .get().then((munis) => munis.docs.forEach((muni){

            muni.reference.update({
              "illegalUseApply" : muni.data()["illegalUseApply"] +1,
              "totalApply" : muni.data()["totalApply"] +1,
              "totalNotifications": muni.data()["totalNotifications"] +1,
              "unseenNotifications": muni.data()["unseenNotifications"] +1,
            });
            muni.reference.collection("illegalUseApplies").add({
              "senderName": MyInheritor.of(context)?.userName,
              "senderMail": MyInheritor.of(context)?.userMail,
              "applyDate": DateTime.now().toString(),
              "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
              "details": detailController.text.trim(), "isSolved": false, "isNameless": isNameless,
              "isIllegalMeter": isIllegalMeter, "isIllegalDrilling": isIllegalDrilling,
              "isForbiddenUse": isForbiddenUse, "isOtherIllegal": isOtherIllegal,
              "otherIllegalText": otherIllegalController.text.trim(), "isSeen": false,
            });
            muni.reference.collection("notifications").add({
              "senderName": MyInheritor.of(context)?.userName,
              "senderMail": MyInheritor.of(context)?.userMail,
              "applyDate": DateTime.now().toString(),
              "applyType": "Kaçak Kullanım İhbarı",
              "imageUrl": downloadUrl.toString(), "street": streetController.text.trim(),
              "details": detailController.text.trim(), "isSolved": false, "isNameless": isNameless,
              "isIllegalMeter": isIllegalMeter, "isIllegalDrilling": isIllegalDrilling,
              "isForbiddenUse": isForbiddenUse, "isOtherIllegal": isOtherIllegal,
              "otherIllegalText": otherIllegalController.text.trim(), "isSeen": false,
            });
          }));
        }
      });

      isLeakage = false;
      isNameless = false;
      isIllegalUse = false;
      isOtherIllegal = false; isIllegalDrilling = false;
      isIllegalMeter = false; isForbiddenUse = false;
      selectedImages.pickedImages.clear();
      streetController.clear();
      detailController.clear();
      otherController.clear();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, elevation: 50,
        content: const Text( "Başvurunuz gönderilmiştir.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        duration: const Duration(seconds: 15),
        action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
      ));

    } catch(e) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text("Hata", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        content: Text(e.toString(),
          style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
        ),
      ); showDialog(context: context, builder: (_) => alertDialog);
    }

  }

  void seeApply(){
    AlertDialog alertDialog = AlertDialog(
      title: Text( _saveNewUse == true ? "Girdiğiniz Bilgiler" : "Başvurunuz"),
      content: SizedBox( height: 300, width: 500,
        child: ListView(
          children: [
            Visibility( visible: _saveNewUse == true ? false : true,
              child: ListTile(
                title: const Text("Başvuru Türü: ", style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(isLeakage == true ? "Su Kaçağı İhbarı"
                    : isIllegalDrilling == true ? "Kaçak Kullanım İhbarı/ Kaçak Sondaj"
                    : isIllegalMeter == true ? "Kaçak Kullanım İhbarı/ Sayaç Bozuk Yok"
                    : isForbiddenUse == true ? "Kaçak Kullanım İhbarı/ Yasaklanmış KUllanım"
                    : "Kaçak Kullanım İhbarı/ Diğer"),
              ),
            ),
            ListTile(
              title: const Text("Mahalle ve Sokak:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(streetController.text.trim()),
            ),
            ListTile(
              title: const Text("Detaylar:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: Text(detailController.text.trim(), style: const TextStyle(fontWeight: FontWeight.bold),),
            ),
            ListTile(
              title: const Text("Görseller:", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: selectedImages.pickedImages.isNotEmpty
                  ? Text("${selectedImages.pickedImages.length} adet görsel eklediniz. Görmek için tıklayınız.")
                  : const Text("Görsel Eklemediniz."),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImagesPage())),
            ),
            Visibility( visible: isIllegalUse == true ? true : false,
              child: Row(
                children: [
                  const Text("     İsimsiz mi:  ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(isNameless == true ? "Evet" : "Hayır", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                      decoration: TextDecoration.underline, color: Colors.indigo),),
                ],
              ),
            ),
          ],
        ),
      ),
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