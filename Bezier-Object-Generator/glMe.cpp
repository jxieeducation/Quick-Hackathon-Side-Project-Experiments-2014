#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>
#include <sstream>
#include <string>

#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#endif

#ifdef OSX
#include <GLUT/glut.h>
#include <OpenGL/glu.h>
#else
#include <GL/glut.h>
#include <GL/glu.h>
#endif

#include <time.h>
#include <math.h>
#include "Patch.h"

#define PI 3.14159265

using namespace std;

float div_num = 0.1;
bool adaptive = false;

float patch_value = 0.5;
float zoom = 1.0;
float zoom1 = -1, zoom2 = 1, zoom3 = -1, zoom4 = 1;
float rotate_left = 0, rotate_down = 0;
float translate_right = 0, translate_down = 0;
bool shading = false, wired = false;

Vector** test;
bool flag = true;
int counter = 0;


//this codes read!!!!
int __patch_num = 0;
std::vector<Patch> patches;

void load(string bez)
{ 
    float x, y, z;
    std::vector<Bezier> beziers;
    std::ifstream file(bez.c_str());     
    if(!file.is_open()) 
    {
      std::cout << "error";
    }
    else 
    {
        std::string line;
        while(file.good()) {
            std::string buf;
            std::vector<std::string> input;
            std::getline(file,line);
            std::stringstream ss(line);
            while (ss >> buf) {
                input.push_back(buf);
            }

            if (__patch_num == 0)
            {
                __patch_num = atof(input[0].c_str());
                continue;
            }
            if(input.size() == 0)
            {
                //this is just a blank line
                if (__patch_num != patches.size() && beziers.size() == 4)
                {
                    Patch patch = Patch(beziers[0], beziers[1],beziers[2], beziers[3], div_num);
                    patches.push_back(patch);
                    beziers.clear();
                }
                continue;
            }
            if (input[0][0] == '#')
            {
              continue;
            }

            x = atof(input[0].c_str());
            y = atof(input[1].c_str());
            z = atof(input[2].c_str());
            Vector one = Vector(x, y, z);

            x = atof(input[3].c_str());
            y = atof(input[4].c_str());
            z = atof(input[5].c_str());
            Vector two = Vector(x, y, z);
                
            x = atof(input[6].c_str());
            y = atof(input[7].c_str());
            z = atof(input[8].c_str());
            Vector three = Vector(x, y, z);

            x = atof(input[9].c_str());
            y = atof(input[10].c_str());
            z = atof(input[11].c_str());
            Vector four = Vector(x, y, z);
            Bezier bez = Bezier(one, two, three, four);
            beziers.push_back(bez);
        }
        if (__patch_num != patches.size())
        {
            std::cout << "we didn't read as many patches as the bez file told us...";
        }
    }
}
//end of read in stuff

class Viewport {
  public:
    int w, h;
};

Viewport viewport;

void myReshape(int w, int h) {
  viewport.w = w;
  viewport.h = h;

  glViewport(0,0,viewport.w,viewport.h);// sets the rectangle that will be the window
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();                // loading the identity matrix for the screen
  glOrtho(zoom1, zoom2, zoom3, zoom4, 1, -1);    // resize type = stretch
}

void initScene(){
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // Clear to black, fully transparent

  myReshape(viewport.w,viewport.h);
}


