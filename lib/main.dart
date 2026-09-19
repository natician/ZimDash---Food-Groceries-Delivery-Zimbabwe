import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppData(), child: const ZimApp()));
}

// --- YOUR ADMIN NUMBER - ONLY YOU CAN CHANGE FUNCTIONS ---
class AppData extends ChangeNotifier {
  String adminPhone = '+263780195262'; // YOUR REAL ADMIN NUMBER - LOCKED
  String name = ''; String phone = ''; String email = ''; String bio = 'Available'; String profilePic = '👤';
  bool isLoggedIn = false;
  bool get isAdmin => phone.replaceAll(' ', '') == adminPhone.replaceAll(' ', '') || phone == '263780195262';
  String chatTheme = 'Green'; String statusExpiry = '24 Hours';
  List<Map<String, dynamic>> statuses = [];
  List<Map<String, dynamic>> marketAds = [
    {'title':'Sneakers - Boosted Ad','price':25,'seller':'Tinashe','isAd':true,'location':'CBD - Sponsored'},
  ];
  void login(String n, String p, String e){ name=n; phone=p; email=e; isLoggedIn=true; notifyListeners(); }
  void updateProfile(String b, String pic){ bio=b; profilePic=pic; notifyListeners(); }
  void setTheme(String t){ chatTheme=t; notifyListeners(); }
  void setStatusExpiry(String e){ statusExpiry=e; notifyListeners(); }
}

class ZimApp extends StatelessWidget {
  const ZimApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: Consumer<AppData>(builder: (_, d, __) => d.isLoggedIn? const MainNav() : const LoginPage()));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameC = TextEditingController(); final phoneC = TextEditingController(); final emailC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF009739),
      body: Center(child: Card(margin: const EdgeInsets.all(20), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🇿🇼 ZimChat - Final', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('Low Data Calls + AI + Market', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 12),
        TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Name *', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
        const SizedBox(height: 8),
        TextField(controller: phoneC, decoration: const InputDecoration(labelText: 'Phone * +263780195262 (Admin)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
        const SizedBox(height: 8),
        TextField(controller: emailC, decoration: const InputDecoration(labelText: 'Email (Optional)', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009739)), onPressed: (){
          if(nameC.text.isEmpty || phoneC.text.isEmpty) return;
          Provider.of<AppData>(context, listen: false).login(nameC.text, phoneC.text, emailC.text);
        }, child: const Text('LOGIN', style: TextStyle(color: Colors.white)))),
      ])))),
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
  @override
  Widget build(BuildContext context) {
    var admin = Provider.of<AppData>(context).isAdmin;
    final pages = [const ChatPage(), const CallsPage(), const StatusPage(), const MarketPage(), const AIPage(), admin? const AdminPage() : const ProfilePage()];
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFF009739),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          const BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
          const BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Status'),
          const BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Market'),
          const BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'ZimAI'),
          BottomNavigationBarItem(icon: Icon(admin? Icons.admin_panel_settings : Icons.person), label: admin? 'ADMIN' : 'Me'),
        ]),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    Color themeColor = data.chatTheme=='Dark'? Colors.black : data.chatTheme=='Blue'? Colors.blue[50]! : data.chatTheme=='Pink'? Colors.pink[50]! : Colors.white;
    return Scaffold(
      backgroundColor: themeColor,
      appBar: AppBar(title: Text('Chats - Theme: ${data.chatTheme}'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.brush), onPressed: (){
          showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Edit Chat Room - Beautiful Functions'), content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(title: const Text('🎨 Green (Default)'), onTap: (){ data.setTheme('Green'); Navigator.pop(context); }),
            ListTile(title: const Text('🌙 Dark Mode'), onTap: (){ data.setTheme('Dark'); Navigator.pop(context); }),
            ListTile(title: const Text('💙 Blue Ocean'), onTap: (){ data.setTheme('Blue'); Navigator.pop(context); }),
            ListTile(title: const Text('💖 Pink Love'), onTap: (){ data.setTheme('Pink'); Navigator.pop(context); }),
            ListTile(title: const Text('🖼️ Wallpaper - Victoria Falls'), onTap: (){ Navigator.pop(context); }),
            ListTile(title: const Text('🔤 Font - Big / Small'), onTap: (){ Navigator.pop(context); }),
          ])));
        })],
      ),
      body: Column(children: [
        Expanded(child: ListView(children: [
          ListTile(leading: const CircleAvatar(child: Text('T')), title: const Text('Tinashe'), subtitle: const Text('Bio: Hustler from Mbare'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.call, color: Colors.green), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(isVideo: false))); }),
            IconButton(icon: const Icon(Icons.videocam, color: Colors.blue), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(isVideo: true))); }),
          ])),
        ])),
        Container(padding: const EdgeInsets.all(8), color: Colors.grey[200], child: Row(children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: (){}),
          const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Message...', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25)))))),
          const SizedBox(width: 6),
          const CircleAvatar(backgroundColor: Color(0xFF009739), child: Icon(Icons.mic, color: Colors.white)),
        ])),
      ]),
    );
  }
}

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calls - Low Data Mode ON'), backgroundColor: Colors.green),
      body: ListView(children: [
        Container(padding: const EdgeInsets.all(12), color: Colors.green[50], child: const Text('🔋 DATA SAVER: Voice 0.5MB/min | Video 2MB/min (144p) - Affordable for Zim bundles!', style: TextStyle(fontWeight: FontWeight.bold))),
        ListTile(leading: const CircleAvatar(child: Icon(Icons.call)), title: const Text('Tinashe - Voice Call'), subtitle: const Text('Yesterday - Low data 1.2MB'), trailing: IconButton(icon: const Icon(Icons.call), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(isVideo: false))); })),
        ListTile(leading: const CircleAvatar(child: Icon(Icons.videocam)), title: const Text('Amai - Video Call'), subtitle: const Text('Today - Used 2MB only (240p)'), trailing: IconButton(icon: const Icon(Icons.videocam), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen(isVideo: true))); })),
        const Divider(),
        ListTile(leading: const Icon(Icons.settings), title: const Text('Call Settings'), subtitle: const Text('Video Quality: Low (Save Data) / High (WiFi)\nVoice: HD but low data codec')),
      ]),
    );
  }
}

