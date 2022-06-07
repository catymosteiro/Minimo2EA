import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/views/chat_page.dart';
import 'package:ea_frontend/views/help.dart';
import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/settings_page.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class WebLayout extends StatefulWidget {
  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  Widget mainComponent = Home();
  @override
  void initState() {
    super.initState();
    mainComponent = Home(setMainComponent: setMainComponent);
  }

  setMainComponent(Widget component) {
    setState(() {
      mainComponent = component;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Image.asset(
            "public/logowhite.png",
            fit: BoxFit.contain,
            height: 64,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                setState(() {
                  mainComponent = Home(setMainComponent: setMainComponent);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Profile and App settings',
              onPressed: () {
                setState(() {
                  mainComponent = SettingPage();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Help',
              onPressed: () {
                setState(() {
                  mainComponent = Help();
                });
              },
            )
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Row(children: <Widget>[
            SizedBox(
              width: 4 * constraints.maxWidth / 5,
              child: mainComponent,
            ),
            SizedBox(
                width: constraints.maxWidth / 5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        getTranslated(context, 'chatTitle')!,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          //   color: Colors.red,
                          height: constraints.maxHeight / 3.5,
                          width: constraints.maxWidth / 5,
                          child: ChatList(
                            setMainComponent: setMainComponent,
                          )),
                      Text(
                        getTranslated(context, 'eventTitle')!,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          height: constraints.maxHeight / 3.5,
                          width: constraints.maxWidth / 5,
                          //    color: Colors.blue,
                          child: EventList(
                            setMainComponent: setMainComponent,
                          )),
                      Text(
                        getTranslated(context, 'clubTitle')!,
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          height: constraints.maxHeight / 3.5,
                          width: constraints.maxWidth / 5,
                          //   color: Colors.green,
                          child: ClubList(
                            setMainComponent: setMainComponent,
                          ))
                    ]))
          ]);
        }));
  }
}
