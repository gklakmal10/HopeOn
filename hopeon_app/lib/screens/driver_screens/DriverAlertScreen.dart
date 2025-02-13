import 'package:flutter/material.dart';
import 'package:hopeon_app/services/alert_service.dart';

class DriverAlertScreen extends StatefulWidget {
  final String driverId;
  const DriverAlertScreen({super.key, required this.driverId});

  @override
  State<DriverAlertScreen> createState() => _DriverAlertScreenState();
}

class _DriverAlertScreenState extends State<DriverAlertScreen> {
  int? _selectedIndex; // Track selected index

  final alerts = [
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an urgent update regarding your child's bus. We are currently facing an unexpected issue, and the bus will be delayed.",
    "This is a quick update about your child’s bus. Due to an emergency, there is a delay in the bus's route.",
    "We are experiencing an emergency situation with the school bus. Please know that all students are safe, and we are working to resolve the issue.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
    "This is an important message regarding your child's school bus. Due to an unforeseen situation, the bus is experiencing a delay.",
  ];

  final AlertService _alertService = AlertService();
  bool _isLoading = false;

  void _handleAlertSend()async{
    setState(() => _isLoading = true);

    Map<String, dynamic> res = await _alertService.saveAlert(alerts[_selectedIndex!], widget.driverId);

    if(res["success"]){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
      setState(() {
        _isLoading = false;
      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Alerts"),
        backgroundColor: const Color.fromRGBO(58, 89, 243, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(
                      alerts[index],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: _selectedIndex,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedIndex = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: MaterialButton(
                onPressed: _handleAlertSend,
                color: const Color.fromRGBO(58, 89, 243, 1),
                minWidth: 300,
                padding: EdgeInsets.all(10),
                textColor: Colors.white,
                child: _isLoading? const CircularProgressIndicator(color: Colors.white):const Text(
                  "Send",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
