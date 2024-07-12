import processing.serial.*;
import processing.video.*;
import java.io.PrintWriter;

PGraphics arcLayer;
boolean clockwise;
boolean anticlockwise;
float anglespeed = 0.02;  // Speed of angle change
float startAngle = -PI; // Starting angle of the arc
float endAngle = -PI;   // Ending angle of the arc
float previousAngleDegrees= 0; // Previous angle in degrees

Capture video;
PImage steer;
PImage roll;
PImage pitch;
PImage tire;
PImage tire_side_view;
PrintWriter output;

Serial myPort;
float[] values=new float[29];
float[] speed=new float[240];
int[] rpm= new int[240];
int [] TS_Temp=new int[240];
int [] current=new int[240];
float [] Ax=new float[240];
float [] Ay=new float[240];
//values[0]=millis
//values[1]=RPM
//values[2]=MotorTemp
//values[3]=speed_FL
//values[4]=speed_FR
//values[5]=speed_RL
//values[6]=speed_RR
//values[7]=speed
//values[8]=brakepressure
//values[9]=LVBatteryVoltage
//values[10]=APPS
//values[11]=datalogging
//values[12]=damper_FL
//values[13]=damper_FR
//values[14]=damper_RL
//values[15]=damper_RR
//values[16]=pitch
//values[17]=roll
//values[18]=FL_loadcell
//values[19]=FR_loadcell
//values[20]=RL_loadcell
//values[21]=RR_loadcell
//values[22]=Ax
//values[23]=Ay
//values[24]=SOC
//values[25]=TS_Temp
//values[26]=TS_Current
//values[27]=TS_Voltage
//values[28]=steering_angle

PFont customFont;

void setup(){
  size(1920,990);
  smooth();
  //video=new Capture(this,Capture.list()[0]);
  //video.start();
  myPort=new Serial(this,Serial.list()[0],230400);  
  for(int i=0;i<speed.length;i++){
    speed[i]=0;
    rpm[i]=0;
    TS_Temp[i]=0;
    current[i]=0;
    Ax[i]=0;
    Ay[i]=0;
  }
  customFont = createFont("Arial Narrow Bold Italic", 32);
  steer=loadImage("Steer.png");
  roll=loadImage("image_roll.png");
  pitch=loadImage("image_pitch.png");
  tire=loadImage("tire.png");
  tire_side_view=loadImage("tire_side_view.png");
  arcLayer=createGraphics(width,height);
  arcLayer.beginDraw();
  arcLayer.background(255, 165, 0);
  arcLayer.endDraw();
}

void draw(){
  background(0);
//  float targetWidth = width;
//  float targetHeight = targetWidth * 1 / 2.1; // Change the aspect ratio here this ensures images and videos are displayed without distortion.
//  // Calculate the scale factor for width and height
//  float scaleX = targetWidth / video.width;
//  float scaleY = targetHeight / video.height; 
//  // Apply the scale transformation
//  pushMatrix();
//  scale(scaleX, scaleY);  
//  // Display the video frame
//  image(video, 215, 205, 216, 210);  
//  popMatrix();
  if (myPort.available()>0) {
    String input = myPort.readStringUntil('\n');
    println(input);
    if (input != null) {
      //output.println(input);  
      String[] valuesStr = split(input.trim(), ",");
      if (valuesStr.length==29) {
        for (int i = 0; i < values.length; i++) {
          values[i] = float(valuesStr[i]);
        }
      }
    }
  }
  float randspeed=values[7];
  int randrpm=int(values[1]);
  int randTS_Temp=int(values[19]);
  int randcurrent=int(values[20]);
  float randAx=values[16];
  float randAy=values[17];
  int apps=int(values[10]);
  int bp=int(values[8]);
  
  //Shift and update all the arrays except the last value
  for(int j=0;j<rpm.length-1;j++){
    speed[j]=speed[j];
    rpm[j]=rpm[j+1];
    TS_Temp[j]=TS_Temp[j+1];
    current[j]=current[j+1];
    Ax[j]=Ax[j+1];
    Ay[j]=Ay[j+1];
  }
  //now update the last index of the array
  rpm[rpm.length-1] = randrpm;
  speed[speed.length-1] = randspeed;
  TS_Temp[TS_Temp.length-1] = randTS_Temp;
  current[current.length-1] = randcurrent;
  Ax[Ax.length-1] = randAx;
  Ay[Ay.length-1]=randAy;
  dash(730,495,randspeed,randrpm,apps,bp,int(values[28]));
  Pitch(750,665,values[16],pitch,"Pitch",10);
  Roll(1150,665,values[17],roll,"Roll",10);


}

