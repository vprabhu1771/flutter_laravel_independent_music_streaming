import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/Genre.dart';
import '../utils/Constants.dart';
import '../screens/song/SongFilterByGenreScreen.dart';

class GenreScreen extends StatefulWidget {

  final String title;

  const GenreScreen({super.key,required this.title});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {

  //Intialize genre as an empty list
  late List<Genre> genres = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      final response =await http.get(Uri.parse(Constants.BASE_URL + Constants.GENRE_ROUTE));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          genres = data.map( (genre) => Genre.fromJson(genre) ).toList();
        });

      }
      else {
        throw Exception('Failed to load genre' + Constants.BASE_URL + Constants.GENRE_ROUTE);
      }

    }
    catch(e) {
      print ('Error:$e');
    }

  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon:Icon(Icons.refresh),
              onPressed: () {
                fetchData ();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: onRefresh,
            child: genres.isEmpty // Check if genres is empty before accessing its elements
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: genres.length,
                itemBuilder: (context, index) {

                  return ListTile(
                    title: Text(genres[index].name),
                    onTap: () {
                      // Navigator.pop(context);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SongFilterByGenreScreen(title: genres[index].name, genre: genres[index],)),
                      );
                    },
                  );
                }
            )
        )
    );
  }
}