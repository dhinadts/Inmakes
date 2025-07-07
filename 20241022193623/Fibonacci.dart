// 1.Write a Dart program to find the nth Fibonacci number using a for loop.
// Fibonacci --

void main() {

  int n = 6;

  int first = 0;
  int second = 1;
  int next = 0;

  if (n == 0) {
    print('The 0th Fibonacci number is 0');
  } else if (n == 1) {
    print('The 1st Fibonacci number is 1');
  } else {
    for (int i = 2; i <= n; i++) {
      next = first + second;
      first = second;
      second = next;
    }
    print('The ${n}th Fibonacci number is $second');
  }
}
