import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/management_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({
    Key? key,
  }) : super(key: key);

  @override
  State<Questionnaire> createState() => _HomeState();
}

class _HomeState extends State<Questionnaire> {
  final LocalStorage storage = LocalStorage('BookHub');
  ScrollController _controller = ScrollController();

  List<Category> _categories = [];
  List<bool> _checkedBoxes = [];
  bool _isLoading = true;
  late User user;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    _categories = await ManagementService.getCategories();
    user = await UserService.getUserByUserName(LocalStorage('BookHub').getItem('userName'));
    setState(() {
      _checkedBoxes = List<bool>.filled(_categories.length, false);
      for(int i = 0; i < _categories.length; i++) {
        for(var userCategory in user.categories) {
          print(userCategory.toString());
          print(_categories[i].id);
          if(_categories[i].id == userCategory) {
            _checkedBoxes[i] = true;
          }
        }
      }
      _isLoading = false;
    });
  }

  String concatCategories() {
    String output = "";
    for (int i = 0; i < _checkedBoxes.length; i++) {
      if(_checkedBoxes[i]) {
      output = output + "," + _categories[i].name!;
      }
    }
    return output.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
        ? Center(child: 
            CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            )
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                  const EdgeInsets.symmetric(horizontal: 25.25, vertical: 0.0),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Text(
                      getTranslated(context, 'configCategories')!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      getTranslated(context, 'questionnaireText')!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding:
                        const EdgeInsets.symmetric(horizontal: 50.50, vertical: 0.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2.4,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _controller,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                _categories[index].name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: _checkedBoxes[index]
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
                                  _checkedBoxes[index] = !_checkedBoxes[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).backgroundColor),
                        minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width, 60)),
                      ),
                      child: Text(
                        getTranslated(context, 'accept')!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        var response = await ManagementService.updateUserCategories(user.id, concatCategories());
                        setState(() {
                          _isLoading = false;
                        });
                        if (response == "200") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HomeScaffold()));
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
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      child: Text(
                        getTranslated(context, 'skip')!,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              const HomeScaffold()
                          )
                        );
                      },
                    ),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}
