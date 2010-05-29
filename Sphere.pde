/**
 * Sphere
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
 
  // Define rotation : angle and axis
  float angle = rotX;
  float x = 1, y = 0, z = 1;
  // Declare original vector
  float v1 = 0, v2 = 100, v3 = 0;
  // Normalize the axis vector
  float n = sqrt(x*x+y*y+z*z);
  x /= n; y /= n; z /= n;

  // Compute quaternion
  float sinCoef = sin(angle/2.0);
  float a = cos(angle/2.0);
  float b = sinCoef*x;
  float c = sinCoef*y;
  float d = sinCoef*z;
  
  // Compute rotated vector
  // Taken from Wikipedia article : Quaternions and spacial rotation
  float t2 =   a*b;
  float t3 =   a*c;
  float t4 =   a*d;
  float t5 =  -b*b;
  float t6 =   b*c;
  float t7 =   b*d;
  float t8 =  -c*c;
  float t9 =   c*d;
  float t10 = -d*d;
  float v1new = 2*( (t8 + t10)*v1 + (t6 -  t4)*v2 + (t3 + t7)*v3 ) + v1;
  float v2new = 2*( (t4 +  t6)*v1 + (t5 + t10)*v2 + (t9 - t2)*v3 ) + v2;
  float v3new = 2*( (t7 -  t3)*v1 + (t2 +  t9)*v2 + (t5 + t8)*v3 ) + v3;
  
  // Draw the axis vector
  stroke(color(255, 0, 0));
  line (0, 0, 0, x*100, y*100, z*100);
  // Draw the original vector and the rotated vector
  stroke(color(255, 255, 255));
  line (0, 0, 0, v1, v2, v3);
  line (0, 0, 0, v1new, v2new, v3new);
  // Draw the rectangle at the end of the original vector
  pushMatrix();
  translate (v1, v2, v3);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
  // Draw the rectangle at the end of the rotated vector
  pushMatrix();
  translate (v1new, v2new, v3new);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
}
