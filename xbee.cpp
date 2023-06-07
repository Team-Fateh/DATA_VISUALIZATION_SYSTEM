#include <varible_def.h>
#include<Arduino.h>
#include<CAN.h>
    void send_xbee(){
  Serial1.print(millis());
  Serial1.print(",");
  Serial1.print(RPM);
  Serial1.print(",");
  Serial1.print(temp);
  Serial1.print(",");
  Serial1.print(gear);
  Serial1.print(",");
  Serial1.print(Speed);   //speed
  Serial1.print(",");
  Serial1.print("0");   //brake pressure
  Serial1.print(",");
  Serial1.print(volts);
  Serial1.print(",");
  Serial1.print(radCheck);   //radiator
  Serial1.print(",");
  Serial1.print("0");   //datalogging
  Serial1.print(",");
  Serial1.print("0");   //throttle position
  Serial1.print(",");
  Serial1.print("0");   //brake temp
  Serial1.print(",");
  Serial1.print("0");   //front left load cell
  Serial1.print(",");
  Serial1.print("0");   //front right load cell
  Serial1.print(",");
  Serial1.print("0");   //rear left load cell
  Serial1.print(",");
  Serial1.print("0");   //rear right load cell
  Serial1.print(",");
  Serial1.print("0");   //accelerometer x-axis
  Serial1.print(",");
  Serial1.print("0");   //accelerometer y-axis
  Serial1.print(",");
  Serial1.println("0");   //steering angle  
    }