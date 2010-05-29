/**
 * Sphere
 */

float angle = 0.0;
float rSize;  // rectangle size
Vector v, vnew, axis;
Quaternion vq, rotq, rotqc, rotqf;

void setup() {
  size(640, 360, P3D);
  rSize = width / 48;  
  noStroke();
  fill(204, 204);
  axis = new Vector (1, 0, 1);
  axis.normalize();
  v = new Vector (0, 100, 0);
  vq = new Quaternion (v);
  rotq = new Quaternion();
  rotqc = new Quaternion();
  rotqf = new Quaternion();
  vnew = new Vector();
}

void draw() {
  background(0);
  
  angle += 0.005;
  if(angle > TWO_PI) {
    angle = 0.0;
  }
  
  translate(width/2, height/2);
 
  compute();
  render();
}

void compute() {
  // Compute quaternion
  rotq.set (angle, axis);
  rotqc.conj(rotq);
  rotqf.mult(rotq, vq);
  vnew.mult(rotqf, rotqc);
}

void render () {
  // Draw the axis vector
  stroke(color(255, 0, 0));
  line (0, 0, 0, axis.x*100, axis.y*100, axis.z*100);
  // Draw the original vector and the rotated vector
  stroke(color(255, 255, 255));
  line (0, 0, 0, v.x, v.y, v.z);
  line (0, 0, 0, vnew.x, vnew.y, vnew.z);
  // Draw the rectangle at the end of the original vector
  pushMatrix();
  translate (v.x, v.y, v.z);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
  // Draw the rectangle at the end of the rotated vector
  pushMatrix();
  translate (vnew.x, vnew.y, vnew.z);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
}
