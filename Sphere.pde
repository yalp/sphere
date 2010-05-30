/**
 * Sphere
 */

float angle = 0.0;
float rSize;  // rectangle size
float sRadius;  // sphere radius
Vector vnew, axis, mouse;
Quaternion vq, rotq, rotqc, rotqf;
Vector[] points, pointsNew;
int N = 40;
int transitionPos = 0;
int transitionMax = 200;

void setup() {
  size(640, 360, P3D);
  sRadius = min(width, height) / 4;
  rSize = width / 48;
  noStroke();
  fill(204, 204);
  // Quaternion & vectors needed for rotation
  axis = new Vector();
  mouse = new Vector ();
  vq = new Quaternion ();
  rotq = new Quaternion();
  rotqc = new Quaternion();
  rotqf = new Quaternion();
  vnew = new Vector();
  // Points randomly places then evenly distributed
  points = new Vector[N];
  pointsNew = new Vector[N];
  for(int i=0; i<N; i++) {
    points[i] = new Vector();
    points[i].normalizedRandom();
    pointsNew[i] = new Vector();
  }
  updatePoints();
}

void draw() {
  background(0);
  
  // Get mouse coords as a vector
  mouse.x = mouseX-width/2;
  mouse.y = mouseY-height/2;
  mouse.z =0;
  float l = mouse.length() / (2*sRadius);
  if (l > 0.5) {
    l = 1 - l;
  }
  if (l > 0.1) {
    l -= 0.1;
    angle = l / 10.0;
    axis.x = -mouse.y;
    axis.y = mouse.x;
    axis.z = mouse.z;
    axis.normalize();
    computeRotation();
  } else {
    angle = 0;
  }
  
  translate(width/2, height/2);
  renderAxis();
  renderTiles();
}

void computeRotation() {
  // Compute quaternion
  rotq.set (-angle, axis);
  rotqc.conj(rotq);
}

void renderTiles() {
  Vector p;
  stroke(color(255, 255, 255));
  color from = color(255, 128, 0);
  color to = color(0, 128, 255);
  for (int i=0; i<N; i++) {
    p = points[i];
    // Apply rotation to the point if any
    if (angle != 0) {
      vq.set(p);
      rotqf.mult(rotq, vq);
      p.mult(rotqf, rotqc);
    }
    if (transitionPos < transitionMax) {
      Vector pn = pointsNew[i];
      // We need to also rotate the new points on transition :(
      if (angle != 0) {
        vq.set(pn);
        rotqf.mult(rotq, vq);
        pn.mult(rotqf, rotqc);
      }
      // Interpolate the current point up to its new position
      p.lerpVector(pn, transitionPos / (float)transitionMax);
    }
    // Draw the rectangle at the end of the rotated vector
    fill(lerpColor(from, to, i/(float)N));
    pushMatrix();
    translate (p.x*sRadius, p.y*sRadius, p.z*sRadius);
    rect(-rSize, -rSize, rSize*2, rSize*2);
    popMatrix();
  }
  // Advance transition
  if (transitionPos < transitionMax) {
    transitionPos++;
  } else if (transitionPos == transitionMax) {
    // On end of transition, swap the position buffers
    Vector[] tmp = points;
    points = pointsNew;
    pointsNew = tmp;
    transitionPos++;
  }
}

void renderAxis() {
   // Draw the mouse vector
  stroke(color(0, 0, 255));
  line (0, 0, 0, mouse.x, mouse.y, mouse.z);
  // Draw the axis vector
  stroke(color(255, 0, 0));
  line (0, 0, 0, axis.x*sRadius, axis.y*sRadius, axis.z*sRadius);
}

void mouseClicked() {
  if (mouseButton == LEFT) {
    if (N < points.length) {
      N++;
      updatePoints();
    }
  } else if (mouseButton == RIGHT) {
    if (N > 0) {
      N--;
      updatePoints();
    }
  }
}

void updatePoints() {
  // Copy current positions
  for (int i=0; i<N; i++) {
    pointsNew[i].set(points[i]);
  }
  // Compute new postions
  distribute(N, pointsNew);
  // Start transition
  transitionPos = 0;
}
