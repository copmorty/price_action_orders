// import 'package:flutter/foundation.dart';
// import 'package:price_action_orders/injection_container.dart';
// import 'package:price_action_orders/z_old/models.dart';
// import 'package:price_action_orders/z_old/service_websocket.dart';
// import 'package:provider/provider.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// // String socket = 'wss://echo.websocket.org';
// // String pair = 'BTC/USDT';
// // String parameterPair = pair.toLowerCase().replaceAll(RegExp(r'/'), '');
// // String socket = 'wss://stream.binance.com:9443/ws/$parameterPair@bookTicker';

// void main() {
//   init();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // final title = 'WebSocket Demo';
//     // final channel = IOWebSocketChannel.connect(socket);
//     print('!!!!!!!!!! channel defined');
//     return MultiProvider(
//       providers: [
//         Provider<IOWebSocketChannel>.value(value: sl<PaoWebSocket>().channel),
//         // StreamProvider<StreamCha>.value(value: channel.stream, initialData: null,)
//       ],
//       child: MaterialApp(
//         title: 'Price Action Orders',
//         home: HomeScreen(),
//         theme: ThemeData.dark(),
//       ),
//     );

//     // return MaterialApp(
//     //   title: title,
//     //   home: MyHomePage(
//     //     title: title,
//     //     // channel: IOWebSocketChannel.connect(socket),
//     //     channel: sl<PaoWebSocket>().channel,
//     //   ),
//     //   theme: ThemeData.dark(),
//     // );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final channel = Provider.of<IOWebSocketChannel>(context);
//     // final channelStream = Provider.of<dynamic>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Price Action Orders'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 3,
//               child: Center(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         pair,
//                       ),
//                     ),
//                     Expanded(
//                       child: StreamBuilder(
//                         stream: channel.stream,
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) return SizedBox();
//                           // final data = jsonDecode(snapshot.data);
//                           final data = BookTicker.fromStringifiedMap(snapshot.data);
//                           print(snapshot.data);
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 color: Colors.green,
//                                 child: Text(data.bidPrice.toString()),
//                               ),
//                               Container(
//                                 color: Colors.red,
//                                 child: Text(data.askPrice.toString()),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   final String title;
//   final WebSocketChannel channel;

//   MyHomePage({Key key, @required this.title, @required this.channel})
//       : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             StreamBuilder(
//               stream: widget.channel.stream,
//               builder: (context, snapshot) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 24.0),
//                   child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       widget.channel.sink.add(_controller.text);
//     }
//   }

//   @override
//   void dispose() {
//     widget.channel.sink.close();
//     super.dispose();
//   }
// }
