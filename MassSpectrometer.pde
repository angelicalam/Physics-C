import Math.java;

float x = 10;
float y = 300;
float a = 1;   // acceleration of the particle 
float B = 1;   // magnitude and direction of B field
float E = 1;   // magnitude and direction of E field
float q = 1;   // magnitude and sign of charge
float r;       // radius of circular motion

public void setup()
{
  size(1000, 600);
}

public void draw()
{
  plate();
  ellipse(x,y,10,10);
  
  // constant acceleration in the x-direction
  // for a uniform electric field
  if (x < 420)
    x = x + (.5)(a)(.001);   // t^2 = (.001) change after checking frames per second
    
  // circular motion in a uniform magnetic field
  float radian;
  if (x >= 420 && B != 0) {
    if (B > 0)      // B field is out of the page
      rad = ;
    else if (B < 0) // B field is into the page
      rad = ;
    x = 420 + (r * Math.cos(radian));
    y = 300 + (r * Math.cos(radian));
  }
}

public void plate()
{
  background(0);
  rect(400,0,20,280);
  rect(400,320,20,280);
}
