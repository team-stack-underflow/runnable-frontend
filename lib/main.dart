import 'package:flutter/material.dart';
import 'sizes_helpers.dart';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    home: RunnableHome()
    //home: ReplPage(name: 'Python')
    //home: CompilerPage(name: 'Python')
  ));
}

class RunnableHome extends StatelessWidget {
  RunnableHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          tooltip: 'Home',
          onPressed: null
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
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //RCSelect(type: setType),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select language',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0.1*usableHeight(context)),
              child: GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    LangBox(
                        name: 'Python',
                        image: 'python.png',
                    ),
                    LangBox(
                        name: 'Java',
                        image: 'java.png',
                    ),
                    LangBox(
                        name: 'C',
                        image: 'c.png',
                    ),
                    LangBox(
                        name: 'JavaScript',
                        image: 'javascript.png',
                    )
                  ],
              ),
            ),
          ]
        ),
      )
    );
  }
}

/* class RCSelect extends StatefulWidget {
  RCSelect({Key key, this.type}) : super(key: key);
  var type;
  @override
  _RCSelectState createState() => _RCSelectState(type: this.type);
}

class _RCSelectState extends State<RCSelect> {
  _RCSelectState({Key key, this.type}) : super();
  var type;
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
          for (int buttonIndex = 0; buttonIndex < type.length; buttonIndex++) {
            if (buttonIndex == index) {
              type[buttonIndex] = true;
            } else {
              type[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: this.type,
    );
  }
}
*/

// LangBox start
class LangBox extends StatelessWidget {
  LangBox({Key key, this.name, this.image}) : super(key: key);
  final String name;
  final String image;

  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RCSelectPage(name: this.name)),
          );
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        Expanded(child: Image.asset("assets/" + image)),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
              padding: EdgeInsets.only(bottom: 0.01*usableHeight(context)),
              child: Text(
                this.name,
                style: TextStyle(fontSize: 20),
              ) //Your widget here,
              ),
        ),
      ]));
  }
}
// LangBox end

// RCSelectPage start
class RCSelectPage extends StatelessWidget {
  RCSelectPage({Key key, this.name}) : super(key: key);
  final String name;

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
          title: Text(name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Search',
                onPressed: null,
              ),
            ],
        ),
        body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children: <Widget> [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  constraints: BoxConstraints(
                    minHeight: 0.2*usableHeight(context),
                    maxHeight: 0.2*usableHeight(context),
                  ),
                  child: RaisedButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CodePage(name: this.name, activeList: [false,true],)),
                        );
                      },
                    color: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                    ),
                    child: Text(
                      'REPL',
                      style: TextStyle(fontSize: 28),
                    ) //Your widget here,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  constraints: BoxConstraints(
                    minHeight: 0.2*usableHeight(context),
                    maxHeight: 0.2*usableHeight(context),
                  ),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CodePage(name: this.name, activeList: [true,false],)),
                        );
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                      ),
                      child: Text(
                        'Compile',
                        style: TextStyle(fontSize: 28),
                      ) //Your widget here,
                  ),
                ),
            ]
          ),
        )
    );
  }
}
// RCSelectPage end


class CodePage extends StatelessWidget {
  CodePage({Key key, this.name, this.activeList}) : super(key: key);
  final String name;
  var activeList;

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
            FocusScope.of(context).unfocus(); // Remove keyboard
          },
        ),
        title: Text(name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.stop),
            tooltip: 'Stop',
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: [
          activeList[0] ? CompilerBody(activeList: activeList) : SizedBox.shrink(),
          activeList[1] ? ReplBody(activeList: activeList) : SizedBox.shrink(),
        ]
      )
    );
  }
}

class CompilerBody extends StatefulWidget {
  CompilerBody({Key key, this.activeList}) : super(key: key);
  var activeList;
  @override
  _CompilerBodyState createState() => _CompilerBodyState();
}

class _CompilerBodyState extends State<CompilerBody> {
  _CompilerBodyState({Key key, this.activeList}) : super();
  var activeList;
  @override
  Widget build(BuildContext context) {
    //if (activeList[0] == true) {
      return ListView(
            shrinkWrap: true,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: null,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.file_upload),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Select source file',
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
                                    'Run program',
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 0.4*usableHeight(context),
                    maxHeight: 0.4*usableHeight(context),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextField(
                          decoration: InputDecoration.collapsed(
                              hintText: 'Your code here'
                          ),
                          maxLines: null,
                        ),
                      )
                  )
              )
            ]
        );
    //}
    //return SizedBox.shrink();
  }
}

class ReplBody extends StatefulWidget {
  ReplBody({Key key, this.activeList}) : super(key: key);
  var activeList;
  @override
  _ReplBodyState createState() => _ReplBodyState();
}

class _ReplBodyState extends State<ReplBody> {
  _ReplBodyState({Key key, this.activeList}) : super();
  var activeList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(8.0),
          constraints: BoxConstraints(
            minHeight: 0.3*usableHeight(context),
            maxHeight: 0.3*usableHeight(context),
          ),
          //>>>>>>>>>>>>>>>>>>>>>ProgramOutput()
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*RaisedButton(
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
              ),*/
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
        ),
        Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
              minHeight: 0.1*usableHeight(context),
              maxHeight: 0.1*usableHeight(context),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
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

//Compiler page start
/*class CompilerPage extends StatelessWidget {
  CompilerPage({Key key, this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RunnableHome()),
                );
                FocusScope.of(context).unfocus();
              },
            ),
            title: Text(name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.stop),
                tooltip: 'Stop',
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.save),
                tooltip: 'Save',
                onPressed: null,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                tooltip: 'Search',
                onPressed: null,
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Code'),
                Tab(text: 'Output'),
              ]
            )
          ),
          body: TabBarView(
            children: [
              CompilerBody(),
              CompilerOutput(),
            ]
          )
        )
    );
  }
}


class CompilerOutput extends StatefulWidget {
  @override
  _CompilerOutputState createState() => _CompilerOutputState();
}

class _CompilerOutputState extends State<CompilerOutput> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(
              minHeight: 0.3*usableHeight(context),
              maxHeight: 0.3*usableHeight(context),
            ),
            //>>>>>>>>>>>>>>>>>>>>>ProgramOutput()
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
          ),
          Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              constraints: BoxConstraints(
                minHeight: 0.1*usableHeight(context),
                maxHeight: 0.1*usableHeight(context),
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
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
*/