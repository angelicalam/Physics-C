// may have to change to floats if using Processing's cos(), sin(), etc.
// otherwise import java.lang.Math (sorry, wrong import statement before)
double x;
double y;
double a;   // acceleration of the particle 
double B;   // magnitude and direction of B field
double E;   // magnitude of E field
double q;   // magnitude and sign of charge
double r;   // radius of circular motion
double m;   // mass of the particle

final static double maxE = 10;  // maximum magnitude of E field
final static double maxB = .1;  // maximum magnitude of B field

boolean isRunning = false;  //particle only moves if isRunning

public void setup()
{
  size(1000, 1000);
  E = 0;
  B = 0;
  q = 1;
}

double v;       // for proportional incrementation of radian
double radian;  // for circular motion
double t = 0;   // time counter for E field
double t2 = 0;  // time counter for B field

public void draw()
{
  resetButton();
  plate();
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
    if (x < 420 && E!= 0)
      // acceleration is x1000 smaller since 1000 = 1 meter
      // slows down the animation
      // t/frameRate aligns draw() with real time
      // 10 is initial x-position of particle
      a = (E*q/m);
      x = 10 + (.5)(a)(t/frameRate)(t/frameRate);
      t++;
    
    // circular motion in a uniform magnetic field
    if (x >= 420 && B != 0)
    {
      // 0.4 is separation between the E field plates
      // 1000 scales r from meters to program's dimensions
      r = sqrt( (2*E*0.4*m)/(B*B*q) * 1000);
      // velocity is x1000 smaller to slow down animation
      v = sqrt( 2*E*q*0.4 / m );
      // B field is out of the page
      // Center of circular motion is (420, 300 + r)
      // radians decrease linearly with time
      if (B > 0)
      {
        radian = radian - (v/r)(t2/frameRate);
        y = (300 + r) - (r * sin(radian));
      }
      // B field is into the page
      // Center of circular motion is (420, 300 - r)
      // radians increase linearly with time
      else
      {
        radian = radian + (v/r)(t2/frameRate);
        y = (300 - r) + (r * sin(radian));
      }
      x = 420 + (r * cos(radian));
      t2++;
    }
    
    // constant velocity if there is no magnetic field
    else
    {
      v = sqrt( 2*E*q*0.4 / m );
      x = x + v(1/frameRate);
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
    radian = PI/2;
  else
    radian = (-1)PI/2;
}

// draws plate separating the electric field and magnetic field
public void plate()
{
  background(0);
  rect(400,0,20,280);
  rect(400,320,20,280);
}

// draws E field    delete this part of the comment later: make lines light grey, white clashes with the particle color
public void displayEField()
{
}

// draws B field    delete this part of the comment later: same as above, make markings grey
public void displayBField()
{
}

// changes value of E and B
public void mouseDragged()
{
  // can't allow E to affect r and v when particle is in B field, so x < 400
  if (mouseX > 805 && mouseX < 975 && mouseY > 140 && mouseY < 170 && x < 400)
  {
    if (mouseX > pmouseX && E < maxE)
      E = E + 0.1;  // change increment later
    else if (mouseX < pmouseX && E > 0)
      E = E - 0.1;
  }
  else if (mouseX > 805 && mouseX < 975 && mouseY > 350 && mouseY < 380)
  {
    if (mouseX > pmouseX && B < maxB)
      B = B + 0.01;  // change increment later
    else if (mouseX < pmouseX && B > (-1)maxB)
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
  // draw slider strip
  fill(255);
  rect(820,155,140,5);
  // draw slider knob, its x-position varies linearly with E
  ellipse( (820 + 140(E/maxE)) ,155,15,15);
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
  // draw slider strip
  fill(255);
  rect(820,365,140,5);
  // draw slider knob, its x-position varies linearly with B
  ellipse( (890 + 70(B/maxB)) ,365,15,15);
  // display B field value
  text("Magnetic field: " + String.format("%.2f",B) + " T", 820,260);
}


