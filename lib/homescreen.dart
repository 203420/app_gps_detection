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
  bool _isLoading = true;

  void initState() {
    requestLocationPermission();
    super.initState();
  }

  void requestLocationPermission() async {
    final permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
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
          _isLoading = false;
        });
      });
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(83, 158, 158, 158)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.pin_drop,
                              size: 30,
                            ),
                            Text(
                              "Fake GPS Detector",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text("Ubicación falsa: $isMock"),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  if (_isLoading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Detectando ubicación...'),
                        ],
                      ),
                    ),
                  if (!_isLoading)
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Ubicación detectada:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isMock == null || isMock == false
                                      ? Colors.green
                                      : Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              child: Icon(
                                isMock == null || isMock == false
                                    ? Icons.check
                                    : Icons.close,
                                color: isMock == null || isMock == false
                                    ? Colors.green
                                    : Colors.red,
                                size: 50,
                              ),
                            ),
                          ),
                          Text(
                            isMock == null || isMock == false
                                ? "No se detectó ninguna modificación del GPS"
                                : "Se detectó una modificación del GPS",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Column(
                children: const [
                  Text(
                    'Hiram Lache Toledo',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    'Alan Alberto Gómez Gómez',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    'Francisco Omar Franco Espinosa',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
