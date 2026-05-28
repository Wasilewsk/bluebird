import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'dart:io';

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
  WebSocketChannel? channel;
  String status = 'Searching...';

  @override
  void initState() {
    super.initState();
    _discoverAndConnect();
  }

  // Simplified discovery: User selects device or scan network
  // In a full implementation, use network scanning here
  Future<void> _discoverAndConnect() async {
    // Mock discovery: In production, scan local IP range
    String targetIp = "192.168.1.100"; // Example
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://$targetIp:8080'));
      setState(() => status = 'Connected to $targetIp');
    } catch (e) {
      setState(() => status = 'Failed to connect');
    }
  }

  void _sendFile() {
    // Add logic to pick file and stream
    channel?.sink.add(jsonEncode({"type": "file_transfer", "payload": {"filename": "test.txt"}}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluebird')),
      body: Column(
        children: [
          Text('Status: $status'),
          ElevatedButton(onPressed: _sendFile, child: Text('Send File')),
        ],
      ),
    );
  }
}
