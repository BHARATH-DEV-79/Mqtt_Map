import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef LocationCallback = void Function(String agentId, double lat, double lng);
typedef ErrorCallback = void Function(String error);

class MqttService {
  late MqttServerClient client;
  bool _isConnected = false;
  
  bool get isConnected => _isConnected;

  Future<void> connect(
    LocationCallback onLocationUpdate, {
    ErrorCallback? onError,
  }) async {
    client = MqttServerClient(
      'broker.hivemq.com',
      'flutter_delivery_${DateTime.now().millisecondsSinceEpoch}',
    );

    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);
    client.autoReconnect = true; 

    client.onConnected = () {
      print('MQTT Connected');
      _isConnected = true;
      client.subscribe('delivery/agents/location', MqttQos.atLeastOnce);
    };

    client.onDisconnected = () {
      print('MQTT Disconnected');
      _isConnected = false;
      onError?.call('MQTT connection lost. Attempting to reconnect...');
    };

    client.onSubscribed = (topic) {
      print(' Subscribed to: $topic');
    };


    client.onAutoReconnect = () {
      print(' MQTT Auto-reconnecting...');
    };

    client.onAutoReconnected = () {
      print('MQTT Auto-reconnected');
      _isConnected = true;
      client.subscribe('delivery/agents/location', MqttQos.atLeastOnce);
    };

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Connection Error: $e');
      onError?.call('Failed to connect to MQTT broker: $e');
      client.disconnect();
      return;
    }

    client.updates!.listen(
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

    client.publishMessage(
      'delivery/agents/location',
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  void disconnect() {
    client.disconnect();
    _isConnected = false;
  }
}