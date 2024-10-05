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

class SearchScreen extends ConsumerStatefulWidget {
  SearchScreen({super.key});

  @override
  createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Future<List<Book>>? books;
  final TextEditingController _searchController = TextEditingController();
  int uid = 0;

  void searchBooks() async {
    DatabaseHelper dbhelp = DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt('uid')!;

    if (userid != 0) {
      setState(() {
        uid = userid;
      });
    }

    try {
      // List<Book> bk = await dbhelp.searchBooks(_searchController.text);
      List<Book> bk = await dbhelp.searchBooks(_searchController.text, userid);
      // int bkid = await dbhelp.getOneBook()
      print(userid);
      setState(() {
        books = Future.value(bk); // Set the books future after fetching
      });
    } catch (e) {
      print(e);
      setState(() {
        books =
            Future.error("Failed to fetch books"); // Handle errors in future
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  // final search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var selectedBook = ref.watch(bookProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorApp().celestialBlue,
          title: SizedBox(
            height: 40,
            width: double.infinity,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                hintStyle: GoogleFonts.montserrat(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorApp().preussianBlue),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: ColorApp().preussianBlue),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  searchBooks();
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      color: ColorApp().lapisLazuli,
                      border: Border.all(color: ColorApp().preussianBlue),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    'Search',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  )),
                ),
              ),
            )
          ],
        ),
        body: FutureBuilder<List<Book>>(
            future: books, // Provide the initialized Future to FutureBuilder
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorApp().preussianBlue,
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
                        'assets/search.svg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Divider(),
                    Text(
                      'No Book Found',
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      // print(bookList[index].isFavorite);
                      return BookCard(
                        updateList: () {
                          // getBooks();
                          searchBooks();
                          // setState(() {});
                        },
                        updateState: () async {
                          try {
                            DatabaseHelper dbhelp = DatabaseHelper();
                            // int bkid = await dbhelp.get
                            ref
                                .read(bookProvider.notifier)
                                .updateSelectedBook(bookList[index]);
                            // var selectedBook;
                            // print(selectedBook.isFavorite);
                          } catch (e) {
                            print(e);
                          } finally {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailBook(
                                updateState: () {
                                  // getBooks();
                                  searchBooks();
                                },
                              ),
                            ));
                          }
                        },
                        title: bookList[index].title,
                        path: bookList[index].pdfPath,
                        id: bookList[index].id!,
                      );
                      // if (bookList[index].addedBy == uid.toString()) {
                      //   return BookCard(
                      //     updateList: () {
                      //       // getBooks();
                      //       searchBooks();
                      //       // setState(() {});
                      //     },
                      //     updateState: () async {
                      //       try {
                      //         DatabaseHelper dbhelp = DatabaseHelper();
                      //         // int bkid = await dbhelp.get
                      //         ref
                      //             .read(bookProvider.notifier)
                      //             .updateSelectedBook(bookList[index]);
                      //         // var selectedBook;
                      //         // print(selectedBook.isFavorite);
                      //       } catch (e) {
                      //         print(e);
                      //       } finally {
                      //         Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (context) => DetailBook(
                      //             updateState: () {
                      //               // getBooks();
                      //               searchBooks();
                      //             },
                      //           ),
                      //         ));
                      //       }
                      //     },
                      //     title: bookList[index].title,
                      //     path: bookList[index].pdfPath,
                      //     id: bookList[index].id!,
                      //   );
                      // }
                    },
                  ),
                );
              }
            }));
  }
}
