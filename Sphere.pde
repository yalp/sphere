/**
 * Sphere
 */

float angle = 0.0;
float rSize;  // rectangle size
Vector vnew, axis;
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
  axis.normalize();
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
  
  angle += 0.005;
  if(angle > TWO_PI) {
    angle = 0.0;
  }
  
  translate(width/2, height/2);

  computeRotation();
  renderAxis();
  stroke(color(255, 255, 255));
  for (int i=0; i<N; i++) {
    renderTiles(points[i]);
  }
}

void computeRotation() {
  // Compute quaternion
  rotq.set (angle, axis);
  rotqc.conj(rotq);
}

void renderTiles(Vector p) {
  // Apply rotation
  vq.set(p);
  rotqf.mult(rotq, vq);
  vnew.mult(rotqf, rotqc);
  // Draw the rectangle at the end of the rotated vector
  pushMatrix();
  translate (vnew.x*100, vnew.y*100, vnew.z*100);
  rect(-rSize, -rSize, rSize*2, rSize*2);
  popMatrix();
}

void renderAxis() {
  // Draw the axis vector
  stroke(color(255, 0, 0));
  line (0, 0, 0, axis.x*100, axis.y*100, axis.z*100);
}
