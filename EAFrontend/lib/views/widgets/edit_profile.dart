import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/author.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/author_service.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/questionnaire.dart';
import 'package:ea_frontend/views/provider/theme_provider.dart';
import 'package:ea_frontend/views/widgets/writer_add_book.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:email_validator/email_validator.dart';
import '../settings_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String idUser;
  var author;
  var storage;
  var isEditing = false;
  String biograpy = "";
  TextEditingController _textFieldController = TextEditingController();

  TextEditingController controllerName = TextEditingController(text: 'Name');
  TextEditingController controllerUserName =
      TextEditingController(text: 'userName');
  TextEditingController controllerMail = TextEditingController(text: 'mail');
  TextEditingController controllerBiography =
      TextEditingController(text: 'biography');

  String controllerBirthDay = "";
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idUser = LocalStorage('BookHub').getItem('userId');
    author = await AuthorService.getAuthor(idUser);
    if (author.runtimeType == Author) {
      LocalStorage('BookHub').setItem('idAuthor', author.id);
    }

    return UserService.getUser(idUser);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            controllerName.text = snapshot.data!.name;
            controllerUserName.text = snapshot.data!.userName;
            controllerMail.text = snapshot.data!.mail;
            controllerBirthDay = snapshot.data!.birthDate.toString();
            if (author.runtimeType == Author) {
              controllerBiography.text = author.biography;
            } else {
              author == null;
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Edit Profile",
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => const SettingPage());
                    Navigator.pop(context, route);
                  },
                ),
              ),
              body: Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).shadowColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                    ))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).shadowColor,
                                ),
                                color: Colors.green,
                              ),
                              child: InkWell(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    print("change photo");
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    buildData(snapshot),
                    const SizedBox(
                      height: 35,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).backgroundColor),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 60)),
                      ),
                      child: Text(
                        getTranslated(context, 'configCategories')!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Questionnaire()));
                      }
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    (isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                child: Text(getTranslated(context, 'returnToHome')!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (controllerName.value.text.isNotEmpty &&
                                      controllerUserName
                                          .value.text.isNotEmpty &&
                                      EmailValidator.validate(
                                          controllerMail.value.text)) {
                                    var response = await UserService.updateUser(
                                        idUser,
                                        controllerName.text,
                                        controllerUserName.text,
                                        controllerMail.text,
                                        controllerBirthDay);

                                    if (author != null &&
                                        controllerBiography
                                            .value.text.isNotEmpty) {
                                      var response2 =
                                          await AuthorService.updateAuthor(
                                              author.id,
                                              controllerName.text,
                                              controllerBiography.text,
                                              controllerBirthDay,
                                              author.deathDate.toString(),
                                              author.photoURL);
                                    }

                                    if (response) {
                                      setState(() {
                                        isEditing = false;
                                      });
                                    }
                                  } else {
                                    String error = "Se ha producido un error";
                                    controllerName.text.isEmpty
                                        ? error = "Name empty"
                                        : null;
                                    controllerUserName.text.isEmpty
                                        ? error = "userName empty"
                                        : null;
                                    !EmailValidator.validate(
                                            controllerMail.text)
                                        ? error = getTranslated(context, 'mailError')!
                                        : null;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(error),
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                                child: Text(
                                  getTranslated(context, 'accept')!,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          )
                        : Container(
                            height: 10,
                          )),
                    SizedBox(
                      height: 35,
                    ),
                    (author == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSeparator(),
                              Container(
                                height: 40,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.green,
                                ),
                                child: InkWell(
                                    child: Row(
                                      children: [
                                        Text("Author information"),
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Enter your biography'),
                                              content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: TextFormField(
                                                  maxLines: 10,
                                                  maxLength: 1000,
                                                  strutStyle: StrutStyle(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      biograpy = value;
                                                    });
                                                  },
                                                  controller:
                                                      _textFieldController,
                                                  decoration: InputDecoration(
                                                      hintText: "My life..."),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  color: Colors.green,
                                                  textColor: Colors.white,
                                                  child: Text('OK'),
                                                  onPressed: () async {
                                                    String category = snapshot
                                                        .data!
                                                        .categories[0]
                                                        .name!;
                                                    for (int i = 1;
                                                        i <
                                                            snapshot
                                                                .data!
                                                                .categories
                                                                .length;
                                                        i++) {
                                                      category = category +
                                                          "," +
                                                          snapshot
                                                              .data!
                                                              .categories[i]
                                                              .name!;
                                                    }
                                                    await AuthorService
                                                        .postAuthor(
                                                            idUser,
                                                            snapshot.data!.name,
                                                            biograpy,
                                                            snapshot.data!.mail,
                                                            snapshot
                                                                .data!.birthDate
                                                                .toString(),
                                                            snapshot
                                                                .data!.birthDate
                                                                .toString(),
                                                            category,
                                                            snapshot.data!
                                                                .photoURL);
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                              ),
                              _buildSeparator()
                            ],
                          )
                        : buildDataAuthor()),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }

  Widget buildData(AsyncSnapshot<User> snapshot) {
    return Column(
      children: [
        buildEdit(getTranslated(context, 'name')!, controllerName),
        buildEdit(getTranslated(context, 'username')!, controllerUserName),
        buildEdit(getTranslated(context, 'mail')!, controllerMail),
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'dd/MM/yyyy',
            initialValue: snapshot.data!.birthDate.toString(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            icon: const Icon(Icons.event),
            dateLabelText: getTranslated(context, 'birthDate')!,
            onSaved: (val) => controllerBirthDay = val!,
            onChanged: (val) => {
              controllerBirthDay = val,
              (!isEditing)
                  ? setState(() {
                      isEditing = true;
                    })
                  : null
            },
            onFieldSubmitted: (val) => controllerBirthDay = val,
          ),
        )
      ],
    );
  }

  Widget buildDataAuthor() {
    return Column(
      children: [
        _buildSeparatorBig(),
        buildEditBig("Biography", controllerBiography),
        Text("Books"),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: booksList(),
            )),
        ElevatedButton(
          onPressed: () async {
            bool response = await AuthorService.deleteAuthor(author.id);
            if (response) {
              setState(() {
                fetchUser();
              });
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: Text(
            "Delete author",
            style: TextStyle(
                fontSize: 14, letterSpacing: 2.2, color: Colors.white),
          ),
        ),
        Container(
          height: 10,
        )
      ],
    );
  }

  List<Widget> booksList() {
    List<Widget> list = [];
    author.books.forEach((element) {
      list.add(buildBook(
          element.title,
          element.publishedDate.day.toString() +
              "/" +
              element.publishedDate.month.toString() +
              "/" +
              element.publishedDate.year.toString(),
          element.id));
    });
    list.add(InkWell(
        onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddBook()))
            },
        child: Container(
          width: 300,
          height: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: const Icon(Icons.add),
          ),
        )));
    return list;
  }

  Widget buildBook(String title, String published, String bookId) {
    return Container(
        width: 300,
        height: 150,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Text(title),
                subtitle: Text("Published Date: " + published),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(onPressed: () => {}, child: Text('Edit')),
                  Container(
                    width: 30,
                  ),
                  ElevatedButton(
                    child: Text("Delete"),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete book?'),
                        content: const Text(
                            'Permanently delete or change the author to anonymous?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => {
                              BookService.deleteBook(bookId),
                              Navigator.pop(context, 'Delete'),
                              setState(() {})
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () => {
                              AuthorService.deleteBook(bookId, author.id),
                              Navigator.pop(context, 'Anonymous'),
                              setState(() {
                                fetchUser();
                              })
                            },
                            child: const Text("Anonymous"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        onTap: () {
          (!isEditing)
              ? setState(() {
                  isEditing = true;
                })
              : null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget buildEditBig(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        maxLines: 10,
        maxLength: 1000,
        strutStyle: StrutStyle(),
        onTap: () {
          (!isEditing)
              ? setState(() {
                  isEditing = true;
                })
              : null;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }

  Widget _buildSeparatorBig() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }
}
