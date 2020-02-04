import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapPageRoute extends CupertinoPageRoute {
  MapPageRoute() : super(builder: (BuildContext context) => new MapPage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new MapPage());
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapState createState() {
    return _MapState();
  }
}

class _MapState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(17.445109, 78.349782);

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(_mapStyle);
    _controller.complete(controller);
  }

  int _cIndex = 2;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
    if (_cIndex == 0) {
      Navigator.of(context).pushNamed('/events');
    } else if (_cIndex == 1) {
      Navigator.of(context).pushNamed('/home');
    }
  }

  static MarkerId markerId = MarkerId("1");

  final Set<Marker> _markers = {
    Marker(
      markerId: markerId,
      position: _center,
      infoWindow: InfoWindow(
        title: 'Custom Marker',
        snippet: 'Inducesmile.com',
      ),
    )
  };

  String _mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString("config/googlemap-config.txt").then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(
    //  appBar: AppBar(title: Text('Map')),
    // // body: Center(
    // // child: Text('hello'),
    // // ),
    // body: GoogleMap(
    return GoogleMap(
      markers: _markers,
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 20.0,
      ),
    );
  }
}

