#ifndef STRUCTURES_H
#define STRUCTURES_H

struct Position {
  int x;
  int y;
};

struct Size {
  int width;
  int length;
};

#endif

// ------------------------------

#ifndef GRAPHICS_H
#define GRAPHICS_H


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

// --- Start of Graphics.cpp

using std::cout;

GraphicsObject::GraphicsObject() {
  position.x = 0;
  position.y = 0;
  RGB = 0xFFFFFF;

  name = "undefined";
}

void GraphicsObject::draw() {
  cout << name << " at [" << position.x << ", " << position.y << "] in color " << RGB << "\n";
} 

// ---------------------------------------------------

#ifndef ROBOT_H
#define ROBOT_H

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

// ---- Start of robot.cpp

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

void Robot::updatePosition() {
  position.x = position.x + speed;
}

void Robot::modifySpeedBy( int pps ) {
  speed = speed + pps;
}

// -------------------------------------------

#ifndef OBSTACLE_H
#define OBSTACLE_H

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

// -------  Start of Obstacle

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

// ---------------------------------------------
// ---- checkInput() is run as a separate thread

#ifndef GUI_H
#define GUI_H


void *checkInput(void*);

#endif

// ----- Start of GUI.cpp

short gQuit;
short gDraw;

void *checkInput(void*) {

  std::string input;

  while(1) {
    std::cout << "q/u >>";
    getline ( std::cin, input );
    char c = input.at(0);
    switch ( c ) {
    case 'Q':
    case 'q' : gQuit = 1; break;
    case 'U':
    case'u': gDraw = 1; break;
    }
  }
}

// ----------------------   Start of main.cpp

#include <pthread.h>

short gQuit = 0;
short gDraw = 0;

int main() {

  Robot ralph;
  Robot suzie;

  Obstacle block1;
  Obstacle block2;

  block1.draw();
  block2.draw();

  pthread_t inputThread;
  pthread_create(&inputThread, NULL, &checkInput, NULL);

  while (!gQuit) {
    if ( gDraw ) {
      ralph.updatePosition();
      ralph.draw();
      suzie.updatePosition();
      suzie.draw();
      gDraw = 0;
    }
  }
}

