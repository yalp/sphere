/**
 * Sphere, points distribution based on
 * http://www.math.niu.edu/~rusin/known-math/97/spherefaq
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
  int N = 80;
  float lastRY = 0;
  for (int k = 1; k <= N; k++) {
    float h = -1 + 2*(k-1)/(float)(N-1);
    float rX = acos(h);
    float rY;
    if (k==1 || k==N) rY = 0;
    else rY = (lastRY + 3.6 / sqrt ( N * (1 - h*h))) % TWO_PI;
    lastRY = rY;
    rX += rotX;
    rY += rotX; // second rotation -> gimbal lock ! :-(
    pushMatrix();
    rotateX(rX);
    rotateY(rY);
    translate(0, 0, 100);
    rotateY(-rY);
    rotateX(-rX);
    if (k==1) fill(color(255, 0, 0));
    else fill(color(128, 128, 128));
    rect(-rSize, -rSize, rSize*2, rSize*2);
    popMatrix();
  }
}
