import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const JobListingApp());
}

class Job {
  final String? jobTitle;
  final String? companyName;
  final String? companyLogo;
  final String? location;
  final String? jobType;
  final String? timePosted;
  final int? daysAgo;

  Job({
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.jobType,
    required this.timePosted,
    this.daysAgo = 0,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobTitle: json['job']['title'],
      companyName: json['job']['company']['name'],
      companyLogo: json['job']['company']['logo'],
      location: json['job']['location']['name_en'],
      jobType: json['job']['type']['name_en'],
      timePosted: json['job']['updated_date'],
      daysAgo:
          calculateDaysDifference(json['job']['updated_date'], DateTime.now()),
    );
  }
}

int calculateDaysDifference(String updatedDate, DateTime now) {
  final formatter = DateFormat('yyyy-MM-dd');
  final jobDate = formatter.parse(updatedDate);
  return now.difference(jobDate).inDays;
}

class JobListingApp extends StatelessWidget {
  const JobListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JobListingPage(),
    );
  }
}

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  int currentPageIndex = 0;
  List<Job> jobList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final response = await http
        .get(Uri.parse('https://mpa0771a40ef48fcdfb7.free.beeceptor.com/jobs'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jobsData = data['data'] as List;
      setState(() {
        jobList = jobsData.map((jobData) => Job.fromJson(jobData)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> pages = [
      isLoading
          ? Center(child: const CircularProgressIndicator())
          : jobList.isEmpty
              ? Center(
                  child: Text('No jobs available',
                      style: theme.textTheme.titleLarge))
              : ListView.builder(
                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    final job = jobList[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Image.network(
                                '${job.companyLogo}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text('${job.jobTitle}',
                                style: theme.textTheme.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${job.companyName} '),
                                Text('${job.location} • ${job.jobType}'),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 4, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${job.daysAgo} days ago',
                                    style:
                                        TextStyle(color: Colors.grey.shade500))
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
      Center(
        child: Text(
          'Resume Page',
          style: theme.textTheme.titleLarge,
        ),
      ),
      Center(
        child: Text(
          'Settings Page',
          style: theme.textTheme.titleLarge,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jobs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined),
            label: 'Resume',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
