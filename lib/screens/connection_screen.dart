import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class ConnectionScreen extends StatelessWidget {
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen()),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen()),
                            );
                          },
                        ),
                      ],
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
}
