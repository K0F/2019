
PVector vectors[];
float cols[];

void setup() {
  size(720, 576, P2D);
  background(0);
 

  vectors = new PVector[width*height];
  cols = new float[width*height];

loadPixels();
  for (int y = 0; y<height;y++)
    for (int x = 0 ; x<width;x++) {
     pixels[y*width+x] = color(random(255)); 
     cols[y*width+x] = random(255);
    }
    updatePixels();
}


void draw() {
  
  
  
  loadPixels();
  
    
  float preamp = 12.0;
  float sc = 280.0;

  
  int c = 0;

  for (int y = 0; y<height;y++)
    for (int x = 0 ; x<width;x++) {
      float theta = noise(y/sc,x/sc,frameCount/sc)*TWO_PI*10.0;
      float amp = noise(y/sc+100,x/sc+100,frameCount/sc)*preamp;
      vectors[c] = new PVector(
      cos(theta)*amp, 
      sin(theta)*amp
        );

      int X = (x+(int)vectors[c].x+width-1)%width;
      int Y = (y+(int)vectors[c].y+height-1)%height;

      c++;
      cols[y*width+x] += (cols[Y*width+X]+ ((amp * theta -180.0) / 20.0)-cols[y*width+x])/2.01;
      pixels[y*width+x] = color(cols[y*width+x]) ;  
  }

  updatePixels();
  
  //filter(BLUR);
}

