import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/book_model.dart';
import 'package:test_e_library/provider/book_provider.dart';
import 'package:test_e_library/sqlite/db_helper.dart';
import 'package:test_e_library/view/add_form.dart';
import 'package:test_e_library/view/book_detail.dart';
import 'package:test_e_library/widgets/bookcard.dart';

class ExploreLibrary extends ConsumerStatefulWidget {
  ExploreLibrary({super.key});

  @override
  createState() => ExploreLibraryState();
}

class ExploreLibraryState extends ConsumerState<ExploreLibrary> {
  Future<List<Book>>? books;
  int bookid = 0;

  void getBooks() async {
    DatabaseHelper dbhelp = DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt('uid')!;

    try {
      List<Book> bk = await dbhelp.getAllBooks(userid);
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
    getBooks();

    // getBooksFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    var selectedBook = ref.watch(bookProvider);

    return Scaffold(
      // backgroundColor: Colors.pink,
      appBar: AppBar(
        backgroundColor: ColorApp().lapisLazuli,
        title: Text(
          'Explore',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder<List<Book>>(
        future: books, // Provide the initialized Future to FutureBuilder
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
                  'No Book Registered',
                  style: GoogleFonts.montserrat(fontSize: 18),
                ),
                Text(
                  'Add book By Button Below',
                  style: GoogleFonts.montserrat(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp().lapisLazuli,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return AddFormPage(
                              updateList: () {
                                getBooks();
                              },
                            );
                          },
                        ));
                      },
                      child: Text(
                        'Add New Book',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.white),
                      )),
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
                      getBooks();
                      setState(() {});
                    },
                    updateState: () async {
                      try {
                        DatabaseHelper dbhelp = DatabaseHelper();
                        // int bkid = await dbhelp.get
                        ref
                            .read(bookProvider.notifier)
                            .updateSelectedBook(bookList[index]);
                        print(selectedBook.isFavorite);
                      } catch (e) {
                        print(e);
                      } finally {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailBook(
                            updateState: () {
                              getBooks();
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
            // return ListView.builder(
            //   itemCount: bookList.length,
            //   itemBuilder: (context, index) {
            //     var book = bookList[index];
            //     return ListTile(
            //       onTap: () {
            //         ref.read(bookProvider.notifier).updateSelectedBook(book);
            //         print(selectedBook.isFavorite);
            //         Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => const DetailBook(),
            //         ));
            //       },
            //       leading: Icon(Icons.book_rounded),
            //       title: Text(
            //         book.title,
            //         style: GoogleFonts.montserrat(
            //             color: ColorApp().indigoGrey,
            //             fontWeight: FontWeight.w600),
            //       ),
            //       subtitle: Text(
            //         'Author : ${book.author}',
            //         style: GoogleFonts.montserrat(
            //           color: ColorApp().indigoGrey,
            //         ),
            //       ),
            //       shape: Border.symmetric(
            //           horizontal:
            //               BorderSide(width: 1, color: ColorApp().indigoGrey)),
            //     );
            //   },
            // );
          }
        },
      ),
      // body: FutureBuilder<List<Book>>(
      //   future: books,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(
      //           color: ColorApp().indigoGrey,
      //         ),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Text('Something Went Wrong : ${snapshot.error} '),
      //       );
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return const Center(
      //         child: Text('No Book Available'),
      //       );
      //     } else {
      //       List<Book> bookList = snapshot.data!;
      //       return GridView.builder(
      //         itemCount: bookList.length,
      //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 2,
      //             childAspectRatio: 3 / 4,
      //             crossAxisSpacing: 2,
      //             mainAxisSpacing: 2),
      //         itemBuilder: (context, index) {
      //           return BookCard(title: bookList[index].title);
      //         },
      //       );
      //       // return ListView.builder(
      //       //   itemCount: bookList.length,
      //       //   itemBuilder: (context, index) {
      //       //     return ListTile(
      //       //       title: Text(bookList[index].title),
      //       //       subtitle: Text(bookList[index].author),
      //       //     );
      //       //   },
      //       // );
      //     }
      //   },
      // ),

      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AddFormPage(
                  updateList: () {
                    getBooks();
                  },
                );
              },
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              color: ColorApp().indigoGrey,
            ),
            height: 60,
            width: 60,
            child: const Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        // child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10)),
        //         backgroundColor: ColorApp().celestialBlue),
        //     onPressed: () {},
        //     child: const Icon(
        //       Icons.add,
        //       color: Colors.white,
        //     )),
      ),
    );
  }
}
