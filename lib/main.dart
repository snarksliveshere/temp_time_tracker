import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import 'package:flutter/services.dart'; // SystemChrome

import './widgets/new_task.dart';
import './widgets/edit_task.dart';
import './widgets/task_list.dart';
import './widgets/chart.dart';
import './models/task.dart';

void main() => runApp(MyApp());

//void main() {
//  // Forbid Landscape mode!!!
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temp Time Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(
                  color: Colors.white,
                ),
                subhead: TextStyle(
                  fontSize: 14,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _userTasks = [];
  BuildContext ctx;
  bool _showChart = false;
  final _scrollController = ScrollController();

  List<Task> get _recentTasks {
    _userTasks.sort((a, b) {
      if (a.flagDivider || b.flagDivider) {
        a.date.add(Duration(seconds: 1));
        b.date.add(Duration(seconds: 1));
      }
      return b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch;
    });
    return _userTasks;
  }

  void _addNewTask(String txTitle, String txDescription, double txAmount,
      DateTime chosenDate, color) {
    List<Task> compare = _userTasks.where((tx) {
      return tx.getDateFormatDM(chosenDate) == tx.dateFormatDM &&
          tx.flagDivider;
    }).toList();

    var rand = Random();
    final Task headerDivider = Task.headerDivider(
      date: chosenDate,
      flagDivider: true,
    );
    final Task newTx = Task(
        title: txTitle,
        description: txDescription,
        amount: txAmount,
        date: chosenDate,
        id: '${DateTime.now().toString()}_${rand.nextInt(1000)}',
        flagDivider: false,
        color: color);

    setState(() {
      if (compare.isEmpty) {
        _userTasks.add(headerDivider);
      }
      _userTasks.add(newTx);
    });
  }

  void _deleteTask(String id) {
    setState(() {
      Task task = _userTasks.firstWhere((el) => el.id == id);
      List<Task> tasks =
          _userTasks.where((el) => el.date == task.date).toList();
      print(tasks.length);
      if (tasks.length <= 2) {
        _userTasks.removeWhere((el) => el.date == task.date);
      } else {
        _userTasks.removeWhere((el) => el.id == id);
      }
    });
  }

//  void _editTask(String id) {
//    setState(() {
//      Task task = _userTasks.firstWhere((el) => el.id == id);
//      task.title = 'new';
//    });
//  }

  void _editTask(String id) {
    _startEditTask(context, id);
  }

  DateTime _editingTaskDatetime;

  void _startEditTask(BuildContext ctx, String id) {
    Task task = _userTasks.firstWhere((el) => el.id == id);
    _editingTaskDatetime = task.date;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return EditTask(task.id, task.title, task.description, task.amount,
            task.date, task.color, _saveTask);
      },
    );
  }

  void _scrollToTask() {
    setState(() {
      _scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  void _saveTask(String id, String txTitle, String txDescription,
      double txAmount, DateTime chosenDate, color) {
    List<Task> compare = _userTasks.where((tx) {
      return tx.getDateFormatDM(chosenDate) == tx.dateFormatDM &&
          tx.flagDivider;
    }).toList();

    final Task headerDivider = Task.headerDivider(
      date: chosenDate,
      flagDivider: true,
    );

    final Task editingTask = Task(
        title: txTitle,
        description: txDescription,
        amount: txAmount,
        date: chosenDate,
        id: id,
        flagDivider: false,
        color: color
    );

    setState(() {
      if (compare.isEmpty) {
        _userTasks.add(headerDivider);
      }
      _userTasks.removeWhere((el) => el.id == id);
      _userTasks.add(editingTask);
      List<Task> tasks =
      _userTasks.where((el) => el.date == _editingTaskDatetime).toList();
      if (tasks.length <= 1) {
        _userTasks.removeWhere((el) => el.date == _editingTaskDatetime);
      }
    });
  }

  void _startAddNewTask(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return NewTask(_addNewTask);
      },
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTasks, _scrollToTask))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTasks,_scrollToTask),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Temp Time Tracker',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _startAddNewTask(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Temp Time Tracker',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTask(context),
              ),
            ],
          );

    final Widget txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TaskList(_userTasks, _deleteTask, _editTask, _scrollController));

    var pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTask(context),
                  ),
          );
  }
}
