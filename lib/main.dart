import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const JobListingPage());
}

class JobListingPage extends StatelessWidget {
  const JobListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align text to the left
            children: [
              Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                  'Jobs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications_none), // Static notification icon
            ),
          ],
        ),
        body: Center(
          child: Text('Job Listing 123!'),
        ),
        bottomNavigationBar: Text("Bottom Navigation Bar"),
      ),
    );
  }
}
