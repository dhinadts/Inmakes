// 2.Develop a program to find the sum of elements in a list of integers.

void main() {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  var sum = 0;
  for (int num in numbers) {
    sum += num;
  }
  print('Sum is $sum');
}
