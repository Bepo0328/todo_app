import 'package:flutter/material.dart';
import 'package:todo_app/data/todo.dart';

class TodoWritePage extends StatefulWidget {
  const TodoWritePage({Key? key, this.todo}) : super(key: key);

  final Todo? todo;

  @override
  _TodoWritePageState createState() => _TodoWritePageState();
}

class _TodoWritePageState extends State<TodoWritePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  int _colorIndex = 0;
  int _ctIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.todo!.title!;
    _memoController.text = widget.todo!.memo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // 저장 버튼 클릭
              widget.todo!.title = _nameController.text;
              widget.todo!.memo = _memoController.text;

              Navigator.pop(context, widget.todo);
            },
            child: const Text(
              '저장',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, idx) {
          if (idx == 0) {
            return Container(
              child: const Text(
                '제목',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            );
          } else if (idx == 1) {
            return Container(
              child: TextField(
                controller: _nameController,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
            );
          } else if (idx == 2) {
            return InkWell(
              onTap: () {
                List<Color> _colors = [
                  const Color(0xFF80D3F4),
                  const Color(0xFFA794FA),
                  const Color(0xFFFB91D1),
                  const Color(0xFFFB8A94),
                  const Color(0xFFFEBD9A),
                  const Color(0xFF51E29D),
                  const Color(0xFFFFFFFF),
                ];

                widget.todo!.color = _colors[_colorIndex].value;
                _colorIndex++;

                setState(() {
                  _colorIndex = _colorIndex % _colors.length;
                });
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '색상',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Container(
                      width: 20.0,
                      height: 20.0,
                      color: Color(widget.todo!.color!),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16.0,
                ),
              ),
            );
          } else if (idx == 3) {
            return InkWell(
              onTap: () {
                List<String> _category = [
                  '공부',
                  '운동',
                  '게임',
                  '청소',
                  '선물',
                  '요리',
                  '약속',
                ];

                widget.todo!.category = _category[_ctIndex];
                _ctIndex++;
                setState(() {
                  _ctIndex = _ctIndex % _category.length;
                });
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '카테고리',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(widget.todo!.category!),
                  ],
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16.0,
                ),
              ),
            );
          } else if (idx == 4) {
            return Container(
              child: const Text(
                '메모',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            );
          } else if (idx == 5) {
            return Container(
              child: TextField(
                controller: _memoController,
                maxLines: 10,
                minLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 1.0,
                horizontal: 16.0,
              ),
            );
          } else {
            return Container();
          }
        },
        itemCount: 6,
      ),
    );
  }
}
