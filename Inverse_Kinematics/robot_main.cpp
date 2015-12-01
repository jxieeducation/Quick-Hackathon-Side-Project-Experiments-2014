#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>
#include <sstream>
#include <string>
#include "Geometry.h"
#include <time.h>
#include <math.h>
#include <windows.h>

#define PI 3.14159265

using namespace std;

class Viewport {
  public:
    int w, h;
};

Viewport viewport;
Segment segment1 = Segment(Vector(2,0,0), Vector(0,0,0), .2);
Segment segment2 = Segment(Vector(4,0,0), Vector(2,0,0), .2, &segment1);
Segment segment3 = Segment(Vector(5,0,0), Vector(4,0,0), .1, &segment2);
Segment segment4 = Segment(Vector(6,0,0), Vector(5,0,0), .1, &segment3);
Arm arm = Arm(&segment1, &segment2, &segment3, &segment4);
int i = 0;
int size = 20;
Vector* goals = ((Vector *) malloc(size*sizeof(Vector)));

void myReshape(int w, int h) {
  viewport.w = w;
  viewport.h = h;

  glViewport(0,0,viewport.w,viewport.h);// sets the rectangle that will be the window
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();                // loading the identity matrix for the screen
}

void initScene(){
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // Clear to black, fully transparent
  glPointSize(6.0);
  glOrtho(-10.0, 10.0, -1.0, 10.0, -10.0, 1.0);
  myReshape(viewport.w,viewport.h);
}

void myDisplay() {
  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glFlush();
  if(i == size) {
	  i = 0;
  }
  /*glBegin(GL_POINTS);
  glColor3f(1.0, 0.0, 0.0);
  glVertex3f(goals[i].x, goals[i].y, goals[i].z);
  glEnd();*/
  //testmove(arm, goals[i]);
  move(&arm, goals[i]);
  i++;
  Sleep(500);
  glutSwapBuffers();
}


void myFrameMove() {
#ifdef _WIN32
  //Sleep(10);
#endif
  glutPostRedisplay();
}

int main(int argc, char *argv[]) {
	goals[0] = Vector(.7,0,0);
	goals[1] = Vector(.3,.7,0);
	goals[2] = Vector(0,.7,0);
	goals[3] = Vector(-.3,.7,0);
	goals[4] = Vector(-.7,0,0);
	goals[5] = Vector(-.3,-.7,0);
	goals[6] = Vector(0,-.7,0);
	goals[7] = Vector(.3,-.7,0);
	goals[8] = Vector(0,0,.7);
	goals[9] = Vector(0,0,-.7);
	goals[10] = Vector(.3,.3,.3);
	goals[11] = Vector(.3,-.3,.3);
	goals[12] = Vector(0,0,.3);
	goals[13] = Vector(-.3,.3,.3);
	goals[14] = Vector(-.3,-.3,.3);
	goals[15] = Vector(0,0,0);
	goals[16] = Vector(0,0,.6);
	goals[17] = Vector(-.3,-.3,0);
	goals[18] = Vector(0,-.6,0);
	goals[19] = Vector(.3,-.3,0);
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
  viewport.w = 1200;
  viewport.h = 1200;
  glutInitWindowSize(viewport.w, viewport.h);
  glutInitWindowPosition(500, 500);
  glutCreateWindow("184!");
  initScene();

  glutDisplayFunc(myDisplay);
  glutReshapeFunc(myReshape);
  glutIdleFunc(myFrameMove); 
  glutMainLoop();
  return 0;
}