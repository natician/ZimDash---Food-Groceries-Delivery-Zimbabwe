import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppData(), child: const ZimConnectApp()));
}

class AppData extends ChangeNotifier {
  String name = '';
  String phone = '';
  String email = '';
  bool isLoggedIn = false;
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> marketItems = [
    {'title':'Original Sneakers Size 42','price':25,'seller':'Tinashe 077...','location':'Mbare Musika','img':'👟'},
    {'title':'Tomatoes Crate','price':12,'seller':'Amai Chipo 078...','location':'Mbare','img':'🍅'},
    {'title':'iPhone 12','price':280,'seller':'Mike 071...','location':'CBD','img':'📱'},
    {'title':'Zim Dancehall Mix 2024','price':0,'seller':'DJ Levels 077...','location':'Nearby - 50m','img':'🎵'},
  ];
  List<Map<String, dynamic>> messages = [
    {'name':'Tinashe (Nearby)','last':'Sent you: Oliver Mtukudzi movie.mp4','offline':true},
    {'name':'Amai - Market','last':'Muri kupi? Tomatoes still available?','offline':false},
  ];

  void login(String n, String p, String e) {
    name = n; phone = p; email = e; isLoggedIn = true;
    notifyListeners();
  }
}

class ZimConnectApp extends StatelessWidget {
  const ZimConnectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color(0xFF009739)),
      home: Consumer<AppData>(builder: (_, data, __) => data.isLoggedIn? const MainNav() : const LoginPage()),
    );
  }
}

// LOGIN - NAME + PHONE, EMAIL OPTIONAL
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final emailC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF009739),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('🇿🇼', style: TextStyle(fontSize: 50)),
                  const Text('ZimConnect', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const Text('Chat • Share Files Without Data • Market', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Full Name *', hintText: 'e.g. Tinashe Moyo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 12),
                  TextField(controller: phoneC, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone Number *', hintText: '+263 77 123 4567', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone))),
                  const SizedBox(height: 12),
                  TextField(controller: emailC, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email (Optional)', hintText: 'You can skip this', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email_outlined))),
                  const SizedBox(height: 8),
                  const Text('Email is optional. We use phone number only.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 20),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009739), padding: const EdgeInsets.all(16)),
                    onPressed: () {
                      if(nameC.text.isEmpty || phoneC.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and Phone required!')));
                        return;
                      }
                      Provider.of<AppData>(context, listen: false).login(nameC.text, phoneC.text, emailC.text);
                    },
                    child: const Text('START CHATTING - NO DATA NEEDED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )),
                  const SizedBox(height: 12),
                  const Text('By continuing you agree to use WiFi Direct for nearby sharing (0 bundle).', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
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
  final pages = [const ChatPage(), const NoDataSharePage(), const MarketPage(), const ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx, onTap: (i) => setState(()=>idx=i),
        type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFF009739),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.wifi_tethering), label: 'Share No Data'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Chats - ${data.name}'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white),
      body: ListView.builder(itemCount: data.messages.length, itemBuilder: (_, i) => ListTile(
        leading: CircleAvatar(backgroundColor: data.messages[i]['offline']? Colors.orange : Colors.green, child: Text(data.messages[i]['name'][0])),
        title: Text(data.messages[i]['name']),
        subtitle: Text(data.messages[i]['last']),
        trailing: data.messages[i]['offline']? const Text('NO DATA • Nearby', style: TextStyle(fontSize:10, color: Colors.orange, fontWeight: FontWeight.bold)) : const Icon(Icons.check, color: Colors.blue),
      )),
      floatingActionButton: FloatingActionButton(onPressed: (){}, backgroundColor: const Color(0xFF009739), child: const Icon(Icons.chat_bubble, color: Colors.white)),
    );
  }
}

class NoDataSharePage extends StatelessWidget {
  const NoDataSharePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Without Data'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)), child: const Column(children: [
              Icon(Icons.wifi_tethering, color: Colors.green, size: 40),
              SizedBox(height: 8),
              Text('NEARBY MODE: ON', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              Text('No bundles needed. Sharing via WiFi Direct.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('Speed: 20MB/s • Range: 100m', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ])),
            const SizedBox(height: 16),
            const Text('Nearby People in Harare (No Data)', style: TextStyle(fontWeight: FontWeight.bold)),
            const ListTile(leading: CircleAvatar(child: Text('T')), title: Text('Tinashe - Tecno Spark'), subtitle: Text('50m away • Ready to receive'), trailing: Icon(Icons.wifi, color: Colors.green)),
            const ListTile(leading: CircleAvatar(child: Text('C')), title: Text('Chipo - Samsung A12'), subtitle: Text('12m away • Ready to receive'), trailing: Icon(Icons.wifi, color: Colors.green)),
            const Spacer(),
            Row(children: [
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.image), label: const Text('Send Image'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.music_note), label: const Text('Music'), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.movie), label: const Text('Movie/Video'), style: ElevatedButton.styleFrom(backgroundColor: Colors.red))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.folder), label: const Text('Any File'), style: ElevatedButton.styleFrom(backgroundColor: Colors.purple))),
            ]),
            const SizedBox(height: 8),
            const Text('You can send: JPG, MP3, MP4 movies, APK, PDF, ZIP - ANYTHING, no bundle!', style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace - Harare'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white, actions: [IconButton(icon: const Icon(Icons.add), onPressed: (){})]),
      body: ListView.builder(itemCount: data.marketItems.length, itemBuilder: (_, i) {
        var item = data.marketItems[i];
        return Card(child: ListTile(
          leading: Text(item['img'], style: const TextStyle(fontSize: 30)),
          title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${item['location']} • ${item['seller']}'),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('\$${item['price']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)), const Text('Chat', style: TextStyle(color: Colors.blue, fontSize: 12))]),
        ));
      }),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white),
      body: ListView(children: [
        ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(data.name), subtitle: Text('${data.phone} ${data.email.isNotEmpty? "• ${data.email}" : ""}')),
        const Divider(),
        const ListTile(leading: Icon(Icons.wifi_tethering), title: Text('Data Saver: Nearby Sharing ON'), subtitle: Text('Movies & music without bundle - 0 data')),
        const ListTile(leading: Icon(Icons.security), title: Text('Login: Phone Number Only'), subtitle: Text('Email optional as you requested')),
        const ListTile(leading: Icon(Icons.language), title: Text('Language: English / Shona')),
      ]),
    );
  }
}
