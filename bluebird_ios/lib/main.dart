import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const BluebirdApp());
}

class BluebirdApp extends StatelessWidget {
  const BluebirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Bluebird',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: FileTransferPage(),
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
  String status = 'Disconnected';
  final TextEditingController _ipController = TextEditingController();

  void _connect(String ip) {
    setState(() => status = 'Connecting to $ip...');
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://$ip:8080'));
      channel!.stream.listen((message) {
        setState(() => status = 'Received: $message');
      }, onDone: () {
        setState(() => status = 'Disconnected');
      }, onError: (error) {
        setState(() => status = 'Error: $error');
      });
      setState(() => status = 'Connected to $ip');
    } catch (e) {
      setState(() => status = 'Connection Error');
    }
  }

  Future<void> _pickAndSendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String filename = p.basename(file.path);
      List<int> bytes = await file.readAsBytes();

      channel?.sink.add(jsonEncode({
        "type": "file_transfer_init",
        "payload": {"filename": filename, "size": bytes.length}
      }));
      channel?.sink.add(bytes);
      setState(() => status = 'Sent: $filename');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Bluebird')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text('Status: $status', style: CupertinoTheme.of(context).textTheme.textStyle),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _ipController,
                placeholder: 'Enter Windows PC IP (e.g. 192.168.1.5)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                onPressed: () => _connect(_ipController.text),
                child: const Text('Connect'),
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                onPressed: _pickAndSendFile,
                child: const Text('Pick and Send File'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
