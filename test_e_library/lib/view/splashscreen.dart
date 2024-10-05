import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/view/carousellogin.dart';
import 'package:test_e_library/view/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // int? uid = prefs.getInt('uid');
      bool uid = prefs.containsKey('uid');

      if (uid) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const MainScreen()), // Your main screen
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const CarouselLogin()), // Your main screen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: ColorApp().celestialBlue),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/iconspsc.svg',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'My E-Lib',
                style: GoogleFonts.montserrat(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: LinearProgressIndicator(
                  backgroundColor: ColorApp().celestialBlue,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
