import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef LocationCallback = void Function(String agentId, double lat, double lng);
typedef ErrorCallback = void Function(String error);

class MqttService {
  late MqttServerClient _client;
  bool _isConnected = false;
  
  bool get isConnected => _isConnected;

  Future<void> connect(
    LocationCallback onLocationUpdate, {
    ErrorCallback? onError,
  }) async {
    _client = MqttServerClient(
      'broker.hivemq.com',
      'flutter_delivery_${DateTime.now().millisecondsSinceEpoch}',
    );

    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.autoReconnect = true; 

    _client.onConnected = () {
      print('MQTT Connected');
      _isConnected = true;
      _client.subscribe('delivery/agents/location', MqttQos.atLeastOnce);
    };

    _client.onDisconnected = () {
      print('MQTT Disconnected');
      _isConnected = false;
      onError?.call('MQTT connection lost. Attempting to reconnect...');
    };

    _client.onSubscribed = (topic) {
      print(' Subscribed to: $topic');
    };


    _client.onAutoReconnect = () {
      print(' MQTT Auto-reconnecting...');
    };

    _client.onAutoReconnected = () {
      print('MQTT Auto-reconnected');
      _isConnected = true;
      _client.subscribe('delivery/agents/location', MqttQos.atLeastOnce);
    };

    try {
      await _client.connect();
    } catch (e) {
      print('MQTT Connection Error: $e');
      onError?.call('Failed to connect to MQTT broker: $e');
      _client.disconnect();
      return;
    }

    _client.updates!.listen(
      (events) {
        final recMessage = events[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMessage.payload.message,
        );

        try {
          final data = jsonDecode(payload);


          if (data['agentId'] == null || data['lat'] == null || data['lng'] == null) {
            print('Invalid MQTT data: Missing required fields');
            return;
          }

          final String agentId = data['agentId'].toString();
          final double lat = double.parse(data['lat'].toString());
          final double lng = double.parse(data['lng'].toString());

          onLocationUpdate(agentId, lat, lng);
          print('Updated location for $agentId: ($lat, $lng)');
        } catch (e) {
          print('Invalid MQTT data format: $e');
          onError?.call('Received invalid location data');
        }
      },
      onError: (error) {
        print('MQTT Stream Error: $error');
        onError?.call('MQTT stream error: $error');
      },
    );
  }

  void publishTestLocation(String agentId, double lat, double lng) {
    if (!_isConnected) {
      print('Cannot publish: MQTT not connected');
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode({
      'agentId': agentId,
      'lat': lat,
      'lng': lng,
      'timestamp': DateTime.now().toIso8601String(),
    }));

    _client.publishMessage(
      'delivery/agents/location',
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  void disconnect() {
    _client.disconnect();
    _isConnected = false;
  }
}