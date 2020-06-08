import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    home: RunnableHome(),
  ));
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
                      child: Text(this.name) //Your widget here,
                  ),
                ),
              ]
            )
        )
    );
  }
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
      body: GridView.count(
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
    );
  }
}
