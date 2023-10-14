import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductScreen extends StatelessWidget {
  final List<dynamic> images;
  final String name;
  final int price;
  final int id;
  final String description;

  const ProductScreen(
      {super.key,
      required this.images,
      required this.name,
      required this.price,
      required this.id,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
                child: CarouselSlider(
              options: CarouselOptions(height: 300.0),
              items: images.map((image) {
                return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(image)),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                ));
              }).toList(),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 40,bottom: 20),
              child: Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text("\$ ${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400)),
            ),
          ],
        ));
  }
}
