import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

//import 'package:flutter/services.dart'; // SystemChrome
import './config/texts.dart';
import './config/config_main.dart';
import './widgets/new_task.dart';
import './widgets/edit_task.dart';
import './widgets/task_list.dart';
import './widgets/chart.dart';
import './models/task.dart';
import './models/storage.dart';

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
      title: Texts.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: ConfigMain.appPrimaryColor,
          accentColor: ConfigMain.appAccentColor,
          errorColor: ConfigMain.appErrorColor,
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
              subhead: TextStyle(
                fontSize: 14,
              ),
              subtitle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300)),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(
        storage: Storage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Storage storage;

  MyHomePage({Key key, @required this.storage}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _userTasks = [];
  String state;
  BuildContext ctx;
  bool _showChart = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var objs;
    try {
      var l = json.decode(state);
      objs = Task.decodeJsonToObject(l);
    } catch (e) {
      print(e.toString());
    }

    widget.storage.readData().then((String value) {
      setState(() {
        if (value != '') {
          var l = json.decode(value);
          objs = Task.decodeJsonToObject(l);
          _userTasks = objs;
        }
        state = value;
      });
    });
  }

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
      color: color,
    );

    setState(() {
      if (compare.isEmpty) {
        _userTasks.add(headerDivider);
      }
      _userTasks.add(newTx);
      List jsonL = Task.encodeToJson(_userTasks);
      _writeData(jsonL.toString());
    });
  }

  Future<File> _writeData(data) async {
    setState(() {
      state = data;
    });

    return widget.storage.writeData(state);
  }

  void _deleteTask(String id) {
    setState(() {
      Task task = _userTasks.firstWhere((el) => el.id == id);
      List<Task> tasks =
          _userTasks.where((el) => el.date == task.date).toList();
      if (tasks.length <= 2) {
        _userTasks.removeWhere((el) => el.date == task.date);
      } else {
        _userTasks.removeWhere((el) => el.id == id);
      }
      List jsonL = Task.encodeToJson(_userTasks);
      _writeData(jsonL.toString());
    });
  }

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
        return EditTask(
            id: task.id,
            title: task.title,
            description: task.description,
            amount: task.amount,
            date: task.date,
            color: task.color,
            editTx: _saveTask);
      },
    );
  }

  void _scrollToTask(DateTime date) {
    String dateFormat = DateFormat.yMd().format(date);
    int index = _userTasks
        .indexWhere((el) => el.dateFormatDM == dateFormat && el.flagDivider);
    // далее надо вытащить все данные листа до этого момента index
    if (index == -1) {
      return;
    }
    List<Task> newUserTaskList = _userTasks.getRange(0, index).toList();

    if (newUserTaskList.length == 0) {
      setState(() {
        this.setScrollController();
      });
      return;
    }
    List<Task> listOfDividers =
        newUserTaskList.where((el) => el.flagDivider).toList();
    List<Task> listOfTask =
        newUserTaskList.where((el) => !el.flagDivider).toList();
    double sum = listOfDividers.length * ConfigMain.taskDividerHeight +
        listOfTask.length * ConfigMain.taskItemHeight;

    setState(() {
      _scrollController.animateTo(sum,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  Future<void> setScrollController() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
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
        color: color);

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
      List jsonL = Task.encodeToJson(_userTasks);
      _writeData(jsonL.toString());
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
            Texts.showChart,
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).primaryColor,
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
              child: Chart(_recentTasks, _scrollToTask),
            )
          : Container(
              height: 0,
              child: Chart(_recentTasks, _scrollToTask),
            ),
      _showChart
          ? Container(
              child: txListWidget,
              height: 0,
            )
          : Container(
              child: txListWidget,
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
            )
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
        child: Chart(_recentTasks, _scrollToTask),
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
            middle: const Text(
              Texts.appName,
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
            title: const Text(
              Texts.appName,
            ),
            actions: <Widget>[
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColorLight,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNewTask(context),
                ),
              ),
              SizedBox(
                width: ConfigMain.middleSpace,
              ),
            ],
          );

    final double taskListHeight = (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
        0.7;

    final Widget txListWidget = Container(
      height: taskListHeight,
      child: TaskList(
          _userTasks,
          _deleteTask,
          _editTask,
          _scrollController,
          (taskListHeight -
              ConfigMain.taskItemHeight -
              (ConfigMain.middleSpace * 2))),
    );

    var pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
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
            backgroundColor: Colors.white,
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            body: pageBody,
          );
  }
}
