import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/data/todo.dart';
import 'package:todo_app/data/utils.dart';
import 'package:todo_app/screen/write.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  int selectIndex = 0;

  List<Todo> _todos = [];

  void getTodayTodo() async {
    _todos = await dbHelper.getTodoByDate(Utils.getFormatTime(DateTime.now()));
    setState(() {});
  }

  void getAllTodo() async {
    allTodo = await dbHelper.getAllTodo();
    setState(() {});
  }

  @override
  void initState() {
    getTodayTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: const Size.fromHeight(0.0),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          // 화면 이동
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return TodoWritePage(
                todo: Todo(
                  title: '',
                  memo: '',
                  category: '',
                  color: 0,
                  done: 0,
                  date: Utils.getFormatTime(DateTime.now()),
                ),
              );
            }),
          );

          setState(() {
            getTodayTodo();
          });
        },
      ),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: '오늘'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
        ],
        currentIndex: selectIndex,
        onTap: (idx) {
          if (idx == 1) {
            getAllTodo();
          }
          setState(() {
            selectIndex = idx;
          });
        },
      ),
    );
  }

  Widget getPage() {
    if (selectIndex == 0) {
      return getMain();
    } else {
      return getHistory();
    }
  }

  Widget getMain() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Container(
            child: const Text(
              '오늘하루',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
          );
        } else if (idx == 1) {
          List<Todo> _undone = _todos.where((t) {
            return t.done == 0;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(_undone.length, (_idx) {
                Todo _todo = _undone[_idx];
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (_todo.done == 0) {
                        _todo.done = 1;
                      } else {
                        _todo.done = 0;
                      }
                    });
                  },
                  onLongPress: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return TodoWritePage(todo: _todo);
                      }),
                    );
                    setState(() {
                      getTodayTodo();
                    });
                  },
                  child: TodoCardWidget(todo: _todo),
                );
              }),
            ),
          );
        } else if (idx == 2) {
          return Container(
            child: const Text(
              '완료된 하루',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
          );
        } else if (idx == 3) {
          List<Todo> _done = _todos.where((t) {
            return t.done == 1;
          }).toList();

          return Container(
            child: Column(
              children: List.generate(_done.length, (_idx) {
                Todo _todo = _done[_idx];
                return InkWell(
                  onTap: () async {
                    setState(() async {
                      if (_todo.done == 0) {
                        _todo.done = 1;
                      } else {
                        _todo.done = 0;
                      }
                    });
                    await dbHelper.insertTodo(_todo);
                  },
                  onLongPress: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return TodoWritePage(todo: _todo);
                      }),
                    );
                    setState(() {});
                  },
                  child: TodoCardWidget(todo: _todo),
                );
              }),
            ),
          );
        } else {
          return Container();
        }
      },
      itemCount: 4,
    );
  }

  List<Todo> allTodo = [];

  Widget getHistory() {
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return TodoCardWidget(todo: allTodo[idx]);
      },
      itemCount: allTodo.length,
    );
  }
}

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget({Key? key, this.todo}) : super(key: key);

  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    int now = Utils.getFormatTime(DateTime.now());
    DateTime time = Utils.numToDateTime(todo!.date!);

    return Container(
      decoration: BoxDecoration(
        color: Color(todo!.color!),
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 12.0,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                todo!.title!,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                todo!.done == 0 ? '미완료' : '완료',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            todo!.memo!,
            style: const TextStyle(color: Colors.white),
          ),
          now == todo!.date
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${time.month}월 ${time.day}일",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
