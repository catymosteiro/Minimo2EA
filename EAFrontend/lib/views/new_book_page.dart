import 'package:ea_frontend/views/widgets/new_book.dart';
import 'package:flutter/material.dart';

import '../localization/language_constants.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NewBookPage',
        home: Scaffold(
          backgroundColor: const Color.fromARGB(124, 247, 202, 111),
          appBar: AppBar(
            title: Text(getTranslated(context, "newBook")!),
            centerTitle: true,
          ),
          body: const NewBook(),
        ));
  }
}
