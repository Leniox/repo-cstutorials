#include <pthread.h>

// Missing KEY #includes of header files

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

