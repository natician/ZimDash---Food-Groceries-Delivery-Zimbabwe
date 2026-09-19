import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => Cart(), child: const ZimDashApp()));
}

class Cart extends ChangeNotifier {
  List<Map<String, dynamic>> items = [];
  double get total => items.fold(0, (s, i) => s + (i['price'] * i['qty']));
  int get count => items.fold(0, (s, i) => s + i['qty'] as int);
  void add(Map<String, dynamic> p) {
    var idx = items.indexWhere((e) => e['name'] == p['name']);
    if (idx >= 0) { items[idx]['qty']++; } else { items.add({...p, 'qty': 1}); }
    notifyListeners();
  }
  void remove(int i) { items.removeAt(i); notifyListeners(); }
  void clear() { items.clear(); notifyListeners(); }
}

class ZimDashApp extends StatelessWidget {
  const ZimDashApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF009739)),
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  final pages = [const HomePage(), const CartPage(), const OrdersPage(), const ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx, onTap: (i) => setState(() => idx = i),
        selectedItemColor: const Color(0xFF009739),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final List shops = const [
    {'name':'Chicken Inn','cat':'Fast Food','time':'25 min','img':'🍗','items':[{'name':'2 Piece & Chips','price':5.5},{'name':'Full Chicken','price':12.0},{'name':'Burger & Chips','price':4.0},{'name':'Spur Burger','price':6.0}]},
    {'name':'KFC','cat':'Fast Food','time':'30 min','img':'🍔','items':[{'name':'Streetwise 2','price':6.0},{'name':'9 Piece Bucket','price':18.0},{'name':'Zinger Burger','price':5.5}]},
    {'name':'Pizza Inn','cat':'Fast Food','time':'35 min','img':'🍕','items':[{'name':'Large Meaty Pizza','price':13.0},{'name':'Chicken Pizza Med','price':9.0},{'name':'Wings 6pc','price':6.5}]},
    {'name':'TM Pick n Pay','cat':'Groceries','time':'40 min','img':'🛒','items':[{'name':'Rice 5kg','price':8.5},{'name':'Mazoe 2L','price':3.2},{'name':'Bread Loaf','price':1.2},{'name':'Milk 2L','price':2.5},{'name':'Eggs 30','price':7.0}]},
    {'name':'OK Mart','cat':'Groceries','time':'35 min','img':'🥩','items':[{'name':'Beef 1kg','price':7.5},{'name':'Chicken 1kg','price':5.0},{'name':'Potatoes 5kg','price':4.0},{'name':'Onions 1kg','price':1.5}]},
    {'name':'Spar','cat':'Groceries','time':'30 min','img':'🥦','items':[{'name':'Tomatoes 1kg','price':2.0},{'name':'Coke 2L','price':2.0},{'name':'Cooking Oil 2L','price':4.5}]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009739),
        title: const Text('ZimDash 🇿🇼 Harare', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [Consumer<Cart>(builder: (_, c, __) => Padding(padding: const EdgeInsets.all(12), child: Text('${c.count} 🛒', style: const TextStyle(color: Colors.white, fontSize: 18))))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF009739), borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Delivering across Harare', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Borrowdale • CBD • Avondale • Highfield • Chitungwiza', style: TextStyle(color: Colors.white70)) ])),
          const SizedBox(height: 16),
          const Text('🔥 Fast Food', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
         ...shops.where((s) => s['cat']=='Fast Food').map((s) => shopCard(context, s)),
          const SizedBox(height: 12),
          const Text('🛒 Groceries & Markets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
         ...shops.where((s) => s['cat']=='Groceries').map((s) => shopCard(context, s)),
        ],
      ),
    );
  }

  Widget shopCard(BuildContext ctx, Map shop) {
    return Card(child: ListTile(
      leading: Text(shop['img'], style: const TextStyle(fontSize: 28)),
      title: Text(shop['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${shop['cat']} • ${shop['time']} • EcoCash • USD • ZiG'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => ShopPage(shop: shop))),
    ));
  }
}

