#include <AStar32U4.h>

// "plug in" jumper cable to general IO port
// identify the port pin from which to read
int rx = 6;

void setup() {
  // initialize port pin as input
  pinMode( rx , INPUT_PULLUP );
}

void loop() {
  // Read from that pin and blink LEDs accordingly
  int inputValue = digitalRead( rx );
  if ( HIGH == inputValue ) {
    ledYellow(1):
    ledGreen(0);
  }
  else {
    ledYellow(0);
    ledGreen(1);
  }
}
