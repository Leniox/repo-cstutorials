
#ifndef GRAPHICS_H
#define GRAPHICS_H

#include "structures.h"
#include <string>

class GraphicsObject {

 protected:
  Position position;
  int RGB;
  std::string name;

 public:
  GraphicsObject();
  void draw();
};

#endif
