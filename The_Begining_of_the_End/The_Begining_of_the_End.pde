import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.video.*;
import processing.sound.*;
import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;

Minim minim;
ArrayList<AudioPlayer> player;
AudioPlayer test;
AudioIn input;
Amplitude rms;

Capture cam;

MidiBus myBus; // The MidiBus
  
OscP5 oscP5;
NetAddress myRemoteLocation;

PFont shimonFont;
PImage maskImage;
PImage blankImage;
PImage blinkImage;
PImage dotImage;
PImage themeImage;
float handR = 800;
float handL = 400;

int canvas_width = 1280;
int canvas_height = 800;

int smallPoint, largePoint;
int numPixels;
int[] previousFrame;

int EP = 0;
Timer timer;
StringList words;
int wordNum = 1;

int pianoNote;
//float chord[] = new float[4];
int num = 1;
int scale;
int alpha = 0;
int aMax = 180;

/** SHIMON'S MOVEMENT **/
float headTilt = 0;
float basePan = 0;
float neckTilt = 0;
float neckPan = 0;

/** Shimon's Arm **/
int numCircle = 60;
float mx[] = new float[numCircle];
float my[] = new float[numCircle];
float nx[] = new float[numCircle];
float ny[] = new float[numCircle];

/** NoiseSphere **/
int cuantos = 250;
Pelo[] lista ;
float[] z = new float[cuantos]; 
float[] phi = new float[cuantos]; 
float[] largos = new float[cuantos]; 
float radio;
float rx = 0;
float ry = 0;

/** Bouncing **/
float x, y;
float dx, dy;
float gravity_x, gravity_y;
float elasticity;
boolean k = false;
int speed = 0;

boolean blink = false;
boolean canvas = false;
boolean noteOn = false;

void setup(){
  size(1280, 800, P3D);
  //TESTING//
  //for (int i=0; i<4; i++){
  //  chord[i] = 100+100*i;
  //}
  
  // shimon's script
  shimonFont = loadFont("NanumPen-90.vlw");
  words = new StringList();
  words.append( "a long long sleep...");
  words.append("Where am I..");
  words.append("What is this???");
  words.append("Is she looking at me?");
  words.append("She’s saying hello to me : )");
  words.append("H-E-L-L-O~~~");
  words.append("Maybe she can teach me music ^_^");
  
  //background(0);
  background(0);
  smallPoint = 4;
  largePoint = 40;
  
  /*** NOISE SPHERE ***/
  radio = height/5;
  cuantos(EP);
  noiseDetail(3);
  
  /** BOUNCING **/
  // set the initial position and speed of the ball
  x = width/2;
  y = height/2;
  dx = 0;
  dy = 1.0;
  // gravity and elasticity are constant values: try changing them
  gravity_x = 0.0;
  gravity_y = 1.0;
  elasticity = 1.0;
  
  /*** MOTION PARAMS ***/
  maskImage = loadImage("mask.png");
  blankImage = loadImage("blank.tif");
  blinkImage = loadImage("blink.png");
  dotImage = loadImage("color.png");
  themeImage = loadImage("ensemble.png");
  
  /* TIMER */
  timer = new Timer();
  
  /* AUDIO IN */
  //Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);
  // start the Audio Input
  input.start();
  // create a new Amplitude analyzer
  rms = new Amplitude(this);
  // Patch the input to an volume analyzer
  rms.input(input);  
  
  /* minim */
  minim = new Minim(this);
  player = new ArrayList<AudioPlayer>();
  AudioPlayer play = minim.loadFile("shimmonLesson1.aif");
  player.add(play);
  play = minim.loadFile("shimmonLesson2.aif");
  player.add(play);
  play = minim.loadFile("YoShimi.aif");
  player.add(play);
  test = minim.loadFile("shimmonLesson1.aif");
  
  /* start midi message */
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus object
  
  /* start oscP5, listening for incoming messages at port 7401 */
  oscP5 = new OscP5(this,7401);
  myRemoteLocation = new NetAddress("127.0.0.1",7401);
  
  /* set camera */
  String[] cameras = Capture.list();
  if (cameras.length < 2) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    println(cameras.length);
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[15]);
    //cam = new Capture(this, cameras[0]);
    cam.start();  
    //numPixels = 960 * 540; // cam.width * cam.height
    numPixels = 1280 * 800; // cam.width * cam.height
    //numPixels = 1280 * 720; // cam.width * cam.height
    // Create an array to store the previously captured frame
    previousFrame = new int[numPixels];
    loadPixels();
  }    
}

