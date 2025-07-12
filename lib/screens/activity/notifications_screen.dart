import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Donation Accepted',
      'message': 'Your donation of bread has been accepted by John Doe.',
      'time': '2 hours ago',
      'type': 'donation',
      'read': false,
    },
    {
      'title': 'Request Completed',
      'message': 'Your request for rice has been fulfilled.',
      'time': '1 day ago',
      'type': 'request',
      'read': true,
    },
    {
      'title': 'New Message',
      'message': 'You have a new message from Jane Smith.',
      'time': '2 days ago',
      'type': 'message',
      'read': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read),
            onPressed: () {
              // TODO: Mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All notifications marked as read')),
              );
            },
          ),
        ],
      ),
      body:
          notifications.isEmpty
              ? Center(child: Text('No notifications yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color:
                        notification['read'] ? Colors.white : Colors.blue[50],
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getNotificationColor(
                          notification['type'],
                        ),
                        child: Icon(
                          _getNotificationIcon(notification['type']),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        notification['title'],
                        style: TextStyle(
                          fontWeight:
                              notification['read']
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification['message']),
                          SizedBox(height: 4),
                          Text(
                            notification['time'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Handle notification tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Notification: ${notification['title']}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'donation':
        return Colors.green;
      case 'request':
        return Colors.blue;
      case 'message':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'donation':
        return Icons.favorite;
      case 'request':
        return Icons.handshake;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }
}
