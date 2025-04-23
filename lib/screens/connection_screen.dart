import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/mqtt_provider.dart';
class ConnectionScreen extends StatefulWidget {
  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final TextEditingController _brokerController = TextEditingController();
  final TextEditingController _clientIdController = TextEditingController();

  bool _isConnecting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _brokerController.text =
          prefs.getString('mqtt_broker') ?? 'broker.hivemq.com';
      _clientIdController.text =
          prefs.getString('mqtt_client_id') ?? 'SmartCaneApp';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqtt_broker', _brokerController.text);
    await prefs.setString('mqtt_client_id', _clientIdController.text);
  }

  Future<void> _connectMQTT() async {
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      final broker = _brokerController.text.trim();
      final clientId = _clientIdController.text.trim();

      if (broker.isEmpty || clientId.isEmpty) {
        throw 'กรุณาระบุข้อมูลให้ครบถ้วน';
      }

      // บันทึกการตั้งค่า
      await _saveSettings();

      // เริ่มการเชื่อมต่อ
      final mqttProvider = Provider.of<MQTTProvider>(context, listen: false);
      mqttProvider.initialize(brokerUrl: broker, clientId: clientId);
      await mqttProvider.connect();

      // ตรวจสอบสถานะการเชื่อมต่อ
      if (mqttProvider.isConnected) {
        // นำทางไปยังหน้า Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        throw 'ไม่สามารถเชื่อมต่อกับ MQTT broker ได้';
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เชื่อมต่ออุปกรณ์',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'เลือกวิธีการเชื่อมต่อที่ต้องการ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 60),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildConnectionCard(
                            context,
                            icon: Icons.wifi,
                            title: 'เชื่อมต่อผ่าน Wi-Fi',
                            description:
                                'เชื่อมต่อกับอุปกรณ์ที่อยู่ในเครือข่าย Wi-Fi เดียวกัน',
                            color: Colors.blue.shade600,
                            onTap: () {
                              _showWiFiConnectionDialog(context);
                            },
                          ),
                          SizedBox(height: 24),
                          _buildConnectionCard(
                            context,
                            icon: Icons.public,
                            title: 'เชื่อมต่อผ่าน Ngrok',
                            description:
                                'เชื่อมต่อกับอุปกรณ์จากระยะไกลผ่านอินเทอร์เน็ต',
                            color: Colors.green,
                            onTap: () {
                              _showRemoteConnectionDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWiFiConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เชื่อมต่อผ่าน Wi-Fi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _brokerController,
                decoration: InputDecoration(
                  labelText: 'MQTT Broker (เช่น 192.168.1.100)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _clientIdController,
                decoration: InputDecoration(
                  labelText: 'Client ID',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: _isConnecting
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _connectMQTT();
                    },
              child: _isConnecting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('เชื่อมต่อ'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoteConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('เชื่อมต่อผ่าน Ngrok'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _brokerController,
                decoration: InputDecoration(
                  labelText: 'Ngrok URL (เช่น mqtt://0.tcp.ngrok.io:12345)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _clientIdController,
                decoration: InputDecoration(
                  labelText: 'Client ID',
                  border: OutlineInputBorder(),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            ElevatedButton(
              onPressed: _isConnecting
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      _connectMQTT();
                    },
              child: _isConnecting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('เชื่อมต่อ'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConnectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: color,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _brokerController.dispose();
    _clientIdController.dispose();
    super.dispose();
  }
}
