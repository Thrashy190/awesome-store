import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/card.dart';
import 'dart:convert';

void main() {
  runApp(AwesomeStoreApp());
}

class AwesomeStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AwesomeStoreHome(),
    );
  }
}

class AwesomeStoreHome extends StatefulWidget {
  const AwesomeStoreHome({super.key});

  @override
  _AwesomeStoreHomeState createState() => _AwesomeStoreHomeState();
}

class _AwesomeStoreHomeState extends State<AwesomeStoreHome> {
  final controller = ScrollController();
  List<dynamic> products = [];
  String text = '';
  int offset = 0;
  int limit = 10;
  bool status = false;

  @override
  void initState() {
    super.initState();
    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    final response = await http.get(Uri.parse(
        'https://api.escuelajs.co/api/v1/products?title=$text&offset=$offset&limit=$limit'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        offset = offset + 10;
        products.addAll(data);
      });
    }
  }

  Future<void> fetchFilterProducts(value) async {
    setState(() {
      text = value;
      offset = 0;
    });

    final response = await http.get(Uri.parse(
        'https://api.escuelajs.co/api/v1/products/?title=$text&offset=$offset&limit=$limit'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products.clear();
        products.addAll(data);
      });
    }
  }

  Future refresh() async {
    setState(() {
      offset = 0;
      products.clear();
    });
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      color: Colors.black,
      onRefresh: refresh,
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text("Awesome Store",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold))),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
            child: TextField(
              onChanged: (value) => fetchFilterProducts(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(width: 3, color: Colors.grey),
                ),
                hintText: 'Busca los productos aqui...',
                contentPadding: const EdgeInsets.all(20.0),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(status ? Icons.view_column : Icons.menu),
                    onPressed: () {
                      setState(() {
                        status = !status;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: products.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.black,
                    ))
                  : GridView.builder(
                      controller: controller,
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: status ? 1 : 2,
                        // number of items in each row
                        mainAxisSpacing: 8.0,
                        // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                      itemCount: products.length + 2,
                      itemBuilder: (context, index) {
                        if (index < products.length) {
                          final product = products[index];
                          return ProductCard(
                            id: product["id"],
                            images: product['images'],
                            name: product['title'],
                            price: product['price'],
                            description: product['description'],
                          );
                        } else {
                          return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )));
                        }
                      },
                    )),
        ],
      ),
    ));
  }
}
