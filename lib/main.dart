import 'package:flutter/material.dart';
import 'package:global_state_management/global_state_management.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterApp(),
    );
  }
}

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  final GlobalState globalState = GlobalState();
  List<Color> cardColors = [];

  void removeCounter(int index) {
    if (index >= 0 && index < globalState.counters.length) {
      setState(() {
        globalState.removeCounter(index);
        cardColors.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 104, 158, 203),
      ),
      body: ReorderableListView(
        children: globalState.counters.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final counter = entry.value;

          if (cardColors.length <= index) {
            cardColors.add(getRandomColor());
          }

          return ReorderableDragStartListener(
            index: index,
            key: Key('$index'),
            child: CardWidget(
              key: Key('$index'),
              index: index,
              counter: counter,
              globalState: globalState,
              onRemove: () {
                removeCounter(index - 1);
              },
              backgroundColor: cardColors[index - 1],
            ),
          );
        }).toList(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final counter = globalState.counters[oldIndex];
            globalState.reorderCards(oldIndex, newIndex);
            final color = cardColors.removeAt(oldIndex);
            cardColors.insert(newIndex, color);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 203, 104, 104),
        onPressed: () {
          setState(() {
            globalState.addCounter(0);
            cardColors.add(getRandomColor());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}

class CardWidget extends StatefulWidget {
  final int index;
  final ValueNotifier<int> counter;
  final GlobalState globalState;
  final VoidCallback onRemove;
  final Color backgroundColor;

  CardWidget({
    required Key key,
    required this.index,
    required this.counter,
    required this.globalState,
    required this.onRemove,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      key: widget.key,
      color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Counter ${widget.index}:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: widget.counter,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (widget.counter.value > 0) {
                        widget.counter
                            .value--; // Kurangi nilai counter jika nilainya lebih dari 0
                      }
                    });
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      widget.counter.value++; // Tambahkan nilai counter
                    });
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onRemove,
                ),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