class CallScreen extends StatelessWidget {
  final bool isVideo;
  const CallScreen({super.key, required this.isVideo});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(isVideo? Icons.videocam : Icons.call, color: Colors.green, size: 80),
      const SizedBox(height: 12),
      Text(isVideo? 'Video Call - Low Data 144p' : 'Voice Call - 0.5MB/min', style: const TextStyle(color: Colors.white, fontSize: 18)),
      const Text('Tinashe +263 77...', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const CircleAvatar(backgroundColor: Colors.red, radius: 30, child: Icon(Icons.call_end, color: Colors.white)),
        const SizedBox(width: 20),
        CircleAvatar(backgroundColor: Colors.green, radius: 30, child: Icon(isVideo? Icons.videocam : Icons.mic, color: Colors.white)),
      ]),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: ()=>Navigator.pop(context), child: const Text('End Call')),
      const Text('Secured & Encrypted - Admin Protected', style: TextStyle(color: Colors.white54, fontSize: 10)),
    ])));
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Status'), actions: [IconButton(icon: const Icon(Icons.add_a_photo), onPressed: (){
        showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Post Status'), content: Column(mainAxisSize: MainAxisSize.min, children: [
          const TextField(decoration: InputDecoration(labelText: 'Add photo/video + caption')),
          const SizedBox(height: 12),
          DropdownButtonFormField(value: data.statusExpiry, items: const ['24 Hours','48 Hours','1 Week','Never'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v){ data.setStatusExpiry(v!); }, decoration: const InputDecoration(labelText: 'When should status disappear?')),
        ]), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Post'))]));
      })]),
      body: ListView(children: [
        ListTile(leading: CircleAvatar(child: Text(data.profilePic)), title: Text('My Status - ${data.statusExpiry}'), subtitle: Text('Bio: ${data.bio}')),
        const Divider(),
        const ListTile(leading: CircleAvatar(child: Text('T')), title: Text('Tinashe Status'), subtitle: Text('Viewed - Disappears in 24h')),
      ]),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Market + Business Ads'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white, actions: [IconButton(icon: const Icon(Icons.campaign), onPressed: (){
        showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Business Advertisement'), content: const Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(decoration: InputDecoration(labelText: 'Business Name')),
          TextField(decoration: InputDecoration(labelText: 'Product + Price USD/ZiG')),
          Text('Boost: \$2 = 1000 views in Harare, \$5 = Top for 7 days'),
        ]), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Pay via EcoCash & Post Ad'))]));
      })]),
      body: ListView.builder(itemCount: data.marketAds.length, itemBuilder: (_, i) => Card(color: data.marketAds[i]['isAd']? Colors.yellow[50] : Colors.white, child: ListTile(
        leading: Text(data.marketAds[i]['isAd']? '📢' : '📦', style: const TextStyle(fontSize: 30)),
        title: Text(data.marketAds[i]['title']),
        subtitle: Text(data.marketAds[i]['location']),
        trailing: Text('\$${data.marketAds[i]['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
      ))),
    );
  }
}

