import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Brand.dart';
import '../utils/Constants.dart';
import '../screens/song/SongFilterByBrandScreen.dart';

class BrandScreen extends StatefulWidget {

  final String title;
  const BrandScreen({super.key, required this.title});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {

  late List<Brand> brands =[];

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData () async {
    try {

      final response =
      await http.get(Uri.parse(Constants.BASE_URL + Constants.BRAND_ROUTE));

      print(response.body.toString());

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        setState(() {
          brands = data.map((brand) => Brand.fromJson(brand)).toList();
        });
      } else {
        throw Exception(

            'Failed to load brands ' + Constants.BASE_URL + Constants.BRAND_ROUTE);

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
            child: brands.isEmpty // Check if genres is empty before accessing its elements
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: brands.length,
                itemBuilder: (context, index) {

                  return ListTile(
                    title: Text(brands[index].name),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        brands[index].image_path,
                        width: 80,
                        height: 80,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => SongFilterByBrandScreen(title: brands[index].name, brand: brands[index],)),
                      );
                    },
                  );
                }
            )
        )
    );

  }
}
