import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppData(), child: const ZimApp()));
}

class AppData extends ChangeNotifier {
  String adminPhone = '+263780195262';
  String name = ''; String phone = ''; bool isLoggedIn = false;
  bool get isAdmin => phone.replaceAll(' ', '').contains('780195262');

  List<Map<String, dynamic>> contacts = [
    {'name':'Tinashe Moyo','phone':'+263771111111','hasApp':true,'bio':'Available','pic':'T'},
    {'name':'Chipo - Mbare','phone':'+263772222222','hasApp':true,'bio':'Selling tomatoes','pic':'C'},
    {'name':'Mike CBD','phone':'+263773333333','hasApp':false,'bio':'Invite to ZimChat','pic':'M'},
    {'name':'Amai','phone':'+263774444444','hasApp':true,'bio':'At market','pic':'A'},
  ];

  List<Map<String, dynamic>> chats = [
    {'name':'Tinashe Moyo','last':'Hey, movie ready?','time':'10:32','unread':2,'pic':'T','messages':[{'text':'Hey, movie ready?','isMe':false,'tick':'✓✓'}]},
    {'name':'Mbare Traders GROUP','last':'Chipo: Tomatoes $12','time':'09:15','unread':5,'pic':'G','isGroup':true,'messages':[{'text':'Tomatoes $12 crate','isMe':false}]},
  ];

  void login(String n, String p){ name=n; phone=p; isLoggedIn=true; notifyListeners(); }
  void sendMessage(int chatIndex, String text){
    chats[chatIndex]['messages'].add({'text':text,'isMe':true,'tick':'✓'});
    chats[chatIndex]['last'] = text;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), (){ chats[chatIndex]['messages'].last['tick']='✓✓'; notifyListeners(); });
  }
  void createGroup(String gname){
    chats.insert(0, {'name':gname,'last':'Group created','time':'now','unread':0,'pic':'G','isGroup':true,'messages':[]});
    notifyListeners();
  }
}

class ZimApp extends StatelessWidget {
  const ZimApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Consumer<AppData>(builder: (_, d, __) => d.isLoggedIn? const MainNav() : const LoginPage()));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final nameC = TextEditingController(); final phoneC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xFF009739), body: Center(child: Card(margin: const EdgeInsets.all(20), child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('ZimChat - WhatsApp Style', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Name *', border: OutlineInputBorder())),
      const SizedBox(height: 8),
      TextField(controller: phoneC, decoration: const InputDecoration(labelText: 'Phone +263780195262 Admin', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF009739)), onPressed: (){
        Provider.of<AppData>(context, listen: false).login(nameC.text, phoneC.text);
      }, child: const Text('LOGIN', style: TextStyle(color: Colors.white)))),
    ])))),
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
    final pages = [const ChatListPage(), const StatusPage(), const CallsPage(), admin? const AdminPage() : const ProfilePage()];
    return Scaffold(body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFF009739),
        items: [const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'), const BottomNavigationBarItem(icon: Icon(Icons.circle_outlined), label: 'Status'), const BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'), BottomNavigationBarItem(icon: Icon(admin? Icons.admin_panel_settings : Icons.person), label: admin? 'ADMIN' : 'Me')]));
  }
}

// CHAT LIST LIKE WHATSAPP
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('ZimChat'), backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.group_add), onPressed: (){
          showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Create Group Chat'), content: const TextField(decoration: InputDecoration(labelText: 'Group Name e.g. Mbare Traders')), actions: [TextButton(onPressed: (){
            data.createGroup('Mbare Traders'); Navigator.pop(context);
          }, child: const Text('Create Group'))]));
        }), IconButton(icon: const Icon(Icons.person_add), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage())); })],
      ),
      body: ListView.builder(itemCount: data.chats.length, itemBuilder: (_, i){
        var chat = data.chats[i];
        return ListTile(
          leading: CircleAvatar(backgroundColor: chat['isGroup']!=null? Colors.orange : Colors.green, child: Text(chat['pic'])),
          title: Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat['last']),
          trailing: Column(children: [Text(chat['time'], style: const TextStyle(fontSize: 11)), if(chat['unread']>0) CircleAvatar(radius: 10, backgroundColor: Colors.green, child: Text('${chat['unread']}', style: const TextStyle(fontSize: 10, color: Colors.white)))]),
          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => ChatOpenPage(chatIndex: i))); },
        );
      }),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF009739), onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsPage())); }, child: const Icon(Icons.chat, color: Colors.white)),
    );
  }
}

