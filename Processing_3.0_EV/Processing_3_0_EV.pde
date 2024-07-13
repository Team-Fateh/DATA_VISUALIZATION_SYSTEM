import processing.serial.*;
import processing.video.*;
import java.io.PrintWriter;

Capture video;
PImage steer;
PImage roll;
PImage pitch;
PImage tire;
PImage tire_side_view;
PrintWriter output;

Serial myPort;
float[] values=new float[30];
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
//values[29]=power
PFont customFont;

void setup(){
  size(1920,990);
  smooth();
  //video=new Capture(this,Capture.list()[0]);
  //video.start();
  myPort=new Serial(this,Serial.list()[2],230400)  ;
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
      if (valuesStr.length==30) {
        for (int i = 0; i < values.length; i++) {
          values[i] = float(valuesStr[i]);
        }
      }
    }
  }
  float randspeed=values[7];
  int randrpm=int(values[1]);
  int randTS_Temp=int(values[25]);
  int randcurrent=int(values[26]);
  int FL_d=int(values[12]);
  int FR_d=int(values[13]);
  int RL_d=int(values[14]);
  int RR_d=int(values[15]);
  float randAx=values[22];
  float randAy=values[23];
  int apps=int(values[10]);
  int bp=int(values[8]);
  
  //Shift and update all the arrays except the last value
  for(int j=0;j<rpm.length-1;j++){
    speed[j]=speed[j+1];
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
  dash(680,495,randspeed,randrpm,apps,bp,int(values[28]));
  Pitch(750,665,values[16],pitch,"Pitch:",10);
  Roll(1100,665,values[17],roll,"Roll:",10);
  textFont(customFont);
  textSize(25);
  text("DAMPLER\nTRAVEL", 950,900);
  dampertravel(700,870,FL_d,"FL:",100);
  dampertravel(1150,870,FR_d,"FR:",100);
  dampertravel(700,950,RL_d,"RL:",100);
  dampertravel(1150,950,RR_d,"RR:",100);
  drawGraphf(240, 95, speed, "Speed", 50, 320, 100, 292, 92, 0, 5, 0);
  drawGraph(240, 95, rpm, "RPM", 50, 470, 3000, 292, 92, 0, 5, 0);
  drawGraphf(240, 75, Ax, "", 50, 625, 5, 255, 165, 0, 5, 1);
  drawGraphf(240, 75, Ay, "", 50, 625, 5, 220, 0, 0, 5, 1);
  circularGraph(values[22],values[23],390,890);
  drawGraph(240, 75,TS_Temp, "TS_Temp", 1375, 50, 150, 292, 92, 0, 5, 0);
  drawGraph(240, 75,current, "Curr", 1375, 200, 4, 292, 92, 0, 5, 0);
  drawBar(1400, 500,int(values[24]),"SOC",100);
  drawBar(1500, 500,int(values[29]),"Power",80);
  ONOFF(250,900,int(values[11]),"D");
  Dataf(100,900,values[9],"V","LVBattery","Voltage");
  Data(1630,400,int(values[26]),"A","Discharge Current");
  Data(1800,400,int(values[27]),"°C","Ts_Temp");
  Data(1630,500,int(values[24]),"%","SOC");
  Data(1800,500,int(values[29]),"W","Power");
  //drawGraph();
}

