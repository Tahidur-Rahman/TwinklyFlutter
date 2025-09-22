import 'package:flutter/material.dart';

class CardsCarousel extends StatelessWidget {
  final double height;
  final ScrollController controller;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const CardsCarousel({
    Key? key,
    required this.height,
    required this.controller,
    required this.itemCount,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 40, bottom: 20),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}


