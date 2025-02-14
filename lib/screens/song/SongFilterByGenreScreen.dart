import 'dart:convert';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import '../../models/Genre.dart';
import '../../models/Song.dart';
import '../../utils/Constants.dart';

class SongFilterByGenreScreen extends StatefulWidget {

  final String title;
  final Genre genre;

  const SongFilterByGenreScreen({super.key, required this.title, required this.genre});

  @override
  State<SongFilterByGenreScreen> createState() => _SongFilterByGenreScreenState();
}

class _SongFilterByGenreScreenState extends State<SongFilterByGenreScreen> {

  // Initialize genres as an empty list
  late List<Song> songs = [];


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      // final genre_id = widget.genre.id.toString();

      final genre_id = widget.genre.id.toString();

      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.SONG_FILTER_BY_GENRE_ROUTE + genre_id));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          songs = data.map((product) => Song.fromJson(product)).toList();
        });

      } else {

        throw Exception('Failed to load songs ' + Constants.BASE_URL + Constants.SONG_FILTER_BY_GENRE_ROUTE + genre_id);

      }
    } catch (e) {
      print('Error: $e');
    }

  }

  Future<void> onRefresh() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: songs.isEmpty // Check if genres is empty before accessing its elements
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(songs[index].name),
              onTap: () {
                // navigateToSongScreen(genres[index]);
                Map carts = {
                  'product_id' : songs[index].id,
                  // 'qty' : 3
                };


              },
            );
          },
        ),
      ),
    );
  }
}