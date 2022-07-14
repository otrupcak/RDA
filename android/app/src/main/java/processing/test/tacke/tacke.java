package processing.test.tacke;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.sensors.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class tacke extends PApplet {



//promenljive
int krugX,krugY;
int r=20;
float nagib;
float osetljivost;
float jacina;
int no_krugX=9;
int no_krugY=6;
int krugH,krugS,krugB;

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

public void setup(){
  //pokretanje senzora
  sensor = new KetaiSensor(this);
  sensor.start();
  
  //definisanje okruzenja
  orientation(LANDSCAPE);
  
  background(0);
  
  ellipseMode(CENTER);
  colorMode(HSB);
  
  osetljivost=200*width/256;
}

public void draw(){
  
  background(0);
  
  //postavljanje tacki
  for(int i=0; i<no_krugX; i++){
    for(int j=0; j<no_krugY; j++){
      krugX=(width/(no_krugX+1))*(i+1);
      krugY=(height/(no_krugY+1))*(j+1);
      
      fill(0,255,(int)intezitet(krugX,krugY));
      ellipse(krugX,krugY,r,r);
    }
  }
  //println(accelerometerY);
}

public void onAccelerometerEvent(float x, float y, float z){
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

public float intezitet(int x, int y){
  if(accelerometerY<-5)
    nagib=0;
  else if(accelerometerY>5)
    nagib=width;
  else
    nagib=map(accelerometerY,-5,5,0,width);
  float udaljenost=abs(nagib-x);
  
  if (udaljenost>width-osetljivost){
    jacina=0;
  }
  else{
    jacina=map(udaljenost,0,width-osetljivost,255,0);
  }
  //println(accelerometerY);
  fill(100,255,255);
  textSize(20);
  //text(udaljenost,x+20,y);
  text(nf(jacina,1,0),x+50,y);
  text(nf(udaljenost,1,0),x+50,y+30);
  text(width-osetljivost,x+50,y+60);
  return(jacina);
}
  public void settings() {  fullScreen(); }
}
