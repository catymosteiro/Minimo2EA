import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import '../../localization/language_constants.dart';
import 'event_list.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key? key}) : super(key: key);

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final titleController = TextEditingController();
  final ISBNController = TextEditingController();
  final photoURLController = TextEditingController();
  final descriptionController = TextEditingController();
  final editorialController = TextEditingController();
  final writerController = TextEditingController();
  String categoryController = "";
  List<dynamic> categories = [];
  String publishedDateController = "";
  dynamic rateController = "0";

  @override
  Widget build(BuildContext context) {
    String category = "MYSTERY";

    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "newBook")!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.network(
                  "https://static.vecteezy.com/system/resources/previews/001/200/107/original/book-png.png",
                  height: 150),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "title")!,
                        hintText: getTranslated(context, "writeTheTitle"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: ISBNController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "ISBN"),
                        hintText: getTranslated(context, "writeTheISBN"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: writerController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "writer"),
                        hintText: getTranslated(context, "writeTheWriter"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: photoURLController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "photoURL"),
                        hintText: getTranslated(context, "writeThePhotoURL"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 8,
                    maxLength: 500,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "description"),
                        hintText: getTranslated(context, "writeTheDescription"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  dateMask: 'dd/MM/yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  icon: const Icon(Icons.event),
                  dateLabelText: getTranslated(context, "publishDate")!,
                  onSaved: (val) => publishedDateController = val!,
                  onChanged: (val) => publishedDateController = val,
                  onFieldSubmitted: (val) => publishedDateController = val,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: editorialController,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return getTranslated(context, "fieldRequired");
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                        labelText: getTranslated(context, "editorial"),
                        hintText: getTranslated(context, "writeTheEditorial"),
                        border: const OutlineInputBorder()),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: category,
                    items: [
                      DropdownMenuItem<String>(
                          value: 'SCI-FI',
                          child: Text(
                            'SCI-FI',
                            style: TextStyle(color: Theme.of(context).backgroundColor),
                          )),
                      DropdownMenuItem<String>(
                          value: 'MYSTERY',
                          child: Text('MYSTERY',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'THRILLER',
                          child: Text('THRILLER',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'ROMANCE',
                          child: Text('ROMANCE',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'WESTERN',
                          child: Text('WESTERN',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'DYSTOPIAN',
                          child: Text('DYSTOPIAN',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'CONTEMPORANY',
                          child: Text('CONTEMPORANY',
                              style: TextStyle(color: Theme.of(context).backgroundColor))),
                      DropdownMenuItem<String>(
                          value: 'FANTASY',
                          child: Text(
                            'FANTASY',
                            style: TextStyle(color: Theme.of(context).backgroundColor),
                          ))
                    ],
                    onChanged: (category) =>
                        categoryController = categoryController,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  getTranslated(context, "addNewBook")!,
                  textScaleFactor: 1,
                ),
                onPressed: () async {
                  /*
                  print("Add new book");

                  var response = await BookService.newBook(Book(
                      id: "",
                      title: titleController.text,
                      ISBN: ISBNController.text,
                      photoURL: photoURLController.text,
                      description: descriptionController.text,
                      editorial: editorialController.text,
                      writer: writerController.text,
                      category: categories,
                      publishedDate: DateTime.parse(publishedDateController),
                      rate: rateController));
                  if (response == "200") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventList()));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(response.toString()),
                        );
                      },
                    );
                  }*/
                },
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).backgroundColor,
                    onPrimary: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(40),
                          child: ElevatedButton(
                            child: const Text(
                              'Back',
                              textScaleFactor: 1,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EventList()),
                              );
                              print("backButton");
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).backgroundColor,
                                onPrimary: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ]),
            ],
          ),
        ));
  }
}
