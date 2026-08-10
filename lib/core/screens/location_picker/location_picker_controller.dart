import 'package:geocoding/geocoding.dart' hide Location;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sales_man/core/services/snackbar/app_snackbar_service.dart';

class SelectedLocation {
  final double latitude;
  final double longitude;
  final String address;

  const SelectedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationPickerController extends GetxController {
  final RxDouble markerLatitude = 0.0.obs;
  final RxDouble markerLongitude = 0.0.obs;
  final RxString address = ''.obs;
  final RxBool isLoadingAddress = false.obs;
  final RxBool isMapReady = false.obs;

  GoogleMapController? _mapController;

  static const LatLng defaultCenter = LatLng(33.6844, 73.0479);

  LatLng get center =>
      LatLng(markerLatitude.value, markerLongitude.value);

  @override
  void onClose() {
    _mapController?.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    isMapReady.value = true;
    _moveToCurrentLocation();
  }

  void recenterToCurrentLocation() {
    _moveToCurrentLocation();
  }

  void onCameraMove(CameraPosition position) {
    markerLatitude.value = position.target.latitude;
    markerLongitude.value = position.target.longitude;
  }

  void onCameraIdle() {
    _updateAddress(markerLatitude.value, markerLongitude.value);
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      final location = Location();

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission == PermissionStatus.granted ||
          permission == PermissionStatus.grantedLimited) {
        bool serviceEnabled = await location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await location.requestService();
        }

        if (serviceEnabled) {
          final locationData = await location.getLocation();
          final lat = locationData.latitude ?? defaultCenter.latitude;
          final lng = locationData.longitude ?? defaultCenter.longitude;

          markerLatitude.value = lat;
          markerLongitude.value = lng;

          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16),
          );
          return;
        }
      }
    } catch (_) {}

    markerLatitude.value = defaultCenter.latitude;
    markerLongitude.value = defaultCenter.longitude;

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(defaultCenter, 14),
    );
  }

  Future<void> _updateAddress(double lat, double lng) async {
    isLoadingAddress.value = true;
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[
          if (place.street != null && place.street!.isNotEmpty) place.street!,
          if (place.subLocality != null && place.subLocality!.isNotEmpty)
            place.subLocality!,
          if (place.locality != null && place.locality!.isNotEmpty)
            place.locality!,
          if (place.administrativeArea != null &&
              place.administrativeArea!.isNotEmpty)
            place.administrativeArea!,
          if (place.country != null && place.country!.isNotEmpty)
            place.country!,
        ];
        address.value = parts.join(', ');
      }
    } catch (e) {
      address.value =
          '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
    } finally {
      isLoadingAddress.value = false;
    }
  }

  void confirmLocation() {
    if (markerLatitude.value == 0.0 && markerLongitude.value == 0.0) {
      AppSnackbarService.warning(
        'Please move the map to select a location',
        title: 'No Location Selected',
      );
      return;
    }

    final result = SelectedLocation(
      latitude: markerLatitude.value,
      longitude: markerLongitude.value,
      address: address.value,
    );

    Get.back(result: result);
  }
}
