import 'dart:async';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event.dart';

class BuildCalendar extends StatefulWidget {
  final Function? setMainComponent;
  final String? eventId;
  final String? modo;
  const BuildCalendar(
      {Key? key, this.modo, this.setMainComponent, this.eventId})
      : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  List<dynamic> _events = [];
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  Future<void> getEvents() async {
    if (widget.modo == "UserEvent") {
      //Get events user
      String id = LocalStorage('BookHub').getItem('userId');
      _events = (await UserService.getUser(id)).events;
    } else {
      //Get all events
      _events = await EventService.getEvents();
      if (widget.modo != "AllEvents") {
        focusedDay =
            DateTime.parse(widget.modo!.split(' ')[0] + " 00:00:00.000Z");
        selectedDay = focusedDay;
      }
    }
    _events.forEach((element) {
      if (selectedEvents[DateTime.parse(
              element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")] !=
          null) {
        selectedEvents[DateTime.parse(
                element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")]
            ?.add(element);
      } else {
        selectedEvents[DateTime.parse(
            element.eventDate.toString().split(" ")[0] + " 00:00:00.000Z")] = [
          element
        ];
      }
    });
    setState(() {});
    _getEventsfromDay(selectedDay);
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton:
            (widget.modo != "AllEvents" && widget.modo != "UserEvents")
                ? FloatingActionButton(
                    backgroundColor: const Color.fromARGB(202, 255, 255, 255),
                    onPressed: () {
                      widget.setMainComponent!(EventPage(
                        setMainComponent: widget.setMainComponent,
                        elementId: widget.eventId,
                      ));
                    },
                    child: const Icon(Icons.arrow_back),
                  )
                : null,
        body: SingleChildScrollView(
            child: Column(children: [
          (widget.modo != "AllEvents" && widget.modo != "UserEvents")
              ? const Padding(padding: EdgeInsets.only(top: 40))
              : const Padding(padding: EdgeInsets.zero),
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                print("1");
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = DateTime.parse(selectDay.toString());
                focusedDay = focusDay;
              });
              _getEventsfromDay(selectDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              markerDecoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).indicatorColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ..._getEventsfromDay(selectedDay)
              .map(
                (Event event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(event.name),
                    subtitle: Text(getTranslated(context, "description")! +
                        ": " +
                        event.description),
                    onTap: () {
                      widget.setMainComponent!(EventPage(
                          setMainComponent: widget.setMainComponent,
                          elementId: event.id));
                    },
                  ),
                ),
              )
              .toList()
        ])));
  }
}
