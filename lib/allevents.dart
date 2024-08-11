import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['eventName'] ?? 'Event ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data['imageUrls'] != null &&
                        (data['imageUrls'] as List).isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: data['imageUrls'][0],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    SizedBox(height: 8),
                    Text('Event Address: ${data['eventAddress'] ?? 'N/A'}'),
                    Text(
                        'Event Capacity: ${data['eventCapacity']?.toString() ?? 'N/A'}'),
                    Text('Event Details: ${data['eventDetails'] ?? 'N/A'}'),
                    Text(
                        'Event Price: ${data['eventPrice']?.toString() ?? 'N/A'}'),
                    Text(
                        'Selected Facilities: ${data['selectedFacilities'] != null ? (data['selectedFacilities'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Selected Food Items: ${data['selectedFoodItems'] != null ? (data['selectedFoodItems'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Selected Time Slots: ${data['selectedTimeSlots'] != null ? (data['selectedTimeSlots'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Selected Payment Method: ${data['selectedpaymentmethod'] != null ? (data['selectedpaymentmethod'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Advance Payment: ${data['advancepayment'] != null ? (data['advancepayment'] as List).join(', ') : 'N/A'}'),
                    if (data['datesWithSlots'] != null)
                      ...((data['datesWithSlots'] as List).map((slot) {
                        var date = slot['date'] as String;
                        try {
                          var formattedDate =
                              DateFormat('dd/MM/yyyy').parse(date);
                          return Text(
                              'Available Slot: ${DateFormat('dd/MM/yyyy').format(formattedDate)}');
                        } catch (e) {
                          return Text('Invalid Date Format: $date');
                        }
                      }).toList()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
