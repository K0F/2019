
// two collaborating nets
Cube one,two;

int size = 8;
float time;
float lasttime;
float tick = 0.0864;
float phaseOne,phaseTwo;

void setup(){
  size(320,240,OPENGL);
  one = new Cube();
  two = new Cube();
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
ArrayList graph;
  boolean matrix[][][];

  Cube(){
    matrix = new boolean[size][size][size];
    graph = new ArrayList();

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
      matrix[((int)coord.x+size-1)%(size)][(int)coord.y][(int)coord.z] = !other.matrix[size-(int)coord.x-1][(int)coord.y][size-(int)coord.z-1];
    }
    
    float tmp[] = unwrap(matrix);
    for(int i  = 0 ; i < size;i++)
    print(tmp[i]+",");
    println();

    graph.add(tmp);

    if(graph.size()>width)
    graph.remove(0);

    plot();
  }

  void plot(){
    float all[][] = new float[size][graph.size()];
if(graph.size()>0){

    for(int i = 0; i < graph.size();i++){
      float tmp[] = (float[])graph.get(i);
      for(int ii = 0 ; ii < size;ii++){
        all[ii][i] = tmp[ii];
      }
    }

      for(int ii = 0 ; ii < all.length;ii+=1){
      beginShape();
        for(int i = 0 ; i < all[ii].length;i++){
        noFill();
        stroke(#ff0000);
        vertex(i,height-all[ii][i]/8.0);
      }
      endShape();
    }
    }

  }


  float [] unwrap(boolean [][][] input){
    float result[] = new float[size];
    String tmp = "";
    for(int iii = 0 ; iii < size;iii++){

      for(int ii = 0 ; ii < size;ii++){
        tmp = "";
        for(int i = 0 ; i < size;i++){
          tmp += matrix[i][ii][iii]?"1":"0";
        }
        result[iii] += unbinary(tmp);
      }
    }
    return result;
  }
}


void realtime(){
  while(true){
    float prec = 0;
    while( millis()-lasttime < tick ){
      ;
    }
    lasttime=millis();
    time+=0.01;
  }


}

