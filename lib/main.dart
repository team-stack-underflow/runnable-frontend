import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sizes_helpers.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    title: 'RunnableApp',
    theme: ThemeData(
      primaryColor: Color(0xff00e676),
      accentColor: Color(0xff424242),
    ),
    home: SplashScreen()
    //home: RunnableHome()
    //home: ReplPage(name: 'Python')
    //home: CompilerPage(name: 'Python')
    //home: SettingsPage()
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initSettings();
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => RunnableHome())
        )
    );
  }

  Future _initSettings() async {
    SharedPreferences settingsMap = await SharedPreferences.getInstance();

    var storage = settingsMap.getString('storage') ?? 'Does not exist';
    if (storage == 'Does not exist') {
      final directory = await getApplicationDocumentsDirectory();
      final storageLocation = Directory('${directory.path}/storage/');
      String storagePath;
      if(await storageLocation.exists()) {
        storagePath = storageLocation.path;
      } else {
        storageLocation.create(recursive: true)
            .then((Directory storageLocation) {
          storagePath = storageLocation.path;
        });
      }
      settingsMap.setString('storage', storagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text('Welcome to Runnable'),
      ),
    );
  }
}

// Homepage start
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
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
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
                    ),
                    LangBox(
                      name: "Java",
                      image: 'java.png',
                    ),
                    LangBox(
                      name: "C",
                      image: 'c.png',
                    ),
                    LangBox(
                      name: "JavaScript",
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

class LangBox extends StatelessWidget {
  LangBox({Key key, this.name, this.image}) : super(key: key);
  final String name;
  final String image;

  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RCSelectPage(name: name)),
          );
      },
      color: Colors.white,
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
                name,
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
  RCSelectPage({Key key, this.name}) : super(key: key);
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
                icon: Icon(Icons.settings),
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
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
                            MaterialPageRoute(builder: (context) => ReplPage(
                                name: this.name,
                                channel: IOWebSocketChannel.connect(channelName),
                            )),
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
                          MaterialPageRoute(builder: (context) => CompilerPage(
                              name: this.name,
                              channel: IOWebSocketChannel.connect(channelName),
                          )),
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
class ReplPage extends StatefulWidget {
  ReplPage({Key key, this.name, this.channel}) : super(key: key);
  final String name;
  final WebSocketChannel channel;

  @override
  _ReplPageState createState() => _ReplPageState();
}

class _ReplPageState extends State<ReplPage> {
  // Variables for storage settings
  final TextEditingController _saveController = TextEditingController();
  final _storageFormKey = GlobalKey<FormState>();
  var _storage = 'Loading';
  StateSetter _setStorageState;
  SharedPreferences settingsMap;

  // Page variables
  final TextEditingController _controller = TextEditingController();
  final FocusNode replNode = FocusNode();
  var outputList = [];
  var containerId = 'none';

  @override
  void initState() {
    super.initState();
    _initRepl();
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

  void _initRepl() async {
    settingsMap = await SharedPreferences.getInstance();
    _storage = settingsMap.getString('storage');
  }

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
          title: Text(widget.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.stop),
              tooltip: 'Stop',
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () async {
                settingsMap = await SharedPreferences.getInstance();
                _storage = settingsMap.getString('storage');
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, setState) {
                            _setStorageState = setState;
                            return AlertDialog(
                              title: Text('Save as text file'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: _storageFormKey,
                                    child: TextFormField(
                                      autocorrect: false,
                                      controller: _saveController,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Your file name'
                                      ),
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a valid file name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text(_storage),
                                    onPressed: _browseFiles,
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: _saveFile,
                                ),
                              ],
                            );
                          }
                      );
                    }
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: ListView(
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
                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
        ),
    );
  }

  void _browseFiles() async {
    _storage = await FilePicker.getDirectoryPath() ?? _storage;
    _setStorageState(() {});
  }

  void _saveFile() async {
/*    PermissionStatus status = await Permission.storage.status;
    if (status.isUndetermined) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]); // it should print PermissionStatus.granted
    }*/
    Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      if (_storageFormKey.currentState.validate()) {
        String fileName = _saveController.text;
        File file = File('$_storage/$fileName.txt');
        String contents = '';
        outputList.forEach((line) {
          contents = contents + line + '\n';
        });
        file.writeAsString(contents);

        _saveController.clear();

        if (_storage != settingsMap.getString('storage')) {
          settingsMap.remove('storage');
          settingsMap.setString('storage', _storage);
        }

        Navigator.pop(context);
      }
    }
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
class CompilerPage extends StatefulWidget {
  CompilerPage({Key key, this.name, this.channel}) : super(key: key);
  final String name;
  final WebSocketChannel channel;

