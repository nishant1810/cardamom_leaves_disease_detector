import 'dart:isolate';
import 'classifier.dart';
import 'dart:io';

Future<Map<String, dynamic>> runInference(File image) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(_entry, receivePort.sendPort);

  final sendPort = await receivePort.first as SendPort;
  final response = ReceivePort();

  sendPort.send([image.path, response.sendPort]);
  return await response.first;
}

void _entry(SendPort mainSendPort) async {
  final port = ReceivePort();
  mainSendPort.send(port.sendPort);

  final classifier = Classifier();
  await classifier.loadModel();

  await for (var msg in port) {
    final path = msg[0] as String;
    final SendPort reply = msg[1];

    final result = await classifier.predict(File(path));
    reply.send(result);
  }
}
