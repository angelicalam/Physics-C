import de.bezier.guido.*;
import java.lang.Math;

// B, E, q, and m are in SI units unless otherwise stated

private double x;   // x-position of the particle
private double y;   // y-position of the particle
private double a;   // acceleration of the particle 
private double B;   // magnitude and direction of B field
private double E;   // magnitude of E field
private double q;   // magnitude and sign of charge
private double r;   // radius of circular motion
private double m;   // mass of the particle

final static double maxE = 2;  // maximum magnitude of E field
final static double maxB = 2;  // maximum magnitude of B field

private boolean isRunning = false;  // particle only moves if isRunning

public void setup()
{
  size(1000, 600);
  E = 0;
  B = 0;
  q = 1;
  
  Interactive.make(this);
  
  // 0.001 <= mass < .101
  // allows for margin of error of 0.005,
  // more than enough to account for 
  // rounding errors and Processing's division errors
  double[] masses = new double[4];
  for(int i = 0; i < 4; i++) {
    masses[i] = Math.random()/10 + 0.001;
    for(int n = i-1; n >= 0; n--) {
      if (Math.abs(masses[i] - masses[n]) < 0.005)
      {
        masses[i] = Math.random()/10 + 0.001;
        n = i-1;
      }
    }
  }
  m = masses[(int)(Math.random()*4)];
  
  // initializes buttons for possible mass-to-charge ratios
  MQButton ratio1 = new MQButton(820,280,60,60, masses[0], m/q);
  MQButton ratio2 = new MQButton(820,360,60,60, masses[1], m/q);
  MQButton ratio3 = new MQButton(900,280,60,60, masses[2], m/q);
  MQButton ratio4 = new MQButton(900,360,60,60, masses[3], m/q);
}

private double v;       // tangential velocity in circular motion
private double radian;  // for circular motion
private double t = 0;   // time counter for E field
private double t2 = 0;  // time counter for B field

