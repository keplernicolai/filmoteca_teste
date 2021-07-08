import 'dart:convert';
import 'dart:io';
import 'package:filmoteca_teste/models/filme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Filme _filmes;
  //List _filmesFavoritos = [];

  Future<Map> _getMovies() async {
    http.Response response;

    response = await http.get(
        "https://api.themoviedb.org/3/discover/movie?api_key=97920d7d9b055ad8501b20b1a18c40fa&sort_by=popularity.desc");

    return json.decode(response.body);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getMovies().then((value) {
  //     setState(() {
  //       _filmes = value.map((json) => Filmes.fromJson(json));
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: Text(
            "Filmoteca",
            style: TextStyle(fontSize: 20.0, color: Colors.white60),
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.blueGrey[900],
          actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: _getMovies(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.amber),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createHorizontalList(context, snapshot);
                  }
                },
              ),
            ),
          ],
        ));
  }

  String _getImageUrl(snapshot, index) {
    String path = snapshot.data["results"][index]["backdrop_path"];
    return "https:/" + path;
  }

  Widget _createHorizontalList(BuildContext context, AsyncSnapshot snapshot) {
    return Expanded(
      child: SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data["results"].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    child: Image.network(
                      _getImageUrl(snapshot, index),
                      height: 100.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                );
              })),
    );
  }

  // Future<File> _getFile() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return File("${directory.path}/data.json");
  // }

  // Future<File> _saveFavoriteMovies() async {
  //   String data = json.encode(_filmesFavoritos);
  //   final file = await _getFile();
  //   return file.writeAsString(data);
  // }

  // Future<String> _readData() async {
  //   try {
  //     final file = await _getFile();
  //     return file.readAsString();
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
