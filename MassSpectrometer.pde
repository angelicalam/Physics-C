import Math.java;

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
  size(1000, 600);
}

double radian;  // for circular motion
double t = 0;   // time counter for accelerating particle

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
    a = (E*q/m);
    if (x < 420 && E!= 0)
      x = x + (.5)(a)(t/frameRate);
      t++;
    
    // circular motion in a uniform magnetic field
    r = Math.sqrt( (2*E*0.4*m)/(B*B*q) );
    if (x >= 420 && B != 0)
    {
      if (B > 0)      // B field is out of the page
        radian = ;
      else if (B < 0) // B field is into the page
        radian = ;
      x = 420 + (r * Math.cos(radian));
      y = 300 + (r * Math.cos(radian));
    }
  
    // constant velocity if there is no magnetic field
    else 
    {
      x = x + ;
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
  a = 1;
  B = 1;
  E = 1;
  q = 1;
  radian = 0;
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
  if (mouseX > 805 && mouseX < 975 && mouseY > 140 && mouseY < 170)
    E = E + 0.1;  // change increment later
  else if (mouseX > 805 && mouseX < 975 && mouseY > 350 && mouseY < 380)
    B = B + 0.01; // change increment later
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


