import 'package:flutter/material.dart';
import 'package:hopeon_app/services/alert_service.dart';

class ParentAlertScreen extends StatefulWidget {
  final String driverId;
  const ParentAlertScreen({super.key, required this.driverId});

  @override
  State<ParentAlertScreen> createState() => _ParentAlertScreenState();
}

class _ParentAlertScreenState extends State<ParentAlertScreen> {
  List<dynamic> alerts = [];

  AlertService _alertService = AlertService();
  bool _isLoading = false;

  void _loadAlerts() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> res =
    await _alertService.getAllAlerts(widget.driverId);
    if (res['success']) {
      List<dynamic> fetchedAlerts = res['body'];

      setState(() {
        alerts = fetchedAlerts;
        _isLoading = false;

      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadAlerts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert"),
        backgroundColor: Colors.blue,
      ),
      body: alerts.isEmpty ? Center(child: Text("No Alerts", style: TextStyle(fontSize: 18),)):ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(alerts[index]['sendAt']! + "").split("T")[0]}",
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(((alerts[index]['sendAt']!+"").split("T")[1].toString()).split(".")[0],
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),

              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(alerts[index]['message']!),
                )
              ],
            ),
          );
        },
      )
    );
  }
}
