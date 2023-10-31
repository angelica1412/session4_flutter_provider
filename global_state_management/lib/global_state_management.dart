import 'package:flutter/foundation.dart';

class GlobalState with ChangeNotifier {
  final List<ValueNotifier<int>> counters = [];

  // Fungsi untuk menambahkan counter baru
  void addCounter(int initialValue) {
    counters.add(ValueNotifier<int>(initialValue));
    notifyListeners(); // Memberi tahu widget bahwa state telah berubah
  }

  // Fungsi untuk menghapus counter berdasarkan indeks
  void removeCounter(int index) {
    if (index >= 0 && index < counters.length) {
      counters.removeAt(index);
      notifyListeners(); // Memberi tahu widget bahwa state telah berubah
    }
  }

  // Fungsi untuk menginkrement counter berdasarkan indeks
  void incrementCounter(int index) {
    if (index >= 0 && index < counters.length) {
      counters[index].value++;
      notifyListeners(); // Memberi tahu widget bahwa state telah berubah
    }
  }

  // Fungsi untuk mendekrement counter berdasarkan indeks
  void decrementCounter(int index) {
    if (index >= 0 && index < counters.length && counters[index].value > 0) {
      counters[index].value--;
      notifyListeners(); // Memberi tahu widget bahwa state telah berubah
    }
  }

  void reorderCards(int startIndex, int endIndex) {
    var movedCard = counters[startIndex];
    counters.removeAt(startIndex);
    counters.insert(endIndex, movedCard);
    notifyListeners(); // Memberi tahu widget bahwa state telah berubah
  }
}
