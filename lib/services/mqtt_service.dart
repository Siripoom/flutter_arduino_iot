import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;
  
  // สำหรับเก็บข้อมูลเซ็นเซอร์ล่าสุด
  double temperature = 25.0;
  double humidity = 60.0;
  int light = 0;
  int distance = 0;
  double gyro = 0.0;
  double accel = 0.0;
  String gpsCoordinates = "";

  // Stream controllers สำหรับส่งข้อมูลไปยัง UI
  final _temperatureController = StreamController<double>.broadcast();
  final _humidityController = StreamController<double>.broadcast();
  final _lightController = StreamController<int>.broadcast();
  final _distanceController = StreamController<int>.broadcast();
  final _gyroController = StreamController<double>.broadcast();
  final _accelController = StreamController<double>.broadcast();
  final _gpsController = StreamController<String>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  // Stream getters
  Stream<double> get temperatureStream => _temperatureController.stream;
  Stream<double> get humidityStream => _humidityController.stream;
  Stream<int> get lightStream => _lightController.stream;
  Stream<int> get distanceStream => _distanceController.stream;
  Stream<double> get gyroStream => _gyroController.stream;
  Stream<double> get accelStream => _accelController.stream;
  Stream<String> get gpsStream => _gpsController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  // Constructor
  MQTTService({
    required String identifier,
    required String host,
    required String topic,
  })  : _identifier = identifier,
        _host = host,
        _topic = topic;

  // เชื่อมต่อกับ MQTT Broker
  Future<void> connect() async {
    _client = MqttServerClient(_host, _identifier);
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 30;
    _client!.onDisconnected = _onDisconnected;
    _client!.onConnected = _onConnected;
    _client!.onSubscribed = _onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .startClean()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .withWillQos(MqttQos.atLeastOnce);

    _client!.connectionMessage = connMess;

    try {
      await _client!.connect();
    } catch (e) {
      debugPrint('Exception: $e');
      _client!.disconnect();
      _connectionStatusController.add(false);
      return;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT client connected');
      _connectionStatusController.add(true);

      // Subscribe to sensor topics
      _client!.subscribe('smartcane/sensors/temperature', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/humidity', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/light', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/distance', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/gyro', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/accel', MqttQos.atLeastOnce);
      _client!.subscribe('smartcane/sensors/gps', MqttQos.atLeastOnce);

      // Listen for incoming messages
      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
        final topic = messages[0].topic;

        _processMessage(topic, payload);
      });
    } else {
      debugPrint('ERROR: MQTT client connection failed - '
          'disconnecting, status is ${_client!.connectionStatus}');
      _client!.disconnect();
      _connectionStatusController.add(false);
    }
  }

  // ประมวลผลข้อมูลที่ได้รับจาก MQTT
  void _processMessage(String topic, String payload) {
    debugPrint('Received message: topic is <$topic>, payload is <$payload>');

    try {
      // จัดการกับข้อมูลแต่ละประเภท
      switch (topic) {
        case 'smartcane/sensors/temperature':
          temperature = double.parse(payload);
          _temperatureController.add(temperature);
          break;
        case 'smartcane/sensors/humidity':
          humidity = double.parse(payload);
          _humidityController.add(humidity);
          break;
        case 'smartcane/sensors/light':
          light = int.parse(payload);
          _lightController.add(light);
          break;
        case 'smartcane/sensors/distance':
          distance = int.parse(payload);
          _distanceController.add(distance);
          break;
        case 'smartcane/sensors/gyro':
          gyro = double.parse(payload);
          _gyroController.add(gyro);
          break;
        case 'smartcane/sensors/accel':
          accel = double.parse(payload);
          _accelController.add(accel);
          break;
        case 'smartcane/sensors/gps':
          gpsCoordinates = payload;
          _gpsController.add(gpsCoordinates);
          break;
      }
    } catch (e) {
      debugPrint('Error processing message: $e');
    }
  }

  // ส่งคำสั่งควบคุมไปยังอุปกรณ์
  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  // ควบคุม LED
  void controlLED(bool on) {
    publishMessage('smartcane/control/led', on ? '1' : '0');
  }

  // ควบคุมเสียงเตือน
  void controlBuzzer(bool on) {
    publishMessage('smartcane/control/buzzer', on ? '1' : '0');
  }

  // Callbacks สำหรับการเชื่อมต่อ MQTT
  void _onConnected() {
    debugPrint('Connected to MQTT broker');
    _connectionStatusController.add(true);
  }

  void _onDisconnected() {
    debugPrint('Disconnected from MQTT broker');
    _connectionStatusController.add(false);
  }

  void _onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }

  // การจัดการเมื่อปิดแอป
  void dispose() {
    _temperatureController.close();
    _humidityController.close();
    _lightController.close();
    _distanceController.close();
    _gyroController.close();
    _accelController.close();
    _gpsController.close();
    _connectionStatusController.close();
    
    _client?.disconnect();
  }
}