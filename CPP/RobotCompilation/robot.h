#ifndef ROBOT_H
#define ROBOT_H

#include "graphics.h"

class Robot : public GraphicsObject {

protected:
  int speed;

public:

  Robot();
  Robot( Position p );

  // move forward based on speed
  void updatePosition();

  // increase or decrease speed by pixels per second
  void modifySpeedBy( int pps );

};

#endif

