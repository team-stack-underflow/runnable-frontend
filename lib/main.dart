import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    home: RunnableHome()
    //home: ReplPage()
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RunnableHome()),
            );
          },
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
  var setType = [true,false];
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
          for (int buttonIndex = 0; buttonIndex < setType.length; buttonIndex++) {
            if (buttonIndex == index) {
              setType[buttonIndex] = true;
            } else {
              setType[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: setType,
    );
  }
}

class LangBox extends StatelessWidget {
  LangBox({Key key, this.name, this.image})
      : super(key: key);
  final String name;
  final String image;

  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReplPage()),
        );
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        Expanded(child: Image.asset("assets/" + image)),
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
      ]));
  }
}

class ReplPage extends StatelessWidget {
  ReplPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          tooltip: 'Home',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RunnableHome()),
            );
          },
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
      body: Column(
        children: [
          ReplBody(),
        ]
      )
    );
  }
}

class ReplBody extends StatefulWidget {
  @override
  _ReplBodyState createState() => _ReplBodyState();
}

class _ReplBodyState extends State<ReplBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(
            minHeight: 300,
            maxHeight: 300,
          ),
          //>>>>>>>>>>>>>>>>>>>>>ProgramOutput()
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: null,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.save),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Save',
                          style: TextStyle(fontSize: 12),
                        ) //Your widget here,
                    ),
                  ]
              )
            ),
            RaisedButton(
              onPressed: null,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.play_arrow),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 12),
                        ) //Your widget here,
                    ),
                  ]
              )
            ),
          ]
        ),
        Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 100,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Your input here'
                    ),
                    maxLines: null,
                  ),
              )
            )
        )
      ]
    );
  }
}