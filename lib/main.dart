import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    home: RunnableHome(),
  ));
}

class RunnableHome extends StatelessWidget {
  RunnableHome({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          tooltip: 'Home',
          onPressed: null,
        ),
        title: Text('Runnable'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      // body is the majority of the screen.
      body: Column(
        children: [
          RCSelect(), // Selects REPL or Compile
          GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              LangBox(
                  name: 'Python',
                  image: 'python.png'
              ),
              LangBox(
                  name: 'Java',
                  image: 'java.png'
              ),
              LangBox(
                  name: 'C',
                  image: 'c.png'
              ),
              LangBox(
                  name: 'JavaScript',
                  image: 'javascript.png'
              )
            ],
          )
        ]
      )
    );
  }
}

class RCSelect extends StatefulWidget {
  @override
  _RCSelectState createState() => _RCSelectState();
}

class _RCSelectState extends State<RCSelect> {
  var isSelected = [true,false];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10.0),
          // Add colour
          width: 100.0,
          height: 48.0,
          alignment: Alignment.center,
          child: Text(
            'REPL',
            style: TextStyle(fontSize: 20)
          )
        ),
        Container(
          margin: const EdgeInsets.all(10.0),
          // Add colour
          width: 100.0,
          height: 48.0,
          alignment: Alignment.center,
          child: Text(
            'Compile',
            style: TextStyle(fontSize: 20),
          )
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: isSelected,
    );
  }
}

class LangBox extends StatelessWidget {
  LangBox({Key key, this.name, this.image})
      : super(key: key);
  final String name;
  final String image;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2), height: 120,
        child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child:Image.asset("assets/" +image)),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          this.name,
                          style: TextStyle(fontSize: 20),
                        ) //Your widget here,
                    ),
                  ),
                ]
            )
        )
    );
  }
}