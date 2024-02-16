import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_power/database/database_helper.dart';
import 'package:food_power/views/CheckoutPage.dart';
import 'package:food_power/views/SummaryPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'DateTimePage.dart';



TextEditingController _addressController = TextEditingController();

Future<List<LatLng>> fetchRoute(LatLng start, LatLng destination, String apiKey) async {
  final response = await http.post(
    Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car/geojson'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': apiKey
    },
    body: jsonEncode({
      'coordinates': [
        [start.longitude, start.latitude],
        [destination.longitude, destination.latitude]
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final coordinates = data['features'][0]['geometry']['coordinates'] as List;
    return coordinates.map((e) => LatLng(e[1], e[0])).toList();
  } else {
    throw Exception('Failed to load route');
  }
}
class MapPage extends StatefulWidget {
  final String userId;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final DeliveryOption deliveryOption;
  final double totalPrice;

  MapPage({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.deliveryOption,
    required this.totalPrice,
    required this.userId,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  final LatLng _restaurantLocation = LatLng(41.99278101, 21.4254378);
  List<LatLng>? _routePoints; // State variable to store route points
  bool _isFetchingLocation = true; // New variable to track location fetching status
  LatLng? _searchedLocation;
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  double calculateDistance(LatLng start, LatLng destination) {
    var earthRadiusKm = 6371;
    var dLat = _degreesToRadians(destination.latitude - start.latitude);
    var dLon = _degreesToRadians(destination.longitude - start.longitude);

    var startLatInRadians = _degreesToRadians(start.latitude);
    var destinationLatInRadians = _degreesToRadians(destination.latitude);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(startLatInRadians) * cos(destinationLatInRadians);
    var c = 2 * asin(sqrt(a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  double calculateDeliveryFee(LatLng userLocation, LatLng restaurantLocation) {
    var distance = calculateDistance(userLocation, restaurantLocation);
    if (distance <= 1) {
      return 0; // Free delivery for distances of 1km or less
    } else {
      return (distance - 1) * 2; // $2 per km after the first km
    }
  }

  void showDeliveryFeeBottomSheet(BuildContext context, double deliveryFee) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.white, // Set the background color to white
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space necessary
            children: <Widget>[
              ListTile(
                title: Text('Delivery Fee', style: TextStyle(color: Colors.black)), // Black text for title
                subtitle: Text('\$${deliveryFee.toStringAsFixed(2)}', style: TextStyle(color: Colors.black54)), // Black text for subtitle
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.cancel, color: Colors.black), // Black icon for "Cancel"
                      label: Text('Cancel', style: TextStyle(color: Colors.black)), // Black text for "Cancel"
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Background color for cancel button
                        onPrimary: Colors.black, // Text color for cancel button (unused due to explicit style)
                        side: BorderSide(color: Colors.black, width: 1), // Border color
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // Spacing between buttons
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_forward, color: Colors.white), // White icon for "Next"
                      label: Text('Next', style: TextStyle(color: Colors.white)), // White text for "Next"
                      onPressed: () async {
                        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                        final totalPrice = await DatabaseHelper.instance.getTotalCartPrice(userId);
                        Navigator.of(context).pop(); // Close the bottom sheet
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SummaryPage(
                              userId: userId,
                              totalPrice: totalPrice,
                              deliveryFee: deliveryFee,
                              selectedDate: widget.selectedDate,
                              selectedTime: widget.selectedTime,
                              isPickup: false), // Replace with your checkout page
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Background color for next button
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _fetchRoute() async {
    if (_restaurantLocation == null || _searchedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please ensure a destination is selected.')),
      );
      return;
    }
    try {
      // Assuming 'your-api-key' is replaced with the actual API key you obtained
      final points = await fetchRoute(_restaurantLocation, _searchedLocation!, '5b3ce3597851110001cf62485ebd3bf1c92d4d75b3798d9fee87e4bb');
      setState(() {
        _routePoints = points; // Update the route points to draw the route on the map
      });

      // Calculate the delivery fee after fetching the route
      double deliveryFee = calculateDeliveryFee(_restaurantLocation, _searchedLocation!);

      // Show the delivery fee in a dialog
      showDeliveryFeeBottomSheet(context, deliveryFee);

    } catch (e) {
      // Handle errors (e.g., show a toast or a dialog)
      print('Error fetching route: $e');
    }
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isFetchingLocation = true; // Indicate that location fetching has started
    });
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      setState(() {
        _isFetchingLocation = false; // Location fetching is done
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationServiceDialog();
        setState(() {
          _isFetchingLocation = false; // Location fetching is done
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showLocationServiceDialog();
      setState(() {
        _isFetchingLocation = false; // Location fetching is done
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _isFetchingLocation = false; // Location fetching is done, and location is obtained
    });
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Services Disabled"),
          content: Text("Please enable location services in your device settings."),
          actions: <Widget>[
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                // Navigate the user to the settings page
                // AppSettings.openLocationSettings(); // Uncomment if using app_settings
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _searchedLocation = latlng;
      _mapController.move(latlng, _mapController.zoom);
    });
  }

// The _findLocation method uses a geocoding service to convert the address to coordinates
  void _findLocation() async {
    print("Searching for address: ${_addressController.text}");
    try {
      List<Location> locations = await locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        setState(() {
          _searchedLocation = LatLng(locations.first.latitude, locations.first.longitude); // Set the searched location
          _mapController.move(_searchedLocation!, 14.0 ); // Move the map to the searched location
        });
      } else {
        print("No locations found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No locations found. Please try a different address.")),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred while searching for address.")),
      );
      // Optionally, inform the user with a dialog or snackbar
    }
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _findLocation, // Make sure you have defined this method
                ),
              ),
            ),
          ),
          Expanded(
            child: _isFetchingLocation ? Center(child: CircularProgressIndicator()) : _buildMap(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _zoomIn,
            child: Icon(Icons.add),
            tooltip: 'Zoom In',
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: _zoomOut,
            child: Icon(Icons.remove),
            tooltip: 'Zoom Out',
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              if (_userLocation != null && _restaurantLocation != null) {
                _fetchRoute();
              } else {
                // Inform the user that the location is not determined yet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Waiting for location to be determined. Please try again.')),
                );
              }
            },
            child: Icon(Icons.route),
            tooltip: 'Fetch Route',
          ),
        ],
      ),
    );
  }


  Widget _buildMap() {
    var markers = <Marker>[
      Marker(
        width: 80.0,
        height: 80.0,
        point: _restaurantLocation,
        child: Icon(Icons.location_on, color: Colors.red),
      ),
      if (_searchedLocation != null)
        Marker(
          width: 80.0,
          height: 80.0,
          point: _searchedLocation!,
          child: Icon(Icons.location_pin, color: Colors.blue),
        ),
    ];
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _restaurantLocation, // Fallback to a default location
        zoom: 13.0,
        onTap: _handleTap,
      ),
      children: [
        TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer( markers: markers),
        if (_routePoints != null) // Conditionally add the PolylineLayerWidget
          PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints!,
                  strokeWidth: 4.0,
                  color: Colors.blue,
    )
              ],
            ),
      ],

    );
  }
}


