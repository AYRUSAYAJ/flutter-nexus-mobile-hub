
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_nexus_hub/providers/app_state.dart';
import 'package:flutter_nexus_hub/utils/location_service.dart';
import 'package:maps_launcher/maps_launcher.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final position = await LocationService.getCurrentLocation();
      final address = await LocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      // Update the app state
      Provider.of<AppState>(context, listen: false).updateLocation(
        position.latitude,
        position.longitude,
        address,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _openInMaps() {
    final appState = Provider.of<AppState>(context, listen: false);
    MapsLauncher.launchCoordinates(
      appState.latitude,
      appState.longitude,
      'Current Location',
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Location'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationCard(),
            SizedBox(height: 24),
            _buildActions(),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Card(
                  color: Colors.red[100],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLocationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Getting location...'),
                  ],
                ),
              )
            : Consumer<AppState>(
                builder: (ctx, appState, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        title: 'Latitude',
                        value: appState.latitude.toStringAsFixed(6),
                      ),
                      Divider(),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        title: 'Longitude',
                        value: appState.longitude.toStringAsFixed(6),
                      ),
                      Divider(),
                      _buildInfoRow(
                        icon: Icons.home,
                        title: 'Address',
                        value: appState.address,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red, size: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildActions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              icon: Icon(Icons.refresh),
              label: Text('REFRESH LOCATION'),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openInMaps,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              icon: Icon(Icons.map),
              label: Text('OPEN IN MAPS'),
            ),
          ],
        ),
      ),
    );
  }
}
