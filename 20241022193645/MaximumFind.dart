// 1.Write a Dart program to find the maximum element in a list of numbers using forEach().

void main() {
  List<int> array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int baseCompare = array[0];
  array.forEach((item) {
    if (item > baseCompare) {
      baseCompare = item;
    }
  });
  print("The maximum element in the list is: $baseCompare");
}
