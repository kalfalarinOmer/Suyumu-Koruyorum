import "package:flutter/material.dart";

class MyInheritor extends InheritedWidget{

  dynamic userName, userMail, uid, userPass, isMunicipality;
  dynamic isMetropolitan, isCity, isTown;

  MyInheritor({
    Key? key,
    required Widget child,

    this.userName, this.userMail, this.uid, this.userPass, this.isMunicipality,
    this.isMetropolitan, this.isCity, this.isTown,


  }): super(key: key, child: child);

  static MyInheritor? of (context){
    return context.dependOnInheritedWidgetOfExactType<MyInheritor>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

}