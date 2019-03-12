

String target  = "Lorem ipsum dolor et amet";
float ftarget[];
int count = 1000;
ArrayList neurons;

int output = target.length();

void setup(){
  size(320,240);
  neurons = new ArrayList();

  ftarget = new float[target.length()];
  for(int i = 0 ; i < ftarget.length;i++){
    ftarget[i] = ((((int)target.charAt(i))-48.0)/128.0);
    print(ftarget[i]+" ");
  }
  println();

  for(int i = 0 ; i < count;i++)
    neurons.add(new Neuron(i));

  for(int i = 0 ; i < neurons.size();i++){
    Neuron n = (Neuron)neurons.get(i);
    n.connect(10);
  }

  textFont(createFont("Semplice Regular",8,false));
  textAlign(CENTER);
  rectMode(CENTER);
}


void draw(){
  /*
     for(int i = 0;i<10;i++){
     int sel = (int)random(0,neurons.size());
     Neuron n = (Neuron)neurons.get(sel);
     if(n.val<0.1||n.val>0.9)
     n.connect(10);
     }
   */

  background(0);

  int s = 4;
  int b = 20;
  int c = 0;

  noStroke();

  for(int y = b;y<height-b;y+=s){
    for(int x = b;x<width-b;x+=s){

      c++;
      if(c<neurons.size()){
        Neuron n =  (Neuron)neurons.get(c);
        /* 
           if(dist(x,y,width/2,height/2)<20){
           n.val = (sin(frameCount/600.0*TWO_PI)+1.0)/2.0;
           }
         */

        n.collect();
        pushMatrix();
        translate(x,y);
        n.draw();
        popMatrix();
      }
    }
  }
  fill(255);
  String out = "";

  for(int i = 0 ; i < output;i++){
    Neuron n = (Neuron)neurons.get(i);
    char ch = (char)((int)(n.val*128.0+48));
    out += ch;
  }
  text(target,width/2,height-32);
  text(out,width/2,height-20);


}


class Neuron{
  int id;
  boolean addmorew = true;
  ArrayList w,ins;
  float val,nval;
  float rate;

  Neuron(int _id){
    id = _id;
    ins = new ArrayList();
    val = random(0,100)/100.0;
    rate = random(0,100)/1000.0;
    ins = new ArrayList();
    w = new ArrayList();
  }

  void connect(int howmany){
    for(int i = 0;i<howmany;i++){
      int ptr = (int)random(neurons.size());
      // if(addmorew){
      w.add(random(0,100)/100.0);
      ins.add((Neuron)neurons.get(ptr));
      // }
    }
    /*
       if(ins.size()>100){
       addmorew=false;
       while(ins.size()>100){
       ins.remove(0);
       }
       }
     */
  }

  float sigmoid(float input){
    return (float)Math.tanh((input)*PI);
  }

  float error(int _id){
    Neuron tmp = (Neuron)neurons.get(_id);
    return ftarget[_id]-tmp.val;
  }

  void backpropagate(Neuron n,float err,float depth){
    for(int i = 0 ; i < n.ins.size();i++){
      Neuron pre = (Neuron)n.ins.get(i);
      float W = (Float)n.w.get(i);
      W += (-err/(n.ins.size()+0.0)*W)*rate;
      
      n.w.set(i,W);

      if(depth>=1){
        pre.backpropagate(pre,err/(pre.ins.size()+0.0)*W,depth-1);
      }
    }
  }

  void collect(){
    for(int i = 0 ; i < ins.size();i++){
      Neuron tmp = (Neuron)ins.get(i);
      float W = (Float)w.get(i);
      nval += ((tmp.val * W)-nval)*rate;

    }
    
    nval /= (ins.size()+0.0);
    nval = sigmoid(nval);
    val += (nval-val)*rate;

    if(id<output){
      backpropagate(this,error(id),3);
    }

    /*
       int neighs[] = {-32,32};
       for(int i = 0 ; i < neighs.length;i++){
       neighs[i]=(neighs[i]+id+neurons.size())%(neurons.size());
       Neuron tmp = (Neuron)neurons.get(neighs[i]);
       float W = 0.05;

       nval += (sigmoid(tmp.val * W)-nval)*rate;
       }
     */
  }

  void draw(){
    fill(map(val,-1,1,0,255));
    rect(0,0,2,2);
  }
}
