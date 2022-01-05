import 'package:flutter/material.dart';
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
  final List<Todo> _todos = [
    Todo(
      title: '방 청소',
      memo: '**시에 방 청소 하기',
      color: Colors.redAccent.value,
      done: 0,
      category: '청소',
      date: 20220104,
    ),
    Todo(
      title: '방 청소2',
      memo: '**시에 방 청소 하기2',
      color: Colors.blue.value,
      done: 1,
      category: '청소',
      date: 20220104,
    ),
  ];

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
          Todo _todo = await Navigator.push(
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
            _todos.add(_todo);
          });
        },
      ),
      body: ListView.builder(
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
                  Todo t = _undone[_idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(t.color!),
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
                              t.title!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              t.done == 0 ? '미완료' : '완료',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          t.memo!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                  Todo t = _done[_idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(t.color!),
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
                              t.title!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              t.done == 0 ? '미완료' : '완료',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          t.memo!,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          } else {
            return Container();
          }
        },
        itemCount: 4,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: '오늘'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: '더보기'),
        ],
      ),
    );
  }
}
