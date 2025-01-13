
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:suyumukoruyorum/Helpers/MyInheritor.dart';
import 'package:suyumukoruyorum/HomePage.dart';
import 'package:suyumukoruyorum/MuniHomePage.dart';
import 'package:suyumukoruyorum/MunicipalityChoosePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class RegisterLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterLoginPageState();
  }

}

class RegisterLoginPageState extends State<RegisterLoginPage>{

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  TextEditingController nameLogin = TextEditingController();
  TextEditingController mailLogin = TextEditingController();
  TextEditingController passLogin = TextEditingController();

  TextEditingController nameRegister = TextEditingController();
  TextEditingController mailRegister = TextEditingController();
  TextEditingController passRegister = TextEditingController();

  bool isLogin= true;

  bool isMetropolitan = false; bool isCity = false;
  bool isTown = false; bool isBelde = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt/Giriş"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: ListView(
            children: [
              Card(
                elevation: 50,
                color: Colors.white,
                child: Container( height: 300, width: 300,
                  child: ListView(
                    children: [
                      const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("GİRİŞ YAP",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),),
                      )),
                      Form( key: _formKey1,
                        child: SizedBox( height: 250,
                          child: ListView(
                            children: <Widget>[
                              Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: TextFormField(
                                  controller: nameLogin,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    labelText: MyInheritor.of(context)?.isMunicipality == true ? "Kurum Adı" : "Ad Soyad",
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty){ "Lütfen alanı doldurunuz.";}
                                    else { return null;}
                                  },
                                ),
                              ),
                              Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: TextFormField(
                                  controller: mailLogin,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: "Email adresi"
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty){ "Lütfen alanı doldurunuz.";}
                                    else { return null;}
                                  },
                                ),
                              ),
                              Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                child: TextFormField(
                                  controller: passLogin,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                      labelText: "Şifre"
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty){ "Lütfen alanı doldurunuz.";}
                                    else { return null;}
                                  },
                                ),
                              ),
                              const SizedBox( height: 20,),
                              SizedBox( width: 50, height: 50,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.login, color: Colors.white,),
                                    style: const ButtonStyle(
                                      elevation: WidgetStatePropertyAll<double>(20),
                                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                                    ),
                                    label: const Text("Giriş Yap", style: TextStyle(fontSize: 20, color: Colors.white), ),
                                    onPressed: () {
                                      isLogin = true;

                                      if( nameLogin.text != ""
                                          && mailLogin.text != ""
                                          && passLogin.text != ""){
                                        MyInheritor.of(context)?.userName = nameLogin.text.trim().toLowerCase();
                                        MyInheritor.of(context)?.userMail = mailLogin.text.trim().toLowerCase();
                                        MyInheritor.of(context)?.userPass = passLogin.text.trim();

                                        _logIn();
                                      } else {

                                        registerLoginErrorDialog();
                                      }},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50,),

              Card(
                elevation: 50,
                color: Colors.blue[200],
                child: Container( height: 300, width: 300,
                  child: ListView(
                    children: [
                      const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("KAYDOL",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                      )),
                      Visibility( visible: MyInheritor.of(context)?.isMunicipality == true ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.blue[300],
                            title: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Wrap( direction: Axis.vertical,
                                  children: [
                                    Text("Kurum Türü", style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text("Aşağıdakilerden yalnızca birini seçiniz.",
                                      style: TextStyle(fontSize: 10),)
                                  ],
                                ),
                                SizedBox(width: 80, height: 30,
                                  child: FloatingActionButton(
                                    heroTag: "Detaylar", backgroundColor: Colors.indigo,
                                    onPressed: () {

                                    },
                                    child: const Text("Detaylar", style: TextStyle(fontSize: 15, color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Center(
                              child: Wrap( direction: Axis.horizontal,
                                children: [
                                  SizedBox( width: 100, height: 50,
                                    child: TextButton(
                                      child: Text("Büyükşehir Bel.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,
                                          decoration: TextDecoration.underline, decorationThickness: 3,
                                          backgroundColor: isMetropolitan == true ? Colors.green : Colors.transparent),),
                                      onPressed: (){
                                        isMetropolitan = true; isCity = false;
                                        isTown = false; isBelde = false;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    child: Text("Şehir Bel.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                        decoration: TextDecoration.underline, decorationThickness: 3,
                                        backgroundColor: isCity == true ? Colors.green : Colors.transparent),),
                                    onPressed: (){
                                      isMetropolitan = false; isCity = true;
                                      isTown = false; isBelde = false;
                                      setState(() {});
                                    },
                                  ),
                                  TextButton(
                                    child: Text("İlçe Bel.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
                                        decoration: TextDecoration.underline, decorationThickness: 3,
                                        backgroundColor: isTown == true ? Colors.green : Colors.transparent),),
                                    onPressed: (){
                                      isMetropolitan = false; isCity = false;
                                      isTown = true; isBelde = false;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Form( key: _formKey2,
                          child: SizedBox( height: 250,
                            child: ListView(
                              children: <Widget>[
                                Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: TextFormField(
                                    controller: nameRegister,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        labelText: MyInheritor.of(context)?.isMunicipality == true ? "Kurum Adı" : "Adı Soyad",
                                    ),
                                    validator: (value) {
                                      if(value!.isNotEmpty){ "Adınızı Soyadınızı giriniz";}
                                      else { return null;}
                                    },
                                  ),
                                ),
                                Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: TextFormField(
                                    controller: mailRegister,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                        labelText: "Email adresi"
                                    ),
                                    validator: (value) {
                                      if(value!.isNotEmpty){ "Email adresinizi giriniz";}
                                      else { return null;}
                                    },
                                  ),
                                ),
                                Padding( padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: TextFormField(
                                    controller: passRegister,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        labelText: "Şifre"
                                    ),
                                    validator: (value) {
                                      if(value!.isNotEmpty){ "Şifrenizi giriniz";}
                                      else { return null;}
                                    },
                                  ),
                                ),
                                const SizedBox( height: 20,),
                                SizedBox( width: 50, height: 50,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.login, color: Colors.blue,),
                                      style: const ButtonStyle(
                                        elevation: WidgetStatePropertyAll<double>(20),
                                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                                      ),
                                      label: const Text("Kaydol", style: TextStyle(fontSize: 20, color: Colors.blue), ),
                                      onPressed: () {
                                        isLogin = false;

                                        if( nameRegister.text != ""
                                            && mailRegister.text != ""
                                            && passRegister.text != ""){
                                          MyInheritor.of(context)?.userName = nameRegister.text.trim().toLowerCase();
                                          MyInheritor.of(context)?.userMail = mailRegister.text.trim().toLowerCase();
                                          MyInheritor.of(context)?.userPass = passRegister.text.trim();

                                          if(MyInheritor.of(context)?.isMunicipality == true){
                                            MyInheritor.of(context)?.isMetropolitan = isMetropolitan;
                                            MyInheritor.of(context)?.isCity = isCity;
                                            MyInheritor.of(context)?.isTown = isTown;
                                          }
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MunicipalityChoosePage()));
                                        } else {
                                          registerLoginErrorDialog();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),

            ],
          )
        ),
      ),
    );
  }

  void registerLoginErrorDialog(){
    AlertDialog alertDialog = AlertDialog(
      title: Center(
          child: Text( isLogin == true ? "*!! Lütfen GİRİŞ alanındaki boş yerleri doldurunuz."
              : "*!! Lütfen KAYDOL alanındaki boş yerleri doldurunuz.",
            style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 15),)),
    ); showDialog(context: context, builder: (_) => alertDialog);
  }

  void _logIn() async {

    print(MyInheritor.of(context)?.userName);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailLogin.text.trim().toLowerCase(), password: passLogin.text.trim()
      );
      final User? user = userCredential.user;

      if(user != null){
        if(MyInheritor.of(context)?.isMunicipality == true){
          await FirebaseFirestore.instance.collection("municipality").where("userMail", isEqualTo: MyInheritor.of(context)?.userMail)
              .get().then((users) => users.docs.forEach((user){
            MyInheritor.of(context)?.uid = user.id;
          }));
        } else {
          await FirebaseFirestore.instance.collection("citizen").where("userMail", isEqualTo: MyInheritor.of(context)?.userMail)
              .get().then((users) => users.docs.forEach((user){
            MyInheritor.of(context)?.uid = user.id;
          }));
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, elevation: 50,
          content: const Text( "Hoşgeldiniz",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          duration: const Duration(seconds: 15),
          action: SnackBarAction(label: "Gizle", textColor: Colors.indigo, onPressed: () => SnackBarClosedReason.hide,),
        ));

        if(MyInheritor.of(context)?.isMunicipality == true){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MuniHomePage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } catch(e) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text("Hata"),
        content: Text(e.toString().contains("invalid-credential") ? "Email adresi veya şifre hatalı yada hesabın süresi dolmuştur."
            : "Bilinmeyen bir hata oluştu. İnternet bağlantınız ile ilgili yada sistemsel bir hata olabilir. "
            "Lütfen daha sonra tekrar deneyiniz",
          style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,
        ),
      ); showDialog(context: context, builder: (_) => alertDialog);

    }

  }

}

