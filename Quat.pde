class Vector {
  float x, y, z;

  Vector () {}

  Vector(float ax, float ay, float az) {
    x = ax; y = ay; z = az;
  }

  void mult(Quaternion q1, Quaternion q2) {
    x = (q1.a*q2.b +q1.b*q2.a +q1.c*q2.d -q1.d*q2.c);
    y = (q1.a*q2.c -q1.b*q2.d +q1.c*q2.a +q1.d*q2.b);
    z = (q1.a*q2.d +q1.b*q2.c -q1.c*q2.b +q1.d*q2.a);
  }

  void normalize () {
    float n = sqrt(x*x+y*y+z*z);
    x /= n; y /= n; z /= n;
  }
}

class Quaternion {
  float a, b, c, d;

  Quaternion () {}

  Quaternion (Vector v) {
    a = 0; b = v.x; c = v.y; d = v.z;
  }

  void set (float angle, Vector v) {
    float sinCoef = sin(angle/2.0);
    a = cos(angle/2.0);
    b = sinCoef* v.x;
    c = sinCoef* v.y;
    d = sinCoef* v.z;
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

