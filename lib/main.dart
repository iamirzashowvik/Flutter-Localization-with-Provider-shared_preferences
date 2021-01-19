import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _count;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    _count = prefs.getBool("boolValue") ?? false;
    return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Counter()),
        ],
        child: MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );
  });
}

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  bool get count => _count;
  SharedPreferences prefs;
  void eng() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("boolValue", false);
    _count = false;
    notifyListeners();
}

  void bangla() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool("boolValue", true);
    _count = true;

    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.watch<Counter>().count
              ? 'ভাষা পরিবর্তন'
              : "Change Language"),
          actions: <Widget>[
            FlatButton(
              child: new Text("English"),
              onPressed: () {
                context.read<Counter>().eng();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("বাংলা"),
              onPressed: () {
                context.read<Counter>().bangla();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(context.watch<Counter>().count);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Counter>().count ? 'বাংলা' : 'English'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.watch<Counter>().count
                  ? 'বাংলা ভাষাতে স্বাগতম'
                  : 'Welcome to English Language',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            FlatButton(
                color: Colors.amber,
                onPressed: _showDialog,
                child: Text(context.watch<Counter>().count
                    ? 'ভাষা পরিবর্তন'
                    : "Change Language"))
          ],
        ),
      ),
    );
  }
}
