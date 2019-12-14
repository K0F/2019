
// two collaborating nets
Cube one,two;

float time;
float lasttime;
float tick = 0.864;
float phaseOne,phaseTwo;

void setup(){
  size(320,240,OPENGL);
  one = new Cube(8);
  two = new Cube(8);
  thread("realtime");
}

void draw(){
  background(255);

  phaseOne = (sin(time/10.0*TWO_PI)+1.0)/2.0;
  phaseTwo = (sin(time/10.0*TWO_PI+PI)+1.0)/2.0;

  one.act(phaseOne,0,0,two);
  two.act(phaseTwo,width/2,0,one);

    println(time);
}

class Cube{
  int size = 8;
  boolean matrix[][][];
  
  Cube(int _size){
    size = _size;
    matrix = new boolean[size][size][size];

    for(int i = 0; i < size;i++)
    for(int ii = 0; ii < size;ii++)
    for(int iii = 0; iii < size;iii++){
      matrix[i][ii][iii] = random(100)>50?true:false;
    }

 }

  void act(float phase,int x,int y,Cube other){
    pushMatrix();
    translate(x,y);
    fill(phase*255);
    noStroke();
    rect(0,0,width/2,height);

    float ss = 2;
    translate(8,8);
      for(int iii = 0 ; iii < size;iii++){
    for(int i = 0 ; i < size;i++){
      for(int ii = 0 ; ii < size;ii++){
        if(matrix[i][ii][iii]){
        fill(255);
        }else{

        fill(0);
        }
        rect(i*ss,ii*ss,ss,ss); 
      }
    }
    translate(size*ss+2,0);
    }
    popMatrix();

  if(phase>0.5){
    PVector coord = new PVector(random(size),random(size),random(size));
    matrix[(int)coord.x][(int)coord.y][(int)coord.z] = other.matrix[size-(int)coord.x-1][(int)coord.y][size-(int)coord.z-1];
    matrix[((int)coord.x+size)%(size-1)][(int)coord.y][(int)coord.z] = !other.matrix[size-(int)coord.x-1][(int)coord.y][size-(int)coord.z-1];
  }
  }
}


void realtime(){
  while(true){
    float prec = 0;
    while( millis()-lasttime < tick ){
      delay(1);
    }
    lasttime=millis();
    time+=0.01;
  }
}

