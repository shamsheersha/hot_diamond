import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final loc.Location locationController;

  LocationBloc({required this.locationController}) : super(LocationInitial()) {
    on<FetchLocationEvent>(_fetchCurrentLocation);
    on<UpdateLocationEvent>(_updateLocationOnMap);
    on<GetImmediateLocationEvent>(_locateMe);
  }

  Future<void> _fetchCurrentLocation(
      FetchLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading());

    try {
      // Check location service and permission
      bool serviceEnabled = await locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationController.requestService();
        if (!serviceEnabled) {
          emit(LocationError("Location service is disabled."));
          return;
        }
      }

      loc.PermissionStatus permissionStatus =
          await locationController.hasPermission();
      if (permissionStatus == loc.PermissionStatus.denied) {
        permissionStatus = await locationController.requestPermission();
        if (permissionStatus != loc.PermissionStatus.granted) {
          emit(LocationError("Location permissions are denied."));
          return;
        }
      }

      // Get location
      loc.LocationData locationData = await locationController.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      // Get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      String city = placemarks.first.locality ?? "Unknown City";
      String area = placemarks.first.subLocality ?? "Unknown Area";

      emit(LocationLoaded(
        latitude: latitude,
        longitude: longitude,
        city: city,
        area: area,
      ));
    } catch (e) {
      emit(LocationError("Failed to fetch location: ${e.toString()}"));
    }
  }

  Future<void> _updateLocationOnMap(
      UpdateLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoaded(
      latitude: event.latitude,
      longitude: event.longitude,
      city: "Selected City",
      area: "Selected Area",
    ));
  }

   // New method for "Locate Me" button click to fetch location immediately
  Future<void> _locateMe(GetImmediateLocationEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoading()); // Show loading state

    try {
      // Check location service and permission
      bool serviceEnabled = await locationController.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationController.requestService();
        if (!serviceEnabled) {
          emit(LocationError("Location service is disabled."));
          return;
        }
      }

      loc.PermissionStatus permissionStatus =
          await locationController.hasPermission();
      if (permissionStatus == loc.PermissionStatus.denied) {
        permissionStatus = await locationController.requestPermission();
        if (permissionStatus != loc.PermissionStatus.granted) {
          emit(LocationError("Location permissions are denied."));
          return;
        }
      }

      // Fetch the current location
      loc.LocationData locationData = await locationController.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      // Get address information from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      String city = placemarks.first.locality ?? "Unknown City";
      String area = placemarks.first.subLocality ?? "Unknown Area";

      // Emit the new state to update the map and UI
      emit(LocationLoaded(
        latitude: latitude,
        longitude: longitude,
        city: city,
        area: area,
      ));
    } catch (e) {
      emit(LocationError("Failed to fetch location: ${e.toString()}"));
    }
  }
}

