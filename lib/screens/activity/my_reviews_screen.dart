import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reviews = [
    {
      'donor': 'John Doe',
      'rating': 5,
      'comment': 'Great experience! Very helpful donor.',
      'date': '2024-05-01',
    },
    {
      'donor': 'Jane Smith',
      'rating': 4,
      'comment': 'Good quality food, delivered on time.',
      'date': '2024-04-20',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Reviews'), leading: BackButton()),
      body:
          reviews.isEmpty
              ? Center(child: Text('No reviews yet.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review['donor'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < review['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(review['comment']),
                          SizedBox(height: 8),
                          Text(
                            review['date'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
