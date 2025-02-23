import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/constants/theme.dart';

class AllowedDevicesScreen extends StatefulWidget {
  @override
  _AllowedDevicesScreenState createState() => _AllowedDevicesScreenState();
}

class _AllowedDevicesScreenState extends State<AllowedDevicesScreen> {
  final String documentId = "8WXiFeYoRC0NCxCOkPhe"; // Firestore document ID
  final CollectionReference deviceCollection =
  FirebaseFirestore.instance.collection('LeaderDevices');

  // Toggle "isAllowed" for a specific device
  Future<void> toggleDeviceStatus(int index, bool currentStatus, List devices) async {
    try {
      // Update the device's "isAllowed" status in Firestore
      devices[index]['isAllowed'] = !currentStatus;

      await deviceCollection.doc(documentId).update({
        'items': devices, // Update the entire list
      });
    } catch (e) {
      print("Error updating device status: $e");
    }
  }
  GetStorage  box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Faol qurilmalar"),
      ),
      body:  StreamBuilder<DocumentSnapshot>(
        stream: deviceCollection.doc(documentId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("No devices found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final devices = List<Map<String, dynamic>>.from(data['items'] ?? []);

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              final name = device['brand'] ?? "Unknown Device";
              final model = device['model'] ?? "Unknown Device";
              final id = device['id'] ?? "Unknown Device";
               final isAllowed = device['isAllowed'] ?? false;

              return box.read('app_id') ==  id  ? SizedBox(): Container(
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: ListTile(
                   title:  Row(children: [Text(name),Text(   " ( $model )",style: TextStyle(color: Colors.grey,fontSize: 12),)],) ,
                  subtitle: Text("ID: ${device['id']}"),



                  trailing: CupertinoSwitch(
                    trackColor: Colors.red,
                    onLabelColor: Colors.green,
                    value: isAllowed,
                    onChanged: (newValue) {
                      toggleDeviceStatus(index, isAllowed, devices);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
