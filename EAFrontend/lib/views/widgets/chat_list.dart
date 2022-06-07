import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'new_chat.dart';

class ChatList extends StatefulWidget {
  final Function? setMainComponent;
  const ChatList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(id);
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
                    MaterialPageRoute(builder: (context) => NewChat()),
                  );
                  log('createChat');
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  if (widget.setMainComponent != null) {
                                    widget.setMainComponent!(ChatPage(
                                        snapshot.data?.chats[index].id, id));
                                  }
                                },
                                leading: FlutterLogo(size: 56.0),
                                title: Text(snapshot.data?.chats[index].name),
                                subtitle: Text('this will be the last message'),
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
