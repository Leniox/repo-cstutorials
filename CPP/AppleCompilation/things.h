#include <string>

class Things {

 protected:
  std::string color;
  std::string name;
  std::string place;

 public:
  Things();
  Things( std::string, std::string, std::string );

  void setname( std::string n );
  std::string getname();

  void setcolor( std::string c );
  std::string getcolor();

  void setplace( std::string p );
  std::string getplace();

  void printMe();

};

