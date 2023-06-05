import controlP5.*;

ControlP5 cp5;

color Yellow = (#FFC503);
color Black = (#171611);

PFont f1, f2;
PImage logo;
Button b0;
ScrollableList s1;
import processing.serial.*;
Serial myPort;        
int gaugeValue;
int[] values = new int[18];
int[] speed = new int[615];
int[] rpm = new int[615];
int[] brakepressure = new int[315];
int[] xAccel = new int[240];
int[] yAccel= new int[240];
int[] xAccel1 = new int[240];
int[] yAccel1= new int[240];
//int gaugeValue2=0;
PFont italicFont;
PImage img;
PImage img2;
float offset = 0;
float easing = 0.05;
boolean linkSketched = false;

void setup() {
  cp5 = new ControlP5(this);
  size(1350,700);
  surface.setTitle("TEAM FATEH GUI SYSTEM");
  logo = loadImage("LOGO.jpg");
  f1 = createFont("Arial-BoldItalicMT-48", 30, true);
  f2 = createFont("Arial", 12);
  img = loadImage("LOGO.jpg"); // Load an image into the program
  img2=loadImage("FB.png");
  image(img2,0,0,width,height);
drawInterface();
BUTTONS();
PORT();
}

void draw() {
  // No need for draw function in this case, since we are not animating anything
}

void drawInterface() {
  smooth();
  surface.setIcon(logo);
  image(logo, width - 100, 0, 100, 100);

  textFont(f1);
  fill(255,0,0);
  textAlign(CENTER);
  text("TEAM FATEH GUI SYSTEM", width / 2, 50);

  stroke(255);
  strokeWeight(2);
  line(width / 4, 60, 3 * width / 4, 60);
}

void BUTTONS() {
  // BUTTON
  fill(Black);
  stroke(Yellow);
  strokeWeight(2);
  b0 = cp5.addButton("START")
         .setValue(1)
         .setPosition(width-150, 385)
         .setSize(130, 50)
         .setColorBackground(color(255,0,0))
         .setColorForeground(Yellow)
         .setColorActive(color(255,0,0));
 b0.addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      if (event.getName().equals("START")) {
        buttonClicked("START");
      }
    }
  });
  b0 = cp5.addButton("EXIT")
         .setValue(2)
         .setPosition(width-150, 450)
         .setSize(130, 50)
         .setColorBackground(color(255,0,0))
         .setColorForeground(Yellow)
         .setColorActive(color(255,0,0));
 b0.addListener(new ControlListener() {
    public void controlEvent(ControlEvent event) {
      if (event.getName().equals("EXIT")) {
        buttonClicked("EXIT");
      }
    }
  });
}
void PORT(){
 // SCROLLABLE LIST
 // Get a list of available port names
  ScrollableList portList;
  cp5 = new ControlP5(this);

  String[] portNames = Serial.list();

  portList = cp5.addScrollableList("AVAILABLE PORTS")
                .setPosition(width - 170, 275)
                .setSize(400, 700)
                .setItemHeight(22)
                .setBarHeight(20)
                .setBackgroundColor(0)
                .setColorBackground(255)
                .setColorActive(color(255, 0, 0))
                .setFont(createFont("Arial", 12))
                .setOpen(false);

  for (String portName : portNames) {
    try {
      Serial port = new Serial(this, portName, 9600); // Replace baud rate with the appropriate one for your device
      println("Device is connected to port: " + portName);
      port.stop();
      portList.addItem(portName, 0);
    } catch (Exception e) {
      println("Port is busy: " + portName);
      e.printStackTrace();
    }
  }
}


