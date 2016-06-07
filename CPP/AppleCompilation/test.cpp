#include "apples.h"
#include <iostream>

using namespace std;

int main() {

  Apples fuji( "red", "kitchen");
  Apples grannySmith;
  Apples pinkLady( "red", "pie" );

  grannySmith.setcolor( "green" );
  grannySmith.setplace( "salad" );

  cout << "pinklady is " << pinkLady.getcolor();

  grannySmith.printMe();

  fuji.inquire();

  return 1;
}
