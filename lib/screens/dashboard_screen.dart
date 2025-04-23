import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_provider.dart';
import 'control_devices_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // ใช้ Consumer เพื่อฟังการเปลี่ยนแปลงข้อมูลจาก Provider
    return Consumer<MQTTProvider>(
      builder: (context, mqttProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF5F7FA),
          appBar: AppBar(
            title: Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue.shade700,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Show settings dialog
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildConnectionStatus(mqttProvider.isConnected),
                  SizedBox(height: 24),
                  Text(
                    'ข้อมูลเซ็นเซอร์',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorCard(
                          icon: Icons.thermostat,
                          title: 'อุณหภูมิ',
                          value:
                              '${mqttProvider.temperature.toStringAsFixed(1)}°C',
                          color: Colors.orange,
                          trend: 'ค่าล่าสุด',
                          trendUp: mqttProvider.temperature > 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildSensorCard(
                          icon: Icons.water_drop,
                          title: 'ความชื้น',
                          value: '${mqttProvider.humidity.toStringAsFixed(1)}%',
                          color: Colors.blue,
                          trend: 'ค่าล่าสุด',
                          trendUp: mqttProvider.humidity > 60,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSensorCard(
                          icon: Icons.light_mode,
                          title: 'แสง',
                          value: '${mqttProvider.light} lux',
                          color: Colors.amber,
                          trend: mqttProvider.light < 300
                              ? 'ต่ำกว่าเกณฑ์'
                              : 'ปกติ',
                          trendUp: mqttProvider.light >= 300,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildSensorCard(
                          icon: Icons.radar,
                          title: 'ระยะห่าง',
                          value: '${mqttProvider.distance} cm',
                          color: Colors.green,
                          trend:
                              mqttProvider.distance < 30 ? 'ระวัง' : 'ปลอดภัย',
                          trendUp: mqttProvider.distance >= 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'ควบคุมอุปกรณ์',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDeviceControlCard(mqttProvider),
                  SizedBox(height: 16),
                  _buildGyroAccelCard(mqttProvider),
                  SizedBox(height: 16),
                  if (mqttProvider.gpsCoordinates.isNotEmpty)
                    _buildLocationCard(mqttProvider.gpsCoordinates),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ControlDevicesScreen()),
              );
            },
            backgroundColor: Colors.blue.shade700,
            label: Text('ควบคุมอุปกรณ์เพิ่มเติม'),
            icon: Icon(Icons.settings_remote),
          ),
        );
      },
    );
  }

  Widget _buildConnectionStatus(bool isConnected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? Colors.green.shade400 : Colors.red.shade400,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.error,
            color: isConnected ? Colors.green.shade700 : Colors.red.shade700,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              isConnected
                  ? 'เชื่อมต่อกับอุปกรณ์ Smart Cane สำเร็จแล้ว'
                  : 'ไม่สามารถเชื่อมต่อกับอุปกรณ์ได้',
              style: TextStyle(
                color:
                    isConnected ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isConnected
              ? Container()
              : TextButton(
                  onPressed: () {
                    // Try to reconnect
                    final mqttProvider =
                        Provider.of<MQTTProvider>(context, listen: false);
                    mqttProvider.connect();
                  },
                  child: Text('เชื่อมต่อใหม่'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required String trend,
    required bool trendUp,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                color: trendUp ? Colors.green : Colors.red,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendUp ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceControlCard(MQTTProvider mqttProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'LED หลัก',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: mqttProvider.ledStatus,
                onChanged: (value) {
                  mqttProvider.toggleLED(value);
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'เสียงเตือน',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: mqttProvider.buzzerStatus,
                onChanged: (value) {
                  mqttProvider.toggleBuzzer(value);
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGyroAccelCard(MQTTProvider mqttProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'การเคลื่อนไหว',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rotate_right,
                          color: Colors.purple,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Gyroscope',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${mqttProvider.gyro.toStringAsFixed(2)} °/s',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.speed,
                          color: Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Accelerometer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${mqttProvider.accel.toStringAsFixed(2)} m/s²',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String coordinates) {
    final parts = coordinates.split(',');
    String lat = parts.isNotEmpty ? parts[0] : '0.0';
    String lng = parts.length > 1 ? parts[1] : '0.0';

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'ตำแหน่งปัจจุบัน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Latitude: $lat',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Longitude: $lng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              // Open map with coordinates
              // Launch URL: 'https://maps.google.com/maps/place/$lat,$lng'
            },
            icon: Icon(Icons.map),
            label: Text('ดูบนแผนที่'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade700,
              minimumSize: Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}
