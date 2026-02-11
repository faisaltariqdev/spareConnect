import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final String orderId;

  FeedbackDialog({required this.orderId});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  int selectedRating = 0; // Holds the selected rating value
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Give Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1; // Update the selected rating
                  });
                },
                icon: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          // Feedback Input Field
          TextField(
            controller: feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your feedback here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final feedback = feedbackController.text.trim();
            if (selectedRating == 0 || feedback.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please provide a rating and feedback.')),
              );
              return;
            }
            // Store feedback and rating in Firebase
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(widget.orderId)
                .update({
              'feedback': feedback,
              'rating': selectedRating,
            });

            Navigator.pop(context); // Close the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Thank you for your feedback!')),
            );
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}

// Function to open the feedback dialog
void _showFeedbackDialog(BuildContext context, String orderId) {
  showDialog(
    context: context,
    builder: (context) => FeedbackDialog(orderId: orderId),
  );
}
