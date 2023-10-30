import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_n_tell/config.dart';
import 'package:go_n_tell/themecolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_n_tell/localization.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get icon => null;
  late Position position;
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        body: Stack(
          children: [
            const Mapwidget(),
            Positioned(
              child: Positioned(
                //constraints.biggest.height to get the height
                // * .05 to put the position top: 5%
                top: 25,
                left: 30,
                child: Container(
                  width: 100.0,
                  height: 80.0,
                  decoration: null,
                  child: const Image(
                      image: AssetImage('assets/img/Gontell_watermark.png')),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () => {},
          backgroundColor: getThemeColor(3, 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
              size: 80,
              color: getThemeColor(8, 1),
              Icons.travel_explore_outlined),
        ));
  }
}

class Mapwidget extends StatelessWidget {
  const Mapwidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late List<dynamic> closeMedia = [];
    final controller = MapTileLayerController();

    var mypos = MapLatLng(57, 13);

    Future<Position> getCurMapPos() async {
      try {
        final pos_ok = await requestPosition();
        if (pos_ok != null) {
          const LocationSettings locationSettings = LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 100,
          );
          StreamSubscription<Position> positionStream =
              Geolocator.getPositionStream(locationSettings: locationSettings)
                  .listen((Position? position) {
            if (position == null) {
              requestPosition();
            } else {
              position = position;
              mypos = MapLatLng(position.latitude, position.longitude);
            }
          });
          return pos_ok;
        } else {
          return pos_ok;
        }
      } on Exception catch (_) {
        return Position(
            longitude: 0,
            latitude: 0,
            accuracy: 0,
            timestamp: DateTime.now(),
            speed: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speedAccuracy: 0);
      }
    }

    void setMerkers() {
      controller.clearMarkers();
      for (final (index, item) in closeMedia.indexed) {
        var it = item[0];
        if (it != "error") {
          return;
        }
        closeMedia[index]["icon"] = IconButton(
            // Use the MdiIcons class for the IconData
            icon: Icon(MdiIcons.accountEye),
            onPressed: () {
              print('Using the sword');
            });
        controller.insertMarker(index);
      }
    }

    try {
      Api().get("/media/media-close-to-me/", null).then((data) => {
            closeMedia = data,
            if (closeMedia.isNotEmpty) {setMerkers()}
          });
    } on Exception catch (_) {
      return Container();
    }

    getCurMapPos();

    return SfMaps(
      key: const Key('main'),
      layers: [
        MapTileLayer(
          // initialFocalLatLng: myPos,
          initialZoomLevel: 15,
          zoomPanBehavior: MapZoomPanBehavior(
            enableDoubleTapZooming: true,
            showToolbar: true,
            maxZoomLevel: 20,
            minZoomLevel: 1,
            focalLatLng: mypos,
          ),
          urlTemplate:
              'https://c.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
          markerBuilder: (BuildContext context, int index) => MapMarker(
              latitude: closeMedia[index]["latlangtime"]["lat"],
              longitude: closeMedia[index]["latlangtime"]["lng"],
              child: closeMedia[index]["icon"]),
          controller: controller,
        ),
      ],
    );

    // return FutureBuilder<Position?>(
    //   future: getCurMapPos(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> positionData) {
    //     if (positionData.hasData) {
    //       return SfMaps(
    //         key: const Key('main'),
    //         layers: [
    //           MapTileLayer(
    //             // initialFocalLatLng: myPos,
    //             initialZoomLevel: 15,
    //             zoomPanBehavior: MapZoomPanBehavior(
    //               enableDoubleTapZooming: true,
    //               showToolbar: true,
    //               maxZoomLevel: 20,
    //               minZoomLevel: 1,
    //               focalLatLng: currentLocation,
    //             ),
    //             urlTemplate:
    //                 'https://c.basemaps.cartocdn.com/rastertiles/voyager_nolabels/{z}/{x}/{y}.png',
    //             markerBuilder: (BuildContext context, int index) => MapMarker(
    //                 latitude: closeMedia[index]["latlangtime"]["lat"],
    //                 longitude: closeMedia[index]["latlangtime"]["lng"],
    //                 child: closeMedia[index]["icon"]),
    //             controller: controller,
    //           ),
    //         ],
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }
}

class Marker {
  Widget build(BuildContext context) {
    return IconButton(
        // Use the MdiIcons class for the IconData
        icon: Icon(MdiIcons.sword),
        onPressed: () {
          print('Using the sword');
        });
  }
}
