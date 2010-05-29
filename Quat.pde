class Vector {
  float x, y, z;

  Vector() {}

  Vector(float ax, float ay, float az) {
    x = ax; y = ay; z = az;
  }

  void set (Vector v) {
    x = v.x; y = v.y; z = v.z;
  }

  void mult(Quaternion q1, Quaternion q2) {
    x = (q1.a*q2.b +q1.b*q2.a +q1.c*q2.d -q1.d*q2.c);
    y = (q1.a*q2.c -q1.b*q2.d +q1.c*q2.a +q1.d*q2.b);
    z = (q1.a*q2.d +q1.b*q2.c -q1.c*q2.b +q1.d*q2.a);
  }

  float dot(Vector v) {
    return x*v.x + y*v.y + z*v.z;
  }

  float length() {
    return sqrt(x*x + y*y + z*z);
  }

  float dist(Vector v) {
    return sqrt(pow(v.x-x, 2) + pow(v.y-y, 2) + pow(v.z-z, 2));
  }

  void normalize() {
    float n = length();
    if (n != 0) {
      x /= n; y /= n; z /= n;
    }
  }

  void normalizedRandom() {
    x = random(2);
    y = random(2);
    z = random(2);
    normalize();
  }

  void reset() {
    x = y = z = 0;
  }
}

class Quaternion {
  float a, b, c, d;

  Quaternion() {}

  Quaternion(Vector v) {
    set(v);
  }

  void set(float angle, Vector v) {
    float sinCoef = sin(angle/2.0);
    a = cos(angle/2.0);
    b = sinCoef* v.x;
    c = sinCoef* v.y;
    d = sinCoef* v.z;
  }

  void set(Vector v) {
    a = 0; b = v.x; c = v.y; d = v.z;
  }

  void mult(Quaternion q1, Quaternion q2) {
    a = (q1.a*q2.a -q1.b*q2.b -q1.c*q2.c -q1.d*q2.d);
    b = (q1.a*q2.b +q1.b*q2.a +q1.c*q2.d -q1.d*q2.c);
    c = (q1.a*q2.c -q1.b*q2.d +q1.c*q2.a +q1.d*q2.b);
    d = (q1.a*q2.d +q1.b*q2.c -q1.c*q2.b +q1.d*q2.a);
  }

  void conj(Quaternion q1) {
    a =  q1.a;
    b = -q1.b;
    c = -q1.c;
    d = -q1.d;
  }
}

