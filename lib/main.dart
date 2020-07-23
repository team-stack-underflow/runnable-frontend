import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'sizes_helpers.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences settingsMap = await SharedPreferences.getInstance();
  String _displayMode = settingsMap.getString('displayMode') ?? 'System';
  ThemeMode _theme = ThemeMode.system;
  if (_displayMode == 'Light') {
    _theme = ThemeMode.light;
  } else if (_displayMode == 'Dark') {
    _theme = ThemeMode.dark;
  }

  runApp(MaterialApp(
    title: 'RunnableApp',
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xff00e676),
      accentColor: Color(0xff424242),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xff00e676),
      accentColor: Color(0xff424242),
    ),
    themeMode: _theme,
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
  }

  Future _initSettings() async {
    SharedPreferences settingsMap = await SharedPreferences.getInstance();

    await Permission.storage.request();
    String storage = settingsMap.getString('storage') ?? 'Does not exist';
    if (storage == 'Does not exist') {
      final directory = await getApplicationDocumentsDirectory();
      final storageLocation = Directory('${directory.path}/storage/');
      String storagePath;
      if(await storageLocation.exists()) {
        storagePath = storageLocation.path;
      } else {
        storageLocation.create(recursive: true);
        storagePath = storageLocation.path;
      }
      settingsMap.setString('storage', storagePath);
    }

    String displayMode = settingsMap.getString('displayMode') ?? 'Does not exist';
    if (displayMode == 'Does not exist') {
      settingsMap.setString('displayMode', 'System');
    }

    double fontSize = settingsMap.getDouble('fontSize') ?? 0;
    if (fontSize == 0) {
      settingsMap.setDouble('fontSize', 14);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RunnableHome()),
    );
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
              'assets/runnableicon.png',
              fit: BoxFit.contain,
          ),
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Theme.of(context).primaryColor)
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
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
  //static const String channelName = 'wss://echo.websocket.org'; // For testing websocket
  static const String channelName = 'wss://s4tdw93cwd.execute-api.us-east-1.amazonaws.com/default/';

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
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28
                                ),
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
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28
                              ),
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

