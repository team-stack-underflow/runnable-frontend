import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'sizes_helpers.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    theme: ThemeData(
      primaryColor: Color(0xff00e676),
      accentColor: Color(0xff424242),
    ),
    home: RunnableHome()
    //home: ReplPage(name: 'Python')
    //home: CompilerPage(name: 'Python')
    //home: SettingsPage()
  ));
}

class RunnableHome extends StatelessWidget {
  RunnableHome({Key key}) : super(key: key);
  Map settings = {
    'storage': 'default'
  };

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
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(settings: settings)),
              );
            },
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
                      name: "Python",
                      image: 'python.png',
                      settings: settings,
                    ),
                    LangBox(
                      name: "Java",
                      image: 'java.png',
                      settings: settings,
                    ),
                    LangBox(
                      name: "C",
                      image: 'c.png',
                      settings: settings,
                    ),
                    LangBox(
                      name: "JavaScript",
                      image: 'javascript.png',
                      settings: settings,
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

class LangBox extends StatelessWidget {
  LangBox({Key key, this.name, this.image, this.settings}) : super(key: key);
  final String name;
  final String image;
  var settings;

  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RCSelectPage(name: name, settings: settings)),
          );
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(0.03*usableHeight(context)),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/' + image),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
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
// Homepage end

// RCSelectPage start
class RCSelectPage extends StatelessWidget {
  RCSelectPage({Key key, this.name, this.settings}) : super(key: key);
  final String name;
  var settings;

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
                tooltip: 'Settings',
                onPressed: null,
              ),
            ],
        ),
        body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8.0),
              children: <Widget> [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: RaisedButton(
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReplPage(name: this.name)),
                          );
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/select_background.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 0.2*usableHeight(context),
                            maxHeight: 0.2*usableHeight(context),
                            minWidth: displayWidth(context),
                            maxWidth: displayWidth(context),
                          ),
                          child: Center(
                            child: Text(
                                'REPL',
                                style: TextStyle(fontSize: 28),
                            ),
                          )
                      ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CompilerPage(name: this.name)),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/select_background.png'),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(0.03*usableHeight(context)),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 0.2*usableHeight(context),
                            maxHeight: 0.2*usableHeight(context),
                            minWidth: displayWidth(context),
                            maxWidth: displayWidth(context),
                          ),
                          child: Center(
                            child: Text(
                              'Compile',
                              style: TextStyle(fontSize: 28),
                            ),
                          )
                      ),//Your widget here,
                  ),
                ),
            ]
          ),
        )
    );
  }
}
// RCSelectPage end

// ReplPage start
class ReplPage extends StatelessWidget {
  ReplPage({Key key, this.name}) : super(key: key);
  final String name;
  //final String channelName = 'wss://echo.websocket.org'; // For testing websocket
  final String channelName = 'wss://s4tdw93cwd.execute-api.us-east-1.amazonaws.com/default/';

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
              tooltip: 'Settings',
              onPressed: null,
            ),
          ],
        ),
        body: ReplBody(
          name: name,
          channel: IOWebSocketChannel.connect(channelName),
        )
    );
  }
}

class ReplBody extends StatefulWidget {
  ReplBody({Key key, this.name, this.channel}) : super(key: key);
  final String name;
  final WebSocketChannel channel;

  @override
  _ReplBodyState createState() => _ReplBodyState();
}

class _ReplBodyState extends State<ReplBody> {
  final TextEditingController _controller = TextEditingController();
  FocusNode replNode = FocusNode();
  var outputList = [];
  var containerId = 'none';

  @override
  void initState() {
    super.initState();
    //widget.channel.sink.add("test");
    widget.channel.sink.add(
        json.encode(
            {
              "action" : "launch",
              "lang" : widget.name.toLowerCase(),
              "mode" : "repl",
           }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                minHeight: 0.3*usableHeight(context),
                maxHeight: 0.3*usableHeight(context),
                minWidth: displayWidth(context),
                maxWidth: displayWidth(context),
              ),
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> outputData = jsonDecode(snapshot.data);
                    if (outputData["containerId"] != null) {
                      containerId = outputData["containerId"];
                    }
                    if (outputData["output"] != null) {
                      if (outputData["output"].substring(0,4) == '>>> ') {
                        outputList.add(outputData["output"].substring(4));
                      } else {
                        outputList.add(outputData["output"]);
                      }
                    }
                  }
                  debugPrint('$outputList');
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: displayWidth(context),
                          maxWidth: displayWidth(context),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              for(var item in outputList) Text(item)
                            ],
                        ),
                      ),
                    ),
                  );
                },
              )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _sendSubmit,
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
                minHeight: 0.15*usableHeight(context),
                maxHeight: 0.15*usableHeight(context),
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: Form(
                      child: TextFormField(
                        autofocus: true,
                        focusNode: replNode,
                        autocorrect: false,
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Your code here'
                        ),
                        maxLines: null,
                      ),
                    ),
                  )
              )
          )
        ]
    );
  }
  
  void _sendSubmit() {
    if (_controller.text.isNotEmpty) {
      //widget.channel.sink.add(_controller.text);
      outputList.add('>>> ' + _controller.text);
      widget.channel.sink.add(
        json.encode(
          {"action": "input",
            "input": _controller.text,
          }
        )
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _controller.dispose();
    FocusScope.of(context).unfocus(); // Remove keyboard
    super.dispose();
  }
}
// ReplPage end

// CompilerPage start
class CompilerPage extends StatelessWidget {
  CompilerPage({Key key, this.name}) : super(key: key);
  final String name;
  //final String channelName = 'wss://echo.websocket.org'; // For testing websocket
  final String channelName = 'wss://s4tdw93cwd.execute-api.us-east-1.amazonaws.com/default/';

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
              tooltip: 'Settings',
              onPressed: null,
            ),
          ],
        ),
        body: CompilerBody(
          name: name,
          channel: IOWebSocketChannel.connect(channelName),
        )
    );
  }
}