public void draw()
{
  plate();
  resetButton();
  displayEField();
  displayBField();
  displayESlider();
  displayBSlider();
  text("Choose the closest", 815,240);
  text("mass-to-charge-ratio:", 815,260);
  
  fill(255);
  ellipse( (float)x, (float)y, 10,10);
 
  if (isRunning)
  {
    // constant acceleration in the x-direction
    // for a uniform electric field
    // no movement for E field = 0
    if (x < 420 && y == 300)
    {
      // acceleration is x100 smaller since 1000 = 1 meter
      // slows down the animation
      // t/frameRate aligns draw() with real time
      // 10 is initial x-position of particle
      a = (E*q/m) * 10;
      x = 10 + .5*(a)*(t/frameRate)*(t/frameRate);
      t++;
      // smooths transition from E field to B field
      // particle will move backwards during transition
      // if x > 420
      if (x > 420)
        x = 420;
    }
    
    // circular motion in a uniform magnetic field
    else if (x >= 420 && B != 0)
    {
      // 0.4 is separation between E field plates in meters
      // 1000 scales r from meters to program's dimensions
      r = Math.sqrt( (2*E*.4*m)/(B*B*q) ) * 1000;
      // velocity is x10 smaller to slow down animation
      v = Math.sqrt( 2*E*q*.4 / m ) * 100;
      // B field is out of the page
      // Center of circular motion is (420, 300 + r)
      // radian decreases linearly with time
      if (B > 0)
      {
        radian = (Math.PI/2) - (v/r)*(t2/frameRate);
        y = (300 + r) - (r * Math.sin(radian));
      }
      // B field is into the page
      // Center of circular motion is (420, 300 - r)
      // radian increases linearly with time
      else
      {
        radian = ((-1)*Math.PI/2) + (v/r)*(t2/frameRate);
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
      // velocity is x10 smaller
      v = Math.sqrt( 2*E*q*0.4 / m ) * 100;
      x = x + (v)*(1/frameRate);
    }
    
    // display distance along plate traveled by particle
    else
    {
      line(385,300,395,300);
      line(390,300,390,(float)y);
      line(385,(float)y,395,(float)y);
      text(String.format("%.3f", 2*(r/1000)) + " m", 325,(float)y);
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
  if (mouseX > 860 && mouseX < 900 && mouseY > 540 && mouseY < 580)
    isRunning = !isRunning;
}

// draws reset button
public void resetButton()
{
  textSize(14);
  text("Press to START.", 820,500);
  text("Press again to RESET.", 820,520);
  if (isRunning)
    fill(255,0,0);  // button is red when the simulation is running
  else
    fill(0,255,0);  // button is green when the simulation is resting
  rect(860,540,40,40);
}

// resets simulation
public void reset()
{
  x = 10;
  y = 300;
  t = 0;
  t2 = 0;
}

// draws plate separating the electric field and magnetic field
public void plate()
{
  background(0);
  fill(255);
  rect(410,0,10,285);
  rect(410,315,10,285);
}

// draws E field
public void displayEField()
{
  if (E != 0)
  {
    for(int n = 50; n < 600; n += 100) {
      stroke(255);
      line(0, n, 410, n);
      line(400, n-10, 410, n);
      line(400, n+10, 410, n);
    }
  }
}

// draws B field
public void displayBField()
{
  stroke(255);
  for(int r = 50; r < 600; r += 100) {
    for(int c = 470; c < 800; c += 100) {
      if (B > 0)
      {
        fill(0);
        ellipse(c,r,15,15);
        fill(255);
        ellipse(c,r,7,7);
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
private double ESliderX = 820;
private double BSliderX = 890;
public void mouseDragged()
{
  if (mouseX > 819 && mouseX < 961 && mouseY > 45 && mouseY < 75)
  {
    // can't allow E to affect r and v when particle is in B field
    if (x < 420)
    {
      ESliderX = mouseX;
      E = ((ESliderX - 820)/140) * maxE;
    }
  }
  else if (mouseX > 819 && mouseX < 961 && mouseY > 115 && mouseY < 145)
  {
    BSliderX = mouseX;
    B = ((BSliderX - 890)/70) * maxB;
  }
}

// draws slider for E field magnitude
public void displayESlider()
{
  // draw slider bar
  fill(255);
  rect(820,60,140,1);
  // draw slider knob
  ellipse((float)ESliderX,60,15,15);
  // display E field value
  text( "Electric field: " + String.format("%.3f",E) + " N/C", 815,40);
}

// draws slider for B field magnitude and direction
// for positive values of B, the B field is directed out of the page
// for negative values of B, the B field is directed into the page
public void displayBSlider()
{
  // draw slider bar
  fill(255);
  rect(820,130,140,1);
  // draw slider knob
  ellipse((float)BSliderX,130,15,15);
  // display B field value
  text("Magnetic field: " + String.format("%.3f",B) + " T", 815,110);
}

// draws options for mass-to-charge ratio
// if user picks the correct one, then
// a winning message is displayed
// Uses Guido
public class MQButton
{
  private float x, y, width, height;
  private double MQ, trueMQ;
  private boolean pressed;
  
  public MQButton(float xx, float yy, float ww, float hh, double mq, double tmq)
  {
    x = xx;
    y = yy;
    width = ww;
    height = hh;
    MQ = mq;
    trueMQ = tmq;
    pressed = false;
    
    Interactive.add(this);
  }
  
  public void mousePressed()
  {
    pressed = true;
  }
  
  public void draw()
  {
    fill(0);
    if (pressed)
    {
      if (MQ == trueMQ)
        displayWinningMessage();
      else
        displayLosingMessage();
      fill(100);
    }
    rect(x,y,width,height);
    fill(255);
    textSize(14);
    text(String.format("%.4f", MQ), (x + .1*width), (y + .45*height));
    text("kg/C", (x + .25*width), (y + .8*height));
  }
  
  public void displayWinningMessage()
  {
    stroke(255);
    fill(0);
    rect(200,100,600,400);
    fill(255);
    textSize(60);
    text("Congrats!", 350,220);
    text("You're a Winner!", 270,300);
    textSize(36);
    text("Refresh to play again.", 310,400);
    textSize(14);
    text("Mass-to-charge-ratio: " + String.format("%.4f", trueMQ) + " kg/C",
         370,450);
  }
  
  public void displayLosingMessage()
  {
    stroke(255);
    fill(0);
    rect(200,100,600,400);
    fill(255);
    textSize(60);
    text("Congrats!", 350,220);
    text("You're a Loser.", 280,300);
    textSize(36);
    text("Refresh to play again.", 310,400);
    textSize(14);
    text("Mass-to-charge-ratio: " + String.format("%.4f", trueMQ) + " kg/C",
         370,450);
  }
}
