import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const HelloWorldApp());
}

class HelloWorldApp extends StatelessWidget {
  const HelloWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Hello Writer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HelloHomePage(),
    );
  }
}

class HelloHomePage extends StatefulWidget {
  const HelloHomePage({super.key});

  @override
  State<HelloHomePage> createState() => _HelloHomePageState();
}

class _HelloHomePageState extends State<HelloHomePage> {
  static const _channel = MethodChannel('com.example.ios_app/native_hello');

  int _counter = 0;
  String _fileContents = '';
  String? _error;
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (!Platform.isIOS) {
      setState(() {
        _error = 'Native channel is only implemented for iOS.';
      });
      return;
    }

    final nextCount = _counter + 1;
    setState(() {
      _counter = nextCount;
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _channel.invokeMethod<String>('writeHello', {
        'count': nextCount,
      });

      setState(() {
        _fileContents = result ?? '';
      });
    } on PlatformException catch (e) {
      setState(() {
        _error = e.message ?? 'Unknown platform error';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter - Swift - C++')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _handlePress,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Записать hello world (${_counter + 1})'),
            ),
            const SizedBox(height: 24),
            Text(
              'Содержимое файла:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Text(
                      _error != null
                          ? 'Ошибка: $_error'
                          : (_fileContents.isEmpty
                                ? 'Файл пока пуст'
                                : _fileContents),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