void myDisplay() {
  static float tip = 0.5f;
  const  float stp = 0.0001f;
  const  float beg = 0.1f;
  const  float end = 0.9f;
  tip += stp;
  if (tip>end) tip = beg;

  glClear(GL_COLOR_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  //int list_num = 0;
  //if(flag) {
	  //list_num = glGenLists(1);
	  //glNewList(list_num, GL_COMPILE);
	  for(int i = 0; i < __patch_num; i++) {
		  tesselate(patches[i], adaptive);
	  }
	  //glEndList();
	  //flag = false;
  //} else {
	//  glCallList(list_num);
  //}
  //for(int i = 0; i < __patch_num; i++) {
	  //tesselate(patches[i], true);
  //}
  /*glBegin(GL_POLYGON);
  counter++;
  printf("This was called %i times\n", counter);
  glColor3f(0.0f,1.0f,0.0f);
  glVertex3f((-0.5f), 0.5f, 0.0f);
  glColor3f(1.0f,0.0f,0.0f);
  glVertex3f((-0.5f), -0.5f, 0.0f);
  glColor3f(0.0f,0.0f,1.0f);
  glVertex3f((0.5f), 0.5f, 0.0f);
  glColor3f(0.0f,1.0f,1.0f);
  glVertex3f((0.5f), -0.5f, 0.0f);
  glEnd();*/
  glFlush();
  glutSwapBuffers();
}


void myFrameMove() {
#ifdef _WIN32
  Sleep(10);
#endif
  glutPostRedisplay();
}

void refresh()
{
  glViewport(0,0,viewport.w,viewport.h);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glTranslatef(translate_right, translate_down, 0);
  glRotatef(rotate_left, 0, 1, 0 );
  glRotatef( rotate_down, 1, 0, 0 );
  glScalef (zoom, zoom, zoom);
  
  glShadeModel(GL_FLAT);
  glLightModelf(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);

  GLfloat ambient[] = {0.2f, 0.2f, 0.2f, 1.0f};
  GLfloat diffuse[] = {0.5f, 0.5f, 0.5f, 1.0f};
  GLfloat specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
  GLfloat shine = 50.0f;
  glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
  glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
  glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
  glMaterialf(GL_FRONT, GL_SHININESS, shine);

  GLfloat lightColor0[] = {0.5f, 0.5f, 0.5f, 1.0f};
  GLfloat lightPos0[] = {-3.0f, -3.0f, -3.0f, 1.0f}; 
  glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor0);
  glLightfv(GL_LIGHT0, GL_POSITION, lightPos0);

  glEnable(GL_NORMALIZE);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);  
}

void pressed(unsigned char key, int x, int y) 
{
  if (key == ' ') {
    exit(0);
  }
  else if (key == '-') 
  {
    zoom -= 0.1;
    refresh();
  }
  else if (key == '+') {
    zoom += 0.1;
    refresh();
  }
  else if (key == 's')
  {
    refresh();
    if (shading)
    {
      glEnable(GL_FLAT);
      glShadeModel(GL_FLAT);
      shading = false;
    }
    else
    {
      glEnable(GL_SMOOTH);
      glShadeModel(GL_SMOOTH);
      shading = true;
    }
  }
  else if (key == 'w')
  {
    refresh();
    if (wired)
    {
      glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
      wired = false;
    }
    else
    {
      glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
      wired = true;
    }
  }
}

void special_pressed(int key, int x, int y) {
  switch (key) {
    case GLUT_KEY_LEFT:
      if (glutGetModifiers() == GLUT_ACTIVE_SHIFT) 
      {
        translate_right -= 0.05;
        refresh();
      }
      else
      {
        rotate_left += 10;
        refresh();
      }
      break;
    case GLUT_KEY_RIGHT:
      if (glutGetModifiers() == GLUT_ACTIVE_SHIFT) 
      {
        translate_right += 0.05;
        refresh();
      }
      else
      {
        rotate_left -= 10;
        refresh();
      }
      break;
    case GLUT_KEY_UP:
      if (glutGetModifiers() == GLUT_ACTIVE_SHIFT) 
      {
        translate_down += 0.05;
        refresh();
      }
      else
      {
        rotate_down -= 10;
        refresh();
      }
      break;
    case GLUT_KEY_DOWN:
      if (glutGetModifiers() == GLUT_ACTIVE_SHIFT) 
      {
        translate_down -= 0.05;
        refresh();
      }
      else
      {
        rotate_down += 10;
        refresh();
      }
      break;
  }
}

int main(int argc, char *argv[]) {
  string bez;
  if (argc > 1)
  {
    bez = argv[1];
    string division = argv[2];
    div_num = atof(division.c_str());
    if (argc > 3)
    {
      string flag = argv[3];
      if (flag == "-a") {
        adaptive = true;
      }
    }
  }
  load(bez);
  glutInit(&argc, argv);
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
  viewport.w = 1200;
  viewport.h = 1200;
  glutInitWindowSize(viewport.w, viewport.h);
  glutInitWindowPosition(500, 500);
  glutCreateWindow("184!");
  initScene();
  glutKeyboardFunc(pressed);
  glutSpecialFunc(special_pressed);

  glutDisplayFunc(myDisplay);
  glutReshapeFunc(myReshape);
  glutIdleFunc(myFrameMove); 
  glutMainLoop();
  return 0;
}