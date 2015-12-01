CC = g++
ifeq ($(shell sw_vers 2>/dev/null | grep Mac | awk '{ print $$2}'),Mac)
	CFLAGS = -g -DGL_GLEXT_PROTOTYPES -I./include/ -I/usr/X11/include -DOSX
	LDFLAGS = -framework GLUT -framework OpenGL \
    	-L"/System/Library/Frameworks/OpenGL.framework/Libraries" \
    	-lGL -lGLU -lm -lstdc++
else
	CFLAGS = -g -DGL_GLEXT_PROTOTYPES -Iexample_00/glut-3.7.6-bin
	LDFLAGS = -lglut -lGL
endif

RM = /bin/rm -f 
all: main 
main: glMe.cpp
	$(CC) $(CFLAGS) -w -o as3 glMe.cpp Patch.h $(LDFLAGS) 