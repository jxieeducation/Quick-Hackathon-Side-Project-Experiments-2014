Inverse_Kinematics
==================

a simple module that simulates a 4-segment arm bending to reach a goal object.   

https://www.youtube.com/watch?v=NihNvI7w7gs   
As shown in the video, we have an arm of different segment length, chasing after a few moving points.    
The root link is attached to an immobile base by a ball joint (the origin).    
segment1 - (2,0,0)-(0,0,0), length = 0.2   
segment2 - (4,0,0)-(2,0,0), length = 0.2   
segment3 - (5,0,0)-(4,0,0), length = 0.1   
segment4 - (6,0,0)-(5,0,0), length = 0.1   
   

Some of the goal points that the arm tried to chase in the video: (.3,0,0), (.15,.15,0), (0,.3,0), (-.15,.15,0), (-.3,0,0), (-.15,-.15,0), (0,-.3,0), (.15,-.15,0), (.3,0,0)   
The video displays the range of motion the robot arm has.   
The range of motion simulates a spiraling circle, that goes outwards and then inwards.

https://www.youtube.com/watch?v=X8sV827Oo-o   
In the above video, we had points that were out of reach. In our program, we made it so that the red points (indicating error!) appears if the spatial vector is out of reach. As shown, the points are very close and the arm is trying to reach them (but it can't...).