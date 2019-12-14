

boolean [][] matrix;

int siz = 8;
float Ls[];
float Rs[];
float Ts[];
float Bs[];

void setup(){
  size(320,320,OPENGL);
  matrix = new boolean[siz][siz];

  textFont(createFont("Semplice Regular",8,false));

  Ls = new float[siz];
  Rs = new float[siz];

  for(int i = 0 ; i < matrix.length;i++){
    for(int ii = 0 ; ii < matrix[i].length;ii++){
      matrix[i][ii] = random(100)>50?true:false;
    }
  }
}


void draw(){
  background(0);
  int x = 0;
  int y = 0;

  pushMatrix();
  translate(125,100);
  for(int ii = 0 ; ii < matrix.length;ii++){
    for(int i = 0 ; i < matrix[ii].length;i++){
      fill(255);
      if(matrix[ii][i]){
        text("1",x,y);
      }else{
        text("0",x,y);
      }
      x+=9;
    }

    int sumR = unbin(matrix[ii],false);
    Rs[ii] += (sumR-Rs[ii])/3.3;
    fill(sumR);
    text(sumR,siz*9+10,y);
    rect(siz*9,y,8,-8);

    int sumL = unbin(matrix[ii],true);
    Ls[ii] += (sumL-Ls[ii])/3.3;
    fill(sumL);
    text(sumL,-35,y);
    rect(-15,y,8,-8);
    
    /*
    int sumT = unbin(extract(matrix,ii),true);
    Ts[ii] += (sumT-Ts[ii])/3.3;
    fill(sumT);
    text(sumT,x,-8);
    rect(x,-16,8,-8);

    int sumB = unbin(extract(matrix(matrix,ii),false);
    Bs[ii] += (sumB-Bs[ii])/3.3;
    fill(sumB);
    text(sumB,x,y);
    rect(x,siz*9,8,-8);
    */


   // simple left right top bottom

    x=0;
    y+=9;
  }
  colorMode(RGB);
  fill(Ls[0],Ls[1],Ls[2]);
  rect(-70,-9,3*9,3*9);
  fill(Ls[3],Ls[4],Ls[5]);
  rect(-70,3*9-9,3*9,3*9);

  colorMode(HSB);
  fill(Rs[0],Rs[1],Rs[2]);
  rect(siz*9+30,-9,3*9,3*9);
  fill(Rs[3],Rs[4],Rs[5]);
  rect(siz*9+30,3*9-9,3*9,3*9);

  colorMode(RGB);

  popMatrix();

  mutate(20);
}

boolean [] extract(boolean [][] input,int which){
  boolean [] tmp = new boolean[siz];
  for(int i = 0 ; i < input[0].length;i++){
    tmp[i] = input[which][i];
  }
  return tmp;
}

int unbin(boolean [] in, boolean reverse){
  String tmp="";
  if(reverse){
    for(int i = in.length-1; i >= 0;i--){
      tmp+=in[i]?"1":"0";
    }
  }else{
    for(int i = 0; i < in.length;i++){
      tmp+=in[i]?"1":"0";
    }
  }
  int answer = unbinary(tmp);
  return answer;
}


void mutate(float rate){
  for(int i = 0 ; i < matrix.length;i++){
    for(int ii = 0 ; ii < matrix[i].length;ii++){
      if(random(1000)<rate)matrix[i][ii]=!matrix[i][ii];
    }
  }
}
