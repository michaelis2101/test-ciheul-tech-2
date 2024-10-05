import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/view/login.dart';
import 'package:test_e_library/view/welcome.dart';

class CarouselLogin extends StatefulWidget {
  const CarouselLogin({super.key});

  @override
  State<CarouselLogin> createState() => _CarouselLoginState();
}

class _CarouselLoginState extends State<CarouselLogin> {
  // final List<Widget> items = [
  //   WelcomePage(
  //     nextPage: () {
  //       buttonCarouselController.nextPage(
  //           duration: Duration(milliseconds: 300), curve: Curves.linear);
  //     },
  //   ),
  //   const LoginScreen()
  // ];
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      WelcomePage(
        nextPage: () {
          buttonCarouselController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.linear);

          print('aaaa');
        },
      ),
      const LoginScreen()
    ];
    return Scaffold(
        body: CarouselSlider(
            carouselController: buttonCarouselController,
            items: items.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: item,
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              // pageSnapping: true,
              height: MediaQuery.of(context).size.height,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              // autoPlayInterval: Duration(seconds: 3),
              // autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.linear,
              // autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              // onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            )));
  }
}
