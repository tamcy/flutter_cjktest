import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'HK'),
        const Locale('zh', 'TW'),
        const Locale('zh', 'CN'),
        const Locale('ja', 'JP'),
      ],
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

  bool specifyLocaleInWidget = false;

  LocaleController getLocaleController(BuildContext context) {
    final scaffoldState = context.ancestorStateOfType(new TypeMatcher<MyAppState>()) as MyAppState;
    return scaffoldState.localeController;
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = getLocaleController(context).locale;

    TextStyle textStyle =
        new TextStyle(fontSize: 128.0, locale: specifyLocaleInWidget ? currentLocale : null);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('${widget.title}'),
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
              new Padding(padding: EdgeInsets.only(bottom: 16.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Checkbox(
                      value: specifyLocaleInWidget,
                      onChanged: (bool value) {
                        setState(() {
                          specifyLocaleInWidget = value;
                        });
                      }),
                  new Text('Explicitly specify locale in widget'),
                ],
              ),
              new Padding(padding: EdgeInsets.only(bottom: 16.0)),
              new Text(
                'Default: ${defaultLocale.toString()}; Current: ${currentLocale.toString()}',
                style: new TextStyle(fontWeight: FontWeight.w600),
              ),
              new Padding(padding: EdgeInsets.only(bottom: 16.0)),
              new Text(
                'Showing that locale is changed property:',
                style: new TextStyle(color: Colors.grey),
              ),
              new Text(MaterialLocalizations.of(context).closeButtonTooltip),
              new Padding(padding: EdgeInsets.only(bottom: 32.0)),
              //
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          'Custom font:',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        new Text(demoWord, style: textStyle.copyWith(fontFamily: 'LoclTest')),
                      ],
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          'System font:',
                          style: new TextStyle(color: Colors.grey),
                        ),
                        new Text(demoWord, style: textStyle),
                      ],
                    ),
                  )
                ],
              )
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
