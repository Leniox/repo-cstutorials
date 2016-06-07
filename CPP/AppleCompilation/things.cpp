#include <iostream>
#include "things.h"

// Overloaded constructors
Things::Things() {
  
  name = "nothing";
  color = "clear";
  place = "nowhere";
}

Things::Things( std::string n, std::string c, std::string p) {
  name = n;
  color = c;
  place = p;
}


// The getters and setters of private data
void Things::setname( std::string n ) { name = n; }
std::string Things::getname() { return name; }

void Things::setcolor( std::string c ) { color = c; }
std::string Things::getcolor() { return color; }

void Things::setplace( std::string p ) { place = p; }
std::string Things::getplace() { return place; }


// Output
void Things::printMe() {
  std::cout << "I am a " << name << " that is the color " << color << ". ";
  std::cout << "I belong in the " << place << ".\n";
}
  
