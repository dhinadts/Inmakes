import 'dart:io';
import 'dart:math';

void main() {
  Random random = Random();
  int target = random.nextInt(100) + 1; // Generates between 1 and 100
  int guess;

  print('Guess the number between 1 and 100 : $target ');

  do {
    stdout.write('Enter your guess: ');
    guess = int.parse(stdin.readLineSync()!);

    if (guess < target) {
      print('Higher');
    } else if (guess > target) {
      print('Lower');
    } else {
      print('Correct! You guessed the number.');
    }
  } while (guess != target);
}
