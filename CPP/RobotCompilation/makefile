
OBJS = main.o graphics.o robot.o obstacle.o GUI.o
CC = g++
DEBUG = -g
CFLAGS = -Wall -c $(DEBUG)
LFLAGS = -Wall $(DEBUG)
 
all: $(OBJS)
	$(CC) $(LFLAGS) $(OBJS) -o robot

main.o : main.cpp 
	$(CC) $(CFLAGS) main.cpp

graphics.o: graphics.cpp graphics.h
	$(CC) $(CFLAGS) graphics.cpp

robot.o: robot.cpp graphics.h structures.h
	$(CC) $(CFLAGS) robot.cpp

obstacles.o: obstacle.cpp obstacle.h
	$(CC) $(CFLAGS) obstacle.cpp

GUI.o: GUI.cpp GUI.h
	$(CC) $(CFLAGS) GUI.cpp
 
clean: 
	\rm *.o *.*~ robot
	
tar:
	tar cfv compileExample.tar makefile *.*

