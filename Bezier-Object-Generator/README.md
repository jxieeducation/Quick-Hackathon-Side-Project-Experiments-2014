Bezier Curves Generator   

The program reads in a Bezier (.bez) file and applies graphical tessellation to reconstruct the original object.   

"s" - toggle between flat and smooth shading.    

"w" - toggle between filled and wireframe mode.   

arrow keys - the object will be rotated.   

shift+arrow keys - the object will be translated.   

+/- - keys will zoom in/out.   


Sample example test inputs:

Uniform (low res)
./as3 teapot.bez 1.1


Adaptive (low res)
./as3 teapot.bez 1.75 -a


Custom bezier file
./as3 next.bez 0.1
 
No shading method
./as3 teapot.bez 0.1
