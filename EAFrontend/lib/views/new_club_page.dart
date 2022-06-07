import 'package:ea_frontend/views/widgets/new_club.dart';
import 'package:flutter/material.dart';

import '../localization/language_constants.dart';

class NewClubPage extends StatelessWidget {
  const NewClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NewClubPage',
        home: Scaffold(
          backgroundColor: const Color.fromARGB(124, 247, 202, 111),
          appBar: AppBar(
            title: Text(getTranslated(context, "newClub")!),
            centerTitle: true,
          ),
          body: const NewClub(),
        ));
  }
}
