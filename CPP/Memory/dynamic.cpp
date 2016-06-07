/*
  This program was created to demonstrate the various types of memory allocation.
  C++, unlike every other language (I think), does NOT do garbage collection (although there are libraries you can use to do that).
  This means as the programmer it is your responsibility to understand how to allocate and free memory, so that you don't run out.
  If you are dealing with very large datasets, memory allocation and efficient use of memory will be extremely important.

  This is not a demonstration of good coding style! The functions and classes are mostly useless, and you should probably
  use containers.
*/

// iostream is for cout and stdint is for uint32_5
#include <iostream>
#include <stdint.h>

// Modify these sizes to crash the system by using up all the various types of memory
// The use of type uint32_t dictates that this is an unsigned 32-bit integer.
// Different platforms can have different sizes for int, so this way you can be sure.
const uint32_t stackSize = 1000;
const uint32_t staticSize = 1000;
const uint32_t heapSize = 1000;
const uint32_t matrixSize = 100;

// These will allow you to use cout instead of std::cout
using namespace std;

//_________________________________________________________________________________________
// This array is statically defined (not at runtime). The size is fixed (i.e. static).
// When declared as a global instance, it uses static memory.
// When declared in a function (even main), it uses stack memory.
class MyArrayClass {
private:
  int size;
  int array[staticSize];
public:
  // Used to count current number of instances
  static int32_t count;

  // Constructor
  MyArrayClass() {
    size = staticSize;
    ++count;
    cout << "Creating MyArrayClass " << count << "\n";
    for ( int i = 0; i < size; i++ ) {
      array[i] = i;
    }
  }

  // Destructor (technically not needed, as compiler will make one for you)
  ~MyArrayClass() {
    cout << "Deleting MyArrayClass " << count << "\n";
    --count;
  }
  // A meaningless class method
  void modify() {
    for ( int i = 0; i < size; i++ ) {
      array[i] += 1;
    }
  }
};

//_________________________________________________________________________________________
// This array is dynamically allocated at run time. It's size can vary.
class DynArrayClass {
private:
  // NOTICE that dynamic allocation requires a pointer, indicated by "*"
  int* array;
  int size;
public:
  // Keeps track of the number of current instances of the class
  static int32_t count;
  DynArrayClass(int inSize) {
    size = inSize;
    ++count;
    cout << "Creating DynArrayClass " << count << "\n";
    // NOTICE that the keyword "new" is used, which returns an address to the newly
    // allocated memory (heap) that array will now point to.
    array = new int[size];
    for (int i = 0; i < inSize; i++ ) {
      array[i] = i;
    }
  }
  ~DynArrayClass() {
    cout << "Deleting DynArrayClass " << count << "\n";
    --count;
    delete []array;
  }
  void modify() {
    for ( int i = 0; i < size; i++ ) {
      array[i] += 1;
    }
  }
};

//_________________________________________________________________________________________
class DynMatrixClass {
private:
  //NOTICE: this is a matrix definition, which uses a pointer to a pointer. The two
  // pointers signify the two dimensions, and each must be defined with "new"
  int** matrix;
  int size;
public:
  static int32_t count;
  DynMatrixClass ( int inSize ) {
    size = inSize;
    ++count;
    cout << "Creating DynMatrixClass " << count << "\n";

    // NOTICE this is memory allocation for the 1st dimension
    matrix = new int*[size];
    for ( int i= 0; i < size ; i++ ) {
      // NOTICE this is memory allocation for the 2nd dimension for EACH of the 1st dimension elements
      // The size is variable along the 2nd dimension. If I wanted a nxn sized matrix, I would use new int[size] instead.
      matrix[i] = new int[size + 10*i];
      for (int j = 0; j < size+10*i ; j++ ) {
        matrix[i][j] = j;
      }
    }
  }
  // ERROR: This is not the right way to handle deletion of this class. Call this a 100,00 times
  // and see what happens. Can you fix it??
  ~DynMatrixClass() {
    cout << "Deleting DynMatrixClass " << count << "\n";
    --count;
    delete []matrix;
  }
  void modify() {
    for ( int i= 0; i < size ; i++ ) {
      for (int j = 0; j < size+10*i ; j++ ) {
        matrix[i][j] += 1;
      }
    }
  }
};

//_________________________________________________________________________________________
// These helper functions demonstrate the automated deletion of an object upon exiting a function.
// All of these instances of the classes created in the helper functions are stored on the stack.
// Can you increase the sizes and make the system crash?
void helperStack() {
  MyArrayClass stackArray1;
  stackArray1.modify();
  MyArrayClass stackArray2;
  stackArray2.modify();
  MyArrayClass stackArray3;
  stackArray3.modify();
}

void helperHeapArray() {
  // NOTICE: These instances are on the stack BUT they contain variables that point to the heap
  DynArrayClass heapArray1( heapSize );
  heapArray1.modify();
  DynArrayClass heapArray2( heapSize );
  heapArray2.modify();
  DynArrayClass heapArray3( heapSize );
  heapArray3.modify();
}

void helperHeapMatrix() {
  // NOTICE: same here, where it is really a combination of stack and heap that are being used.
  DynMatrixClass heapMatrix1( matrixSize );
  heapMatrix1.modify();
  DynMatrixClass heapMatrix2( matrixSize );
  heapMatrix2.modify();
  DynMatrixClass heapMatrix3( matrixSize );
  heapMatrix3.modify();
}

//_________________________________________________________________________________________
// NOTICE: you have to declare and define the static variables for each class
// For each instance of a class, non-static variables are generated for each.
// There is only 1 static variable for ALL instances of a class.
int MyArrayClass::count = 0;
int DynArrayClass::count = 0;
int DynMatrixClass::count = 0;

// This uses static memory
MyArrayClass staticArray;

int main() {

  // You can try each one individually by commenting lines out.
  for ( int i = 0; i < 10; i++ ) { helperStack(); }
  //for ( int i = 0; i < 10; i++ ) { helperHeapArray(); }
  //for ( int i = 0; i < 10; i++ ) { helperHeapMatrix(); }

}
