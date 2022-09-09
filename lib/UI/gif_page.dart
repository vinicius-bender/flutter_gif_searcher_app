import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget {
  
  Map gifData = Map();

  GifPage(this.gifData, {super.key});

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData["title"]),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            FlutterShare.share(linkUrl: gifData["images"]["fixed_height"]["url"], title: gifData["title"]);
          }, icon: const Icon(Icons.share)),
        ],
      ),
      body: Center(
        child: Image.network(gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}