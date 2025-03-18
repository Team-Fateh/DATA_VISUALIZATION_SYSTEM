PImage steeringWheel;  // Declare PImage variable for the steering wheel
float rotationAngle = 0;  // Initialize rotation angle

void setup() {
  size(600, 400);
  steeringWheel = loadImage("Steer.png");  // Replace with your steering wheel image path
}
void draw() {
  background(255);
  float targetAngle = random(-PI,PI);;  // Map mouseX to an angle range from -PI to PI
  
  // Calculate the rotation increment to smoothly rotate the steering wheel
  float deltaAngle = targetAngle - rotationAngle;
  if (abs(deltaAngle) > 0.01) {
    rotationAngle += deltaAngle * 0.1;  // Adjust 0.1 for rotation speed/smoothness
  }
  
  // Translate to the center of the canvas
  translate(width / 2, height / 2);
  
  // Apply rotation around the center of the image
  rotate(rotationAngle);
  
  // Draw the image centered at (0, 0)
  imageMode(CENTER);
  image(steeringWheel, 0, 0);
}
