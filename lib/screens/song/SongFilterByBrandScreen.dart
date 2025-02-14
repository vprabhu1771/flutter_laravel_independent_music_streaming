import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Brand.dart';
import '../../models/Song.dart';
import '../../utils/Constants.dart';
import 'MusicPlayerScreen.dart';

class SongFilterByBrandScreen extends StatefulWidget {

  final String title;
  final Brand brand;

  const SongFilterByBrandScreen({super.key, required this.title, required this.brand});

  @override
  State<SongFilterByBrandScreen> createState() => _SongFilterByBrandScreenState();
}

class _SongFilterByBrandScreenState extends State<SongFilterByBrandScreen> {

  // Initialize brands as an empty list
  late List<Song> songs = [];


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    try {

      // final brand_id = widget.brand.id.toString();

      final brand_id = widget.brand.id.toString();

      final response = await http.get(Uri.parse(Constants.BASE_URL + Constants.SONG_FILTER_BY_BRAND_ROUTE+ brand_id));

      if (response.statusCode == 200) {

        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          songs = data.map((product) => Song.fromJson(product)).toList();
        });

      } else {

        throw Exception('Failed to load songs ' + Constants.BASE_URL + Constants.SONG_FILTER_BY_BRAND_ROUTE+ brand_id);

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
        child: songs.isEmpty // Check if brands is empty before accessing its elements
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(songs[index].name),
              onTap: () {
                // navigateToSongScreen(brands[index]);
                Map carts = {
                  'product_id' : songs[index].id,
                  // 'qty' : 3
                };

                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => MusicPlayerScreen(song: songs[index])),
                );

              },
            );
          },
        ),
      ),
    );
  }
}