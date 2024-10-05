import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/book_model.dart';
import 'package:test_e_library/provider/book_provider.dart';
import 'package:test_e_library/sqlite/db_helper.dart';
import 'package:test_e_library/view/pdf_screen.dart';

class DetailBook extends ConsumerWidget {
  VoidCallback updateState;
  DetailBook({super.key, required this.updateState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedBook = ref.watch(bookProvider);
    final Completer<PDFViewController> _controller =
        Completer<PDFViewController>();
    // int? pages = 0;
    int? currentPage = 0;
    // bool isReady = false;
    // String errorMessage = '';

    final title = TextEditingController();
    final author = TextEditingController();
    final desc = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Detail Book',
          style: GoogleFonts.montserrat(),
        ),
        bottom: PreferredSize(
            preferredSize: const Size(1, 1),
            child: Container(
              height: 1,
              color: ColorApp().indigoGrey,
            )),
        leading: InkWell(
          onTap: () {
            updateState();
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorApp().indigoGrey,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        width: 2,
                                        color: ColorApp().preussianBlue)),
                                width: 120,
                                height: 160,
                                child: PDFView(
                                  filePath: selectedBook.pdfPath,
                                  enableSwipe: false,
                                  pageFling: false,
                                  defaultPage: 0,
                                  onError: (error) {
                                    print(error);
                                  },
                                  onPageError: (page, error) {
                                    print('$page: ${error.toString()}');
                                  },
                                  // onViewCreated: (PDFViewController pdfViewController) {
                                  //   _controller.complete(pdfViewController);
                                  // },
                                )
                                // child: const Icon(Icons.book)

                                ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedBook.title,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(selectedBook.author,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                      )),

                                  // Text(selectedBook.,
                                  //     style: GoogleFonts.montserrat(
                                  //       fontSize: 20,
                                  //     )),
                                  // const SizedBox(
                                  //   height: 30,
                                  // ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorApp().indigoGrey,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () async {
                                                DatabaseHelper db =
                                                    DatabaseHelper();

                                                try {
                                                  await db.toggleFavorite(
                                                      selectedBook.id!,
                                                      !selectedBook.isFavorite);
                                                } catch (e) {
                                                  print(e);
                                                } finally {
                                                  ref
                                                      .read(
                                                          bookProvider.notifier)
                                                      .updateFavorite(
                                                          !selectedBook
                                                              .isFavorite);
                                                  print(
                                                      selectedBook.isFavorite);
                                                  // await db.
                                                  // if (selectedBook.isFavorite ==
                                                  //     false) {
                                                  //   ref
                                                  //       .read(bookProvider
                                                  //           .notifier)
                                                  //       .updateFavorite(true);
                                                  // } else {
                                                  //   ref
                                                  //       .read(bookProvider
                                                  //           .notifier)
                                                  //       .updateFavorite(false);
                                                  // }
                                                }

