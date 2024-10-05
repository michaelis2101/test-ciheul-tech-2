import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/user_model.dart';
import 'package:test_e_library/sqlite/db_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final pw = TextEditingController();
  final repw = TextEditingController();

  bool isHide = false;
  bool reIsHide = false;

  Future<List<UserModel>> getUser() async {
    DatabaseHelper dbhelp = DatabaseHelper();

    List<UserModel> user = await dbhelp.getAllUser();

    print(user.length);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorApp().celestialBlue,
          automaticallyImplyLeading: false,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(10)),
                color: ColorApp().indigoGrey),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: ColorApp().celestialBlue),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Please Sign Up,',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                  Text(
                    'To Use The App',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/signup.svg',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  Text(
                    'Username',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                        // label: Text('Email'),
                        // labelText: 'Email',
                        hintText: 'Username',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorApp().indigoGrey),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
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
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Repeat Password',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: repw,
                    obscureText: reIsHide,
                    decoration: InputDecoration(
                        // label: Text('Email'),
                        // labelText: 'Email',
                        hintText: 'Repeat Password',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: ColorApp().indigoGrey),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        prefixIcon: Icon(Icons.password),
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                reIsHide = !reIsHide;
                              });
                            },
                            child: Icon(reIsHide
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined)),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
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
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          DatabaseHelper dbhelp = DatabaseHelper();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => const SignUp(),
                          // ));
                          // print(getUser());
                          try {
                            UserModel newuser =
                                UserModel(username.text, pw.text);
                            await dbhelp.createNewUser(newuser);

                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      // color: ColorApp().indigoGrey,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10))),
                                  height: 200,
                                  width: double.infinity,
                                  // color: ColorApp().preussianBlue,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Success',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              color: ColorApp().indigoGrey,
                                              fontSize: 20),
                                        ),
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 60,
                                        ),
                                        Text(
                                          'Please Login to Continue',
                                          style: GoogleFonts.montserrat(
                                              // fontWeight: FontWeight.bold,
                                              color: ColorApp().indigoGrey,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } catch (e) {
                          } finally {}
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
            ),
          ),
        ));
  }
}
