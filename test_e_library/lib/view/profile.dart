import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/user_model.dart';
import 'package:test_e_library/sqlite/db_helper.dart';
import 'package:test_e_library/view/carousellogin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '...';
  int uid = 0;

  void getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseHelper db = DatabaseHelper();
    int userid = prefs.getInt('uid')!;

    try {
      List<UserModel> user = await db.getLoggedUser(userid);

      setState(() {
        username = user[0].username!;
        uid = userid;
      });
    } catch (e) {
      print(e);
      setState(() {
        username = '...';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorApp().preussianBlue,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: 150,
                    height: 150,
                    child: SvgPicture.asset(
                      'assets/avatar.svg',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    username,
                    style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    'uid: $uid',
                    style: GoogleFonts.montserrat(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        // color: ColorApp().indigoGrey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Are You Sure Want To Logout?',
                              style: GoogleFonts.montserrat(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            width: 1,
                                            color: ColorApp().indigoGrey)),
                                    child: Text(
                                      'No',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          color: ColorApp().indigoGrey),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        side: BorderSide(
                                            width: 1, color: Colors.green)),
                                    child: Text(
                                      'Yes',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      await prefs.remove('uid');
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CarouselLogin()),
                                        (Route<dynamic> route) => false,
                                      );
                                      // Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                shape: Border.symmetric(
                    horizontal:
                        BorderSide(width: 1, color: ColorApp().indigoGrey)),
                trailing: Icon(
                  Icons.logout_outlined,
                  color: ColorApp().indigoGrey,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.montserrat(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}
