import 'package:flutter/material.dart';

class RequestHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> requests = [
    {'date': '2024-05-01', 'item': 'Bread', 'status': 'Completed'},
    {'date': '2024-04-20', 'item': 'Rice', 'status': 'Completed'},
    {'date': '2024-04-10', 'item': 'Milk', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request History'), leading: BackButton()),
      body:
          requests.isEmpty
              ? Center(child: Text('No requests yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Icon(Icons.handshake, color: Colors.brown),
                      title: Text(request['item'] ?? ''),
                      subtitle: Text('Date: ${request['date']}'),
                      trailing: Text(
                        request['status'] ?? '',
                        style: TextStyle(
                          color:
                              request['status'] == 'Completed'
                                  ? Colors.green
                                  : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
