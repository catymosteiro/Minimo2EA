import 'dart:developer';
import 'package:ea_frontend/routes/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/book.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../routes/user_service.dart';

class BookPage extends StatefulWidget {
  final String? elementId;

  const BookPage({
    Key? key,
    this.elementId,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<Comment> commentList = List.empty(growable: true);
  bool _nocomments = true;

  String userid = "";
  final titleController = TextEditingController();
  final textController = TextEditingController();
  String typeController = "";
  List<dynamic> usersController = List.empty(growable: true);
  dynamic likesController = "0";
  dynamic dislikesController = "0";
  String idBook = "";

  void initState() {
    super.initState();
    fetchBook();
    getCommentsList();
    fetchUser();
  }

  Future<Book> fetchBook() async {
    return BookService.getBook(widget.elementId!);
  }

  Future<void> getCommentsList() async {
    idBook = widget.elementId!;
    typeController = idBook;
    commentList =
        (await CommentService.getCommentByType(idBook)).cast<Comment>();
    setState(() {
      if (commentList.length != 0) {
        _nocomments = false;
      }
    });
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    userid = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(userid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: SingleChildScrollView(
                    child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        snapshot.data!.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: stars(snapshot.data!.rate),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: FittedBox(
                          fit: BoxFit.fill, // otherwise the logo will be tiny
                          child: FlutterLogo(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data!.writer.name,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'description')! +
                            ' : ' +
                            snapshot.data!.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'specs')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'publishDate')! +
                            ': ' +
                            snapshot.data!.publishedDate.day.toString() +
                            "-" +
                            snapshot.data!.publishedDate.month.toString() +
                            "-" +
                            snapshot.data!.publishedDate.year.toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'editorial')! +
                            ': ' +
                            snapshot.data!.editorial,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTranslated(context, 'categories')! + ': ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < snapshot.data!.category.length; i++)
                        (Text(
                          snapshot.data?.category[i].name + "  ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'comments')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 150.0,
                          child: _nocomments
                              ? Column(
                                  children: [
                                    Text(getTranslated(context, 'noComments')!),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: commentList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CommentItem(
                                      commentList[index].user,
                                      commentList[index].title,
                                      commentList[index].text,
                                      commentList[index].type,
                                      commentList[index].users,
                                      commentList[index].likes,
                                      commentList[index].dislikes,
                                      index,
                                    );
                                  }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context, 'addComment')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, "fieldRequired");
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "title")!,
                            hintText: getTranslated(context, "writeTheTitle"),
                            border: OutlineInputBorder()),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: textController,
                        maxLines: 4,
                        maxLength: 300,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, "fieldRequired");
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "text")!,
                            hintText: getTranslated(context, "writeTheText"),
                            border: OutlineInputBorder()),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      getTranslated(context, "addNewComment")!,
                      textScaleFactor: 1,
                    ),
                    onPressed: () async {
                      print("Add new comment");
                      var response = await CommentService.addComment(Comment(
                          user: userid,
                          title: titleController.text,
                          text: textController.text,
                          type: typeController,
                          users: usersController,
                          likes: likesController,
                          dislikes: dislikesController));
                      if (response == "200") {
                        print("New comment added");
                        setState(() {
                          getCommentsList();
                          titleController.text = "";
                          textController.text = "";
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(response.toString()),
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )));
          } else if (snapshot.hasError) {
            print(snapshot);
            log(snapshot.error.toString());
            print(snapshot.error);
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }

  Widget CommentItem(dynamic user, String title, String text, String type,
      List<dynamic> users, String likes, String dislikes, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.person_outline_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        user.userName + ': ' + title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(text),
    );
  }

  stars(int rate) {
    List<Widget> lista = [];
    int i = 0;
    for (i; i < ((rate / 2) - 0.1).round(); i++) {
      lista.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    // No funciona el detectar si es par convencional asi que esto
    if (rate.isOdd) {
      i++;
      lista.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    for (i; i < 5; i++) {
      lista.add(const Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    return lista;
  }
}
