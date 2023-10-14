import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopapp/productScreen.dart';

class ProductCard extends StatelessWidget {
  final List<dynamic> images;
  final String name;
  final int price;
  final int id;
  final String description;

  const ProductCard(
      {super.key,
      required this.images,
      required this.name,
      required this.price,
      required this.id,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductScreen(images: images,name: name,price: price,id: id, description: description,),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(images[0])),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
              )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
                child: Text("\$ ${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        ));
  }
}