class CompilerBody extends StatefulWidget {
  CompilerBody({Key key, this.name, this.channel}) : super(key: key);
  final String name;
  final WebSocketChannel channel;

  @override
  _CompilerBodyState createState() => _CompilerBodyState();
}

class _CompilerBodyState extends State<CompilerBody> {
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _bottomController = TextEditingController();
  FocusNode compNode = FocusNode();
  FocusNode replNode = FocusNode();
  bool _firstRun = true;
  bool _visible = false;
  var outputList = [];
  var containerId = 'none';

  @override
  void initState() {
    super.initState();
    compNode.addListener(() {
      if (outputList.isNotEmpty) {
        outputList.removeLast();
      }
      setState(() {});
    }); // Resize widget on text form selection
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).primaryColor,
                      onPressed: _sendRun,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.play_arrow),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Run',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ]
                      )
                  ),
                ]
            ),
          ),
          AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              constraints: BoxConstraints(
                minHeight: compNode.hasFocus ? 0.4*usableHeight(context): 96,
                maxHeight: compNode.hasFocus ? 0.4*usableHeight(context): 96,
              ),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: Form(
                      child: TextFormField(
                        autofocus: true,
                        focusNode: compNode,
                        autocorrect: false,
                        controller: _topController,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Your code here'
                        ),
                        maxLines: null,
                      ),
                    ),
                  )
              )
          ),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Column(
              children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    constraints: BoxConstraints(
                      minHeight: 0.3*usableHeight(context),
                      maxHeight: 0.3*usableHeight(context),
                      minWidth: displayWidth(context),
                      maxWidth: displayWidth(context),
                    ),
                    child: StreamBuilder(
                      stream: widget.channel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> outputData = jsonDecode(snapshot.data);
                          if (outputData["containerId"] != null) {
                            containerId = outputData["containerId"];
                          }
                          if (outputData["output"] != null) {
                            outputList.add(outputData["output"]);
                          }
                          //outputList.add(snapshot.data);
                        }
                        debugPrint('$outputList');
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return Align(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth: displayWidth(context),
                                maxWidth: displayWidth(context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for(var item in outputList) Text(item)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: _sendSubmit,
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
                        minHeight: 0.15*usableHeight(context),
                        maxHeight: 0.15*usableHeight(context),
                      ),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: Form(
                              child: TextFormField(
                                autocorrect: false,
                                controller: _bottomController,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Your code here'
                                ),
                                maxLines: null,
                              ),
                            ),
                          )
                      )
                  )
              ]
            )
          ),
        ]
    );
  }

  void _sendRun() {
    if (_topController.text.isNotEmpty) {
      if (_firstRun) {
        widget.channel.sink.add(
            json.encode(
                {
                  "action": "launch",
                  "lang": widget.name.toLowerCase(),
                  "mode": "compile",
                  "prog": _topController.text,
                }
            )
        );
        _visible = true;
        _firstRun = false;
      }
      else {
        widget.channel.sink.add(
            json.encode(
                {
                  "action": "launch",
                  "lang": widget.name.toLowerCase(),
                  "mode": "compile",
                  "prog": _topController.text,
                }
            )
        );
      }
      compNode.unfocus();
    }
  }

  void _sendSubmit() {
    if (_bottomController.text.isNotEmpty) {
      //widget.channel.sink.add(_controller.text);
      outputList.add(_bottomController.text);
      widget.channel.sink.add(
          json.encode(
              {"action": "input",
                "input": _bottomController.text,
              }
          )
      );
      _bottomController.clear();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _topController.dispose();
    _bottomController.dispose();
    FocusScope.of(context).unfocus(); // Remove keyboard
    super.dispose();
  }
}
// CompilerPage end

// SettingsPage start
class SettingsPage extends StatelessWidget {
  SettingsPage({Key key, this.settings}) : super(key: key);
  var settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.book),
                  title: Text('User guide'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: null,
                )
              ),
              Card(
                  child: ListTile(
                    leading: Icon(Icons.sd_storage),
                    title: Text('Storage location'),
                    subtitle: Text(settings['storage']),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Change storage location'),
                            content: Text('Browse files'),
                            actions: [
                              FlatButton(
                                child: Text('Save'),
                                onPressed: null,
                              ),
                            ],
                          );
                        }
                      );
                    }
                  )
              ),
              Card(
                  child: ListTile(
                    leading: Icon(Icons.help),
                    title: Text('About'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: null,
                  )
              ),
              Card(
                  child: ListTile(
                    leading: Icon(Icons.bug_report),
                    title: Text('Report a bug'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: null,
                  )
              ),
            ],
          )
        )
    );
  }
}
// SettingsPage end