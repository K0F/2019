import processing.video.*;
Movie mov;

void setup(){
  size(320,240,P2D);
  mov = new Movie(this,"test.mp4");
  mov.play();
}


void draw(){
  image(mov,0,0);
}

void movieEvent(Movie m){
  m.read();
}
