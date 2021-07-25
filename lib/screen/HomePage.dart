import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_map/util/MarkerGenerator.dart';
import 'package:web_map/model/Meals.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String _mapStyle;
  @override
  void initState() {
    _add();
    rootBundle.loadString('assets/dark_map_style.json').then((string) {
      _mapStyle = string;
    });
    super.initState();

  }



  void _add() async {
    final ImageCropper image = ImageCropper();
    for (int i = 0; i < MEALS_DATA.length; i++) {
        final MarkerId markerId = MarkerId(MEALS_DATA[i].id);
        final Marker marker = Marker(
          markerId: markerId,
          position: LatLng(
              MEALS_DATA[i].lat,
              MEALS_DATA[i].long
          ),
          icon: await image.resizeAndCircle(MEALS_DATA[i].image,150),
          infoWindow: InfoWindow(
              title: MEALS_DATA[i].name,
              snippet: MEALS_DATA[i].deis),
          onTap: () {
          },
        );
        if (this.mounted)
          setState(() {
            markers[markerId] = marker;
          });
      }
  }





  double zoomVal = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildGoogleMap(context),
           Column(children: [
             _zoomplusfunction(),
             _zoomminusfunction()
           ],),
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  Widget _zoomminusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchMinus, color: Colors.white),
          onPressed: () {
            zoomVal--;
            _minus(zoomVal);
          }),
    );
  }

  Widget _zoomplusfunction() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(FontAwesomeIcons.searchPlus, color: Colors.white),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }

  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
          itemCount: MEALS_DATA.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final  Meals meals = MEALS_DATA[index];
            return _boxes(meals);
          },
        ),
      ),
    );
  }

  Widget _boxes(Meals meals) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(meals.lat, meals.long);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: FittedBox(
          child: Material(
              color: Color(0xFF3B3B3B),
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0xFF383737),
              child: Row(
                children: [
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24)),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(meals.image),
                      ),
                    ),
                  ),
                  Container(
                    width: 340,
                    height: 200,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 4),
                    child: myDetailsContainer1(meals),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(Meals meals) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            child: Text(
              meals.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      meals.rating.toString(),
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    )),
                SizedBox(
                  width: 8,
                ),
                RatingBar.builder(
                  initialRating: meals.rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  updateOnDrag: false,
                  ignoreGestures: true,
                  itemSize: 35,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) =>
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 10,
                      ),
                  onRatingUpdate: (double value) {},
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                    child: Text(
                      "(${meals.numberOrders})",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    )),
              ],
            )),
        Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              meals.deis,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            )),
        Container(
            margin: EdgeInsets.only(top: 8),
            child: Text(
              "Closed 12:54  Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:
        CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(_mapStyle);
        },
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}




