import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Poppins',
    ),
    home: Home(),
  ));

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> todos = ["Buy groceries", "Fix the car"];
  String newTodo = '';
  String editedTodo = '';
  final _controller = TextEditingController();
  List<bool> checkBoxBoolValues = [false, false];
  List checkBoxStyles = [const TextStyle(fontSize: 20.0), const TextStyle(fontSize: 20.0, decoration: TextDecoration.lineThrough)];
  List<int> checkBoxStyleNum = [0, 0];

  void submit() {
    Navigator.of(context).pop();
  }

  AppBar _buildAppBar () {
    return AppBar(
      title: const Text("Create your ToDos"),
      leading: GestureDetector(
        onTap: () { /* Write listener code here */ },
        child: const Icon(
          Icons.menu,  // add custom icons also
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            )
        ),
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                  Icons.more_vert
              ),
            )
        ),
      ],
    );
  }

  Widget createToDo () {
    return Container(
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),

      // The input field & button container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget> [
          Expanded(
            child: SizedBox(
              width: 10.0,
              child: TextField(
                onChanged: (text) {
                  var capitalText = "${text[0].toUpperCase()}${text.substring(1)}";
                  newTodo = capitalText;
                },
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Enter a todo',
                    suffixIcon: IconButton(
                        onPressed: _controller.clear,
                        icon: const Icon(Icons.clear)
                    )
                ),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  todos.insert(0, newTodo);
                  checkBoxBoolValues.add(false);
                  checkBoxStyleNum.add(0);
                });
                _controller.clear();
              },
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget allToDosHeader () {
    return Container(
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 25.0),
      child: const Text(
        "All ToDos",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 25.0,
        ),
      ),
    );
  }

  Widget displayAllToDos () {
    return Column(
      children: todos.map((todo) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),

          // The Row widget for the all todos & icons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: CheckboxListTile(
                    title: Text(
                      todo,
                      style: checkBoxStyles[checkBoxStyleNum[todos.indexOf(todo)]],
                    ),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: checkBoxBoolValues[todos.indexOf(todo)],
                    onChanged: (bool ? value) {
                      setState(() {
                        checkBoxBoolValues[todos.indexOf(todo)] = value!;
                        if (value) {
                          checkBoxStyleNum[todos.indexOf(todo)] = 1;
                        } else {
                          checkBoxStyleNum[todos.indexOf(todo)] = 0;
                        }
                      });
                    },
                  ),
                ),
              ),

              // The icons row widget
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        todos.remove(todo);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Edit todo"),
                              content: TextField(
                                onChanged: (text) {
                                  var capitalText = "${text[0].toUpperCase()}${text.substring(1)}";
                                  editedTodo = capitalText;
                                },
                                decoration: const InputDecoration(
                                  hintText: "New todo",
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        todos[todos.indexWhere((item) => item == todo)] = editedTodo;
                                      });
                                      submit();
                                    },
                                    child: const Text("Done")
                                ),
                                TextButton(
                                    onPressed: () {
                                      submit();
                                    },
                                    child: const Text("Cancel")
                                ),
                              ],
                            )
                        );
                      });
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget clearCompletedToDosBtn () {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25.0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(280, 80),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: Colors.white,
            side: const BorderSide(width: 0.5, color: Colors.lightBlue)
        ),
        onPressed: () {
          List<bool> uncheckedBoolValues = [];
          List<int> uncheckedStyleNum = [];

          var uncompletedTodos = todos.where((todo) {
            return checkBoxBoolValues[todos.indexWhere((item) => item == todo)] == false;
          }).toList();

          for(var i = 0; i < todos.length; i++) {
            uncheckedBoolValues.add(false);
            uncheckedStyleNum.add(0);
          }
          setState(() {
            todos = uncompletedTodos;
            checkBoxBoolValues = uncheckedBoolValues;
            checkBoxStyleNum = uncheckedStyleNum;
          });
        },
        icon: const Icon(Icons.cleaning_services_rounded),
        label: const Text("Clear completed ToDos"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),

    // Body
    body: Center(
      child: Form(
        child: Column(
          children: <Widget>[
            createToDo(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Column(
                children: [
                  allToDosHeader(),
                  displayAllToDos(),
                  clearCompletedToDosBtn(),
                ],
              ),
            ),
            // The list of todos container
          ],
        ),
      ),
    ),
    );
  }
}


