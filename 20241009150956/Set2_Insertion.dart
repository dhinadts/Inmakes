// 2.Develop a program to find the intersection of two sets of integers.

void main() {
  Set<int> numbers1 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
  Set<int> numbers2 = {1, 4, 5, 7, 9, 10, 12, 15};

  var result = numbers1.intersection(numbers2);
  print("Intersection of the two sets:");

  print(result);

  // print("Numbers set");
  // numbers.forEach((num) => print(num));

  // numbers.add(10);
  // print("Add 10 to the Numbers set: $numbers");

  // numbers.addAll([20, 30, 40, 50, 60]);

  // print("Add an array of number to the set: $numbers");
}
