import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.thermostat,
      'title': 'อุณหภูมิสูงเกิน',
      'message': 'อุณหภูมิสูงเกิน 35°C กรุณาตรวจสอบอุปกรณ์',
      'time': '15:45',
      'color': Colors.red,
      'isRead': false,
    },
    {
      'icon': Icons.water_drop,
      'title': 'ความชื้นต่ำ',
      'message': 'ความชื้นต่ำกว่า 40% ระบบเปิดปั๊มน้ำอัตโนมัติ',
      'time': '14:30',
      'color': Colors.amber,
      'isRead': false,
    },
    {
      'icon': Icons.lightbulb,
      'title': 'LED ทำงาน',
      'message': 'LED เปิดทำงานโดยอัตโนมัติเนื่องจากแสงไม่เพียงพอ',
      'time': '12:15',
      'color': Colors.green,
      'isRead': true,
    },
    {
      'icon': Icons.error,
      'title': 'การเชื่อมต่อขัดข้อง',
      'message': 'การเชื่อมต่อกับอุปกรณ์ขัดข้อง ระบบเชื่อมต่อใหม่อัตโนมัติ',
      'time': 'เมื่อวาน, 18:30',
      'color': Colors.grey,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int unreadCount = notifications.where((notif) => !notif['isRead']).length;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'การแจ้งเตือน',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () {
              // Mark all as read
            },
            tooltip: 'อ่านทั้งหมด',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'การแจ้งเตือน',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  if (unreadCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unreadCount ใหม่',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // Filter notifications
                    },
                    icon: Icon(Icons.filter_list, size: 16),
                    label: Text('กรอง'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(
                    context: context,
                    icon: notification['icon'],
                    title: notification['title'],
                    message: notification['message'],
                    time: notification['time'],
                    color: notification['color'],
                    isRead: notification['isRead'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required Color color,
    required bool isRead,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        border: !isRead
            ? Border.all(
                color: Colors.blue.shade300,
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Mark as read and show details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
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
                      ),
                      SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8),
                      !isRead
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'อ่านแล้ว',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
