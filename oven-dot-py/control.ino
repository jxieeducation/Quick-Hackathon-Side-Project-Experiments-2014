#include <AFMotor.h>

AF_DCMotor motorc(3, MOTOR12_1KHZ); 
AF_DCMotor motord(4, MOTOR12_1KHZ); 
char msg; 

void setup() {
  Serial.begin(115200);           
  motorc.setSpeed(255);
  motorc.run(FORWARD);
  motord.setSpeed(255);
  motord.run(FORWARD);
}

void loop() { 
  if(Serial.available() > 0)
  {
    char data = Serial.read();
    if(data == 'A')
    {
        motorc.run(RELEASE);
    }
    else if(data == 'B')
    {
        motorc.run(FORWARD);
    }
    else if(data == 'C')
    {
        motord.run(RELEASE);
    }
    else if(data == 'D')
    {
        motord.run(FORWARD);
    }
  }
}  
 
  
