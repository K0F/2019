import processing.svg.*;

boolean record;

void setup() {
  size(1024, 576,P2D);
  smooth();
  noiseSeed(2019);
}

void draw() {
  // Note that #### will be replaced with the frame number. Fancy!
  beginRecord(SVG, "render/frame-######.svg");

  // Draw something good here
  background(0);
  int mx = 1000;
  stroke(255,15);
  noFill();
  float n = 7.0;
  for(int s = 1; s < n ;s++)
 for(int i  = 0 ; i < mx ; i ++){
    float x = map(i,0,mx,0,width);
    x *= noise(x/1000.0+frameCount/100.0);
    float n1 = noise(x/999.0+frameCount/100.1)*(TWO_PI/n)*s;
    float n2 = noise(x/998.0+frameCount/1001.0)*(TWO_PI/n)*s;
    float n3 = noise(x/997.0+frameCount/1002.0)*(TWO_PI/n)*s;
    pushMatrix();
    translate(width/2,height/2);
    rotate(n3);
    arc(0,0,x,x,n1,n2);
    popMatrix();
  }
  endRecord();
}

