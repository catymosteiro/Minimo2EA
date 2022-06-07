import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/models/event.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:ea_frontend/views/widgets/book_profile.dart';
import 'package:ea_frontend/views/widgets/calendar.dart';
import 'package:ea_frontend/views/widgets/club_card.dart';
import 'package:ea_frontend/views/widgets/event_card.dart';
import 'package:ea_frontend/views/widgets/map.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:textfield_search/textfield_search.dart';

import '../routes/club_service.dart';

class Home extends StatefulWidget {
  final Function? setMainComponent;
  const Home({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage('BookHub');
  ScrollController _controller = ScrollController();
  TextEditingController findBooksController = TextEditingController();
  TextEditingController findEventsController = TextEditingController();
  TextEditingController findClubsController = TextEditingController();

  List<Book> _books = [];
  bool _isLoadingBook = true;
  List<Event> _events = [];
  bool _isLoadingEvent = true;
  List<Club> _clubs = [];
  bool _isLoadingClub = true;

  @override
  void initState() {
    super.initState();
    getBooks();
    getEvents();
    getClubs();
    findBooksController.addListener(() => findBooks(findBooksController.text));
    findEventsController
        .addListener(() => findEvents(findEventsController.text));
    findClubsController.addListener(() => findClubs(findClubsController.text));
  }

  Future<void> getBooks() async {
    _books = await BookService.getBooks();
    setState(() {
      _isLoadingBook = false;
    });
  }

  Future<void> getEvents() async {
    _events = await EventService.getEvents();
    setState(() {
      _isLoadingEvent = false;
    });
  }

  Future<void> getClubs() async {
    _clubs = await ClubService.getClubs();
    setState(() {
      _isLoadingClub = false;
    });
  }

  String getStringCategories(List<dynamic> categories) {
    String output = "";
    for (var category in categories) {
      output = output + ", " + category.name;
    }
    return output.substring(1);
  }

  List<String> getBookNames() {
    List<String> list = [];
    for (var book in _books) {
      list.add(book.title);
    }
    return list;
  }

  List<String> getEventNames() {
    List<String> list = [];
    for (var event in _events) {
      list.add(event.name);
    }
    return list;
  }

  List<String> getClubNames() {
    List<String> list = [];
    for (var club in _clubs) {
      list.add(club.name);
    }
    return list;
  }

  void findBooks(String title) {
    for (int i = 0; i < _books.length; i++) {
      if (_books[i].title == title) {
        widget.setMainComponent!(BookPage(elementId: _books[i].id));
        findBooksController.text = "";
      }
    }
  }

  void findEvents(String name) {
    for (int i = 0; i < _events.length; i++) {
      if (_events[i].name == name) {
        widget.setMainComponent!(EventPage(
            setMainComponent: widget.setMainComponent,
            elementId: _events[i].id));
        findEventsController.text = "";
      }
    }
  }

  void findClubs(String name) {
    for (int i = 0; i < _clubs.length; i++) {
      if (_clubs[i].name == name) {
        widget.setMainComponent!(ClubPage(elementId: _clubs[i].id));
        findClubsController.text = "";
      }
    }
  }

  bool verifyAdminEvent(int index) {
    if(_events[index].admin.id == LocalStorage('BookHub').getItem('userId')) {
      return true;
    }
    else {
      return false;
    }
  }

  bool verifyAdminClub(int index) {
    if(_clubs[index].admin.id == LocalStorage('BookHub').getItem('userId')) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        getTranslated(context, 'interestBook')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Container(
                              width: 250,
                              child: TextFieldSearch(
                                initialList: getBookNames(),
                                label: getTranslated(context, "find")!,
                                controller: findBooksController,
                              ),
                            ),
                            const SizedBox(width: 25),
                          ],
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              MediaQuery.of(context).size.width < 1100
                  ? Container(
                      width: 250,
                      child: TextFieldSearch(
                        initialList: getBookNames(),
                        label: getTranslated(context, "find")!,
                        controller: findBooksController,
                      ),
                    )
                  : const SizedBox(height: 0),
              Container(
                height: 250,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: _isLoadingBook
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              color: Theme.of(context).backgroundColor,
                            ),
                            const SizedBox(height: 200),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: BookCard(
                                title: _books[index].title,
                                author: _books[index].writer.name,
                                rate: _books[index].rate.toString(),
                                imageUrl: _books[index].photoURL,
                              ),
                              onTap: () {
                                widget.setMainComponent!(
                                    BookPage(elementId: _books[index].id));
                              },
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        getTranslated(context, 'interestEvent')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Container(
                              width: 250,
                              child: TextFieldSearch(
                                initialList: getEventNames(),
                                label: getTranslated(context, "find")!,
                                controller: findEventsController,
                              ),
                            ),
                            const SizedBox(width: 25),
                          ],
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              MediaQuery.of(context).size.width < 1100
                  ? Container(
                      width: 250,
                      child: TextFieldSearch(
                        initialList: getEventNames(),
                        label: getTranslated(context, "find")!,
                        controller: findEventsController,
                      ),
                    )
                  : const SizedBox(height: 0),
              Container(
                height: 250,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: _isLoadingEvent
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              color: Theme.of(context).backgroundColor,
                            ),
                            const SizedBox(height: 200),
                          ],
                        )
                      : Stack(
                          children: [
                            ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: EventCard(
                                    title: _events[index].name,
                                    date:
                                        _events[index]
                                                .eventDate
                                                .day
                                                .toString() +
                                            "-" +
                                            _events[index]
                                                .eventDate
                                                .month
                                                .toString() +
                                            "-" +
                                            _events[index]
                                                .eventDate
                                                .year
                                                .toString(),
                                    numberUsers: _events[index]
                                        .usersList
                                        .length
                                        .toString(),
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
                                    admin: verifyAdminEvent(index),
                                  ),
                                  onTap: () {
                                    widget.setMainComponent!(EventPage(
                                        setMainComponent:
                                            widget.setMainComponent,
                                        elementId: _events[index].id));
                                  },
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.15, vertical: 15.15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton(
                                    backgroundColor:
                                        Theme.of(context).indicatorColor,
                                    onPressed: () {
                                      widget.setMainComponent!(BuildCalendar(
                                        modo: "AllEvents",
                                        setMainComponent:
                                            widget.setMainComponent,
                                      ));
                                    },
                                    tooltip:
                                        getTranslated(context, "goCalendar"),
                                    child: const Icon(Icons.calendar_today),
                                  ),
                                  const SizedBox(width: 5),
                                  FloatingActionButton(
                                    backgroundColor:
                                        Theme.of(context).indicatorColor,
                                    onPressed: () {
                                      widget.setMainComponent!(BuildMap(
                                        modo: "AllEvents",
                                        setMainComponent:
                                            widget.setMainComponent,
                                      ));
                                    },
                                    tooltip: getTranslated(context, "goMap"),
                                    child: const Icon(Icons.map),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      Text(
                        getTranslated(context, 'interestClub')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  MediaQuery.of(context).size.width >= 1100
                      ? Row(
                          children: [
                            Container(
                              width: 250,
                              child: TextFieldSearch(
                                initialList: getClubNames(),
                                label: getTranslated(context, "find")!,
                                controller: findClubsController,
                              ),
                            ),
                            const SizedBox(width: 25),
                          ],
                        )
                      : const SizedBox(width: 0),
                ],
              ),
              MediaQuery.of(context).size.width < 1100
                  ? Container(
                      width: 250,
                      child: TextFieldSearch(
                        initialList: getClubNames(),
                        label: getTranslated(context, "find")!,
                        controller: findClubsController,
                      ),
                    )
                  : const SizedBox(height: 0),
              Container(
                height: 250,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: _isLoadingClub
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              color: Theme.of(context).backgroundColor,
                            ),
                            const SizedBox(height: 200),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: _clubs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: ClubCard(
                                title: _clubs[index].name,
                                categories:
                                    getStringCategories(_clubs[index].category)
                                        .toString(),
                                numberUsers:
                                    _clubs[index].usersList.length.toString(),
                                imageUrl:
                                    "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
                                admin: verifyAdminClub(index),
                              ),
                              onTap: () {
                                widget.setMainComponent!(
                                    ClubPage(elementId: _clubs[index].id));
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
