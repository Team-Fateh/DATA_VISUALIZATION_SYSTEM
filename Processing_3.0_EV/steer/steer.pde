float angle = -PI;   // Initial angle
float angleSpeed = 0.02;  // Speed of angle change
boolean clockwise = true; // Direction of rotation
float startAngle = -PI; // Starting angle of the arc
float endAngle = -PI;   // Ending angle of the arc
PGraphics arcLayer; // Layer to draw the arc

void setup() {
  size(800, 800);
  arcLayer = createGraphics(width, height);
  arcLayer.beginDraw();
  arcLayer.background(255, 255, 255, 0);
  arcLayer.endDraw();
}

void draw() {
  background(255);

  // Update the angle based on the direction
  if (clockwise) {
    angle += angleSpeed;
    if (angle >= 0) {
      angle = 0;
    }
  } else {
    angle -= angleSpeed;
    if (angle <= -PI) {
      angle = -PI;
    }
  }

  // Calculate ellipse position
  float x = width / 2 + cos(angle) * 200;
  float y = height / 2 + sin(angle) * 200;

  // Draw the ellipse
  fill(0);
  ellipse(x, y, 20, 20);

  // Update arc start and end angles based on direction change
  if (clockwise) {
    if (!clockwise) {
      startAngle = angle;
      endAngle = angle;
    }
    startAngle = min(startAngle, angle);
  } else {
    if (!clockwise) {
      endAngle = max(endAngle, angle);
    }
  }

  // Draw the arc based on the current direction
  arcLayer.beginDraw();
  arcLayer.clear();
  arcLayer.stroke(0, 0, 255);
  arcLayer.strokeWeight(2);
  arcLayer.noFill();

  if (clockwise) {
    arcLayer.arc(width / 2, height / 2, 400, 400, startAngle, angle);
  } else {
    arcLayer.arc(width / 2, height / 2, 400, 400, angle, endAngle);
  }

  arcLayer.endDraw();
  image(arcLayer, 0, 0);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    if (!clockwise) {
      startAngle = angle; // Start from current position when switching to clockwise
    }
    clockwise = true;
  } else if (key == 'l' || key == 'L') {
    if (clockwise) {
      endAngle = angle; // Start from current position when switching to counterclockwise
    }
    clockwise = false;
  }
}
