#include "GUI.h"

#include <iostream>
#include <string>

extern short gQuit;
extern short gDraw;

void *checkInput(void*) {

  std::string input;
  char c;

  std::cout << "q/d >>";
  std::cin >> input;
  c = input.at(0);

  while(1) {
    switch ( c ) {
    case 'Q':
    case 'q' :
      gQuit = 1;
      break;
    case 'D':
    case'd' :
      while ( gDraw == 1 ) {}
      std::cout << "q/d >>";
      std::cin >> input;
      c = input.at(0);
      gDraw = 1; 
      break;
    default :
      std::cout << "q/d >>";
      getline ( std::cin, input );
      c = input.at(0);
      break;
    }
  }
}
