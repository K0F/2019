

int len = 20480;
float buffer[];
ArrayList data;
int ins = 512;
int outs = 16;

void setup(){
  size(1024,320);
  buffer = new float[ins+outs];
  data = new ArrayList();
  
  data.add(len+" "+ins+" "+outs);
}

void draw(){
    
  
  background(255);
  stroke(0);
  
  
  gen(123,len,"/home/kof/src/fann/datasets/perlin.train");
  gen(321,len,"/home/kof/src/fann/datasets/perlin.test");

  exit();
}

void gen(int seed,int siz,String filename){
 
  noiseSeed(seed);
  
  
  for(int counter = 0; counter < siz; counter++ ){
  
  for(int i = 0 ; i < buffer.length;i++){
   buffer[i] = noise((i+(counter*siz))/10.0);
   //point(i,buffer[i]*height);
  }
  
  String line = "";
  for(int i = 0; i < buffer.length-outs;i++){
    line = line + buffer[i] + " "; 
  }
  data.add(line);
  
  line = "";
  for(int i = buffer.length-outs; i < buffer.length;i++){
    line = line + buffer[i] + " "; 
  }
  data.add(line);
  
  
  }
  
  saveData(filename);
  
}


void saveData(String filename){
 
  String all[] = new String[data.size()];
  for(int i = 0 ; i < data.size();i++){
    String tmp = (String)data.get(i);  
    all[i] = tmp+"";
  }
  
  saveStrings(filename,all);
    
}