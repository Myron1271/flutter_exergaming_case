import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_poc_gyroscope/auth.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {  
  double? _lastPeakTime = 0;
  int _jumpingJackCount = 0;
  List<double>? _accelerometerValues;

  final double _threshold = 15.0;
  final double _minInterval = 1.0;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _detectJumpingJack(event.z);
         _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    });
  }

  void _detectJumpingJack(double zValue) {
    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    
    //Dit kan een mogelijkheid zijn om te zeggen dat dit nep is:
    if (zValue.abs() > _threshold && zValue.abs() < 17 ) {
      if (currentTime - (_lastPeakTime ?? 0) > _minInterval) {        
        _jumpingJackCount++;
        _lastPeakTime = currentTime;
      }
    }
    // Algoritme valsspelen aan te pakken
    // if (yValue.abs() > _cheatingThreshold) {
    //   if (currentTime - (_lastPeakTime ?? 0) > _minInterval) {        
    //     _jumpingJackCount--;
    //     _lastPeakTime = currentTime;
    //   }
    // }
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Account Page");
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text("Sign Out"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: _title()),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Jumping Jacks Counted: $_jumpingJackCount' ' \n ' 'Accelerometer: $accelerometer'),   
            const Text("Welcome!"),
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
