import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart' as Location;
import 'package:map_picker/map_picker.dart';

import '../../../widgets/elevated_btn.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.7333, 76.7794),
    zoom: 10.4746,
  );

  TextEditingController searchController = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  MapPickerController mapPickerController = MapPickerController();

  LatLng? latlong;
  CameraPosition? _cameraPosition;
  GoogleMapController? _googleMapController;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), _getCurrentLocation);
    _cameraPosition =
        const CameraPosition(target: LatLng(30.7333, 76.7794), zoom: 10.0);
    super.initState();
  }

  Set<Marker> markers = {};

  double? latitude, longitude;

  Position? _currentPosition;

  String _currentAddress = '',
      lat = '',
      lng = '',
      city = '',
      state = '',
      postal_code = '',
      country = '';

  Widget _searchLocation() {
    return GooglePlaceAutoCompleteTextField(
        textEditingController: searchController,
        googleAPIKey: "AIzaSyAbgWTyuXJbZtehcat3VvAsHE3FyapBVDs",
        inputDecoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        debounceTime: 800,
        // default 600 ms,

        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lng.toString());
          lat = prediction.lat!;
          lng = prediction.lat!;

          _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(double.parse(prediction.lat!),
                    double.parse(prediction.lng!)),
                zoom: 18.0,
              ),
            ),
          );
        },
        itmClick: (Prediction prediction) async {
          searchController.text = prediction.description!;
          searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length));
        });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Location.Location location = Location.Location();
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() async {
    await _determinePosition().then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 10.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        city = place.locality!;
        country = place.country!;

        lat = _currentPosition!.latitude.toString();
        lng = _currentPosition!.longitude.toString();

        postal_code = place.postalCode!;
        state = place.street!;

        searchController.text = _currentAddress;

        print("------------>" + _currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            MapPicker(
              mapPickerController: mapPickerController,
              iconWidget: Image.asset(
                'assets/images/ic_location_pin.png',
                height: 35,
                width: 35,
              ),
              child: GoogleMap(
                markers: Set<Marker>.from(markers),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: _kGooglePlex,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _googleMapController = controller;
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving!();
                },
                onCameraMove: (cameraPosition) {
                  this._cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving!();
                  List<Placemark> p = await placemarkFromCoordinates(
                      _cameraPosition!.target.latitude,
                      _cameraPosition!.target.longitude);

                  Placemark place = p[0];

                  setState(() {
                    _currentAddress =
                        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
                    searchController.text = _currentAddress;

                    city = place.locality!;
                    state = place.street!;
                    country = place.country!;

                    lat = _cameraPosition!.target.latitude.toString();
                    lng = _cameraPosition!.target.longitude.toString();

                    print("------------>" + _currentAddress);
                  });
                },
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.20),
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: const Text(
                          'Please choose the location of where the staff member should work.',
                          style: TextStyle(
                            color: Color(0xff858585),
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: const Color(0xff858585), width: 1)),
                        child: Row(
                          children: [
                            Expanded(child: _searchLocation()),
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              Icons.search,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        print("hello");
                        _getCurrentLocation();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.20),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                        child: ElevatedBtn(
                      text: "Done",
                      onTap: () {
                        if (_currentAddress.isEmpty) {
                          // HelperWidget.showToast(
                          //     message: "Please select valid location");
                          return;
                        }
                        var data = {
                          "location": searchController.text.toString(),
                          "lat": lat,
                          "lng": lng,
                          "city": city,
                          "street": state,
                          "country": country
                        };
                        Navigator.pop(context, data);
                      },
                    )),
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
