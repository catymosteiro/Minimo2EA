import 'package:ea_frontend/models/newchat.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../localization/language_constants.dart';
import '../../routes/user_service.dart';

class NewChat extends StatefulWidget {
  const NewChat({Key? key}) : super(key: key);

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  List<User> _response = List.empty(growable: true);
  bool _isLoading = true;

  final nameController = TextEditingController();
  List<String> usersController = List.empty(growable: true);
  List<UserList> selectedUsers = List.empty(growable: true);
  String idController = "";
  List<UserList> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUser();
    getUsers();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(idController);
  }

  Future<void> getUsers() async {
    _response = await UserService.getUsers();
    setState(() {
      for (int i = 0; i < _response.length; i++) {
        if (_response[i].id != idController) {
          UserList user1 = new UserList(_response[i].id.toString(),
              _response[i].userName.toString(), false);
          userList.add(user1);
        }
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "newChat")!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.network("https://cdn-icons-png.flaticon.com/512/61/61582.png",
                height: 200),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, "fieldRequired");
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "name"),
                      hintText: getTranslated(context, "writeTheNameChat"),
                      border: OutlineInputBorder()),
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 300.0,
                    child: _isLoading
                        ? Column(
                            children: const [
                              SizedBox(height: 10),
                              LinearProgressIndicator(),
                              SizedBox(height: 200),
                            ],
                          )
                        : ListView.builder(
                            itemCount: userList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return userItem(
                                userList[index].id,
                                userList[index].userName,
                                userList[index].isSlected,
                                index,
                              );
                            }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                getTranslated(context, "addNewChat")!,
                textScaleFactor: 1,
              ),
              onPressed: () async {
                print("Add new chat");
                var response = await ChatService.newChat(NewChatModel(
                    name: nameController.text, userIds: usersController));
                if (response == "201") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatList()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(response.toString()),
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).backgroundColor,
                  onPrimary: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        )));
  }

  Widget userItem(String id, String userName, bool isSelected, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Icon(
          Icons.person_outline_outlined,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        userName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(id),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).backgroundColor,
            )
          : const Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
      onTap: () {
        setState(() {
          userList[index].isSlected = !userList[index].isSlected;
          if (userList[index].isSlected == true) {
            selectedUsers.add(UserList(id, userName, true));
          } else if (userList[index].isSlected == false) {
            selectedUsers.removeWhere(
                (item) => item.userName == userList[index].userName);
          }
          usersController = [idController];
          for (int i = 0; i < selectedUsers.length; i++) {
            usersController.add(selectedUsers[i].id);
          }
        });
      },
    );
  }
}
