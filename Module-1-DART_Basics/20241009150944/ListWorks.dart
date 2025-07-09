// 1.Write a Dart program to create a list of integers and print its elements.

void main() {
  List<int> numbers = [10, 20, 30, 40, 50];

  print('The list of numbers is: $numbers');

  // using for loop we can print using one by one
  print('Print Using For loop');
  for (int i in numbers) {
    print(i);
  }
}
