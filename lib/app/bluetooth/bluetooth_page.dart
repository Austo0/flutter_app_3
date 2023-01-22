import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class bluetoothPage extends StatefulWidget {
  bluetoothPage({Key? key}) : super(key: key);
  @override
  State<bluetoothPage> createState() => _bluetoothPageState();
}

class _bluetoothPageState extends State<bluetoothPage> {
  // Add instances
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // final StreamSubscription<ScanResult> scanSubscription;
  List<ScanResult> scanResults = <ScanResult>[];
  BluetoothDevice? _device = null; // Selected BLE device
  int _connectionState = 0; // 0 = connected, 1 = connected, 2 = connecting

  BluetoothDevice? _connectedDevice = null; // Connected BLE device

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Connect to Device'),
        elevation: 2.0,
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ),
    );
  }

  final List<String> entries = const <String>['A', 'B', 'C'];
  final List<int> colorCodes = const <int>[600, 500, 100];
  Widget _buildContent() {
    return Column(

      children: <Widget>[

        SizedBox(height: 48.0, width: double.infinity,
            child:Padding(padding: EdgeInsets.all(15),
             child: Text('Connected Device:',textAlign: TextAlign.left,),),),

        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Device: ${scanResults[index].device.name}'),
                  subtitle: Text('MAC: ${scanResults[index].device.id}'),
                  onTap: () async {
                    setState(() async {
                      _device = scanResults[index].device;
                      _connectionState = 2; // Indicate connecting
                      // Connect to the device
                      //await _device!.connect();
                    });
                  },
                  trailing: _device != null &&
                          _device!.id == scanResults[index].device.id
                      ?
                      // Icon(
                      //   Icons.check,
                      //   color: Colors.green,
                      //
                      // )
                      Text("Connecting...")
                      : null,
                );
              }),
        ),
      ],
    );
  }

  void startScan() {
    scanResults.clear();

    // Listen to scan results
    flutterBlue.scan(timeout: Duration(seconds: 6)).listen((scanResult) {
      // do something with scan results

      // if(scanResult.device.name.startsWith("ESP"))
      // {
      scanResults.add(scanResult);
      setState(() {});
      // }
    });
  }
}
