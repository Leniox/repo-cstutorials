#include "obstacle.h"

Obstacle::Obstacle( ) {
  size.length = 5;
  size.width = 10;
  position.x = 15;
  position.y = 12;
  visible = 1;
  RGB = 0xF33A24;
  name = "Obstacle";
}

Obstacle::Obstacle( Position p ) {
  size.length = 5;
  size.width = 10;
  position.x = p.x;
  position.y = p.y;
  visible = 1;
  RGB = 0xF33A24;
  name = "Obstacle";
}

void Obstacle::makeVisible() { visible = 1; }
void Obstacle::makeInvisible() { visible = 0; }

