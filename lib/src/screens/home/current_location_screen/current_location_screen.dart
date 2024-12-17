import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hot_diamond_users/src/controllers/location/location_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_event.dart';
import 'package:hot_diamond_users/src/controllers/location/location_state.dart';
import 'package:hot_diamond_users/src/screens/home/current_location_screen/widgets/area_selection_widget.dart';
import 'package:hot_diamond_users/src/screens/home/current_location_screen/widgets/city_selection_widget.dart';
import 'package:hot_diamond_users/src/screens/home/current_location_screen/widgets/location_confirmation_button.dart';
import 'package:hot_diamond_users/src/screens/home/current_location_screen/widgets/map_widget.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/home_screen.dart';
import 'package:hot_diamond_users/src/services/user_repository.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';

class CurrentLocationScreen extends StatefulWidget {
  final UserRepository userRepository;
  const CurrentLocationScreen({super.key, required this.userRepository});

  @override
  // ignore: library_private_types_in_public_api
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
   Completer<GoogleMapController>? _mapController = Completer();
  String selectedCity = "";
  String selectedArea = "";
@override
  void initState() {
    super.initState();
    _initializeMapController();
  }

  _initializeMapController(){
    _mapController = Completer<GoogleMapController>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          } else if (state is LocationLoaded) {
            final LatLng location = LatLng(state.latitude, state.longitude);

            return Stack(
              children: [
                MapWidget(
                  mapController: _mapController!,
                  location: location,
                ),
                Positioned(
                  top: 485,
                  right: 15,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.white)),
                    onPressed: () {
                      context
                          .read<LocationBloc>()
                          .add(GetImmediateLocationEvent());
                    },
                    icon: const Icon(Icons.my_location, color: Colors.black),
                    label: const Text("Locate Me",
                        style: CustomTextStyles.bodyText1),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 15,
                  right: 15,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 8,
                                spreadRadius: 2),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text("Please select your location",
                                style: CustomTextStyles.bodyText1),
                            const SizedBox(height: 10),
                            CitySelectionWidget(
                              selectedCity: selectedCity,
                              onCitySelected: (city) {
                                setState(() {
                                  selectedCity = city;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            AreaSelectionWidget(
                              selectedArea: selectedArea,
                              onAreaSelected: (area) {
                                setState(() {
                                  selectedArea = area;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            LocationConfirmationButton(
                              selectedCity: selectedCity,
                              selectedArea: selectedArea,
                              onConfirm: () async {
                                await widget.userRepository.storeLocationInFirestore(
                                    selectedCity, selectedArea);
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeMapController();
  }
}
