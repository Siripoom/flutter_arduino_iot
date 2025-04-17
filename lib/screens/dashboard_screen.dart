import 'package:flutter/material.dart';
import 'control_devices_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double temperature = 25.0;
  double humidity = 60.0;
  bool isConnected = true;

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => NotificationScreen()),
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
              _buildConnectionStatus(),
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
                      value: '$temperature°C',
                      color: Colors.orange,
                      trend: 'เพิ่มขึ้น +0.5°C',
                      trendUp: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSensorCard(
                      icon: Icons.water_drop,
                      title: 'ความชื้น',
                      value: '$humidity%',
                      color: Colors.blue,
                      trend: 'ลดลง -2%',
                      trendUp: false,
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
              _buildDeviceControlCard(),
              SizedBox(height: 16),
              _buildDeviceHistoryCard(),
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
  }

  Widget _buildConnectionStatus() {
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
                  ? 'เชื่อมต่อกับอุปกรณ์ Arduino สำเร็จแล้ว'
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
                color: trendUp ? Colors.red : Colors.green,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendUp ? Colors.red : Colors.green,
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

  Widget _buildDeviceControlCard() {
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
                value: true,
                onChanged: (value) {
                  // ส่งคำสั่งเปิด/ปิด LED
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
                  Icons.air,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'พัดลม',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: false,
                onChanged: (value) {
                  // ส่งคำสั่งเปิด/ปิดพัดลม
                },
                activeColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceHistoryCard() {
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
            'ประวัติการทำงานล่าสุด',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildHistoryItem(
            icon: Icons.lightbulb,
            title: 'LED หลัก เปิด',
            time: '15:30',
            color: Colors.amber,
          ),
          Divider(),
          _buildHistoryItem(
            icon: Icons.air,
            title: 'พัดลม ปิด',
            time: '15:20',
            color: Colors.blue,
          ),
          Divider(),
          _buildHistoryItem(
            icon: Icons.thermostat,
            title: 'อุณหภูมิเกินกำหนด',
            time: '14:45',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String time,
    required Color color,
  }) {
    return Row(
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
            size: 16,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
