import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/user_model.dart';
import 'package:test_e_library/sqlite/db_helper.dart';
import 'package:test_e_library/view/mainscreen.dart';
import 'package:test_e_library/view/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pw = TextEditingController();

  bool isHide = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: ColorApp().celestialBlue),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -85,
                right: -40,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Please Login',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text(
                      'to continue',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: MediaQuery.of(context).size.height / 6),
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: SvgPicture.asset(
                    //       'assets/book.svg',
                    //       height: 200,
                    //       width: 200,
                    //     ),
                    //   ),
                    // ),

                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/reading.svg',
                        width: 200,
                        height: 200,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                                // label: Text('Email'),
                                // labelText: 'Email',
                                hintText: 'Username',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: ColorApp().indigoGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                prefixIcon: Icon(Icons.person),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Password',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                            ),
                          ),
                          TextField(
                            controller: pw,
                            obscureText: isHide,
                            decoration: InputDecoration(
                                // label: Text('Email'),
                                // labelText: 'Email',
                                hintText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: ColorApp().indigoGrey),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isHide = !isHide;
                                      });
                                    },
                                    child: Icon(isHide
                                        ? Icons.remove_red_eye
                                        : Icons.remove_red_eye_outlined)),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorApp().indigoGrey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  DatabaseHelper db = DatabaseHelper();
                                  // Navigator.of(context)
                                  //     .pushReplacement(MaterialPageRoute(
                                  //   builder: (context) {
                                  //     return const MainScreen();
                                  //   },
                                  // ));
                                  try {
                                    var res =
                                        await db.login(email.text, pw.text);

                                    if (res.isNotEmpty) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      UserModel user = res[0];
                                      await prefs.setInt('uid', user.id!);
                                      print(
                                        user.id,
                                      );
                                      print(
                                        user.username,
                                      );
                                      print(
                                        user.password,
                                      );
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) {
                                          return const MainScreen();
                                        },
                                      ));
                                    } else {
                                      showFailed(context);
                                      // showModalBottomSheet(context: context, builder: builder)
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorApp().preussianBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ));
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 20),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFailed(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.block_sharp,
                color: Colors.red,
                size: 40,
              ),
              Text(
                'Login Failed',
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                ),
              ),
              Text(
                'Invalid Credentials',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                ),
              )
            ]),
      );
    },
  );
}
