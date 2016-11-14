// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**

 Visual from : Code-Package-Processing-3.x/02_M/M_1_5_02_TOOL/M_1_5_02_TOOL.pde
 at https://github.com/generative-design/Code-Package-Processing-3.x/blob/master/02_M/M_1_5_02_TOOL/M_1_5_02_TOOL.pde
 
 * noise values (noise 2d) are used to animate a bunch of agents.
 * 
 * KEYS
 * m                   : toogle menu open/close
 * 1-2                 : switch noise mode
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 
  * This sketch demonstrates how to use the BeatDetect object song SOUND_ENERGY mode.<br />
  * 
  * For more information about Minim and additional features, 
  * visit http://code.compartmental.net/minim/
  */
  
  
  //    FIRST TRY
  
  //    BPM DETECTION + PERLIN NOISE BASED VIDEO GENERATION
  //    NO SERIAL CONNECTION
  //
  //
  
  
//import processing.serial.*;

import ddf.minim.*; //BPM detection
import ddf.minim.analysis.*;


import controlP5.*; //fader
import java.util.Calendar;


Minim minim;
AudioPlayer song;
BeatDetect beat;
Bpm bpmo;

int MAX_AGENTS = 2000;

// ------ agents ------
Agent[] agents = new Agent[MAX_AGENTS]; // create more ... to fit max slider agentsCount
int agentsCount = 400;
float noiseScale = 300, noiseOld = 300, noiseStrength = 10; 
float overlayAlpha = 10, overlayAlphaOld = 10, agentsAlpha = 90, agentsAlphaOld = 90, strokeWidth = 0.3;
int drawMode = 1;

//float con, res, conv;

ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

float eRadius;
int initTime, counter;
int BPM1=0;

void setup()
{
  
  size(1280,800,P2D);
  smooth();

  for(int i=0; i<agents.length; i++) { //inizializza gli oggetti grafici
    agents[i] = new Agent();
  }

  setupGUI();
  bpmo = new Bpm();
  minim = new Minim(this);
  song = minim.loadFile("song.mp3", 2048);
  
  song.play();
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  
  bpmo.setInitTime(millis());
  bpmo.setCounter(0);
  
  frameRate(30);
  beat.setSensitivity(400);
  
  
 // String portName = Serial.list()[0]; //serial communication
 // myPort = new Serial(this, portName, 9600);
 
  
}

void draw()
{
  agentsAlpha = agentsAlphaOld;
  noiseScale = noiseOld ;
  overlayAlpha = overlayAlphaOld;
  
//  agentsCount = (int)(1.0+(float)agentsCount*con); //modify agents number according to CONDUCTANCE value from the sensor
//  println(agentsCount);
//  if(agentsCount > MAX_AGENTS) agentsCount = (int)((float)agentsCount / 50 );
  
  beat.detect(song.mix);
  
  BPM1 = bpmo.getBPM( 1500 ); //GET BPM FUNCTION
  
  if ( beat.isRange(1,1,1) ) { //if KICK is detected...
    
    int newNoiseSeed = (int) random(100000); // change objects direction
    //println("newNoiseSeed: "+newNoiseSeed);
    noiseSeed(newNoiseSeed);
    
    //noiseOld = noiseScale;
    //noiseScale = 0;
    
    overlayAlphaOld = overlayAlpha;  //  fa una copia del valore attuale di OverlayAlpha
    overlayAlpha = 255;              // Imposta temporaneamente l'opacità al minimo (effetto flash)
    
    agentsAlphaOld = agentsAlpha;
    agentsAlpha = 30;
    
    bpmo.incrementCounter(); 
  }
  
  fill(255, overlayAlpha);
  noStroke();
  rect(0,0,width,height);
  
  
  strokeWidth = BPM1/40;
  //println(" strokeWidth: " +strokeWidth);
  
  stroke(0, agentsAlpha);
  
  //draw agents
  if (drawMode == 1) {    // default is 1
    for(int i=0; i<agentsCount; i++) agents[i].update1();
  } 
  else {
    for(int i=0; i<agentsCount; i++) agents[i].update2();
  }
  
  drawGUI();
   //println("CON: "+ con);
}


  
void keyReleased(){
  
  if(key=='m' || key=='M') {
    showGUI = controlP5.getGroup("menu").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == ' ') {
    int newNoiseSeed = (int) random(100000);
    println("newNoiseSeed: "+newNoiseSeed);
    noiseSeed(newNoiseSeed);
  }
  if (key == DELETE || key == BACKSPACE) background(255);
}


String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}
  
