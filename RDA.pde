//RDA je aplikacija za android koja podatke sa akcelerometra prikazuje pomocu inteziteta osvetljenosti tacaka rasporedjenih
//u pravilnoj mrezi na ekranu. Ima tri moda rada, nagib po X osi, nagib po Y osi i prikaz nagiba po obe ose.
//Za prelazak sa jednog na drugi mod neophodno je dvaput kucnuti na ekran.
//Za pokretanje aplikacije neophodno je instalirati Android SDK za processing, ukljuciti developer options,
//omoguciti USB debugging i prikaciti telefon na racunar preko USB kabla.
//
//Ukljucivanje developer optins-a https://www.digitaltrends.com/mobile/how-to-get-developer-options-on-android/
//Processing for Android https://android.processing.org/
//Ketai biblioteka za pristup senzorima i upravljanje telefonom http://ketai.org/


import ketai.sensors.*;
import ketai.ui.*;

//promenljive
int krugX,krugY; //pozicija centra lampice
int r=20; //poluprecnik lampice
float nagibY,nagibX; //promenljiva za mapiranje podataka sa akcelerometra u koordinatni sistem ekrana
float osetljivost,osetljivostX,osetljivostY; //obuhvat upaljenih lampica 
float ink1=200; //promenljiva za definisanje osetljivosti
float dijagonala; //dijagonala ekrana
float jacina,jacinaY,jacinaX; //jacina signala koju emituje lampica za tri moda prikazivanja
int no_krugX=9; //broj krugova po sirini ekrana
int no_krugY=6; //broj krugova po visini ekrana
int kont1=1; //brojac za prikaz statistike
int kont2=1; //brojac za promenu moda prikaza
int a=2; //pomocni brojac za promenu moda prikaza

KetaiSensor sensor;
KetaiGesture gesture;
float accelerometerX, accelerometerY, accelerometerZ; //pomocne za prihvatanje podataka sa akcelerometra

void setup(){
  //pokretanje senzora
  sensor = new KetaiSensor(this);
  sensor.start();
  
  gesture = new KetaiGesture(this);
  
  //definisanje okruzenja
  orientation(LANDSCAPE);
  fullScreen();
  background(0);
  
  ellipseMode(CENTER);
  colorMode(HSB); 
}

void draw(){
  
  background(0);
  
  dijagonala=dist(0,0,width,height);
  osetljivostY=ink1*width/256;
  osetljivostX=ink1*height/256;
  osetljivost=ink1*dijagonala/256;
  
  //postavljanje tacki
  for(int i=0; i<no_krugX; i++){
    for(int j=0; j<no_krugY; j++){
      krugX=(width/(no_krugX+1))*(i+1);
      krugY=(height/(no_krugY+1))*(j+1);
      
      fill(0,255,(int)intezitet(krugX,krugY));
      ellipse(krugX,krugY,r,r);
    }
  }
}

float intezitet(int x, int y){
  
  //rotacija oko Y ose
  if(accelerometerY<-5)
    nagibY=0;
  else if(accelerometerY>5)
    nagibY=width;
  else
    nagibY=map(accelerometerY,-5,5,0,width);
  float udaljenostY=abs(nagibY-x);
  
  if (udaljenostY>width-osetljivostY){
    jacinaY=0;
  }
  else{
    jacinaY=map(udaljenostY,0,width-osetljivostY,255,0);
  }
  
  //rotacija oko X ose
  if(accelerometerX<-5)
    nagibX=0;
  else if(accelerometerX>5)
    nagibX=height;
  else
    nagibX=map(accelerometerX,-5,5,0,height);
  float udaljenostX=abs(nagibX-y);
  
  if (udaljenostX>height-osetljivostX){
    jacinaX=0;
  }
  else{
    jacinaX=map(udaljenostX,0,height-osetljivostX,255,0);
  }
  
  float udaljenost=dist(nagibY,nagibX,x,y);
  
  if(kont2==0)
    jacina=map(udaljenost,0,dijagonala-osetljivost,255,0);
  if(kont2==1)
    jacina=jacinaY;
  if(kont2==2)
    jacina=jacinaX;

  //stats for nerds on long tap
  if(kont1<0){
    fill(100,255,255);
    textSize(20);
    text(nf(jacina,3,1),x+50,y);
    text(ink1,x+50,y+30);
  }
  
  return(jacina); 
}

void onAccelerometerEvent(float x, float y, float z){
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

//promena obuhvata upaljenih lampica skupljanjem/sirenjem dva prsta na ekranu
void onPinch(float x, float y, float d)
{
  ink1 = constrain(ink1-d/7, 1, 255);
}

//promena moda rada sa duplim klikom na povrsini ekrana
void onDoubleTap(float x, float y)
{
  a++;
  kont2=abs(a)%3;
}

//prikaz podataka o jacini signala svake lampice i trenutne vrednosti obuhvata dugim klikom na ekran
void onLongPress(float x, float y)
{
  kont1*=-1;
}
