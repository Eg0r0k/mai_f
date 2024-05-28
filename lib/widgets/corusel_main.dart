import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MainCorusel extends StatelessWidget {
  const MainCorusel({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    bool isDesktop = screenWidth > 600;

    double carouselHeight = isDesktop ? 550.0 : 350.0;

    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        autoPlay: true,
      ),
      items: [1, 2, 3, 4].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/slider-$i.webp'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}