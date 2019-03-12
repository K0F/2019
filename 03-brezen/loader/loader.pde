

ArrayList entries;

void setup(){

  size(1920,1080);

  entries = new ArrayList();

  String raw[] = loadStrings("/home/kof/storage/local/qc_sorted/allVals.txt");

  for(int i = 0 ; i < raw.length ; i++){
    String tmp[] = splitTokens(raw[i],",");
      entries.add(new Entry(tmp[0],parseFloat(tmp[1]),tmp[2]));
  }

}



void draw(){

  for(int i = 0 ; i < width*height; i++){
    Entry en = (Entry)entries.get(i);
    stroke(en.val);
    point(i%width,i/width);
  }


}


class Entry{
  String tc;
  float val;
  String path;

  Entry(String _tc,float _val,String _path){
    tc = _tc+"";
    val=_val;
    path=_path+"";

  }


}
