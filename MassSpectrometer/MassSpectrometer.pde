

float x = 10;
float y = 300;
float a = 5;   // acceleration of the particle 
float B = 1;   // magnitude and direction of B field
float E = 1;   // magnitude and direction of E field
float q = 1;   // magnitude and sign of charge
float r = 10;       // radius of circular motion
float radian = 0;
float z = map(millis()%10000,0,10000,0,TWO_PI);


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
    x = x + (.5*a);   // t^2 = (.001) change after checking frames per second
  if (x>=420 && B!=0 && radian<=3.1415926){   
  // circular motion in a uniform magnetic field
    radian = radian + 3.1415926/12;
    x = x + (r * cos(radian));
    y = y + (r * sin(radian));
  }
}

public void plate()
{
  background(0);
  rect(400,0,20,280);
  rect(400,320,20,280);
}
