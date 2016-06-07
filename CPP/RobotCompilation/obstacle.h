
#ifndef OBSTACLE_H
#define OBSTACLE_H

#include "structures.h"
#include "graphics.h"

class Obstacle : public GraphicsObject {

 protected:
  Size size;
  short visible;

 public:
  Obstacle();
  Obstacle( Position p );

  void makeVisible();
  void makeInvisible();
};

#endif
