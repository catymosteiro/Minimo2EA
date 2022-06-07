import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/new_book_page.dart';
import 'package:ea_frontend/views/new_club_page.dart';
import 'package:ea_frontend/views/settings_page.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/localization/language_constants.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Widget mainComponent = Home();
  setMainComponent(Widget component) {
    setState(() {
      mainComponent = component;
      pageController.jumpToPage(5);
      appBarTitle = getTranslated(context, component.toString())!;
    });
  }

  final LocalStorage storage = LocalStorage('BookHub');
  int _selectedIndex = 0;
  PageController pageController = PageController();
  String appBarTitle = 'Home';
  var views = ["Home", "Club", "Event", "Chat", "Perfil"];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = views[index];
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appBarTitle = getTranslated(context, "home")!;
    views = [
      getTranslated(context, "home")!,
      getTranslated(context, "clubTitle")!,
      getTranslated(context, "eventTitle")!,
      getTranslated(context, "chatTitle")!,
      getTranslated(context, "profile")!
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
          automaticallyImplyLeading: false),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: getTranslated(context, 'home')!),
            BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: getTranslated(context, 'clubTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.event),
                label: getTranslated(context, 'eventTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.chat),
                label: getTranslated(context, 'chatTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.face),
                label: getTranslated(context, 'profile')!)
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).backgroundColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          selectedIconTheme: Theme.of(context).iconTheme,
          unselectedIconTheme: Theme.of(context).iconTheme,
          onTap: onTapped),
      body: PageView(controller: pageController, children: [
        Home(setMainComponent: setMainComponent),
        ClubList(setMainComponent: setMainComponent),
        EventList(setMainComponent: setMainComponent),
        ChatList(setMainComponent: setMainComponent),
        SettingPage(),
        mainComponent,
      ]),
    );
  }
}