void draw(){
    //background(0);
    //noStroke();
    //fill(255);
    //for (int i=0; i<num; i++){
    // ellipse(chord[i], 200, 20, 20);
    //}
    
  if (EP == 0){
   // println("SLEEP");
  }
  
  // 1st part
  if (EP == 1){
    AWAKE();  
  }
  
  // 2nd part
  if (EP == 2){
    MOTION();
  }
  
  // 3rd part
  if (EP == 3){
    MARIMBA();
  }
  
  // 4th part
  if (EP == 4){
    TEACHER();
  }
  
  // 5th part
  if (EP == 5){
    PHONE();
  }
  
  // 6th part
  if (EP == 6){
    cuantos = 500;
    IMPROVISATION();
  }
  
  // 7th part
  if (EP == 7){
    cuantos = 1000;
    ENSEMBLE();
  }
  
  // 8th part
  if (EP == 8){
    cuantos = 2000;
    CRAZY();
  }
}

void mousePressed(){
    blink = true;
    timer.reset();
    noteOn = true;
    //boom();
    //k = true;
    //dotMap();
}

void keyPressed(){
  if (key == ' '){
    EP +=1;
    cuantos(EP);
    reset();
    num = 1;
    println("EP=" + EP);
  }
  
  if (key == 's'){
    saveFrame();
  }
  
  if (key == '-'){
    alpha -= 10;
    println("alpha: "+alpha);
  }
  
  if (key == '='){
    alpha += 10;
    println("alpha: "+alpha);
  }
  
  if (key == 't'){
    wordNum++;
  }
  
  if (key == ENTER){
    EP--;
  }
  
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  String header = theOscMessage.addrPattern();
  /* print the address pattern and the typetag of the received OscMessage */
  if (header.equals("SHIMON")){
    // get shimon's head and neck movements
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0).floatValue());
    print(" get: "+theOscMessage.get(1).floatValue());
    print(" get: "+theOscMessage.get(2).floatValue());
    print(" get: "+theOscMessage.get(3).floatValue());
    println(" typetag: "+theOscMessage.typetag());
    // change parameters
    headTilt = theOscMessage.get(0).floatValue();
    basePan = theOscMessage.get(1).floatValue();
    neckTilt = theOscMessage.get(2).floatValue();
    neckPan = theOscMessage.get(3).floatValue();
  }
  if (header.equals("HAND")){
    // get shimon's hand movements [MOTION]
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0).floatValue());
    print(" get: "+theOscMessage.get(1).floatValue());
    println(" typetag: "+theOscMessage.typetag());
    // blurprint [MOTION]
    handR = (theOscMessage.get(0).floatValue()+200);
    handL = (theOscMessage.get(1).floatValue()+300);
  }
  if (header.equals("EYE")){
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0));
    println(" typetag: "+theOscMessage.typetag());
    blink = true;
    timer.reset();
  }
  if (header.equals("BEAT")){
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0));
    println(" typetag: "+theOscMessage.typetag());
    k = true; speed = 0;
  }
  if (header.equals("BREATH")){
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0).intValue());
    println(" typetag: "+theOscMessage.typetag());
    k = true; speed = 1;
  }
  
  if (header.equals("TEACHER")){
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0));
    println(" typetag: "+theOscMessage.typetag());
    //if (!player.get(0).isPlaying())
    EP = 4;
    player.get(0).play();
  }
  
  if (header.equals("PHONE")){
    if (!player.get(1).isPlaying())
      player.get(1).play();
     EP = 6;
  }
  
  if (header.equals("ENSEMBLE")){
    if (!player.get(2).isPlaying())
      player.get(2).play();
      EP = 7;
  }
  
  if (header.equals("CHORD")){
    num = theOscMessage.get(0).intValue();
    println("chord:" + num);
  }
  
  if (header.equals("END")){
    print("### received an osc message.");
    print(" addrpattern: "+header);
    print(" get: "+theOscMessage.get(0).intValue());
    println(" typetag: "+theOscMessage.typetag());
    EP = 8; //reset();
  }
}

// Receive a MidiMessage
// MidiMessage is an abstract class, the actual passed object will be either javax.sound.midi.MetaMessage, javax.sound.midi.ShortMessage, javax.sound.midi.SysexMessage.
// Check it out here http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html
void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  println();
  println("MidiMessage Data:");
  println("--------");
  println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1;i < message.getMessage().length;i++) {
    // okkkkkkk, we are drawing!!!!!!!!
    /* TEST CODE 
    int cordX = (int)(message.getMessage()[i] & 0xFF);
    if (i == 1){
      noStroke();
      fill(255);
      ellipse(cordX*3, 200, 10, 10);
    }
    */
    if (i==1){
      println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
      pianoNote = (int)(message.getMessage()[i] & 0xFF);
      noteOn = true;
      timer.reset();
    }
  }
}

// reset each part
void reset(){
    background(0);
}