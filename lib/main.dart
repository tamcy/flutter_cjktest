import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

const Locale defaultLocale = const Locale('zh', 'HK');

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  LocaleController localeController;

  @override
  void initState() {
    super.initState();
    localeController = new LocaleController()
      ..addListener(() {
        setLocale(localeController.locale);
      });
    localeController.locale = defaultLocale;
    _locale = defaultLocale;
  }

  void setLocale(Locale locale) {
    setState(() {
      print('Setting locale to ${locale.toString()}');
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      locale: _locale,
      title: 'Locale Test',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: 'Locale Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const demoWord = '遍';

  LocaleController getLocaleController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(new TypeMatcher<MyAppState>()) as MyAppState;
    return scaffoldState.localeController;
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = getLocaleController(context).locale;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('${widget.title} : ${currentLocale.toString()}'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(bottom: 16.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ChangeLocaleButton(const Locale('ja', 'JP')),
                  new ChangeLocaleButton(const Locale('zh', 'HK')),
                  new ChangeLocaleButton(const Locale('zh', 'TW')),
                  new ChangeLocaleButton(const Locale('zh', 'CN')),
                ],
              ),
              new Padding(padding: EdgeInsets.only(bottom: 8.0)),
              new Text('Custom font:'),
              new Text(demoWord, style: new TextStyle(fontSize: 128.0, fontFamily: 'LoclTest')),
              new Padding(padding: EdgeInsets.only(bottom: 8.0)),
              new Text('System font:'),
              new Text(demoWord, style: new TextStyle(fontSize: 128.0)),
            ],
          ),
        ));
  }
}

class LocaleController extends ChangeNotifier {
  Locale locale;

  void setLocale(Locale locale) {
    this.locale = locale;
    notifyListeners();
  }
}

class ChangeLocaleButton extends StatelessWidget {
  final Locale locale;
  final String text;

  ChangeLocaleButton(this.locale) : this.text = locale.toString();

  LocaleController getLocaleController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(new TypeMatcher<MyAppState>()) as MyAppState;
    return scaffoldState.localeController;
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: new Text(text),
      onPressed: () {
        getLocaleController(context).setLocale(locale);
      },
    );
  }
}
