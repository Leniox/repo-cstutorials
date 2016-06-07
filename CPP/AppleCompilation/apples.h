#include "things.h"
#include <string>

class Apples : public Things {
 public:
  Apples();
  Apples( std::string c, std::string p );
  void inquire();
};





