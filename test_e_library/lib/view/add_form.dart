import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_e_library/classes/colors_collention.dart';
import 'package:test_e_library/model/book_model.dart';
import 'package:test_e_library/sqlite/db_helper.dart';

class AddFormPage extends StatefulWidget {
  VoidCallback updateList;
  AddFormPage({super.key, required this.updateList});

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  TextEditingController title = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController description = TextEditingController();

  String filepath = '';
  String filename = '';
  int userid = 0;

  void getuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userid = prefs.getInt('uid') ?? 0;
    });
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      return;
    }

    setState(() {
      filepath = result.files.first.path!;
      filename = result.files.first.name;
    });

    print('path: $filepath');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Add New Book',
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorApp().indigoGrey,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: GoogleFonts.montserrat(
                      // color: Colors.,
                      fontSize: 20),
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      // label: Text('Email'),
                      // labelText: 'Email',
                      hintText: 'Title',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      prefixIcon: Icon(Icons.book),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Author',
                  style: GoogleFonts.montserrat(
                      // color: Colors.,
                      fontSize: 20),
                ),
                TextField(
                  controller: author,
                  decoration: InputDecoration(
                      // label: Text('Email'),
                      // labelText: 'Email',
                      hintText: 'Autohr',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Description',
                  style: GoogleFonts.montserrat(
                      // color: Colors.,
                      fontSize: 20),
                ),
                TextField(
                  maxLines: 5,
                  controller: description,
                  decoration: InputDecoration(
                      // label: Text('Email'),
                      // labelText: 'Email',
                      hintText: 'Description',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      // prefixIcon: Icon(Icons.description),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: ColorApp().indigoGrey),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select File',
                      style: GoogleFonts.montserrat(
                          // color: Colors.,
                          fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () async {
                          pickFile();
                          print(filepath);
                          setState(() {});
                        },
                        icon: filepath.isEmpty
                            ? const Icon(Icons.add)
                            : const Icon(Icons.edit))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      filename,
                      style: GoogleFonts.montserrat(
                          // color: Colors.,
                          fontSize: 15),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 13.0),
                    //   child: Icon(Icons.highlight_remove_outlined),
                    // )
                    if (filepath.isNotEmpty)
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              filepath = '';
                              filename = '';
                            });
                          },
                          icon: Icon(Icons.highlight_remove_outlined))
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        userid = prefs.getInt('uid')!;
                        DatabaseHelper db = DatabaseHelper();
                        if (userid != 0) {
                          Book newBook = Book(
                              addedBy: userid.toString(),
                              title: title.text,
                              author: author.text,
                              description: description.text.isEmpty
                                  ? ''
                                  : description.text,
                              pdfPath: filepath);

                          try {
                            int numm = await db.insertBook(newBook);
                            print('num : $numm');
                            print(userid);
                            // var books = await db.getAllBooks(userid);
                            // print(books[0].title);

                            Navigator.pop(context);
                            showSuccess(context);
                          } catch (e) {
                            print(e);
                          } finally {
                            widget.updateList();
                            // Navigator.pop(context);
                            title.clear();
                            author.clear();
                            description.clear();
                            setState(() {
                              filepath = '';
                              filename = '';
                            });
                          }

                          // await db.
                          // print(userid);
                        }
                      },
                      child: Text(
                        'Save Book',
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
      ),
    );
  }
}

void showSuccess(BuildContext ctx) {
  showModalBottomSheet(
    context: ctx,
    builder: (context) {
      return Container(
          decoration: BoxDecoration(
              color: ColorApp().indigoGrey,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          height: 200,
          width: double.infinity,
          // color: ColorApp().indigoGrey,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Success',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            )
          ]));
    },
  );
}
