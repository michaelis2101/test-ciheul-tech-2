import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/view/explore.dart';
import 'package:test_e_library/view/favorite.dart';
import 'package:test_e_library/view/profile.dart';
import 'package:test_e_library/view/search.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget> screens = [
    ExploreLibrary(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: BottomNavigationBar(
            backgroundColor: ColorApp().lapisLazuli,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            showUnselectedLabels: true,
            // selectedItemColor: ColorApp().lapisLazuli,
            // selectedIconTheme: IconThemeData(),
            unselectedLabelStyle: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.w600),
            selectedLabelStyle: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.w600),
            unselectedItemColor: Colors.white,
            currentIndex: index,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  activeIcon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.explore,
                      color: ColorApp().lapisLazuli,
                    ),
                  ),
                  icon: const Icon(Icons.explore),
                  label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  activeIcon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.search,
                      color: ColorApp().lapisLazuli,
                    ),
                  ),
                  label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  activeIcon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: ColorApp().lapisLazuli,
                    ),
                  ),
                  label: 'Favorite'),
              BottomNavigationBarItem(
                  activeIcon: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: ColorApp().lapisLazuli,
                    ),
                  ),
                  icon: Icon(Icons.person),
                  label: 'Profil'),
            ]),
      ),
      body: screens[index],
    );
  }
}