// CONTACT LIST - SEE WHO USES APP
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Contacts - ${data.contacts.where((c)=>c['hasApp']).length} use ZimChat'), actions: [IconButton(icon: const Icon(Icons.link), onPressed: (){
        showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Invite via Link'), content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Share this link:'),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.all(8), color: Colors.grey[200], child: const Text('https://zimchat.co.zw/join/263780195262', style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          const Text('Anyone who clicks joins ZimChat and sees you as contact.'),
        ]), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Share via WhatsApp')), TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Copy Link'))]));
      })]),
      body: ListView(
        children: [
          const ListTile(leading: CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.group_add, color: Colors.white)), title: Text('New Group'), subtitle: Text('Create group chat')),
          const ListTile(leading: CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.person_add, color: Colors.white)), title: Text('Invite Friends'), subtitle: Text('Share ZimChat link - No data needed via Nearby')),
          const Divider(),
         ...data.contacts.map((c) => ListTile(
            leading: CircleAvatar(child: Text(c['pic'])),
            title: Text(c['name']),
            subtitle: Text(c['bio']),
            trailing: c['hasApp']? const Text('● ZimChat', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)) : ElevatedButton(onPressed: (){}, child: const Text('Invite')),
            onTap: (){
              if(c['hasApp']){
                int idx = data.chats.indexWhere((ch)=>ch['name']==c['name']);
                if(idx==-1){ data.chats.insert(0, {'name':c['name'],'last':'Hi!','time':'now','unread':0,'pic':c['pic'],'messages':[]}); idx=0; }
                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatOpenPage(chatIndex: idx)));
              }
            },
          )),
        ],
      ),
    );
  }
}

// OPEN CHAT - LIKE WHATSAPP
class ChatOpenPage extends StatefulWidget {
  final int chatIndex;
  const ChatOpenPage({super.key, required this.chatIndex});
  @override
  State<ChatOpenPage> createState() => _ChatOpenPageState();
}
class _ChatOpenPageState extends State<ChatOpenPage> {
  final msgC = TextEditingController();
  bool isRecording = false;
  double swipeDx = 0;

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AppData>(context);
    var chat = data.chats[widget.chatIndex];
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF009739), foregroundColor: Colors.white, title: Row(children: [CircleAvatar(child: Text(chat['pic'])), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(chat['name'], style: const TextStyle(fontSize: 16)), Text(chat['isGroup']!=null? 'Tinashe, Chipo, +3' : 'Online - Low data mode', style: const TextStyle(fontSize: 11))])]), actions: [IconButton(icon: const Icon(Icons.videocam), onPressed: (){}), IconButton(icon: const Icon(Icons.call), onPressed: (){})]),
      body: Column(children: [
        Expanded(child: ListView.builder(itemCount: chat['messages'].length, itemBuilder: (_, i){
          var m = chat['messages'][i];
          return Align(alignment: m['isMe']? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.all(6), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: m['isMe']? const Color(0xFFDCF8C6) : Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(m['text']), const SizedBox(width: 6), Text(m['tick']??'✓', style: TextStyle(fontSize: 10, color: m['tick']=='✓✓'? Colors.blue : Colors.grey)])));
        })),
        // CAMERA + TEXT + VOICE SWIPE LIKE WHATSAPP
        Container(color: Colors.grey[200], padding: const EdgeInsets.all(6), child: Row(children: [
          IconButton(icon: const Icon(Icons.camera_alt, color: Colors.blue), onPressed: (){
            // TAP CAMERA -> OPEN CAMERA
            showDialog(context: context, builder: (_) => AlertDialog(title: const Text('📷 Camera'), content: const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.camera, size: 80), Text('Camera open - Take picture and share instantly to chat')]), actions: [TextButton(onPressed: (){ Navigator.pop(context); data.sendMessage(widget.chatIndex, '📷 Photo - IMG_001.jpg'); }, child: const Text('Take & Send'))]));
          }),
          Expanded(child: TextField(controller: msgC, decoration: InputDecoration(hintText: 'Message', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)), contentPadding: const EdgeInsets.symmetric(horizontal: 16)))),
          const SizedBox(width: 6),
          // SWIPE TO RECORD LIKE WHATSAPP
          GestureDetector(
            onHorizontalDragUpdate: (d){ setState(()=>swipeDx = d.delta.dx); },
            onLongPressStart: (_) { setState(()=>isRecording=true); },
            onLongPressEnd: (_) { setState(()=>isRecording=false); data.sendMessage(widget.chatIndex, '🎤 Voice note 0:08'); },
            child: AnimatedContainer(duration: const Duration(milliseconds: 200), transform: Matrix4.translationValues(swipeDx, 0, 0), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isRecording? Colors.red : const Color(0xFF009739), shape: BoxShape.circle), child: Icon(isRecording? Icons.mic : Icons.mic_none, color: Colors.white)),
          ),
          const SizedBox(width: 4),
          CircleAvatar(backgroundColor: const Color(0xFF009739), child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: (){ if(msgC.text.isNotEmpty){ data.sendMessage(widget.chatIndex, msgC.text); msgC.clear(); } })),
        ])),
        if(isRecording) Container(color
