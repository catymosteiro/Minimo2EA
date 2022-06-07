import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/event.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';

import '../../models/location.dart';
import '../event_page.dart';

class BuildMap extends StatefulWidget {
  final Function? setMainComponent;
  final String? eventId;
  final String? modo;
  final Location? center;
  const BuildMap(
      {Key? key, this.modo, this.center, this.setMainComponent, this.eventId})
      : super(key: key);

  @override
  State<BuildMap> createState() => _BuildMapState();
}

class _BuildMapState extends State<BuildMap> {
  final PopupController _popupController = PopupController();
  List<Marker> markers = [];
  List<dynamic> _events = [];
  int pointIndex = 0;
  LatLng centerPoint = LatLng(0.0, 0.0);
  List points = [];
  Future<bool> getEvents() async {
    if (widget.modo == "UserEvent") {
      //Get events user
      String id = LocalStorage('BookHub').getItem('userId');
      _events = (await UserService.getUser(id)).events;
    } else {
      //Get all events
      _events = await EventService.getEvents();
    }
    _events.forEach((element) {
      Event event = element;
      points.add(LatLng(event.location.latitude, event.location.longitude));
      markers.add(Marker(
        anchorPos: AnchorPos.align(AnchorAlign.center),
        height: 30,
        width: 30,
        point: LatLng(event.location.latitude, event.location.longitude),
        builder: (ctx) => const Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ));
    });
    if (widget.center == null) {
      centerPoint = points[0];
    } else {
      centerPoint = LatLng(widget.center!.latitude, widget.center!.longitude);
    }
    if (_events != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getEvents(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startTop,
              floatingActionButton: (widget.center != null)
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
              body: FlutterMap(
                options: MapOptions(
                  center: centerPoint,
                  zoom: 5,
                  maxZoom: 15,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                  onTap: (_, __) => _popupController
                      .hideAllPopups(), // Hide popup when the map is tapped.
                ),
                children: <Widget>[
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      spiderfyCircleRadius: 80,
                      spiderfySpiralDistanceMultiplier: 2,
                      circleSpiralSwitchover: 12,
                      maxClusterRadius: 120,
                      rotate: true,
                      size: Size(40, 40),
                      anchor: AnchorPos.align(AnchorAlign.center),
                      fitBoundsOptions: const FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                        maxZoom: 5,
                      ),
                      markers: markers,
                      polygonOptions: const PolygonOptions(
                          borderColor: Colors.blueAccent,
                          color: Colors.black12,
                          borderStrokeWidth: 3),
                      popupOptions: PopupOptions(
                          popupSnap: PopupSnap.markerTop,
                          popupController: _popupController,
                          popupBuilder: (_, marker) => Container(
                                width: 200,
                                height: 100,
                                child: GestureDetector(
                                  onTap: () => debugPrint('Popup tap!'),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Theme.of(context).backgroundColor),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: ListTile(
                                      title: Text(
                                        _events[markers.indexOf(marker)].name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                          _events[markers.indexOf(marker)]
                                                  .eventDate
                                                  .day
                                                  .toString() +
                                              "-" +
                                              _events[markers.indexOf(marker)]
                                                  .eventDate
                                                  .month
                                                  .toString() +
                                              "-" +
                                              _events[markers.indexOf(marker)]
                                                  .eventDate
                                                  .year
                                                  .toString(),
                                          style:
                                              TextStyle(color: Colors.black)),
                                      onTap: () {
                                        widget.setMainComponent!(EventPage(
                                            setMainComponent:
                                                widget.setMainComponent,
                                            elementId:
                                                _events[markers.indexOf(marker)]
                                                    .id));
                                      },
                                    ),
                                  ),
                                ),
                              )),
                      builder: (context, markers) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.cyan),
                          child: Center(
                            child: Text(
                              markers.length.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
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
