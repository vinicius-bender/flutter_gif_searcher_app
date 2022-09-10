import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifapp/UI/gif_page.dart';

import 'package:http/http.dart' as http; 
import 'package:flutter_share/flutter_share.dart';
import 'package:transparent_image/transparent_image.dart';

class GifAppHomePage extends StatefulWidget{
  const GifAppHomePage({super.key});

  @override
  GifAppHomePageState createState () => GifAppHomePageState();
}

class GifAppHomePageState extends State<GifAppHomePage>{
  
  String? search;
  int offseat = 0;
  
  @override
  void initState() {
    super.initState();
    getSearch().then((map){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
             Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text("Search", style: TextStyle(color: Colors.white),),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (text){
                  setState(() {
                    search = text;
                    offseat = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getSearch(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    case ConnectionState.waiting:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    case ConnectionState.active:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError){
                        return createGifTable(context, snapshot);
                      }else{
                        return createGifTable(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<Map> getSearch () async{

    http.Response response;
    var url = Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=ROV2CsXKmkEA4RtXw5VyUI23w9pEcQwr&limit=20&rating=g");
    var url2 = Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=ROV2CsXKmkEA4RtXw5VyUI23w9pEcQwr&q=$search&limit=19&offset=$offseat&rating=g&lang=en");
    

    if (search == null || search == ""){//A response pega os gifs trending
      response = await http.get(url);
    }else{//A response pega os gifs do conteudo pesquisado
      response = await http.get(url2);
    }
    return json.decode(response.body); //Transforma o Json em um Map e retorna
  }

  int getCount (List data){
    if (search == null || search == ""){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget createGifTable (BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: getCount(snapshot.data["data"]), 
      itemBuilder: (context, index){
        if (search == null || search == "" || index < snapshot.data["data"].length){
          return GestureDetector(
          child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
          height: 300.0,
          fit: BoxFit.cover,
          ),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index])));
          },
          onLongPress: () {
            FlutterShare.share(linkUrl: snapshot.data["data"][index]["images"]["fixed_height"]["url"], title: snapshot.data["images"][index]["title"]);
          },
        );
        }else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white,),
                  Text("Carregar mais...", style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              ),
              onTap: (){
                setState(() {
                  offseat = offseat + 19;
                });
              },
            ),
          );
        }
      }
    );
  }
}