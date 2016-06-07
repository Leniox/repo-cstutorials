# make is a utility that automates compilation
# it is invoked with "make" at the os prompt

OBJS = 
CC = g++
CFLAGS = -Wall -c
LFLAGS = -Wall
SOURCES = maketest.cpp things.cpp apples.cpp
HEADERS = things.h apples.h

all: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o maketest 

maketest : maketest.o apples.o things.o
	g++ maketest.o apples.o things.o -o maketest

maketest.o : maketest.cpp apples.h things.h 
	g++ -c -Wall maketest.cpp

apples.o : apples.cpp things.h apples.h
	g++ -c -Wall apples.cpp

things.o : things.cpp things.h
	g++ -c -Wall things.cpp 

clean: 
	\rm

tar:
	tar cfv maketest.tar Makefile *.cpp *.h
