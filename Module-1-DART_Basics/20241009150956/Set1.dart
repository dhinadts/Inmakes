// 1.Write a Dart program to create a set of integers and print its elements.

void main() {
  Set<int> numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
  print("Number set1");
  numbers.forEach((num) => print(num));
  Set<int> numbers2 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
  print("Number set2");
  for (var num in numbers2) {
    print(num);
  }
}
