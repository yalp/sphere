/**
 * Sphere
 */

float angle = 0.0;
float rSize;  // rectangle size
Vector vnew, axis, mouse;
Quaternion vq, rotq, rotqc, rotqf;
Vector[] points;
int N = 40;

void setup() {
  size(640, 360, P3D);
  rSize = width / 48;  
  noStroke();
  fill(204, 204);
  // Quaternion & vectors needed for rotation
  axis = new Vector (1, -1, 1);
  mouse = new Vector ();
  vq = new Quaternion ();
  rotq = new Quaternion();
  rotqc = new Quaternion();
  rotqf = new Quaternion();
  vnew = new Vector();
  // Points randomly places then evenly distributed
  points = new Vector[N];
  for(int i=0; i<N; i++) {
    points[i] = new Vector();
    points[i].normalizedRandom();
  }
  distribute (points);
}

void draw() {
  background(0);
  
  // Get mouse coords as a vector
  mouse.x = mouseX-width/2;
  mouse.y = mouseY-height/2;
  mouse.z =0;
  float l = mouse.length() / (max(width, height)/2);
  if (l > 0) {
    angle = l / 25.0;
    axis.x = -mouse.y;
    axis.y = mouse.x;
    axis.z = mouse.z;
    axis.normalize();
    computeRotation();
  }
  
  translate(width/2, height/2);
  renderAxis();
  stroke(color(255, 255, 255));
  for (int i=0; i<N; i++) {
    fill(color(128,(i*256)/N, 128));
    renderTiles(points[i]);
  }
}

void computeRotation() {
  // Compute quaternion
  rotq.set (-angle, axis);
  rotqc.conj(rotq);
}

void renderTiles(Vector p) {
  // Apply rotation
  vq.set(p);
  rotqf.mult(rotq, vq);
  p.mult(rotqf, rotqc);
  // Draw the rectangle at the end of the rotated vector
  pushMatrix();
  translate (p.x*100, p.y*100, p.z*100);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
}

void renderAxis() {
   // Draw the mouse vector
  stroke(color(0, 0, 255));
  line (0, 0, 0, mouse.x, mouse.y, mouse.z);
  // Draw the axis vector
  stroke(color(255, 0, 0));
  line (0, 0, 0, axis.x*100, axis.y*100, axis.z*100);
}