  @override
  _CompilerPageState createState() => _CompilerPageState();
}

class _CompilerPageState extends State<CompilerPage> {
  // Variables for storage settings
  final TextEditingController _saveController = TextEditingController();
  final _storageFormKey = GlobalKey<FormState>();
  var _storage = 'Loading';
  var _fileToOpen = 'Browse files';
  StateSetter _setStorageState;
  StateSetter _setLoadState;
  SharedPreferences settingsMap;

  // Page variables
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _bottomController = TextEditingController();
  final FocusNode compNode = FocusNode();
  final FocusNode replNode = FocusNode();
  var outputList = [];
  var containerId = 'none';
  bool _firstRun = true;
  bool _visible = false;

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
          title: Text(widget.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.stop),
              tooltip: 'Stop',
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () async {
                settingsMap = await SharedPreferences.getInstance();
                _storage = settingsMap.getString('storage');
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                          builder: (context, setState) {
                            _setStorageState = setState;
                            return AlertDialog(
                              title: Text('Save as text file'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: _storageFormKey,
                                    child: TextFormField(
                                      autocorrect: false,
                                      controller: _saveController,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Your file name'
                                      ),
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a valid file name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text(_storage),
                                    onPressed: _browseFiles,
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: _saveFile,
                                ),
                              ],
                            );
                          }
                      );
                    }
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            settingsMap = await SharedPreferences.getInstance();
                            _storage = settingsMap.getString('storage');
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                        _setLoadState = setState;
                                        return AlertDialog(
                                          title: Text('Choose file'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FlatButton(
                                                child: Text(_fileToOpen),
                                                onPressed: _browseTxts,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                'Open',
                                                style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              onPressed: _loadFile,
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                }
                            );
                          },
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
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
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
        ),
    );
  }

  void _browseFiles() async {
    _storage = await FilePicker.getDirectoryPath() ?? _storage;
    _setStorageState(() {});
  }

  void _saveFile() async {
    Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      if (_storageFormKey.currentState.validate()) {
        String fileName = _saveController.text;
        File file = File('$_storage/$fileName.txt');
        file.writeAsString(_topController.text);

        _saveController.clear();

        if (_storage != settingsMap.getString('storage')) {
          settingsMap.remove('storage');
          settingsMap.setString('storage', _storage);
        }

        Navigator.pop(context);
      }
    }
  }

  void _browseTxts() async {
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['txt']);
    _fileToOpen = file.path ?? _fileToOpen;
    _setLoadState(() {});
  }

  void _loadFile() async {
    if (_fileToOpen != 'Browse files') {
      try {
        File file = await File(_fileToOpen);
        String contents = await file.readAsString();
        _topController.text = contents;
      } catch (e) {}
      Navigator.pop(context);
    }
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
      //outputList.add(_bottomController.text);
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
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences settingsMap;
  var _storage = 'Loading';
  var _tempStorage = 'Loading';
  StateSetter _setStorageState; // To set state of storage dialog

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future _loadSettings() async {
    settingsMap = await SharedPreferences.getInstance();
    setState(() {
      _storage = settingsMap.getString('storage') ?? 'Null';
      _tempStorage = settingsMap.getString('storage') ?? 'Null';
    });
  }

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
                    subtitle: Text(_storage),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              _setStorageState = setState;
                              return AlertDialog(
                                title: Text('Change storage location'),
                                content: FlatButton(
                                    child: Text(_tempStorage),
                                    onPressed: _browseFiles,
                                ),
                                actions: [
                                  FlatButton(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    onPressed: _saveLocation,
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      ).then((val) {
                        _tempStorage = _storage; // Reset temp to original on dialog dismissal
                      });
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

  void _browseFiles() async {
    _tempStorage = await FilePicker.getDirectoryPath() ?? _storage;
    _setStorageState(() {});
  }

  void _saveLocation() {
    settingsMap.remove('storage');
    settingsMap.setString('storage', _tempStorage);
    setState(() {
      _storage = _tempStorage;
    });
    Navigator.pop(context);
  }
}
// SettingsPage end