// Pop-up menu choices start
class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share', icon: Icons.share),
  const Choice(title: 'Settings', icon: Icons.settings),
];
// Pop-up menu choices end

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
  String _storage = 'Loading';
  StateSetter _setStorageState;
  SharedPreferences settingsMap;
  double _fontSize = 14;

  // Page variables
  final TextEditingController _controller = TextEditingController();
  final FocusNode replNode = FocusNode();
  List _outputList = [];
  String _containerId = 'none';
  bool _connected = false;
  StateSetter _setStreamState;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initRepl();
    if (widget.channel != null) {
      _listenToStream();
      widget.channel.sink.add(
          json.encode(
              {
                "action": "launch",
                "lang": widget.name.toLowerCase(),
                "mode": "repl",
              }
          )
      );
    }
  }

  void _initRepl() async {
    settingsMap = await SharedPreferences.getInstance();
    _readPreferences();
  }

  void _readPreferences() {
    _storage = settingsMap.getString('storage') ?? null;
    _fontSize = settingsMap.getDouble('fontSize') ?? 14;
    setState(() {});
  }

  void _listenToStream() {
    _streamSubscription = widget.channel.stream.listen((snapshot) {
      if (snapshot != null) {
        Map<String, dynamic> outputData = jsonDecode(snapshot);
        if (_containerId == 'none') {
          if (outputData["output"] == null) {
            if (outputData["containerId"] != null) {
              _containerId = outputData["containerId"];
            }
          }
        }
        if (_containerId == outputData['containerId']) {
          if (outputData["output"] != null) {
            if (outputData["output"].substring(0, 4) == '>>> ') {
              _outputList.add(outputData["output"].substring(4));
            } else {
              _outputList.add(outputData["output"]);
            }
          }
        }
        _connected = true;
        _setStreamState(() {});
      } else {
        //_connected = false;
      }
    });
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
              icon: Icon(Icons.refresh),
              tooltip: 'Restart',
              onPressed: _restart,
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
                                      decoration: InputDecoration(
                                          hintText: 'Your file name',
                                        border: OutlineInputBorder(),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: RaisedButton(
                                      child: Text(_storage),
                                      onPressed: _browseFiles,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'Save',
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
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(choice.icon),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(choice.title),
                          ),
                        ]
                    ),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  constraints: BoxConstraints(
                    minHeight: 0.3*usableHeight(context),
                    maxHeight: 0.3*usableHeight(context),
                    minWidth: displayWidth(context),
                    maxWidth: displayWidth(context),
                  ),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      _setStreamState = setState;
                      debugPrint('$_outputList');
                      if (_connected) {
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
                                  for(var item in _outputList) Text(item, style: TextStyle(fontSize: _fontSize),)
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                          color: Color(0xff424242),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          onPressed: _sendSubmit,
                          child: Container(
                            height: 36,
                            width: 88,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/runnableicon.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          /*child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.play_arrow),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(fontSize: 16),
                                    ) //Your widget here,
                                ),
                              ]
                          )*/
                      ),
                    ]
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
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
                            style: TextStyle(fontSize: _fontSize),
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

  void _restart() {
    _containerId = 'none';
    _outputList = [];
    _setStreamState(() {});
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

  void _browseFiles() async {
    _storage = await FilePicker.getDirectoryPath() ?? _storage;
    _setStorageState(() {});
  }

  void _saveFile() async {
    await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      if (_storageFormKey.currentState.validate()) {
        String fileName = _saveController.text;
        File file = File('$_storage/$fileName.txt');
        String _contents = '';
        _outputList.forEach((line) {
          _contents = _contents + line + '\n';
        });
        file.writeAsString(_contents);

        _saveController.clear();

        if (_storage != settingsMap.getString('storage')) {
          settingsMap.remove('storage');
          settingsMap.setString('storage', _storage);
        }

        Navigator.pop(context);
      }
    }
  }

  // Extra options for top right start
  void _select(Choice choice) {
    if (choice.title == 'Share') {
      _shareText();
    } else if (choice.title == 'Settings') {
      _openSettings();
    }
  }

  void _openSettings() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage())
    );
    _readPreferences();
  }

  void _shareText() {
    if (_outputList != []) {
      String _contents = '';
      _outputList.forEach((line) {
        _contents = _contents + line + '\n';
      });
      Share.share(_contents);
    }
  }
  // Extra options for top right end

  void _sendSubmit() {
    if (_controller.text.isNotEmpty) {
      //widget.channel.sink.add(_controller.text);
      _outputList.add('>>> ' + _controller.text);
      widget.channel.sink.add(
          json.encode(
              {"action": "input",
                "input": _controller.text,
                "containerId": _containerId,
              }
          )
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _streamSubscription.cancel();
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
  String _storage = 'Loading';
  String _fileToOpen = 'Browse files';
  String _autoSaved;
  StateSetter _setStorageState;
  StateSetter _setLoadState;
  SharedPreferences settingsMap;
  double _fontSize = 14;

  // Page variables
  final TextEditingController _topController = TextEditingController();
  final TextEditingController _bottomController = TextEditingController();
  final FocusNode _compNode = FocusNode();
  List _outputList = [];
  String _containerId = 'none';
  bool _connected = false;
  bool _firstRun = true;
  bool _visible = false;
  StateSetter _setStreamState;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _initCompile();
    _listenToStream();
    _compNode.addListener(() {
      setState(() {});
    }); // Resize widget on text form selection
    if (widget.name == 'C') {
      _topController.text = '#include <stdio.h>\nint main(void){\n    \n    return 0;\n}';
    } else if (widget.name == 'Java') {
      _topController.text = 'public class Program {\n    public static void main(String[] args) {\n        \n    }\n}';
    }
  }

  void _initCompile() async {
    settingsMap = await SharedPreferences.getInstance();
    _autoSaved = settingsMap.getString('autoSaved' + widget.name) ?? null;
    if (_autoSaved != null) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Restore previous session?'),
              content: Text('Previous data will be cleared if you select No'),
              actions: [
                FlatButton(
                  child: Text('Yes'),
                  onPressed: _loadSaved,
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: _resetSaved,
                )
              ],
            );
          }
      );
    }
    _readPreferences();
  }

  void _loadSaved() {
    _topController.text = _autoSaved;
    Navigator.pop(context);
  }

  void _resetSaved() {
    settingsMap.remove('autoSaved' + widget.name);
    Navigator.pop(context);
  }

  void _readPreferences() {
    _storage = settingsMap.getString('storage') ?? null;
    _fontSize = settingsMap.getDouble('fontSize') ?? 14;
    setState(() {});
  }

  void _listenToStream() {
    _streamSubscription = widget.channel.stream.listen((snapshot) {
      if (snapshot != null) {
        Map<String, dynamic> outputData = jsonDecode(snapshot);
        if (_containerId == 'none') {
          if (outputData["output"] == null) {
            if (outputData["containerId"] != null) {
              _containerId = outputData["containerId"];
            }
          }
        }
        if (_containerId == outputData['containerId']) {
          if (outputData["output"] != null) {
            _outputList.add(outputData["output"]);
          }
        }
        _connected = true;
        _setStreamState(() {});
      } else {
        _connected = false;
      }
    });
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
              onPressed: _sendStop,
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
                                      decoration: InputDecoration(
                                          hintText: 'Your file name',
                                          border: OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: RaisedButton(
                                      child: Text(_storage),
                                      onPressed: _browseFiles,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'Save',
                                    /*style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),*/
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
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(choice.icon),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(choice.title),
                          ),
                        ]
                    ),
                  );
                }).toList();
              },
            )
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          onPressed: () async {
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
                                              RaisedButton(
                                                child: Text(_fileToOpen),
                                                onPressed: _browseSources,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text(
                                                'Open',
                                                /*style: TextStyle(
                                                  color: Theme.of(context).primaryColor,
                                                ),*/
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
                                Icon(
                                  Icons.folder_open,
                                  color: Colors.black,
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Open file',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                      ),
                                    ) //Your widget here,
                                ),
                              ]
                          )
                      ),
                      RaisedButton(
                          //color: Theme.of(context).primaryColor,
                          color: Color(0xff424242),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Theme.of(context).primaryColor)
                          ),
                          onPressed: _sendRun,
                          child: Container(
                            height: 36,
                            width: 88,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/runnableicon.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ),
                    ]
                ),
              ),
              AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  constraints: BoxConstraints(
                    minHeight: _compNode.hasFocus ? 0.4*usableHeight(context): 96,
                    maxHeight: _compNode.hasFocus ? 0.4*usableHeight(context): 96,
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: Form(
                          child: TextFormField(
                            onChanged: (text) {
                              if (text != null) {
                                settingsMap.setString('autoSaved' + widget.name, text);
                              }
                            },
                            style: TextStyle(fontSize: _fontSize),
                            autofocus: true,
                            focusNode: _compNode,
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
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
                            constraints: BoxConstraints(
                              minHeight: 0.3*usableHeight(context),
                              maxHeight: 0.3*usableHeight(context),
                              minWidth: displayWidth(context),
                              maxWidth: displayWidth(context),
                            ),
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                _setStreamState = setState;
                                /*if (snapshot.hasData) {
                                  Map<String, dynamic> outputData = jsonDecode(snapshot.data);
                                  if (outputData["containerId"] != null) {
                                    containerId = outputData["containerId"];
                                  }
                                  if (outputData["output"] != null) {
                                    outputList.add(outputData["output"]);
                                  }
                                  //outputList.add(snapshot.data);
                                }*/
                                debugPrint('$_outputList');
                                if (_connected) {
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
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            for(var item in _outputList) Text(item, style: TextStyle(fontSize: _fontSize),)
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              },
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RaisedButton(
                                    color: Color(0xff424242),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(color: Theme.of(context).primaryColor)
                                    ),
                                    onPressed: _sendSubmit,
                                    child: Container(
                                      height: 36,
                                      width: 88,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/runnableiconleft.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    /*child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(Icons.keyboard_arrow_right),
                                          Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(fontSize: 16),
                                              ) //Your widget here,
                                          ),
                                        ]
                                    )*/
                                ),
                              ]
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(8.0),
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
                                      style: TextStyle(fontSize: _fontSize),
                                      autocorrect: false,
                                      controller: _bottomController,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Provide standard input here'
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
    await Permission.storage.request();
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

  // Extra options for top right start
  void _select(Choice choice) {
    if (choice.title == 'Share') {
      _shareInputAsText();
    } else if (choice.title == 'Settings') {
      _openSettings();
    }
  }

  void _openSettings() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage())
    );
    _readPreferences();
  }

  void _shareInputAsText() {
    if (_topController.text.isNotEmpty) {
      Share.share(_topController.text);
    }
  }
  // Extra options for top right end

  void _browseSources() async {
    File file = await FilePicker.getFile(type: FileType.any);
    _fileToOpen = file.path ?? _fileToOpen;
    _setLoadState(() {});
  }

  void _loadFile() async {
    if (_fileToOpen != 'Browse files') {
      await Permission.storage.request();
      if (await Permission.storage.request().isGranted) {
        try {
          File file = File(_fileToOpen);
          String contents = await file.readAsString();
          _topController.text = contents;
        } catch (e) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid file type'),
            )
          );
        }
        Navigator.pop(context);
      }
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
        _containerId = 'none';
        _outputList = [];
        _setStreamState(() {});
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
      _compNode.unfocus();
    }
  }

  void _sendStop() {
    if (_containerId != 'none') {
      widget.channel.sink.add(
          json.encode(
              {
                "action": "stop",
                "containerId": _containerId,
              }
          )
      );
      _containerId = 'none';
    }
  }

  void _sendSubmit() {
    if (_bottomController.text.isNotEmpty) {
      //outputList.add(_bottomController.text);
      widget.channel.sink.add(
          json.encode(
              {"action": "input",
                "input": _bottomController.text,
                "containerId": _containerId,
              }
          )
      );
      _bottomController.clear();
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _streamSubscription.cancel();
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
  String _displayMode = 'System';
  double _fontSize = 14;
  String _storage = 'Loading';
  String _tempStorage = 'Loading';
  StateSetter _setStorageState; // To set state of storage dialog

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future _loadSettings() async {
    settingsMap = await SharedPreferences.getInstance();
    setState(() {
      _displayMode = settingsMap.getString('displayMode') ?? 'System';
      _fontSize = settingsMap.getDouble('fontSize') ?? 14;
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserGuide(fontSize: _fontSize,))
                      );
                    }
                  )
              ),
              Card(
                  child: ListTile(
                    leading: Icon(Icons.brightness_6),
                    title: Text('Theme'),
                    trailing: Container(
                      width: 110,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _displayMode,
                          items: [
                            DropdownMenuItem(
                              child: Text('System'),
                              value: 'System',
                            ),
                            DropdownMenuItem(
                              child: Text('Light'),
                              value: 'Light',
                            ),
                            DropdownMenuItem(
                                child: Text('Dark'),
                                value: 'Dark',
                            ),
                          ],
                          onChanged: (value) {
                            settingsMap.setString('displayMode', value);
                            setState(() {
                              _displayMode = value;
                            });
                          },
                        ),
                      ),
                    ),
                    onTap: null,
                  )
              ),
              Card(
                  child: ListTile(
                    leading: Icon(Icons.text_fields),
                    title: Text('Code font size'),
                    trailing: Container(
                      width: 110,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<double>(
                          isExpanded: true,
                          value: _fontSize,
                          items: [
                            DropdownMenuItem(
                              child: Text('Small'),
                              value: 14,
                            ),
                            DropdownMenuItem(
                              child: Text('Medium'),
                              value: 18,
                            ),
                            DropdownMenuItem(
                              child: Text('Large'),
                              value: 22,
                            ),
                          ],
                          onChanged: (value) {
                            settingsMap.setDouble('fontSize', value);
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                    ),
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
    settingsMap.setString('storage', _tempStorage);
    setState(() {
      _storage = _tempStorage;
    });
    Navigator.pop(context);
  }
}
// SettingsPage end

class UserGuide extends StatelessWidget {
  UserGuide({Key key, this.fontSize}) : super(key: key);
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      appBar: AppBar(
        title: Text('User Guide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Text(
                    'Welcome to Runnable',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: fontSize + 4,
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Runnable provides a coding environment for users to run code.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('This guide will go through the 2 main code execution types.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Text('REPL Mode',
                    style: TextStyle(fontSize: fontSize + 4),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Internet connection is required throughout usage. If the loading circle indicator persists, please check your internet connection.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('After opening, please wait for the environment to initialise. '
                  'This may take a while, after which an initialisation message will be displayed.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('After initialisation, it will behave like a basic read-eval-print-loop environment. '
                  'This will take in user input from the text box at the bottom, evaluate it, and then display the output on top.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Text('Compile Mode',
                    style: TextStyle(fontSize: fontSize + 4),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('There are 2 ways to start using this environment. '
                  'You may start typing code directly into the text box, or choose to open an existing code file. '
                  'Note that only text files (ending with .txt) or code specific files (eg. ending with .py or .c) can be opened.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('After running the code, please wait for the code to be evaluated. '
                  'This may take a while, after which the output will be displayed in the middle.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('An additional text box is provided below to provide standard input.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
