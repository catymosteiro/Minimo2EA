import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:ea_frontend/views/widgets/calendar.dart';
import 'package:ea_frontend/views/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../new_book_page.dart';
import 'new_book.dart';

class EventList extends StatefulWidget {
  final Function? setMainComponent;
  const EventList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(id);
  }

  getDate(DateTime d) {
    String date = "${d.day}/${d.month}/${d.year}";
    return Text(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).indicatorColor,
                      onPressed: () {
                        widget.setMainComponent!(BuildMap(
                          modo: "UserEvent",
                          setMainComponent: widget.setMainComponent,
                        ));
                      },
                      tooltip: getTranslated(context, "goMap"),
                      child: const Icon(Icons.map),
                    ),
                    const SizedBox(
                      width:
                          15.0, //Esto es solo para dar cierto margen entre los FAB
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).indicatorColor,
                      onPressed: () {
                        widget.setMainComponent!(BuildCalendar(
                          modo: "UserEvent",
                          setMainComponent: widget.setMainComponent,
                        ));
                      },
                      tooltip: getTranslated(context, "goCalendar"),
                      child: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(
                      width:
                          15.0, //Esto es solo para dar cierto margen entre los FAB
                    ),
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).iconTheme.color,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewBook()),
                        );
                        log('createEvent');
                      },
                    ),
                  ]),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.events.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  widget.setMainComponent!(EventPage(
                                    elementId: snapshot.data?.events[index].id,
                                    setMainComponent: widget.setMainComponent,
                                  ));
                                },
                                leading: const FlutterLogo(size: 56.0),
                                title: Text(snapshot.data?.events[index].name),
                                subtitle: getDate(snapshot
                                    .data?.events[index].eventDate as DateTime),
                                //trailing: Icon(Icons.more_vert),
                              ),
                            );
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
