// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Mp3ListApp extends StatelessWidget {
//   const Mp3ListApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pháp thoại làng mai',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Mp3ListScreen(),
//     );
//   }
// }

// class Mp3ListScreen extends StatefulWidget {
//   const Mp3ListScreen({super.key});

//   @override
//   _Mp3ListScreenState createState() {
//     return _Mp3ListScreenState();
//   }
// }

// class _Mp3ListScreenState extends State<Mp3ListScreen> {
//   List<String> mp3Links = [];
//   bool isLoading = true;
//   final AudioPlayer audioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     fetchMp3Links();
//   }

//   Future<void> fetchMp3Links() async {
//     debugPrint('Refreshing the links');
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "https://langmai.org/thien-duong/nghe-phap-thoai/nghe-phap-thoai-audio/",
//         ),
//       );
//       if (response.statusCode == 200) {
//         String body = response.body;
//         RegExp regExp = RegExp(
//           r'(https?:\/\/[^\s"]+\.mp3)',
//           caseSensitive: false,
//         );
//         Iterable<RegExpMatch> matches = regExp.allMatches(body);

//         setState(() {
//           mp3Links = matches.map((match) => match.group(0)!).toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception("Failed to load page");
//       }
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pháp thoại làng mai")),
//       body:
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                 itemCount: mp3Links.length,
//                 itemBuilder: (context, index) {
//                   final url = mp3Links[index];
//                   return ListTile(
//                     title: Text(url.split('/').last),
//                     subtitle: Text(url),
//                     trailing: Icon(Icons.play_arrow),
//                     onTap: () async {
//                       await _launchUrl(Uri.parse(url));
//                     },
//                   );
//                 },
//               ),
//     );
//   }
// }

// Future<void> _launchUrl(Uri url) async {
//   if (!await launchUrl(url)) {
//     throw Exception('Could not launch $url');
//   }
// }
