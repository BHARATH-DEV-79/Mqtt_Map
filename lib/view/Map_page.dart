import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:product_api/controller/controller.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MqttService mqttService = MqttService();
  String? _errorMessage;
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    _connectMqtt();
  }

  Future<void> _connectMqtt() async {
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      await mqttService.connect(
        (agentId, lat, lng) {
          if (mounted) {
            context.read<ProductController>().updateAgentLocation(agentId, lat, lng);
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() => _errorMessage = error);
          }
        },
      );

      if (mounted) {
        setState(() => _isConnecting = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _errorMessage = 'Failed to connect: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapController = context.watch<ProductController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Live Agent Tracking'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    mqttService.isConnected ? Icons.wifi : Icons.wifi_off,
                    color: mqttService.isConnected ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mqttService.isConnected ? 'Connected' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: mqttService.isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.9716, 77.5946), 
              zoom: 12,
            ),
            markers: mapController.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
          if (_isConnecting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Connecting to MQTT...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_errorMessage != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _connectMqtt,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _errorMessage = null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (mapController.markers.isNotEmpty)
            Positioned(
              bottom: 80,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.delivery_dining, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${mapController.markers.length} Active Agents',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 100),
        child: FloatingActionButton.extended(
          onPressed: _sendTestLocation,
          icon: const Icon(Icons.pin_drop),
          label: const Text('Test Location'),
        ),
      ),
    );
  }
  void _sendTestLocation() {
    mqttService.publishTestLocation(
      'agent_001',
      12.9716 + (DateTime.now().second % 10) * 0.001,
      77.5946 + (DateTime.now().second % 10) * 0.001,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test location published'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}