void dash(int x,int y, float speedVal, int rpmVal, int APPSVal, int BPVal, int SteerAngVal){
  pushMatrix();
  translate(x,y);
  strokeWeight(5);
  stroke(292, 92, 0);
  arc(250,-170,600,20,-PI,0);
  line(-150,-100,-50,-170);
  line(-150,-100,-130,90);
  line(550,-170,640,-100);
  line(640,-100,610,90);
  arc(250,120,800,20,-PI,0);
  drawGauge(25,0,speedVal,"Speed",100);
  drawGauge(505,0,rpmVal,"RPM",3000);
  drawHalfGauge(290,0,BPVal,"BrakePress",50,"Left");
  drawHalfGauge(250,0,APPSVal,"APPS",100,"Right");
  steeringAng(270,-20,SteerAngVal,"Steer_Angle:",180);
  popMatrix();
}
void steeringAng(int x, int y, int value, String label, int maxVal){
  // Assume angle is being updated in real-time elsewhere in your code
  // angle = ...;  // Update this with the real-time angle value from -90 to 90 degrees

  // Translate to the center of the canvas
  translate(x,y);

  // Convert angle from degrees to radians for rotation
  float radiansAngle = radians(value);
  textSize(20);
  text(label, 0,100);
  textFont(customFont);
  textSize(30);
  text(value,80,100);
  text("°",110,100);
  rotate(radiansAngle);
  // Draw the image centered at (0, 0)
  imageMode(CENTER);
  stroke(255);
  fill(255);
  ellipse(0,-80,5,5);
  image(steer, 0, 0,200,200);
}
void drawGauge(int x, int y, float value, String label, int maxValue) {
  pushMatrix();
  translate(x, y);
  noFill();
  strokeWeight(15);
  stroke(292, 92, 0);
  arc(0, 0, 150, 150, -PI, map(value, 0, maxValue, -PI, 0));
  textAlign(CENTER, CENTER);
  textSize(20);
  text(label, 0, 0);
  textFont(customFont);
  textSize(30);
  text(value, 0, -30);
  popMatrix();
}

void drawHalfGauge(int x, int y, int value, String label, int maxValue, String type) {
  pushMatrix();
  translate(x, y);
  noFill();
  strokeWeight(15);
  if (type==("Left")) {
    stroke(2, 173, 0);
    arc(0, 0, 300, 300, -PI, map(value, 0, maxValue, -PI,-2*PI/3));
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, -170, -120);
    textFont(customFont);
    textSize(30);
    text(value, -160, -150);
    text("bar",-125,-150);
  } 
  else if (type==("Right")) {
    stroke(209, 21, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, 150, -120);
    textFont(customFont);
    textSize(30);
    text(value, 140, -150);
    text("%",165,-150);
    scale(-1,1);
    arc(0, 0, 300, 300, -PI, map(value, 0, maxValue,-PI,-2*PI/3));
  }
  popMatrix();
}

void Pitch(int x,int y,float value,PImage img,String label,int maxValue){
  float angle=map(value,0,maxValue,-0.5,0.5);
  float RadAng=radians(angle);
  pushMatrix();
  translate(x,y);
  stroke(292, 92, 0);
  if(value>0){
    arc(105,10,150,10,-PI,map(value,0,maxValue,-PI/2,0));
  }
  else{
   push();
   scale(-1,1);
   arc(55,10,150,10,-PI,map(value,-maxValue,0,-PI/2,0));
   pop();
  }
  push();
  stroke(255);
  strokeWeight(5);
  line(25,-10,25,20);
  pop();
  textAlign(CENTER, CENTER);
  textSize(20);
  text(label, 0, -30);
  textFont(customFont);
  textSize(30);
  text(value, 60, -30);
  image(tire,-80,100,50,50);
  image(tire,120,100,50,50);
  rotate(RadAng);
  imageMode(CENTER);
  image(img,0,90,300,300);
  popMatrix();
}

void Roll(int x,int y,float value,PImage img,String label,int maxValue){
  float angle=map(value,0,maxValue,-1,1);
  float RadAng=radians(angle);
  pushMatrix();
  translate(x,y);
  stroke(292, 92, 0);
  if(value>0){
    arc(105,10,150,10,-PI,map(value,0,maxValue,-PI/2,0));
  }
  else{
   push();
   scale(-1,1);
   arc(55,10,150,10,-PI,map(value,-maxValue,0,-PI/2,0));
   pop();
  }
  push();
  stroke(255);
  strokeWeight(5);
  line(25,-10,25,20);
  pop();
  textAlign(CENTER, CENTER);
  textSize(20);
  text(label, 0, -30);
  textFont(customFont);
  textSize(30);
  text(value, 60, -30);
  image(tire_side_view,70,70,25,25);
  image(tire_side_view,0,70,25,25);
  image(tire_side_view,92,120,50,50);
  image(tire_side_view,-25,120,50,50);
  rotate(RadAng);
  imageMode(CENTER);
  image(img,30,90,150,150);
  popMatrix();
}

void captureEvent(Capture video) {
  video.read();
}
