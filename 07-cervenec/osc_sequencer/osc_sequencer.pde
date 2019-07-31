

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

OscThread osc;

String [] names = {"/a","/b","/c","/d","/e","/f","/g","/h"};
int size = 64;
int tracks = 8;
float grid[][];
int sel = 0;
float speed = 8.0;
double bpm = 120.0;

void setup() {
  size(800,240);
  textFont(createFont("Semplice Regular",8,false));
  // create new thread running at 160bpm, bit of D'n'B



  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",10000);
  grid = new float[tracks][size];  

  osc=new OscThread(bpm);
  osc.start();
}

void draw() {
  background(0);

  fill(osc.clock_led);
  stroke(255);

  rect(width-15,10,5,5);

  fill(255);
  text("OSC out:",width-56,16);
  text("BPM: "+bpm,16,16);
  fill(250);
  rect(sel*12+18,28,14,height-28-10);
  for(int ii = 0; ii < tracks;ii++){
    fill(255);
    text(names[ii],5,ii*12+39);
    for(int i = 0 ; i < size;i++){
      fill(grid[ii][i]*255);
      stroke(i%4==0?color(255,128,0,200):color(255,200));
      rect(i*12+20,ii*12+30,10,10);
    }
  }


  if(osc.clock_led>0)
    osc.clock_led-=40;
}

void mouseClicked(){

  for(int ii = 0; ii < tracks;ii++){
    for(int i = 0 ; i < size;i++){
      if(mouseX>i*12+20&&mouseX<i*12+20+10&&mouseY>ii*12+30&&mouseY<ii*12+30+10){
        grid[ii][i] = grid[ii][i]==1?0:1;
      }
    }
  }
}

// also shutdown the osc thread when the applet is stopped
public void stop() {
  if (osc!=null) osc.isActive=false;
  super.stop();
}

void keyPressed(){
  if(key == ' ')    
    reset();

  if(key =='=')
    bpm++;

  if(key =='-')
    bpm--;

  if(keyCode==DELETE){
    for(int ii = 0; ii < grid.length;ii++)
    for(int i = 0; i < grid[ii].length;i++)
      grid[ii][i] = 0;
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());

  if(theOscMessage.addrPattern().equals("/reset"))
reset();
  
  if(theOscMessage.addrPattern().equals("/bpm"))
    bpm = (double)theOscMessage.get(0).floatValue();

}

void reset(){

  osc.previousTime=System.nanoTime();
  osc.total = 0;  
  sel=0;
}

class OscThread extends Thread {
  float clock_led = 0;
  long previousTime;
  boolean isActive=true;
  double interval;
  double total;

  OscThread(double _bpm) {
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
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<interval) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }



        for(int ii = 0; ii < tracks;ii++){
          if(grid[ii][sel]>0){ 
            clock_led = 255;
            OscMessage myMessage = new OscMessage(names[ii]);
            myMessage.add(grid[ii][sel]);
            oscP5.send(myMessage, myRemoteLocation); 
            println("OSC "+names[ii]+" "+grid[ii][sel]+" time: "+total+"ms");
          }
        }

        total+=timePassed;
        sel++;
        if(sel>=size)
          sel=0;

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
