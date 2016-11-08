public class Bpm {

  private int BPMvalue;
  private int timeLength, initTime,counter;
  
  //costruttore
  public Bpm(){
    BPMvalue=0;
  }
  
  public int getCounter(){ return counter;}
  public int getTimeLength(){ return timeLength;}
  public int getInitTime(){ return initTime;}
 
  public void setCounter(int i){counter=i;} 
  public void setInitTime(int i){initTime=i;} 
  public void setTimeLength(int i){timeLength=i;} 
    
  public void incrementCounter(){counter++;}


  
  //metodo get BPM
public int getBPM(int tL){
  //timeLenght is the observation window in milliseconds
  // initTime is the starting time
  // counter is the number of beats revealed in one "timeLenght" window
  timeLength=tL;
  
  int elapsedTime;
  int BPM ;
  elapsedTime = millis() - initTime;
  
  if( elapsedTime > timeLength-20 && elapsedTime < timeLength+20)
    {
    BPM = (counter*(60*1000)/timeLength);   //resolution = (60*1000)/timeLength;
    counter = 0;
    initTime = millis();
    
    BPMvalue = BPM;
    }
  else 
    {BPM = BPMvalue;}
    
  //if(BPM!=0) //println("BPM:" + BPM);
  return BPM;
  }
  
}