import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/widgets/new_club.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ClubList extends StatefulWidget {
  final Function? setMainComponent;
  const ClubList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<ClubList> createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(id);
  }

  concatCategory(List<Category> categories) {
    String txt = "";
    categories.forEach((element) {
      txt = txt + element.name! + ", ";
    });
    return Text(txt);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).backgroundColor,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewClub()),
                  );
                  log('createClub');
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.clubs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: ListTile(
                                    onTap: () {
                                      widget.setMainComponent!(ClubPage(
                                          elementId:
                                              snapshot.data?.clubs[index].id));
                                    },
                                    leading: const FlutterLogo(size: 56.0),
                                    title:
                                        Text(snapshot.data?.clubs[index].name),
                                    subtitle: concatCategory(
                                        snapshot.data?.clubs[index].category)
                                    //trailing: Icon(Icons.more_vert),

                                    ));
                          }),
                    ),
                  ),
                ],
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
}
