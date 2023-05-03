import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? latitude;
  String? longitude;
  bool? isMock;

  void initState(){
    requestLocationPermission();
    super.initState();
  }


  void requestLocationPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      print("Si");
      TrustLocation.start(10);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  } 

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitude = result.latitude;
          longitude = result.longitude;
          isMock = result.isMockLocation;
        });
      });
    } catch (e) {
      print("error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Ubicación falsa: $isMock"
        ),
      ),
    );
  }
}