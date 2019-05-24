import Math.java;

double x = 10;
double y = 300;
double a = 1;   // acceleration of the particle 
double B = 1;   // magnitude and direction of B field
double E = 1;   // magnitude and direction of E field
double q = 1;   // magnitude and sign of charge
double r;       // radius of circular motion
double m;      // mass of the particle

public void setup()
{
  size(1000, 600);
}

public void draw()
{
  plate();
  ellipse( (float)x, (float)y, 10,10);
  
  // constant acceleration in the x-direction
  // for a uniform electric field
  // no movement for E field = 0
  if (x < 420 && E!= 0)
    x = x + (.5)(a)(.001);   // t^2 = (.001) change after checking frames per second
    
  // circular motion in a uniform magnetic field
  r = getRadius();
  double radian;
  if (x >= 420 && B != 0) {
    if (B > 0)      // B field is out of the page
      radian = ;
    else if (B < 0) // B field is into the page
      radian = ;
    x = 420 + (r * Math.cos(radian));
    y = 300 + (r * Math.cos(radian));
  }
  
  // constant velocity if there is no magnetic field
  else {
    x = x + ;
  }
}

// draws plate separating the electric field and magnetic field
public void plate()
{
  background(0);
  rect(400,0,20,280);
  rect(400,320,20,280);
}

// calculates radius of circular motion in the magnetic field
public double getRadius()
{
  // 0.4 is the distance across which the E field acts on the particle
  r = Math.sqrt( (2*E*0.4*m)/(B*B*q) );
  return r;
}
