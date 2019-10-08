
Paratime time;
int size = 16;
int sel = 0 ;
float speed = 1.0;
float bpm = 135.0;
boolean grid[][];
float send[];

void setup(){
  size(320,320);
  frameRate(60); 

  grid = new boolean[8][size];
  send = new float[8];
  time=new Paratime(bpm);
  time.start();

  textFont(createFont("Semplice Regular",8));
}



void draw(){

  background(0);
  stroke(255);
  fill(255);
  text("bpm: "+bpm,10,14);

  pushMatrix();
  translate(width/2,height/2);
  noFill();

  for(int i = 0 ; i < 8;i++){
    strokeWeight(2);
    noFill();
    ellipse(0,0,i*31+100,i*31+100);
    strokeWeight(1);

    stroke(255); 
    if(send[i]>0)
      send[i]-=25;

    fill(255,send[i]);
    pushMatrix();
    resetMatrix();
    rect(width-60+i*5,10,5,5);
    popMatrix();
  }
  noFill();


  for(int i = 0 ; i < size;i++){
    float theta = map(i,0,size,0,TWO_PI);
    pushMatrix();
    rotate(theta);
    stroke(255,120);
    line(0,-160,0,-50);
    popMatrix();
  }

  for(int ii = 1 ; ii < 8; ii++){
    for(int i = 0 ; i < size;i++){
      float theta = map(i,0,size,0,TWO_PI)+PI;


      if(over(ii,i)){
        pushMatrix();
        rotate(theta);
        stroke(#ffcc00,100);
        strokeWeight(15);
        strokeCap(SQUARE);
        arc(0,0,ii*31+84,ii*31+84,0,TWO_PI/size);
        popMatrix();
        if(mousePressed){
          grid[ii][i]=!grid[ii][i];
        }
        mousePressed=false;
      }

      if(grid[ii][i]){
        pushMatrix();
        rotate(theta);
        stroke(255);
        strokeWeight(15);
        strokeCap(SQUARE);
        arc(0,0,ii*31+84,ii*31+84,0,TWO_PI/size);
        popMatrix();
      }
    }
  }
  strokeWeight(1);

  rotate(map(sel,0,size,0,TWO_PI));
  line(0,-160,0,0);
  popMatrix();

}


boolean over(int ii,int i){
  boolean answer = false;
  float theta = map(i,0,size,0,TWO_PI)-PI;
  float theta2 = atan2(mouseY-height/2,mouseX-width/2)-(TWO_PI/size/2.0);
  float dist = dist(mouseX,mouseY,width/2,height/2)*2;
  float target = ii*31+84;

  if(abs(target-dist)<15 && abs(theta-theta2)<TWO_PI/size/2){
    answer=true;
  }

  return answer;
}

class Paratime extends Thread {

  float clock_led = 0;
  long previousTime;
  boolean isActive=true;
  double interval;
  double total;
  double timePassed;

  Paratime(float _bpm) {
    bpm = _bpm;
    // interval currently hard coded to quarter beats
    interval = 1000.0 / (bpm / 60.0 * speed);
    previousTime=System.nanoTime();
  }

  void run() {
    try {
      while(isActive) {
        // calculate time difference since last beat & wait if necessary
        interval = 1000.0 / (bpm / 60.0 * speed);
        timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }
        total+=timePassed;
        sel++;
        if(sel>=size)
          sel=0;

        for(int i = 0;i<8;i++){
          if(grid[i][sel]){
            send[i] = 255;
            println("sending ["+i+"]["+sel+"]");
          }
        }


        // insert your osc event sending code here
        // calculate real time until next beat
        long delay=(long)(interval-(System.nanoTime()-previousTime)*1.0e-6);
        previousTime=System.nanoTime();
        if(delay>0)
          Thread.sleep(delay);

      }
    }
    catch(InterruptedException e) {
      println("force quit...");
    }
  }
}
