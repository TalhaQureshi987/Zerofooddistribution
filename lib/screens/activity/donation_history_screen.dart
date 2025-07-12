import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> donations = [
    {'date': '2024-05-01', 'item': 'Bread', 'status': 'Completed'},
    {'date': '2024-04-20', 'item': 'Rice', 'status': 'Completed'},
    {'date': '2024-04-10', 'item': 'Milk', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donation History'), leading: BackButton()),
      body:
          donations.isEmpty
              ? Center(child: Text('No donations yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: Icon(Icons.card_giftcard, color: Colors.brown),
                      title: Text(donation['item'] ?? ''),
                      subtitle: Text('Date: ${donation['date']}'),
                      trailing: Text(
                        donation['status'] ?? '',
                        style: TextStyle(
                          color:
                              donation['status'] == 'Completed'
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
