import 'package:flutter/material.dart';

void main() {
  runApp(const ZimDashApp());
}

class ZimDashApp extends StatelessWidget {
  const ZimDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZimDash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF009739),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF009739)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF009739),
        title: const Text('ZimDash 🇿🇼', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF009739), borderRadius: BorderRadius.circular(12)),
            child: const Text('Order Chicken Inn & Groceries\nDelivered in 30 mins in Harare', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          const Text('Fast Food', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          shopCard('Chicken Inn', '2 Piece, Burgers', '30 min', '💰 \$3 - \$12'),
          shopCard('KFC', 'Streetwise, Buckets', '25 min', '💰 \$4 - \$18'),
          const SizedBox(height: 20),
          const Text('Groceries', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          shopCard('TM Pick n Pay', 'Rice, Mazoe, Bread', '35 min', '💰 USD + ZiG'),
          shopCard('OK Mart', 'Groceries & Meats', '40 min', '💰 EcoCash & Cash'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF009739),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget shopCard(String name, String desc, String time, String price) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFF009739), child: Text('🍗', style: TextStyle(fontSize: 20))),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$desc\n$time • $price'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
