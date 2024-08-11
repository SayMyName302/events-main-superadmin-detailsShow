import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collectionGroup('bookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['eventName'] ?? 'No event name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Number: ${data['accountNumber'] ?? 'N/A'}'),
                    Text('Advance Payment: ${data['advancePayment'] ?? 'N/A'}'),
                    Text('Bank Details: ${data['bankDetails'] ?? 'N/A'}'),
                    Text(
                        'Booking Date: ${data['bookingDate'] != null ? DateFormat('dd/MM/yyyy').format((data['bookingDate'] as Timestamp).toDate()) : 'N/A'}'),
                    Text('Capacity: ${data['capacity'] ?? 'N/A'}'),
                    Text('Contact Number: ${data['contactNumber'] ?? 'N/A'}'),
                    Text('Event Address: ${data['eventAddress'] ?? 'N/A'}'),
                    Text('Event Capacity: ${data['eventCapacity'] ?? 'N/A'}'),
                    Text('Event Date: ${data['eventDate'] ?? 'N/A'}'),
                    Text('Event Details: ${data['eventDetails'] ?? 'N/A'}'),
                    Text('Event Price: ${data['eventPrice'] ?? 'N/A'}'),
                    Text('Payment Method: ${data['paymentMethod'] ?? 'N/A'}'),
                    Text(
                        'Selected Facilities: ${data['selectedFacilities'] != null ? (data['selectedFacilities'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Selected Food Items: ${data['selectedFoodItems'] != null ? (data['selectedFoodItems'] as List).join(', ') : 'N/A'}'),
                    Text(
                        'Selected Time Slot: ${data['selectedTimeSlot'] ?? 'N/A'}'),
                    data['imageUrls'] != null
                        ? Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: (data['imageUrls'] as List).map((url) {
                              return CachedNetworkImage(
                                imageUrl: url,
                                width: 100,
                                height: 100,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) {
                                  // Log or print the error
                                  print('Error loading image: $error');
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error),
                                      SizedBox(height: 8.0),
                                      Text('Error loading image'),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          )
                        : const Text('No images available'),
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
