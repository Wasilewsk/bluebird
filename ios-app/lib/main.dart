import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(const BluebirdApp());
}

class BluebirdApp extends StatelessWidget {
  const BluebirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluebird',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const FileTransferPage(),
    );
  }
}

class FileTransferPage extends StatefulWidget {
  const FileTransferPage({super.key});

  @override
  State<FileTransferPage> createState() => _FileTransferPageState();
}

class _FileTransferPageState extends State<FileTransferPage> {
  late WebSocketChannel channel;
  String status = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _connect();
  }

  void _connect() {
    // Note: Use the actual Windows PC IP address
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.xxx:8080'));
    channel.stream.listen((message) {
      setState(() => status = 'Received: $message');
    }, onError: (error) {
      setState(() => status = 'Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluebird File Bridge')),
      body: Column(
        children: [
          Semantics(
            label: 'Connection Status',
            child: Text('Status: $status'),
          ),
          ElevatedButton(
            onPressed: () {
              channel.sink.add(jsonEncode({
                "type": "file_transfer",
                "payload": {"filename": "test.txt"}
              }));
            },
            child: const Semantics(
              label: 'Send Test File',
              child: Text('Send Test'),
            ),
          ),
        ],
      ),
    );
  }
}