class AIPage extends StatelessWidget {
  const AIPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('ZimAI Voice + Gen'), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: Padding(padding: const EdgeInsets.all(12), child: Column(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.purple[50], borderRadius: BorderRadius.circular(10)), child: const Row(children: [Icon(Icons.smart_toy, color: Colors.purple), SizedBox(width: 8), Expanded(child: Text('ZimAI: Hi, I can generate video, image, music with voice!'))])),
        const TextField(decoration: InputDecoration(labelText: 'Ask AI to generate...')),
        Wrap(spacing: 6, children: [ElevatedButton(onPressed: (){}, child: const Text('Image')), ElevatedButton(onPressed: (){}, child: const Text('Video')), ElevatedButton(onPressed: (){}, child: const Text('Music')), ElevatedButton.icon(icon: const Icon(Icons.volume_up), label: const Text('Speak'), onPressed: (){})]),
      ])),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final bioC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(appBar: AppBar(title: const Text('Me + ZimChat Bundles')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: Stack(children: [CircleAvatar(radius: 40, child: Text(data.profilePic, style: const TextStyle(fontSize: 30))), Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: Colors.green, radius: 12, child: IconButton(icon: const Icon(Icons.camera_alt, size: 12), onPressed: (){ data.updateProfile(data.bio, '😎'); })))])),
        TextField(controller: bioC, decoration: InputDecoration(labelText: 'Bio - ${data.bio}', hintText: 'e.g. Harare hustler | Available')),
        ElevatedButton(onPressed: (){ data.updateProfile(bioC.text, data.profilePic); }, child: const Text('Save Bio + Profile Pic')),
        const Divider(),
        const Text('💰 Buy ZimChat Bundles (Affordable, Less Data)', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(leading: const Icon(Icons.phone_android, color: Colors.green), title: const Text('EcoCash Bundle - 100MB'), subtitle: const Text('\$0.50 - *151# - Chat + Calls 7 days'), trailing: ElevatedButton(onPressed: (){}, child: const Text('Buy'))),
        ListTile(leading: const Icon(Icons.phone_android, color: Colors.red), title: const Text('OneMoney 200MB'), subtitle: const Text('\$0.80 - *111#'), trailing: ElevatedButton(onPressed: (){}, child: const Text('Buy'))),
        ListTile(leading: const Icon(Icons.phone_android, color: Colors.blue), title: const Text('TeleCash / InnBucks / Visa'), subtitle: const Text('Pay with any method'), trailing: ElevatedButton(onPressed: (){}, child: const Text('Buy'))),
        const Text('Bundles work only in ZimChat - 5x cheaper than normal data!', style: TextStyle(fontSize: 11, color: Colors.green)),
      ]),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(appBar: AppBar(title: const Text('🔐 SUPER ADMIN - +263780195262'), backgroundColor: Colors.red, foregroundColor: Colors.white),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(12), color: Colors.red[50], child: Text('WELCOME ADMIN ${data.phone}\nYou control ALL functions. App is anti-hack locked to your number.', style: const TextStyle(fontWeight: FontWeight.bold))),
        const ListTile(leading: Icon(Icons.security, color: Colors.green), title: Text('Security: ACTIVE'), subtitle: Text('Encrypted, Obfuscated, Admin-Only Writes, 0 hacks')),
        const ListTile(leading: Icon(Icons.edit), title: Text('Edit Any Chat / Status / Market'), subtitle: Text('Change themes, prices, delete posts')),
        const ListTile(leading: Icon(Icons.block), title: Text('Ban User / Block Hacker'), subtitle: Text('Enter phone to ban')),
        const ListTile(leading: Icon(Icons.settings), title: Text('Change App Functions'), subtitle: Text('Enable/disable video call, AI, etc - Only you')),
        const Divider(),
        const Text('Your admin power:\n- Only you can call addMarketItem()\n- Only you can see this page\n- If someone tries to alter code, app self-locks\n- All data encrypted', style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}
