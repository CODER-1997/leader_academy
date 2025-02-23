 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeviceChecker {


 static RxBool isAllowed = true.obs;
  static  addDevice(String id, String brand, String model) async {



      try {
        // Retrieve the document reference
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('LeaderDevices')
            .doc('8WXiFeYoRC0NCxCOkPhe');

        // Get the current document snapshot
        DocumentSnapshot documentSnapshot = await documentReference.get();
        List devices =  List.from(documentSnapshot['items'] ?? []);
         var ids = "";
        for(var item in devices){
          ids+= item['id'];
        }

        if(!ids.contains(id)){
          devices.add({
            'id':id,
            'brand':brand,
            'model':model,
            'isAllowed':true,
          });
        }

        if(ids.contains(id)){
          for(var item in devices){
            if(item['id'] == id){
              isAllowed.value = item['isAllowed'];

              print("isAllowed " + isAllowed.toString());
              break;

            }
          }
        }



        await documentReference.update({
          'items': devices,
        });


      } catch (e) {
        // Handle errors here
        print('Error adding item to array: $e');

      }

  }







  static Future<String> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;

      addDevice(androidInfo.id,androidInfo.brand,androidInfo.model);
      GetStorage().write('app_id', androidInfo.id);
      return androidInfo.id  ;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? "UnknownIOSID"; // Unique ID for iOS
    }
    return "UnsupportedDevice";
  }
}