void dash(int x,int y, float speedVal, int rpmVal, int APPSVal, int BPVal, int SteerAngVal){
  pushMatrix();
  translate(x,y);
  strokeWeight(5);
  stroke(292, 92, 0);
  arc(250,-170,600,20,-PI,0);
  arc(250,120,700,20,-PI,0);
  drawGaugef(25,0,speedVal,"Speed",100);
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
void drawGaugef(int x, int y, float value, String label, int maxValue) {
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

void drawGauge(int x, int y, int value, String label, int maxValue) {
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

void dampertravel(int x,int y,int value,String label,int maxValue){
 pushMatrix();
 translate(x,y);
 //fill(292, 92, 0);
 if (value>=0){
 rect(10,0,value,15);
 }
 else if(value<0){
 rect(-5,0,value,15);
 }
 push();
 strokeWeight(5);
 stroke(255);
 line(5,20,5,-10);
 pop();
  textAlign(CENTER, CENTER);
  textSize(20);
  text(label, -15, -30);
  textFont(customFont);
  textSize(30);
  text(value, 25, -30);
  text("%", 55, -30);
 popMatrix();
}

void drawGraph(float w, float h, int[] data, String label, int xOffset, int yOffset, int maxValue, int str1, int str2, int str3, int time, int flag) {
  pushMatrix();
  translate(xOffset, yOffset);
  int i=0, x1=0, x2 = 0, y1=0, y2 = 0;
  int pointInterval = int(w / data.length)*2;
  strokeWeight(3);
  stroke(str1, str2, str3);
  for (i = 1; i < data.length; i++) {
    x1 = (i-1) * pointInterval;
    y1 = int(h - (data[i-1] * h / maxValue));
    x2 = i * pointInterval;
    y2 = int(h - (data[i] * h / maxValue));
    line(x1, y1, x2, y2);
  }
  textSize(20);
  text(data[i-1], x2 + 30, y2 - 5);
  textSize(25);
  text(label, x2-230, -20);
  stroke(255);
  line(0, 0, x2, 0);
  line(0, h, x2, h);
  textSize(20);
  for (i = 0; i <= time; i++) {
    line(int((96.25 * i)), -10, int((96.25 * i)), h + 10);
    text(i - time, int((96.25 * i)), h + 20);
  }
  if (flag==1) {
    line(0, 2*h, x2, 2*h);
    for (i = 0; i <= time; i++) {
      line(int((96.25 * i)), h-10, int((96.25 * i)), 2*h + 10);
    }
    textSize(25);
    text("G's", x2 + 75, 95);
    flag=0;
  }
  popMatrix();
}

void drawGraphf(float w, float h, float[] data, String label, int xOffset, int yOffset, int maxValue, int str1, int str2, int str3, int time, int flag) {
  pushMatrix();
  translate(xOffset, yOffset);
  int i=0;
  float x1=0.0, x2 = 0.0, y1=0.0, y2 = 0.0;
  int pointInterval = int(w / data.length)*2;
  strokeWeight(3);
  stroke(str1, str2, str3);
  for (i = 1; i < data.length; i++) {
    x1 = (i-1) * pointInterval;
    y1 = (h - (data[i-1] * h / maxValue));
    x2 = i * pointInterval;
    y2 = (h - (data[i] * h / maxValue));
    line(x1, y1, x2, y2);
  }
  textSize(20);
  text(data[i-1], x2 + 30, y2 - 5);
  textSize(25);
  text(label, x2-230, -20);
  stroke(255);
  line(0, 0, x2, 0);
  line(0, h, x2, h);
  textSize(20);
  for (i = 0; i <= time; i++) {
    line(int((96.25 * i)), -10, int((96.25 * i)), h + 10);
    text(i - time, int((96.25 * i))+10, h + 30);
  }
  if (flag==1) {
    line(0, 2*h, x2, 2*h);
    for (i = 0; i <= time; i++) {
      line(int((96.25 * i)), h-10, int((96.25 * i)), 2*h + 10);
    }
    textSize(25);
    text("G's", x2 -250, -20);
    flag=0;
  }
  popMatrix();
}

public void circularGraph(float v1,float v2,int X,int Y){
  pushMatrix();
  translate(X,Y);
  noFill();
  stroke(292,92,0);
  ellipse(0,0,150,150);
  ellipse(0,0,100,100);
  ellipse(0,0,50,50);
  line(0,-75,0,75);
  line(-75,0,75,0);
  noStroke();
  fill(255);
  ellipse(v1,v2,20,20);
  fill(255);
  textSize(50);
  popMatrix();
}

void drawBar(int x, int y, int value, String label, int maxValue) {
  pushMatrix();
  translate(x, y);
  float barHeight = map(value, 0, maxValue, 0, 130);
  noStroke();
  fill(292,92, 0);
  rect(0 - 20, -barHeight, 40, barHeight);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(255);
  text(value, 0, -barHeight-30);
  text(label, 0, 20);
  popMatrix();
}

void ONOFF(int x,int y,int value,String S){
  pushMatrix();
  translate(x,y);
  push();
  if(value==0){
  stroke(255);
  fill(255,0,0);
  ellipse(0,0,70,70);
  fill(0);
  textSize(30);
  text(S,1,-1);
}
else{
  stroke(255);
  fill(0,255,0);
  ellipse(0,0,70,70);
  fill(0);
  textSize(30);
  text(S,1,-1);
  }
  pop();
  popMatrix();
}

void Dataf(int x,int y,float value,String unit,String label,String label2){
  textFont(customFont);
  textSize(30);
  push();
  fill(293,92,0);
  text(value, x, y-20);
  pop();
  textSize(25);
  text(label+"\n"+label2, x, y+30);
  text(unit, x+50, y-20);
}

void Data(int x,int y,int value,String unit,String label){
  textFont(customFont);
  textSize(30);
  push();
  fill(293,92,0);
  text(value, x, y-20);
  pop();
  textSize(25);
  text(label, x, y+30);
  text(unit, x+35, y-20);
}

void captureEvent(Capture video) {
  video.read();
}
