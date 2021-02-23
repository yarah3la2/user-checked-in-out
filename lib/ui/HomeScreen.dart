import 'package:Task/ui/widgets/CommonAlert.dart';
import 'package:Task/utilies/constants.dart';
import 'package:Task/utilies/storageUtilies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geo_firestore/geo_firestore.dart';

enum UserMode { SIGNEDIN, SIGNEDOUT }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Firestore _firestore = Firestore.instance;
  GeoFirestore _geoFirestore;
  Sharedpref _sharedpref = new Sharedpref();
  bool _isCheckedIn = false;

  @override
  void initState() {
    getDeviceCurrentLocation();
    _setOfficeLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      backgroundColor: WHITE,
      body: Center(
        child: Text("Welome to the office"),
      ),
    ));
  }

  _setOfficeLocation() async {
    _geoFirestore = GeoFirestore(_firestore.collection('places'));
    final queryLocation =
        GeoPoint(37.7853889, -122.4056973); //set office location
    final List<DocumentSnapshot> documents =
        await _geoFirestore.getAtLocation(queryLocation, 0.6);
    _checkUserState(documents);
  }

  _checkUserState(List<DocumentSnapshot> documents) {
    documents.forEach((document) {
      if (!_isCheckedIn &&
          _sharedpref.read(USER_CURRENT_LOCATION_KEY_LAT) ==
              document.data["Latitude"] &&
          _sharedpref.read(USER_CURRENT_LOCATION_KEY_LONG) ==
              document.data["Longitude"])
        _userCheckedInAction();
      else if (_isCheckedIn &&
          !(_sharedpref.read(USER_CURRENT_LOCATION_KEY_LAT) ==
                  document.data["Latitude"] &&
              _sharedpref.read(USER_CURRENT_LOCATION_KEY_LONG) ==
                  document.data["Longitude"])) _userCheckedOutAction();
    });
  }

  _userCheckedInAction() {
    setState(() {
      _isCheckedIn = true;
    });
    ShowAlertMessage(CHECK_IN_MESSAGE, context, UserMode.SIGNEDIN);
  }

  _userCheckedOutAction() {
    setState(() {
      _isCheckedIn = false;
    });
    ShowAlertMessage(CHECK_OUT_MESSAGE, context, UserMode.SIGNEDOUT);
  }

//---- location helping methods -------
  Future<void> getDeviceCurrentLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    List<double> locationDataList = [];

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    _sharedpref.save(USER_CURRENT_LOCATION_KEY_LAT, _locationData.latitude);
    _sharedpref.save(USER_CURRENT_LOCATION_KEY_LONG, _locationData.longitude);
    print(
        "current location lat ===${_locationData.latitude} longt=== ${_locationData.longitude} ");
    return;
  }
}
