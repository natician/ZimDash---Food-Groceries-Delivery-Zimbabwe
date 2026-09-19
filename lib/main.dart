import 'package:flutter/material.dart';

void main() {
  runApp(const ZimDashApp());
}

class ZimDashApp extends StatelessWidget {
  const ZimDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZimDash',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('ZimDash 🇿🇼'), backgroundColor: const Color(0xFF0f172a)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _card('USD / ZiG Rate', '1 USD = 26.5 ZiG'),
            _card('Fuel', 'Diesel: \$1.68 | Petrol: \$1.65'),
            _card('Status', 'App is working! ✅'),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value) {
    return Card(
      color: const Color(0xFF1e293b),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Color(0xFF38bdf8), fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}
