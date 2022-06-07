import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ea_frontend/models/chat_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  final _socketResponse = StreamController<ChatMessage>();

  void Function(ChatMessage) get addResponse => _socketResponse.sink.add;

  Stream<ChatMessage> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  // ChatSocket streamSocket = ChatSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  IO.Socket connectAndListen(String chatId) {
    print('Executed connectAnd Listen');
    IO.Socket socket = IO.io(
        const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000'),
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connected websocket');
    });

    socket.emit('new-chat', chatId);
    //When an event recieved from server, data is added to the stream
    socket.on('textMessage', (data) {
      print(data + ' received');
      ChatMessage msg = ChatMessage.fromJson(jsonDecode(data));
      addResponse(msg);
    });
    socket.onDisconnect((_) => print('disconnect'));

    return socket;
  }

  void sentMessage() {}
}
