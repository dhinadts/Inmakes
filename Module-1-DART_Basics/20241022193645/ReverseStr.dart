// 2.Create a program that takes a list of strings as input and prints the strings in reverse order using forEach().

void main() {
  String str = 'DHINAKARAN';
  var array = str.split('');
  String reverseStr = '';
  for (int i = array.length - 1; i >= 0; i--) {
    reverseStr += array[i];
  }
  print('Reversed String is : $reverseStr');
}