void COM(int n) {
  println("ScrollableList event: " + n + ", " + cp5.get(ScrollableList.class, "COM").getItem(n).get("name"));
  drawInterface();
}
void buttonClicked(String buttonName) {
  if (buttonName.equals("START")) {
    PApplet.runSketch(new String[] { "MySketch" }, new MySketch());
  }
  if (buttonName.equals("EXIT")) {
exit()  ;
}
}
class MySketch extends PApplet {
  public void settings(){
  size(1350,860);
  }
  public void setup() {
  size(1350,860);
  smooth();
  //myPort = new Serial(this,"COM4",230400);
    myPort = new Serial(this,Serial.list()[0],230400);
  for (int i = 0; i < rpm.length; i++) {
    rpm[i] = 0;
    speed[i] = 0;
 }
   for (int i = 0; i < brakepressure.length; i++) {
    brakepressure[i] = 0;
  }
  for (int i = 0; i < xAccel.length; i++) {
    xAccel[i] = 0;
    yAccel[i] = 0;
    xAccel1[i] = 0;
    yAccel1[i] = 0;
  }
  }
public void draw(){
background(0);
  image(img,450,220,400,365);
  if (myPort.available() > 0) {
    String input = myPort.readStringUntil('\n');
    println(input);
    if (input != null) {
     String[] valuesStr = split(input.trim(), ",");
       if (valuesStr.length==18) {
        for (int i = 0; i < values.length; i++) {
          values[i] = int(valuesStr[i]);
        }
      }
    }
  }
  int dataValue = values[0];//millis
  int randValue = values[1];//RPM
  int randValue1 = values[4];//SPEED
  int randValue2 = values[5];//BRAKEpressure
  int randValue3 = values[9];//THROTTLE
  int randValue4 = values[10];//breaktemp
  int randValue5 = values[15];//circulargraphX
  int randValue6 = values[16];//circulargraphY
  for (int i = 0; i < rpm.length-1; i++) {
    rpm[i] = rpm[i+1];
    speed[i]=speed[i+1];
  }
   for (int i = 0; i < brakepressure.length-1; i++) {
    brakepressure[i]=brakepressure[i+1];
  }
    for (int i = 0; i < xAccel.length-1; i++) {
    xAccel[i] = xAccel[i+1];
    yAccel[i] = yAccel[i+1];
    xAccel1[i] = xAccel1[i+1];
    yAccel1[i] = yAccel1[i+1];
  }
  
  speed[speed.length-1] = randValue1;
  rpm[rpm.length-1]=randValue;
  brakepressure[brakepressure.length-1]=randValue2;
  xAccel[xAccel.length-1] = randValue5;
  yAccel[yAccel.length-1] = randValue6;
  xAccel1[xAccel1.length-1] = int(map(randValue5,0,1023,-50,50));
  yAccel1[yAccel1.length-1] = int(map(randValue6,0,1023,-50,50));
  int dataValue1 = values[1];
    GAUGE(980,height-150,values[4],"SPEED",150);
    GAUGE(1225,height-150,values[1],"RPM",11000);
    GRAPH(615,170,speed,"SPEED",20,10,150);
    GRAPH(615,170,rpm,"RPM",680,10,11000);
    GRAPH2(315,85,xAccel1,yAccel1,"G's",30,290,50);
    BAR(800,height-170, values[5],"BreakPressure",100);
    G(values[15],values[16],100,520);
    ONOFF(200,520,values[7],"R");
    ONOFF(300,520,values[8],"D");
    RAWDATA(1150,250);
    stroke(255);
    line(0,height-275,width,height-275);
    line(0,220,width,220);
    noFill();
    rect(5,220,400,365);
    rect(945,220,400,365);
    textAlign(CENTER,CENTER);
    fill(255);
    //textSize(20);
    //text("ENGINE",215,480);
    //text("DATA",310,480);
    textSize(50);
    text("GEAR",100,670);
    textSize(30);
    text("Battery",500,600);
    text("EngineTemp",320,600);
    textSize(70);
    fill(255, 204, 0);
    text(values[3],100,620);
    textSize(50);
    text("G's",170,250);
    text("'C",350,650);
    text("V",515,650);
    text(values[2],300,650);
    text(values[6],480,650);
}
public void GAUGE(int X,int Y,int value,String label,int maxvalue){
strokeWeight(25);
  pushMatrix();
  translate(X,Y);
  stroke(255, 204, 0);
  noFill();
  arc(0,0,200,200,-PI, map(value, 0,maxvalue,-PI,0));
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(30);
  text(label,0,-60);
  text(value,0,-30);
  popMatrix();
}
public void GRAPH(float w, float h, int[] data, String label, int x,int  y, int maxValue){
  pushMatrix();
  translate(x,y);
  int i=0, x1=0, x2 = 0, y1=0, y2 = 0;
  int pointInterval = int(w / data.length);
  strokeWeight(2);
  stroke(255, 204, 0);
  for (i = 1; i < data.length; i++) {
    x1 =(i-1) * pointInterval;
    y1 = int(h - (data[i-1] * h / maxValue));
    x2 =i * pointInterval;
    y2 = int(h - (data[i] * h / maxValue));
    line(x1, y1, x2, y2);
  }
  fill(255, 204, 0);
  textSize(20);
  text(data[i-1], x2 + 20, y2 - 5);
  text(label, 1870,75);
  stroke(255);
  line(0,0,w,0);
  line(0,h,w,h);
  textSize(20);
  text(label,w+25,h/2);
  for(i = 0; i<=10; i++){
   line(((w/10)* i),0,((w/10)* i),h); 
   text(i -10,((w/10)* i),h+20);
  }
   popMatrix();
}
public void GRAPH2(float w, float h, int[] data,int[] data2, String label, int x,int  y, int maxValue){
  pushMatrix();
  translate(x,y);
  int i=0, x1=0, x2 = 0, y1=0, y2 = 0;
  int pointInterval = int(w / data.length);
  strokeWeight(2);
  stroke(255, 204, 0);
  for (i = 1; i < data.length; i++) {
    x1 =(i-1) * pointInterval;
    y1 = int(h - (data[i-1] *h / maxValue));
    x2 =i * pointInterval;
    y2 = int(h - (data[i] *h / maxValue));
    line(x1, y1, x2, y2);
  }
  for (i = 1; i < data2.length; i++) {
    x1 =(i-1) * pointInterval;
    y1 = int(h - (data2[i-1] *h / maxValue));
    x2 =i * pointInterval;
    y2 = int(h - (data2[i] *h / maxValue));
    line(x1, y1, x2, y2);
  }
  fill(255, 204, 0);
  textSize(20);
  text(data[i-1], x2 + 20, y2 - 5);
  text(label, 1870,75);
  stroke(255);
  line(0,0,w,0);
  line(0,2*h,w,2*h);
  textSize(20);
  text(label,w+25,2*h);
  for(i = 0; i<=10; i++){
   line((w/10* i),0,(w/10* i),2*h); 
   line(0,h,w,h);
   text(i -10,((w/10)* i)-10,h+20);
  }
  popMatrix();
}
public void BAR(float x, float y, int value, String label, int maxValue){
  pushMatrix();
  translate(x,y);
  float barHeight = map(value, 0, maxValue, 0, 100);
  noStroke();
  fill(255, 204, 0);
  rect(0 - 20, -barHeight, 40, barHeight);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(30);
  text(value, 0,10);
  textSize(20);
  text(label, 0,30);
  popMatrix();
}
public void G(int v1,int v2,int X,int Y){
  pushMatrix();
  translate(X,Y);
  noFill();
  stroke(255);
  ellipse(0,0,100,100);
  ellipse(0,0,75,75);
  ellipse(0,0,50,50);
  line(0,-50,0,50);
  line(-50,0,50,0);
  noStroke();
  fill(255, 204, 0);
  ellipse(v1,v2,10,10);
  fill(255);
  textSize(50);
  popMatrix();
}
public void RAWDATA(int X,int Y){
  pushMatrix();
  translate(X,Y);
  fill(255, 204, 0);
   textAlign(CENTER,CENTER);
   textSize(50);
    text("RAWDATA",0,0);
    fill(255);
    textSize(20);
    textAlign(LEFT);
    text("millis-",-170,50);
    text("Speed-",-170,70);
    text("RPM-",-170,100);
    text("Throttle-",-170,130);
    text("BATTERY-",-170,160);
    text("EngineTemp-",-170,190);
    text("Gear-",-170,220);
    text("BrakePressure-",-170,250);
    text("G in YDir-",-170,280);
    text("G in XDir-",-170,310);
    textAlign(LEFT);
    fill(255, 204, 0);
    text(values[0],-40,50);
    text(values[4],-40,70);
    text(values[1],-40,100);
    text(values[9],-40,130);
    text(values[6],-40,160);
    text(values[2],-40,190);
    text(values[3],-40,220);
    text(values[5],-40,250);
    text(values[16],-40,280);
    text(values[15],-40,310);
    popMatrix();
}
public void ONOFF(int x,int y,int value,String S){
pushMatrix();
translate(x,y);
if(value==0){
stroke(255);
fill(255,0,0);
ellipse(0,0,40,40);
fill(255);
textSize(20);
text(S,0,-1);
}
else{
stroke(0);
fill(255,0,0);
ellipse(0,0,40,40);
fill(255);
textSize(20);
text(S,0,-1);
}
popMatrix();
}
}

