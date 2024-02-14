import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



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
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  final LatLng _restaurantLocation = LatLng(41.99278101, 21.4254378); // Example coordinates
  List<LatLng>? _routePoints; // State variable to store route points
  bool _isFetchingLocation = true; // New variable to track location fetching status

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _fetchRoute() async {
    try {
      // Assuming 'your-api-key' is replaced with the actual API key you obtained
      final points = await fetchRoute(_userLocation!, _restaurantLocation, '5b3ce3597851110001cf62485ebd3bf1c92d4d75b3798d9fee87e4bb');
      setState(() {
        _routePoints = points; // Update the route points to draw the route on the map
      });
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

  void _handleTap(TapPosition tapPosition,LatLng tappedPoint) {
    setState(() {
      _userLocation = tappedPoint;
    });
  }

// The _findLocation method uses a geocoding service to convert the address to coordinates
  void _findLocation() async {
    print("Searching for address: ${_addressController.text}");
    try {
      List<Location> locations = await locationFromAddress(_addressController.text);
      print("Locations found: $locations");
      if (locations.isNotEmpty) {
        print("Moving map to: ${locations.first.latitude}, ${locations.first.longitude}");
        _mapController.move(LatLng(locations.first.latitude, locations.first.longitude), 14.0);
      } else {
        print("No locations found.");
      }
    } catch (e) {
      print("Error occurred: $e");
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
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _userLocation ?? LatLng(0, 0), // Fallback to a default location
        zoom: 13.0,
        onTap: _handleTap,
      ),
      children: [
        TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _userLocation ?? LatLng(0, 0),
                child: Icon(Icons.location_pin, color: Colors.blue),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: _restaurantLocation,
                child:  Icon(Icons.location_on, color: Colors.red),
    ),
                ],
          ),
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


