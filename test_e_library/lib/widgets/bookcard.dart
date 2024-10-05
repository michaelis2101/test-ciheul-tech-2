import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/sqlite/db_helper.dart';

class BookCard extends StatefulWidget {
  VoidCallback updateState;
  VoidCallback updateList;
  String title;
  String path;
  int id;
  BookCard(
      {super.key,
      required this.title,
      required this.path,
      required this.updateState,
      required this.updateList,
      required this.id});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  int pageIndex = 0;
  // Uint8List? image;

  // void renderCover() async {
  //   final pdf = PdfImageRendererPdf(path: widget.path);
  //   await pdf.open();
  //   final size = await pdf.getPageSize(pageIndex: 0);
  //   final img = await pdf.renderPage(
  //     pageIndex: pageIndex,
  //     x: 0,
  //     y: 0,
  //     width: size.width, // you can pass a custom size here to crop the image
  //     height: size.height, // you can pass a custom size here to crop the image
  //     scale: 1, // increase the scale for better quality (e.g. for zooming)
  //     background: Colors.white,
  //   );
  //   await pdf.closePage(pageIndex: 0);

  //   // close the PDF after rendering the page
  //   pdf.close();

  //   // use setState to update the renderer
  //   setState(() {
  //     image = img!;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // renderCover();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.updateState();
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 200,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delete Books?',
                      style: GoogleFonts.montserrat(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorApp().indigoGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () async {
                              DatabaseHelper db = DatabaseHelper();
                              try {
                                await db.deleteBook(widget.id);
                              } catch (e) {
                                print(e);
                              } finally {
                                // widget.updateState();
                                widget.updateList();
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Yes',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                // backgroundColor: ColorApp().indigoGrey,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: ColorApp().indigoGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, color: ColorApp().indigoGrey),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 150,
        width: 100,
        // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        // decoration: BoxDecoration(color: Colors.pink),
        child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PDFView(
                    filePath: widget.path,
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
                  ),
                ),
              ),
              // Positioned(
              //     bottom: 10,
              //     left: 10,
              //     child: Text(
              //       widget.title,
              //       style: GoogleFonts.montserrat(
              //         fontSize: 13,
              //       ),
              //     )),
              Positioned(
                bottom: 5,
                left: 10,
                child: Container(
                  // width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  // color: Colors.black54,
                  child: Text(
                    widget.title,
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      // begin: Alignment.top,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 10,
                child: Container(
                  width: 100,
                  // height: 200,

                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  // color: Colors.black54,
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () async {
                    // showDialog(context: context, builder: builder);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            height: 200,
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Delete Books?',
                                  style: GoogleFonts.montserrat(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorApp().indigoGrey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                        onPressed: () async {
                                          DatabaseHelper db = DatabaseHelper();
                                          try {
                                            await db.deleteBook(widget.id);
                                          } catch (e) {
                                            print(e);
                                          } finally {
                                            // widget.updateState();
                                            widget.updateList();
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          'Yes',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              color: Colors.white),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            // backgroundColor: ColorApp().indigoGrey,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: ColorApp().indigoGrey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              color: ColorApp().indigoGrey),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    // color: Colors.black,
                    decoration: BoxDecoration(
                        color: ColorApp().indigoGrey,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          // bottomRight: Radius.circular(10),
                        )
                        // shape: RoundedRectangleBorder()
                        ),
                    height: 30,
                    width: 30,
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // child: PopupMenuButton<String>(
                //   icon: const Icon(Icons.more_horiz_outlined),
                //   shape: CircleBorder(
                //       side:
                //           BorderSide(width: 0.5, color: ColorApp().indigoGrey)),
                //   // color: Colors.pink,

                //   itemBuilder: (context) => [
                //     PopupMenuItem(
                //       value: 'delete',
                //       child: ListTile(
                //         leading: const Icon(Icons.delete),
                //         title: Text(
                //           'Delete',
                //           style: GoogleFonts.montserrat(
                //               color: ColorApp().indigoGrey),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
              ),
            ]),
      ),
    );
  }
}