class ShopPage extends StatelessWidget {
  final Map shop;
  const ShopPage({super.key, required this.shop});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shop['name']), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: shop['items'].length,
        itemBuilder: (_, i) {
          var item = shop['items'][i];
          return Card(child: ListTile(
            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${item['price']} USD'),
            trailing: ElevatedButton(onPressed: () { Provider.of<Cart>(context, listen: false).add(item); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['name']} added to cart'))); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009739)), child: const Text('Add', style: TextStyle(color: Colors.white))),
          ));
        },
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String payment = 'EcoCash';
  String suburb = 'CBD';
  final suburbs = ['CBD','Borrowdale','Avondale','Highfield','Warren Park','Chitungwiza','Kuwadzana','Mbare','Greendale'];
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white),
      body: cart.items.isEmpty? const Center(child: Text('Cart empty. Go add Chicken Inn! 🍗')) :
      Column(children: [
        Expanded(child: ListView.builder(itemCount: cart.items.length, itemBuilder: (_, i) => ListTile(title: Text(cart.items[i]['name']), subtitle: Text('Qty: ${cart.items[i]['qty']} • \$${cart.items[i]['price']}'), trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => cart.remove(i))))),
        const Divider(),
        Padding(padding: const EdgeInsets.all(12), child: Column(children: [
          DropdownButtonFormField(value: suburb, items: suburbs.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => suburb = v!), decoration: const InputDecoration(labelText: 'Delivery Suburb - Harare', border: OutlineInputBorder())),
          const SizedBox(height: 8),
          DropdownButtonFormField(value: payment, items: const [DropdownMenuItem(value: 'EcoCash', child: Text('EcoCash - *151#')), DropdownMenuItem(value: 'OneMoney', child: Text('OneMoney')), DropdownMenuItem(value: 'ZiG', child: Text('ZiG')), DropdownMenuItem(value: 'USD Cash', child: Text('USD Cash on Delivery')), DropdownMenuItem(value: 'Card', child: Text('Visa / ZimSwitch'))].map((e) => e).toList(), onChanged: (v) => setState(() => payment = v!), decoration: const InputDecoration(labelText: 'Payment Method', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Text('Delivery: \$2.00 | Total: \$${(cart.total + 2).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { cart.clear(); Navigator.push(context, MaterialPageRoute(builder: (_) => const SuccessPage())); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009739), padding: const EdgeInsets.all(16)), child: Text('Pay with $payment - Order Now', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
        ])),
      ]),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('✅', style: TextStyle(fontSize: 80)), const SizedBox(height: 16), const Text('Order Placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Your rider is on the way in Harare. You will get SMS on EcoCash to confirm payment.', textAlign: TextAlign.center), const SizedBox(height: 20), ElevatedButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('Back to Home'))]))));
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('My Orders'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white), body: ListView(children: const [
      ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('Chicken Inn - 2 Piece'), subtitle: Text('Today • Delivered • \$5.50 • EcoCash'), trailing: Text('⭐ 5.0')),
      ListTile(leading: Icon(Icons.delivery_dining, color: Colors.orange), title: Text('TM Pick n Pay - Groceries'), subtitle: Text('On the way - Rider: Tinashe 077...'), trailing: Text('Live')),
    ]));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Profile'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white), body: ListView(children: const [
      ListTile(leading: CircleAvatar(child: Text('N')), title: Text('Natician'), subtitle: Text('+263 77... • Harare, Zimbabwe')),
      Divider(),
      ListTile(leading: Icon(Icons.location_on), title: Text('Delivery Addresses'), subtitle: Text('Home - Borrowdale, Work - CBD')),
      ListTile(leading: Icon(Icons.payment), title: Text('EcoCash: 077... • ZiG Account'), subtitle: Text('Verified')),
      ListTile(leading: Icon(Icons.language), title: Text('Language: English / Shona')),
      ListTile(leading: Icon(Icons.headset_mic), title: Text('Support: WhatsApp 077...'), subtitle: Text('For Harare deliveries')),
    ]));
  }
}
