// Starting rotation of the box
float boxRotationX = -0.4;
float boxRotationY = 1.25;
float boxRotationZ = 0.0;

boolean sphereVisible = true;

void setup() {
  size(640, 360, P3D);
  background(0);
  lights();
}

void draw() {

  clear();
  background(100);

  // Check box for making sphere visible
  pushMatrix();
  translate( 500, 100, 0);
  textSize(12);
  fill(255);
  textAlign(LEFT, TOP);
  text("Spheres Visible", 30, 0);
  stroke(125);
  fill(#FFEF00);
  rect(0, 0, 20, 20);
  if ( sphereVisible ) {
    stroke(0);
    line(0, 0, 20, 20);
    line(0, 20, 20, 0);
  }
  popMatrix();

  // display box that can be rotated using keyboard options
  pushMatrix();
  translate(130, height/2, 0);
  rotateY(boxRotationY);
  rotateX(boxRotationX);
  rotateZ(boxRotationZ);
  stroke(0);
  fill(#90EEF1);
  box(100);
  popMatrix();
  
  // If box is checked, then spheres are visible
  if ( sphereVisible ) {
    // Light the bottom of the sphere
    directionalLight(51, 102, 126, 1, 1, 0);

    // Orange light on the upper-right of the sphere
    spotLight(204, 153, 0, 360, 160, 600, 0, 0, -1, PI/2, 2000); 

    // Moving spotlight that follows the mouse
    spotLight(102, 153, 204, 360, mouseY, 600, 0, 0, -1, PI/2, 600); 

    // display wiremesh sphere
    pushMatrix();
    translate(width/2, height/2, 0);
    stroke(0);
    fill(#90EEF1);
    sphere(90);
    
    // display solid sphere (relative to mesh)
    pushMatrix();
    translate(70,70,70);
    noStroke();
    fill(#FF0080);
    sphere(20);
    popMatrix();
    
    popMatrix();
  }
}

void mousePressed() {  
  // check for mouse press inside of checkbox
  if ( mouseX >= 500 && mouseX <= 520 ) {
    if ( mouseY >= 100 && mouseY <= 120 ) {
      if ( sphereVisible ) {
        sphereVisible = false;
      } else {
        sphereVisible = true;
      }
    }
  }
}

void keyPressed() {
  // key presses control box rotation
  
  // nothing so far when spacebar pressed
  if (key == ' ') {
  } 

  // use different keys for rotation about the 3 axes
  if (key == ',') {
    boxRotationZ = boxRotationZ - .1;
  } 
  if (key == '.') {
    boxRotationZ = boxRotationZ + .1;
  }
  if (key == CODED && keyCode == LEFT) {
    boxRotationY = boxRotationY - .1;
  }
  if (key == CODED && keyCode == RIGHT) {
    boxRotationY = boxRotationY + .1;
  }
  if (key == CODED && keyCode == UP) {
    boxRotationX = boxRotationX + .1;
  }
  if (key == CODED && keyCode == DOWN) {
    boxRotationX = boxRotationX - .1;
  }
}