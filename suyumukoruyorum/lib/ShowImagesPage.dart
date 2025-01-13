import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suyumukoruyorum/Helpers/SelectedImages.dart';

class ShowImagesPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ShowImagesPageState();
  }

}

class ShowImagesPageState extends State<ShowImagesPage>{

  SelectedImages selectedImages = SelectedImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seçtiğiniz Resimler"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 600,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 10,
                ),
                itemCount: selectedImages.pickedImages.length,
                itemBuilder: (context, index){
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        SizedBox(height: 200, width: 200,
                         child: Image.file(File(selectedImages.pickedImages[index].path),
                           fit: BoxFit.cover,
                         ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Colors.blueGrey,
                  child: const Text("Listeyi Temizle", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    selectedImages.pickedImages.clear();
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
                MaterialButton(
                  color: Colors.green,
                  child: const Text("Onayla", style: TextStyle(color: Colors.white),),
                  onPressed: (){

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}