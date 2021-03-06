import 'package:ea_frontend/views/settings_page.dart';
import 'package:ea_frontend/views/widgets/icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reload() {
      Route route =
          MaterialPageRoute(builder: (context) => const SettingPage());
      Navigator.pop(context, route);
    }

    String lenguage = getTranslated(context, 'lenguageCode')!;
    return SimpleSettingsTile(
        title: getTranslated(context, 'accountSettings')!,
        subtitle: getTranslated(context, 'accountSettingsSub')!,
        leading: const IconWidget(icon: Icons.person, color: Colors.green),
        child: SettingsScreen(
          title: getTranslated(context, 'accountSettings')!,
          children: <Widget>[
            buildLanguage(context, lenguage, reload),
            buildPrivacy(context),
            buildSecurity(context),
            buildAccountInfo(context),
          ],
        ));
  }

  Widget buildLanguage(
          BuildContext context, String lenguage, Function reload) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            width: 20,
          ),
          Text(getTranslated(context, 'language2')!),
          const Spacer(),
          DropdownButton(
              value: lenguage,
              items: const [
                DropdownMenuItem<String>(
                    value: 'es',
                    child: Text(
                      'Español',
                    )),
                DropdownMenuItem<String>(
                    value: 'en',
                    child: Text(
                      'English',
                    )),
                DropdownMenuItem<String>(
                    value: 'ca',
                    child: Text(
                      'Català',
                    ))
              ],
              onChanged: (String? value) async {
                Locale _locale = await setLocale(value!);
                MyApp.setLocale(context, _locale);
                reload();
              }),
          const SizedBox(
            width: 20,
          ),
        ],
      );

  Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'privacy')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.lock, color: Colors.blue),
      onTap: () => {});

  Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'security')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.security, color: Colors.red),
      onTap: () => {});

  Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
      title: getTranslated(context, 'accountInfo')!,
      subtitle: '',
      leading: const IconWidget(icon: Icons.text_snippet, color: Colors.purple),
      onTap: () => {});
}
