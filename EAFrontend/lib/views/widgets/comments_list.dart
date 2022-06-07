import 'package:flutter/material.dart';
import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book_profile.dart';

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  BookService bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Return to dashboard'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildRowTitle(),
          const SizedBox(height: 50),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'AquiVaElComentario:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'AquiVaLaDate',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  //decoration: TextDecoration.underline
                ),
              ),
            ),
          ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fecha de publicación:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowTitle() {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const <Widget>[
        SizedBox(
          width: 20,
        ),
        Text(
          'UserName',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 310,
        ),
        Text(
          '4/5',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 36.0,
        ),
      ],
    );
  }
}
