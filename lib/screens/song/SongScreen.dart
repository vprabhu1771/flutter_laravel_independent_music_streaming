import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/Song.dart';
import '../../utils/Constants.dart';

class SongScreen extends StatefulWidget {

  final String title;
  const SongScreen({super.key, required this.title});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {

  late List<Song> songs =[];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData () async {
    try {

      final response =
      await http.get(Uri.parse(Constants.BASE_URL + Constants.SONG_ROUTE));

      print(response.body.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          songs = data.map((song) => Song.fromJson(song)).toList();
        });
      } else {
        throw Exception(

            'Failed to load songs ' + Constants.BASE_URL + Constants.SONG_ROUTE);

      }

    }
    catch (e) {

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
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        songs[index].image_path,
                        width: 80,
                        height: 80,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    onTap: () {},
                  );
                }
            )
        )
    );

  }
}