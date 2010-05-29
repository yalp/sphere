/**
 * Sphere
 *
 */
 
float rotX = 0.0;
float rSize;  // rectangle size

void setup() {
  size(640, 360, P3D);
  rSize = width / 48;  
  noStroke();
  fill(204, 204);
}

void draw() {
  background(0);
  
  rotX += 0.005;
  if(rotX > TWO_PI) { 
    rotX = 0.0; 
  }
  
  translate(width/2, height/2);
  for (int j=0; j<10; j++) {
    float rY = j * TWO_PI/10;
    for (int i=0; i<10; i++) {
      float rX = rotX + i * TWO_PI/10;
      pushMatrix();
      rotateX(rX);
      rotateY(rY);
      translate(0, 0, 100);
      rotateY(-rY);
      rotateX(-rX);
      
      rect(-rSize, -rSize, rSize*2, rSize*2);
      popMatrix(); 
    }
  }
}
