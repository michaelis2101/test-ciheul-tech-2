import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/book_model.dart';
import 'package:test_e_library/provider/book_provider.dart';
import 'package:test_e_library/sqlite/db_helper.dart';
import 'package:test_e_library/view/book_detail.dart';
import 'package:test_e_library/widgets/bookcard.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  FavoriteScreen({super.key});

  @override
  createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  Future<List<Book>>? books;
  int bookid = 0;

  void getFavoritess() async {
    DatabaseHelper dbhelp = DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt('uid')!;

    try {
      List<Book> bk = await dbhelp.getFavoriteBooks(userid);
      // int bkid = await dbhelp.getOneBook()
      print(userid);
      setState(() {
        books = Future.value(bk);
      });
    } catch (e) {
      print(e);
      setState(() {
        books = Future.error("Failed to fetch books");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavoritess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorApp().lapisLazuli,
          title: Text(
            'Favorites',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: FutureBuilder<List<Book>>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorApp().indigoGrey,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something Went Wrong: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/empty.svg',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Divider(),
                  Text(
                    'No Favorites Book',
                    style: GoogleFonts.montserrat(fontSize: 18),
                  ),
                ],
              );
            } else {
              List<Book> bookList = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: bookList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    print(bookList[index].isFavorite);
                    return BookCard(
                      updateList: () {
                        getFavoritess();
                        setState(() {});
                      },
                      updateState: () async {
                        try {
                          DatabaseHelper dbhelp = DatabaseHelper();
                          // int bkid = await dbhelp.get
                          ref
                              .read(bookProvider.notifier)
                              .updateSelectedBook(bookList[index]);
                          // print(selectedBook.isFavorite);
                        } catch (e) {
                          print(e);
                        } finally {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailBook(
                              updateState: () {
                                getFavoritess();
                              },
                            ),
                          ));
                        }
                      },
                      title: bookList[index].title,
                      path: bookList[index].pdfPath,
                      id: bookList[index].id!,
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
