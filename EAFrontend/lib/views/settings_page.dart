import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/login_page.dart';
import 'package:ea_frontend/views/settings/account_page.dart';
import 'package:ea_frontend/views/widgets/edit_profile.dart';
import 'package:ea_frontend/views/widgets/icon_widget.dart';
import 'package:ea_frontend/views/widgets/change_theme_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:localstorage/localstorage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController controllerOld = TextEditingController(text: '');
  TextEditingController controllerNew = TextEditingController(text: '');
  TextEditingController controllerCheck = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SafeArea(
              child: ListView(padding: EdgeInsets.all(24), children: [
        Text(
          getTranslated(context, 'settings')!,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        SettingsGroup(
          title: getTranslated(context, 'general')!,
          children: <Widget>[
            buildAccountTheme(context),
            AccountPage(),
            buildEditProfile(),
            buildLogout(),
            buildPassword(),
            buildDeleteAccount(),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        SettingsGroup(
            title: getTranslated(context, 'feedback')!,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              buildReportBug(context),
              buildSendFeedback(context),
            ])
      ])));

  Widget buildEditProfile() => SimpleSettingsTile(
        title: "View Profile",
        subtitle: '',
        leading: const IconWidget(icon: Icons.face, color: Colors.orange),
        child: EditProfile(),
      );
  Widget buildLogout() => SimpleSettingsTile(
      title: getTranslated(context, 'logout')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () => {
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildPassword() => SimpleSettingsTile(
      title: "Change password",
      subtitle: '',
      leading: const IconWidget(icon: Icons.lock, color: Colors.purpleAccent),
      onTap: () => {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(fontSize: 20),
                          ),
                          buildEdit("Old password", controllerOld),
                          buildEdit("New password", controllerNew),
                          buildEdit("Repeat password", controllerCheck),
                          ElevatedButton(
                              onPressed: () {
                                if (controllerOld.text.isEmpty &&
                                    controllerNew.text.isEmpty &&
                                    controllerCheck.text.isEmpty) {
                                  print("algun campo vacio");
                                } else {
                                  if (controllerCheck.text ==
                                      controllerNew.text) {
                                    UserService.changePassword(
                                        LocalStorage('BookHub')
                                            .getItem('userId'),
                                        controllerNew.text,
                                        controllerOld.text);
                                    Navigator.of(context).pop();
                                  } else {
                                    print("print psw no coincideixen");
                                  }
                                }
                              },
                              child: Text("Change"))
                        ],
                      ),
                    ),
                  );
                })
          });
  Widget buildEdit(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TextField(
        obscureText: true,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            hintText: labelText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            )),
      ),
    );
  }

  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: getTranslated(context, 'deleteAccount')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.delete, color: Colors.pink),
      onTap: () async => {
            await UserService.deleteAccount(
                LocalStorage('BookHub').getItem('userId') as String),
            LocalStorage('BookHub').deleteItem('token'),
            Navigator.pop(context),
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });

  Widget buildReportBug(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'reportABug')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.bug_report, color: Colors.teal),
      onTap: () => {});

  Widget buildSendFeedback(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'sendFeedback')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.thumb_up, color: Colors.purple),
      onTap: () => {});

  Widget buildAccountTheme(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Tema: "),
          const Spacer(),
          ChangeThemeButtonWidget(),
        ],
      );
}