                                                // ref.read(bookProvider.notifier)
                                              },
                                              child: Icon(
                                                selectedBook.isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorApp().preussianBlue,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            1.5,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Edit Book',
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    title,
                                                                decoration:
                                                                    InputDecoration(
                                                                        // label: Text('Email'),
                                                                        // labelText: 'Email',
                                                                        hintText:
                                                                            'Title',
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        filled:
                                                                            true,
                                                                        prefixIcon:
                                                                            const Icon(Icons
                                                                                .book),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: ColorApp().indigoGrey),
                                                                            borderRadius: BorderRadius.circular(10))),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    author,
                                                                decoration:
                                                                    InputDecoration(
                                                                        // label: Text('Email'),
                                                                        // labelText: 'Email',
                                                                        hintText:
                                                                            'Author',
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        filled:
                                                                            true,
                                                                        prefixIcon:
                                                                            const Icon(Icons
                                                                                .person),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: ColorApp().indigoGrey),
                                                                            borderRadius: BorderRadius.circular(10))),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextField(
                                                                maxLines: 5,
                                                                controller:
                                                                    desc,
                                                                decoration:
                                                                    InputDecoration(
                                                                        // label: Text('Email'),
                                                                        // labelText: 'Email',
                                                                        hintText:
                                                                            'Description',
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                width:
                                                                                    1,
                                                                                color: ColorApp()
                                                                                    .indigoGrey),
                                                                            borderRadius: BorderRadius.circular(
                                                                                10)),
                                                                        filled:
                                                                            true,
                                                                        // prefixIcon: Icon(Icons.description),
                                                                        fillColor:
                                                                            Colors
                                                                                .white,
                                                                        border: OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(width: 1, color: ColorApp().indigoGrey),
                                                                            borderRadius: BorderRadius.circular(10))),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: ColorApp()
                                                                                .indigoGrey,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    10))),
                                                                        onPressed:
                                                                            () async {
                                                                          DatabaseHelper
                                                                              db =
                                                                              DatabaseHelper();

                                                                          Book updateBook = Book(
                                                                              id: selectedBook.id,
                                                                              addedBy: selectedBook.addedBy,
                                                                              title: title.text.isEmpty ? selectedBook.title : title.text,
                                                                              author: author.text.isEmpty ? selectedBook.author : author.text,
                                                                              description: desc.text.isEmpty ? selectedBook.description : desc.text,
                                                                              isFavorite: selectedBook.isFavorite,
                                                                              pdfPath: selectedBook.pdfPath);

                                                                          try {
                                                                            await db.updateBook(updateBook);
                                                                          } catch (e) {
                                                                            print(e);
                                                                          } finally {
                                                                            ref.read(bookProvider.notifier).updateAuthor(updateBook.author);
                                                                            ref.read(bookProvider.notifier).updateTitle(updateBook.title);
                                                                            ref.read(bookProvider.notifier).updateDescription(updateBook.description);
                                                                            // ref.read(bookProvider.notifier).updateSelectedBook(updateBook);
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'Save',
                                                                          style: GoogleFonts.montserrat(
                                                                              fontSize: 16,
                                                                              color: Colors.white),
                                                                        )),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.white,
                                                                            shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: ColorApp().indigoGrey), borderRadius: BorderRadius.circular(10))),
                                                                        onPressed: () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                          'Cancel',
                                                                          style: GoogleFonts.montserrat(
                                                                              fontSize: 16,
                                                                              color: ColorApp().indigoGrey),
                                                                        )),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        // const SizedBox(
                        //   height: 60,
                        // ),
                        // ExpansionTile(
                        //     title: Text(
                        //   'Descripiton',
                        // )),
                      ],
                    ),
                  ),
                  ExpansionTile(
                    collapsedShape: Border.symmetric(
                        horizontal: BorderSide(
                            width: 1, color: ColorApp().lapisLazuli)),
                    // shape: Border.symmetric(
                    //     vertical:
                    //         BorderSide(width: 1, color: ColorApp().indigoGrey),
                    //     horizontal:
                    //         BorderSide(width: 1, color: ColorApp().indigoGrey)),
                    shape: RoundedRectangleBorder(
                        side:
                            BorderSide(width: 1, color: ColorApp().indigoGrey),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10))),
                    title: Text(
                      'Description',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                      ),
                    ),
                    children: [
                      Container(
                        // height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10))
                            // borderRadius: const BorderRadius.vertical(
                            //     bottom: Radius.circular(10))
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: selectedBook.description.isEmpty
                              ? Text(
                                  'No Decription For This Book',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  selectedBook.description,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Preview : ',
                    style: GoogleFonts.montserrat(fontSize: 20),
                  ),
                  Container(
                    // color: Colors.grey.shade400,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: ColorApp().indigoGrey)),
                    height: 500,
                    width: double.infinity,
                    child: PDFView(
                      filePath: selectedBook.pdfPath,
                      enableSwipe: false,
                      swipeHorizontal: false,
                      defaultPage: currentPage,
                      pageFling: true,
                      pageSnap: true,
                      onError: (error) {
                        print(error);
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _controller.complete(pdfViewController);
                      },
                      onPageChanged: (page, total) {
                        print('page change: $page/$total');
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorApp().indigoGrey,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PDFScreen(
                      path: selectedBook.pdfPath, title: selectedBook.title),
                ));
              },
              child: Text(
                'Start Read Book',
                style: GoogleFonts.montserrat(
                    color: ColorApp().preussianBlue, fontSize: 20),
              )),
        ),
      ),
    );
  }
}
