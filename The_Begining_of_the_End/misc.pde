/*********** TIME ****************/
void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

class Timer {
  int startTime;

  Timer() {   // constructor
    reset();
  }

  void reset() {
    startTime = millis();
  }

  int elapsedMillis() {
    return millis() - startTime;
  }
}
 