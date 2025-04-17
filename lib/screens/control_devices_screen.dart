import 'package:flutter/material.dart';

class ControlDevicesScreen extends StatefulWidget {
  @override
  _ControlDevicesScreenState createState() => _ControlDevicesScreenState();
}

class _ControlDevicesScreenState extends State<ControlDevicesScreen> {
  bool ledStatus = false;
  bool fanStatus = false;
  double brightnessValue = 0.5;
  double speedValue = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'ควบคุมอุปกรณ์',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'อุปกรณ์ทั้งหมด',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              _buildDeviceCard(
                icon: Icons.lightbulb,
                title: 'LED หลัก',
                subtitle: ledStatus ? 'กำลังทำงาน' : 'ปิดอยู่',
                status: ledStatus,
                color: Colors.amber,
                onToggle: (value) {
                  setState(() {
                    ledStatus = value;
                  });
                  // ส่งคำสั่งเปิด/ปิด LED
                },
                hasSlider: true,
                sliderValue: brightnessValue,
                sliderLabel: 'ความสว่าง',
                onSliderChanged: (value) {
                  setState(() {
                    brightnessValue = value;
                  });
                  // ปรับความสว่าง LED
                },
              ),
              SizedBox(height: 16),
              _buildDeviceCard(
                icon: Icons.air,
                title: 'พัดลม',
                subtitle: fanStatus ? 'กำลังทำงาน' : 'ปิดอยู่',
                status: fanStatus,
                color: Colors.blue,
                onToggle: (value) {
                  setState(() {
                    fanStatus = value;
                  });
                  // ส่งคำสั่งเปิด/ปิดพัดลม
                },
                hasSlider: true,
                sliderValue: speedValue,
                sliderLabel: 'ความเร็ว',
                onSliderChanged: (value) {
                  setState(() {
                    speedValue = value;
                  });
                  // ปรับความเร็วพัดลม
                },
              ),
              SizedBox(height: 16),
              _buildDeviceCard(
                icon: Icons.water_drop,
                title: 'ปั๊มน้ำ',
                subtitle: 'ปิดอยู่',
                status: false,
                color: Colors.teal,
                onToggle: (value) {
                  // ส่งคำสั่งเปิด/ปิดปั๊มน้ำ
                },
                hasSlider: false,
              ),
              SizedBox(height: 16),
              _buildAutomationCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool status,
    required Color color,
    required Function(bool) onToggle,
    required bool hasSlider,
    double sliderValue = 0,
    String sliderLabel = '',
    Function(double)? onSliderChanged,
  }) {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: status ? color : color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: status ? Colors.white : color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: status,
                  onChanged: onToggle,
                  activeColor: color,
                ),
              ],
            ),
          ),
          if (hasSlider && status)
            Column(
              children: [
                Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sliderLabel,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            '${(sliderValue * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: color,
                          thumbColor: color,
                          inactiveTrackColor: color.withOpacity(0.1),
                        ),
                        child: Slider(
                          value: sliderValue,
                          min: 0,
                          max: 1,
                          onChanged: onSliderChanged,
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

  Widget _buildAutomationCard() {
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
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'การทำงานอัตโนมัติ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildAutomationItem(
            title: 'เปิด LED เมื่ออุณหภูมิต่ำกว่า 20°C',
            isEnabled: true,
            color: Colors.amber,
          ),
          SizedBox(height: 12),
          _buildAutomationItem(
            title: 'เปิดพัดลมเมื่ออุณหภูมิสูงกว่า 30°C',
            isEnabled: true,
            color: Colors.blue,
          ),
          SizedBox(height: 12),
          _buildAutomationItem(
            title: 'เปิดปั๊มน้ำเมื่อความชื้นต่ำกว่า 40%',
            isEnabled: false,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationItem({
    required String title,
    required bool isEnabled,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            isEnabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isEnabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isEnabled ? Colors.black87 : Colors.black54,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              // Toggle automation rule
            },
            activeColor: color,
          ),
        ],
      ),
    );
  }
}
