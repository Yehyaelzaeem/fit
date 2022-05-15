import 'package:app/app/modules/shippingDetails/controllers/shipping_details_controller.dart';
import 'package:app/app/utils/helper/echo.dart';
import 'package:app/app/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

class PickMap extends GetView<ShippingDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height - 50,
            child: MapPicker(
              iconWidget: Icon(Icons.location_pin, color: kColorPrimary, size: 50),
              mapPickerController: controller.mapPickerController,
              child: GoogleMap(
                initialCameraPosition: controller.cameraPosition,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController ctx) {
                  controller.googleMapController.complete(ctx);
                },
                onCameraMoveStarted: () {
                  controller.mapPickerController.mapMoving!();
                  controller.textController.text = "";
                },
                onCameraMove: (cameraPosition) {
                  controller.cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  controller.mapPickerController.mapFinishedMoving!();
                  // //get address name from camera position
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    controller.cameraPosition.target.latitude,
                    controller.cameraPosition.target.longitude,
                  );
                  if (placemarks.length > 0) {
                    Echo('name -> ${placemarks[0].name}');
                    Echo('street -> ${placemarks[0].street}');
                    Echo('isoCountryCode -> ${placemarks[0].isoCountryCode}');
                    Echo('country -> ${placemarks[0].country}');
                    Echo('postalCode -> ${placemarks[0].postalCode}');
                    Echo('administrativeArea -> ${placemarks[0].administrativeArea}');
                    Echo('subAdministrativeArea -> ${placemarks[0].subAdministrativeArea}');
                    Echo('locality -> ${placemarks[0].locality}');
                    Echo('subLocality -> ${placemarks[0].subLocality}');
                    Echo('thoroughfare -> ${placemarks[0].thoroughfare}');
                    Echo('subThoroughfare -> ${placemarks[0].subThoroughfare}');
                    // update the ui with the address
                    String address = '';
                    if (placemarks[0].country != null) {
                      address += placemarks[0].country! + ', ';
                    }
                    if (placemarks[0].administrativeArea != null) {
                      address += placemarks[0].administrativeArea! + ', ';
                    }
                    if (placemarks[0].subAdministrativeArea != null) {
                      address += placemarks[0].subAdministrativeArea! + ', ';
                    }
                    if (placemarks[0].locality != null) {
                      address += placemarks[0].locality! + ', ';
                    }
                    address.substring(0, address.length - 2);
                    controller.textController.text = address;
                  }
                },
              ),
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).viewPadding.top + 20,
          //   width: Get.width / 1.4,
          //   height: 50,
          //   child: TextFormField(
          //     maxLines: 3,
          //     textAlign: TextAlign.center,
          //     readOnly: true,
          //     decoration: const InputDecoration(contentPadding: EdgeInsets.zero, border: InputBorder.none),
          //     controller: controller.textController,
          //   ),
          // ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              child: TextButton(
                child: Text(
                  "Pick Locations",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 14,
                    // height: 19/19,
                  ),
                ),
                onPressed: () {
                  controller.longitude.value = controller.cameraPosition.target.longitude.toString();
                  controller.latitude.value = controller.cameraPosition.target.latitude.toString();
                  Get.back();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kColorPrimary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
