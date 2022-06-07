import 'package:ea_frontend/models/chat_message.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/chat.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  ChatPage(this.chatId, this.userId);
  String chatId;
  String userId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    ChatSocket chatSocket = ChatSocket();
    IO.Socket socket = chatSocket.connectAndListen(widget.chatId);
    List<ChatMessage> msgList = [];
    User? user;

    @override
    void dispose() {
      print('Dispose Chat and disconnect Socket!');
      super.dispose();
      socket.disconnect();
    }

    void sendMessage(TextEditingController textEditingController) {
      print('emit on ' + widget.chatId + ' text ' + textEditingController.text);
      var js = json.encode(ChatMessage.toJson(ChatMessage(
          user: user!,
          message: textEditingController.text,
          date: DateTime.now())));

      socket.emit(widget.chatId, js);
      textEditingController.clear();
    }

    Future<Chat> fetchChat() async {
      return ChatService.getChat(widget.chatId);
    }

    return FutureBuilder(
        future: fetchChat(),
        builder: (context, AsyncSnapshot<Chat> snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.users.forEach((element) {
              //print(element.name);
              if (element.id == widget.userId) {
                user = element;
              }
            });
            return Scaffold(
                appBar: AppBar(
                    title: ListTile(
                      title: Text(snapshot.data!.name),
                      subtitle: Text("Online"),
                    ),
                    leading: CircleAvatar(
                      radius: 48, // Image radius
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKr-4_3JHSaiKkrTwXGXdRXkpl5dl2o7EaGg&usqp=CAU'),
                    )),
                bottomNavigationBar: BottomAppBar(child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  TextEditingController textEditingController =
                      TextEditingController();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 4 / 5,
                          child: TextField(
                            controller: textEditingController,
                            onSubmitted: (value) {
                              sendMessage(textEditingController);
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            sendMessage(textEditingController);
                          },
                          child: Icon(Icons.send, color: Colors.black),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            primary: Theme.of(context)
                                .backgroundColor, // <-- Button color
                          ),
                        ),
                      ],
                    ),
                  );
                })),
                body: StreamBuilder(
                  stream: chatSocket.getResponse,
                  // initialData: [],
                  builder: (context, AsyncSnapshot<ChatMessage> snapshot) {
                    if (snapshot.hasData) {
                      print('has data!!' + snapshot.data!.message);
                      msgList.add(snapshot.data!);
                      return ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: msgList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {},
                                leading: FlutterLogo(size: 56.0),
                                title: Text(msgList[index].user.name),
                                subtitle: Text(msgList[index].message),
                                //trailing: Icon(Icons.more_vert),
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      print(snapshot.error);
                      //   throw snapshot.error.hashCode;
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );
                    }
                    return Center(
                      child: Text('No messages yet'),
                    );
                  },
                ));
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }
}
