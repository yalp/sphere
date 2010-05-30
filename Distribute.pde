/*
 * Points distribution on a sphere
 * Ported from http://www.math.niu.edu/~rusin/known-math/96/repulsion
 * Original author: Vladimir Bulatov <V.Bulatov@ic.ac.uk>
 *
 * It uses a brute force techinic to find the best match... kind of expensive.
 * I like the fact that inserting a new point will just make the overs points
 * move slitely to make some place for the new point.
 */

float length(Vector v1, Vector v2) {
    return sqrt(pow(v2.x-v1.x, 2) + pow(v2.y-v1.y, 2) + pow(v2.z-v1.z, 2));
}

double get_coulomb_energy(int N, Vector[] l) {
  double e = 0;
  for(int i = 0;i<N;i++) {
    for(int j = i+1; j<N; j++ ) {
      e += 1 / length(l[i], l[j]);
    }
  }
  return e;
}


void get_forces(int N, Vector[] f, Vector[] p)
{
  int i,j;
  for(i = 0; i<N; i++) {
    f[i].reset();
  }
  double ff;
  for(i = 0; i<N; i++) {
    for(j = i+1; j<N; j++) {
      float rx = p[i].x-p[j].x;
      float ry = p[i].y-p[j].y;
      float rz = p[i].z-p[j].z;
      double l = 1 / pow(sqrt(rx*rx + ry*ry + rz*rz), 3);
      ff = l*rx; f[i].x += ff; f[j].x -= ff;
      ff = l*ry; f[i].y += ff; f[j].y -= ff;
      ff = l*rz; f[i].z += ff; f[j].z -= ff;
    }
  }
}

void distribute(int N, Vector[] p0) {
  int Nstep = 1000;
  float step = 0.001;
  double minimal_step = 1e-10;
  Vector[] p1 = new Vector[N];
  Vector[] f = new Vector[N];
  Vector[] pp0 = p0, pp1 = p1;
  int i, k;

  for (i=0; i<N; i++) {
    p1[i] = new Vector();
    f[i] = new Vector();
  }

  double e0 = get_coulomb_energy(N,p0);
  for (k = 0; k<Nstep; k++) {
    get_forces(N,f,p0);
    for(i=0; i < N;i++) {
      double d = f[i].dot(pp0[i]);
      f[i].x  -= pp0[i].x*d;
      f[i].y  -= pp0[i].y*d;
      f[i].z  -= pp0[i].z*d;
      pp1[i].x = pp0[i].x+f[i].x*step;
      pp1[i].y = pp0[i].y+f[i].y*step;
      pp1[i].z = pp0[i].z+f[i].z*step;
      pp1[i].normalize();
    }
    double e = get_coulomb_energy(N,pp1);
    if (e >= e0) {  // not successfull step
      step /= 2;
      if (step < minimal_step)
	break;
      continue;
    } else {   // successfull step
      Vector[] t = pp0; pp0 = pp1; pp1 = t;
      e0 = e;
      step*=2;
    }
  }
}
