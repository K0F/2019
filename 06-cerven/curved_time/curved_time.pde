import VLCJVideo.*;

VLCJVideo video;

int W = 720;
int H = 576;
int DEPTH = 25;
color timepix[][][] = new color[W][H][DEPTH];

void setup() {
  size(720,576,P2D);
  frameRate(25);
  noiseSeed(2019);

  video = new VLCJVideo(this);
  video.openMedia("GOLEM_LT.mov");
  video.loop();
  video.play();
  video.mute();

  background(0);
}

void draw() {


  //background(0);
  /*
  fill(0,15);
  strokeWeight(20);
  stroke(0,200);
  rect(0,0,width,height);
*/
 //tint(255,50);
  image(video, 0, 0,width,height);

 // filter(BLUR,2);
  stroke(255);
  /*
  line(
      sin(frameCount/1000.0*TWO_PI)*width,
      0,
      sin(frameCount/1000.0*TWO_PI)*width,
      height
      );
      */
  fill(
      (sin(frameCount/150.1)+1.0)*127.0,
      (sin(frameCount/160.2)+1.0)*127.0,
      (sin(frameCount/170.3)+1.0)*127.0,
      50);
  noStroke();
  float X = width/2;

  //ellipse(X,height/2,600,600);

  int sel = 0;//(int)((sin(frameCount/250.0*TWO_PI)+1.0)*DEPTH/2.0);//frameCount%DEPTH;

  loadPixels();
 
  for(int y = 0 ; y < height ; y++)
    for(int x = 0 ; x < width ; x++){
      timepix[x][y][sel] = pixels[y*width+x];
    }

    
  for(int i = DEPTH-1 ; i >= 1;i--){
    for(int y = 0 ; y < height ; y++){
      for(int x = 0 ; x < width ; x++){
        timepix[x][y][i] = timepix[x][y][i-1];//lerpColor(timepix[x][y][i-1],timepix[x][y][i],0.5);
      }
    }
  }


  for(int y = 0 ; y < height ; y++)
    for(int x = 0 ; x < width ; x++){
  float sc = noise(frameCount/500.0,x/1000.0,y/1000.0)*1800.0;
      int tmp = (int)(noise(x/sc,y/sc,frameCount/sc)*DEPTH);
      pixels[y*width+x] = lerpColor(timepix[x][y][tmp],pixels[y*width+x],0.75);
    } 
  updatePixels();

  saveFrame("/home/kof/storage/local/render/curvedTime/fr######.tga");
}





