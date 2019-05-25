import java.lang.Math;

double x;
double y;
double a;   // acceleration of the particle 
double B;   // magnitude and direction of B field
double E;   // magnitude of E field
double q;   // magnitude and sign of charge
double r;   // radius of circular motion
double m;   // mass of the particle

final static double maxE = 10;  // maximum magnitude of E field
final static double maxB = 1;   // maximum magnitude of B field

boolean isRunning = false;  //particle only moves if isRunning

public void setup()
{
  size(1000, 800);
  E = 0;
  B = 0;
  q = 1;
  m = .001; // may remove later
}

double v;       // for proportional incrementation of radian
double radian;  // for circular motion
double t = 0;   // time counter for E field
double t2 = 0;  // time counter for B field

public void draw()
{
  plate();
  resetButton();
  displayEField();
  displayBField();
  displayESlider();
  displayBSlider();
  
  fill(255);
  ellipse( (float)x, (float)y, 10,10);
 
  if (isRunning)
  {
    // constant acceleration in the x-direction
    // for a uniform electric field
    // no movement for E field = 0
    if (x < 420 && y == 300 && E!= 0)
    {
      // acceleration is x1000 smaller since 1000 = 1 meter
      // slows down the animation
      // t/frameRate aligns draw() with real time
      // 10 is initial x-position of particle
      a = E*q/m;
      x = 10 + .5*(a)*(t/frameRate)*(t/frameRate);
      t++;
      // smooths transition from E field to B field
      if (x > 420)
        x = 420;
    }
    
    // circular motion in a uniform magnetic field
    else if (x >= 420 && B != 0)
    {
      // 0.4 is separation between the E field plates
      // 1000 scales r from meters to program's dimensions
      r = Math.sqrt( (2*E*.4*m)/(B*B*q) * 1000);
      // velocity is x100 smaller to slow down animation
      v = Math.sqrt( 2*E*q*.4 / m ) * 10;
      // B field is out of the page
      // Center of circular motion is (420, 300 + r)
      // radians decrease linearly with time
      if (B > 0)
      {
        radian = radian - (v/r)*(t2/frameRate);
        y = (300 + r) - (r * Math.sin(radian));
      }
      // B field is into the page
      // Center of circular motion is (420, 300 - r)
      // radians increase linearly with time
      else
      {
        radian = radian + (v/r)*(t2/frameRate);
        y = (300 - r) + (r * Math.sin(radian));
      }
      x = 420 + (r * Math.cos(radian));
      t2++;
      // stops particle from passing through the plate
      if (x < 420)
        x = 419;
    }
    
    // constant velocity if there is no magnetic field
    else if (B == 0 && x >= 420)
    {
      // velocity is x50 smaller
      v = Math.sqrt( 2*E*q*0.4 / m ) * 20;
      x = x + (v)*(1/frameRate);
    }
    
    // display distance along plate traveled by particle
    else
    {
      line(385,300,395,300);
      line(390,300,390,(float)y);
      line(385,(float)y,395,(float)y);
      text(String.format("%.2f", 2*(r/1000)) + " m", 350,(float)(y/2));
    }   
  }
  
  else
  {
    reset();
  }
}

// sets isRunning when the reset button is pressed
public void mousePressed()
{
  if (mouseX > 875 && mouseX < 925 && mouseY > 675 && mouseY < 725) // change if neccessary
    isRunning = !isRunning;
}

// draws reset button
public void resetButton()
{
  text("Press to START.", 875,600);
  text("Press again to RESET.", 875,640);
  if (isRunning)
    fill(255,0,0);  // button is red when the simulation is running
  else
    fill(0,255,0);  // button is green when the simulation is resting
  rect(875,675,50,50);
}

// resets simulation
public void reset()
{
  x = 10;
  y = 300;
  t = 0;
  t2 = 0;
  if (B > 0)
    radian = Math.PI/2;
  else
    radian = (-1)*Math.PI/2;
}

// draws plate separating the electric field and magnetic field
public void plate()
{
  background(0);
  fill(255);
  rect(400,0,20,280);
  rect(400,320,20,280);
}

// draws E field    delete this part of the comment later: make lines light grey, white clashes with the particle color
public void displayEField()
{
  stroke(200);
  for(int n = 100; n < 1000; n += 100)
    line(0,n,400,n);
}

// draws B field    delete this part of the comment later: same as above, make markings grey
public void displayBField()
{
  stroke(200);
  for(int r = 100; r < 1000; r += 100) {
    for(int c = 470; c < 800; c += 100) {
      fill(200);
      if (B > 0)
      {
        ellipse(c,r,10,10);
        fill(0);
        ellipse(c,r,15,15);
      }
      else if (B < 0)
      {
        line(c-10, r+10, c+10, r-10);
        line(c-10, r-10, c+10, r+10);
      }
    }
  }
}

// changes value of E and B
double delta;
public void mouseDragged()
{
  // can't allow E to affect r and v when particle is in B field, so x < 400
  if (mouseX > 805 && mouseX < 975 && mouseY > 140 && mouseY < 170 && x < 400)
  {
    if (mouseX > pmouseX && E < maxE)
      E = E + 0.05;
    else if (mouseX < pmouseX && E > 0)
      E = E - 0.05;
  }
  else if (mouseX > 805 && mouseX < 975 && mouseY > 350 && mouseY < 380)
  {
    if (mouseX > pmouseX && B < maxB)
      B = B + 0.01;
    else if (mouseX < pmouseX && B > (-1)*maxB)
      B = B - 0.01;
  }
}

// draws slider for E field magnitude
public void displayESlider()
{
  // draw border
  stroke(255);
  fill(0);
  rect(800,20,180,200);
  // draw slider bar
  fill(255);
  rect(820,155,140,3);
  // draw slider knob, its x-position varies linearly with E
  ellipse( (float)(820 + 140*(E/maxE)) ,155,15,15);
  // display E field value
  text( "Electric field: " + String.format("%.2f",E) + " N/C", 820,50);
}

// draws slider for B field magnitude and direction
// for positive values of B, the B field is directed out of the page
// for negative values of B, the B field is directed into the page
public void displayBSlider()
{
  // draw border
  stroke(255);
  fill(0);
  rect(800,230,180,200);
  // draw slider bar
  fill(255);
  rect(820,365,140,3);
  // draw slider knob, its x-position varies linearly with B
  ellipse( (float)(890 + 70*(B/maxB)) ,365,15,15);
  // display B field value
  text("Magnetic field: " + String.format("%.2f",B) + " T", 820,260);
}

/*
Ignore for now
--------------
2d array: A-Z and masses
getCode()
getMass()
*/
