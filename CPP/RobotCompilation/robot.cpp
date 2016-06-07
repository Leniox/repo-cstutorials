// MISSING a key #include
#include "robot.h"

Robot::Robot() {
  position.x = 20;
  position.y = 20;
  name = "Robot";
  RGB = 0xA346FB;
  speed = 2;
}

Robot::Robot( Position p ) {
  position.x = p.x;
  position.y = p.y;
  name = "Robot";
  RGB = 0xA346FB;
  speed = 2;
}

// MISSING a scope reference
void updatePosition() {
  position.x = position.x + speed;
}

void Robot::modifySpeedBy( int pps ) {
  speed = speed + pps;
}

