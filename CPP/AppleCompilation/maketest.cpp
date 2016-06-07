#include "iostream"
#include "apples.h"

int main() {

  Apples fuji( "red", "kitchen");
  Apples grannySmith;
  Apples pinkLady( "red", "pie" );

  grannySmith.setcolor( "green" );
  grannySmith.setplace( "salad" );

  std::cout << "pinklady is " << pinkLady.getcolor();

  grannySmith.printMe();

  fuji.inquire();

  return 1;
}
