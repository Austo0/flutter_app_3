import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class bluetoothPage extends StatefulWidget {
  bluetoothPage({Key? key}) : super(key: key);



  @override
  State<bluetoothPage> createState() => _bluetoothPageState();
}

class _bluetoothPageState extends State<bluetoothPage> {
  // Add instances
 static const DEVICE_SERIVE_ID = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
 static const DEVICE_TX_CHAR_ID = '6E400002-B5A3-F393-E0A9-E50E24DCCA9E';

  FlutterBlue flutterBlue = FlutterBlue.instance;
  // final StreamSubscription<ScanResult> scanSubscription;
  List<ScanResult> scanResults = <ScanResult>[];
  List<BluetoothService> services = <BluetoothService>[];
  BluetoothDevice? _device = null; // Selected BLE device
  late BluetoothCharacteristic characteristic;
  late ScanResult selectedDevice;
  int _connectionState = 0; // 0 = connected, 1 = connected, 2 = connecting

  BluetoothDevice? _connectedDevice = null; // Connected BLE device

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Connect to Device'),
        elevation: 2.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Message Sent')));
              // Reads all characteristics
              List<int> value;
              // Reads all characteristics
              var characteristics = services[2].characteristics;
              for (BluetoothCharacteristic c in characteristics) {
                value = await c.read();
                print(value);
              }
              // if(service == "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
              //   {
              //     service.([0x12, 0x34]);
              //   };
              // });

              // await c.write([0x12, 0x34])
            },
          ),
        ],
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
        SizedBox(
          height: 100.0,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Connected\nDevice:', textAlign: TextAlign.left),
                ),
                Expanded(
                  child: Text('${_device?.name}\n${_device?.id}',
                      textAlign: TextAlign.left),
                ),
                Expanded(
                  child: Text(
                    _connectionState == 0
                        ? 'Disconnected'
                        : _connectionState == 1
                            ? 'Connected'
                            : _connectionState == 2
                                ? 'Connecting'
                                : 'null',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: scanResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Device: ${scanResults[index].device.name}'),
                  subtitle: Text('MAC: ${scanResults[index].device.id}'),
                  onTap: () async {
                    setState(()  {
                      // _device?.disconnect();
                      selectedDevice = scanResults[index];
                      getService(context);
                      // _connectionState = 2; // Indicate connecting
                      // // Connect to the device
                      // await _device!.connect();
                      // services.clear();
                      // services = (await _device?.discoverServices())!;
                      // services?.forEach((service) async {
                      //   print('Service::: ${service.uuid}');
                      // });
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
                      Text(_connectionState == 0
                          ? 'Disconnected'
                          : _connectionState == 1
                              ? 'Connected'
                              : _connectionState == 2
                                  ? 'Connecting'
                                  : 'null')
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

  void getService(BuildContext context) async {
    try{
      await selectedDevice.device.disconnect();
      await selectedDevice.device.connect().timeout(Duration(seconds: 10),onTimeout: (){print('Failed to connect');});

      var services = await selectedDevice.device.discoverServices();
      var uartService = services.firstWhere((service) => service.uuid.toString().toUpperCase()==DEVICE_SERIVE_ID);

      if(uartService == null)
        {
          print('UART Service Not Found');
        }
      else
        {
          print('Service::: ${uartService.uuid}');
        }

      BluetoothCharacteristic txChar = uartService.characteristics.firstWhere((char) => char.uuid.toString().toUpperCase() == DEVICE_TX_CHAR_ID);
      try
      {
        print('Characteristic::: ${txChar.uuid}');
       await txChar.write([0x48,0x69]);
      }
      catch (e)
      {

      }


    }
    catch (e)
    {
      print(e);
    }

  }
}
