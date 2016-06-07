#include "structures.h"
#include "graphics.h"
#include <iostream>
#include <string>

// Missing a namespace directive here

GraphicsObject::GraphicsObject() {
  position.x = 0;
  position.y = 0;
  RGB = 0xFFFFFF;

  name = "undefined";
}

void GraphicsObject::draw() {
  cout << name << " at [" << position.x << ", " << position.y << "] in color " << RGB << "\n";
} 

