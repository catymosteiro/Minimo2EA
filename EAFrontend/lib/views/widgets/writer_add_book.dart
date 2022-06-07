import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/routes/author_service.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/views/new_book_page.dart';
import 'package:ea_frontend/views/widgets/edit_profile.dart';
import 'package:ea_frontend/views/widgets/new_book.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class AddBook extends StatefulWidget {
  const AddBook({
    Key? key,
  }) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  List<Book> _response = [];
  List<Book> books = [];
  bool _isLoading = true;
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    getBooks();
  }

  Future<void> getBooks() async {
    _response = await BookService.getBooks();
    _response.forEach(
      (element) => {
        if (element.writer.name == "anonymous")
          {books.add(element), isSelected.add(false)}
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books", style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: _isLoading
                        ? Column(
                            children: const [
                              SizedBox(height: 10),
                              LinearProgressIndicator(),
                              SizedBox(height: 200),
                            ],
                          )
                        : ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BookItem(
                                "Published Date: " +
                                    books[index].publishedDate.day.toString() +
                                    "/" +
                                    books[index]
                                        .publishedDate
                                        .month
                                        .toString() +
                                    "/" +
                                    books[index].publishedDate.year.toString(),
                                books[index].title,
                                isSelected[index],
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
                "Add books",
                textScaleFactor: 1,
              ),
              onPressed: () async {
                for (int i = 0; i < books.length; i++) {
                  if (isSelected[i]) {
                    print(isSelected[i]);
                    String authorId =
                        LocalStorage('BookHub').getItem('idAuthor');
                    await AuthorService.addBook(books[i].id, authorId);
                  }
                }
                Route route = MaterialPageRoute(
                    builder: (context) => const EditProfile());
                Navigator.pop(context, route);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 30,
            ),
            ElevatedButton(
              child: Text(
                "Add new book",
                textScaleFactor: 1,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NewBook()));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        )));
  }

  Widget BookItem(String id, String book, bool selected, int index) {
    return ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.book,
            color: Colors.white,
          ),
        ),
        title: Text(
          book,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(id),
        trailing: selected
            ? Icon(
                Icons.check_circle,
                color: Colors.orange,
              )
            : Icon(
                Icons.check_circle_outline,
                color: Colors.grey,
              ),
        onTap: () {
          setState(() {
            isSelected[index] = !isSelected[index];
          });
        });
  }
}
