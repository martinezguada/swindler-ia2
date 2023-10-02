
import fisica.*;
//img
PImage gatito;
PImage stars;
PImage pinches;
PImage colores;
PImage inicio;
PImage tiempo;
PImage ganar;
PImage dia;
PImage noche;
//world
FWorld world;
FDistanceJoint cadena;
FCompound pop;
FCompound cage;
FBox eje;
FCompound pinche;
//FLine trampolin;
float rotVal=0;
float angulo = 0;

int estado = 0;
boolean juegoEnCurso = false; // Variable para controlar si el juego está en curso
boolean juegoGanado = false;  

//variables de tiempo
ArrayList <FBody> Tiempo;

int tiempoInicial; // Almacena el tiempo inicial en milisegundos
int duracion = 90 * 1000; // Duración en milisegundos (90 segundos)

void setup() {
  size(1400, 1000);
  //img
  inicio= loadImage("inicio.jpg");
  tiempo= loadImage("perder.jpg");
  ganar= loadImage("ganar.jpg");
  dia= loadImage("dia.png");
  noche= loadImage("noche.png");

  Tiempo = new ArrayList();
  tiempoInicial = 0; // Guarda el tiempo actual en milisegundos
  smooth();

  Fisica.init(this);
  Fisica.setScale(10);

  world = new FWorld();
  //world.setEdges(0, 0, 500, 500);


  //
  // FLine trampolin = new FLine(100, 500, 200, 650);
  //trampolin.setStrokeWeight(5);
  // world.add(trampolin);
  //
  cage = createCage();

  cage.setStatic(true);
  cage.setPosition(250, 250);
  cage.setRotation(0);
  cage.setBullet(true);
  cage.setGrabbable(false);
  world.add(cage);
  //

  FBox eje = new FBox (1, 1);
  eje.setStatic(true);
  eje.setPosition(310, 150);
  world.add(eje);
  //
  gatito = loadImage("pj.png");
  FCircle pj = new FCircle(61);
  pj.attachImage(gatito);
  pj.setPosition(-350, 150);
  pj.setBullet(true);
  pj.setFriction(1);
  pj.setNoStroke();
  pj.setFillColor(color(#FF9203));
  pj.setName("pj");
  world.add(pj);
  //
  //  pinche = createPinche();
  //pinche.setStatic(true);
  // pinche.setPosition(400, 260);
  //pinche.setRotation(0);
  // pinche.setBullet(true);
  //pinche.setGrabbable(false);
  // pinche.setName("pinche");
  //  world.add(pinche);

  rectMode(CENTER);
  //
  /*
  cadena = new FDistanceJoint (eje, pj);
   cadena.setLength(380);
   cadena.setFrequency(2);
   world.add (cadena);
   */
  //
  stars = loadImage("star.png");
  FCircle star = new FCircle(60);
  star.attachImage(stars);
  star.setStatic(true);
  star.setPosition (180, -5);
  star.setGrabbable(false);
  star.setName("star");
  world.add(star);
  FCircle star2 = new FCircle(60);
  star2.attachImage(stars);
  star2.setStatic(true);
  star2.setPosition (180, 720);
  star2.setGrabbable(false);
  star2.setName("star");
  world.add(star2);
  FCircle star3 = new FCircle(60);
  star3.attachImage(stars);
  star3.setStatic(true);
  star3.setPosition (280, 210);
  star3.setGrabbable(false);
  star3.setName("ganar");
  world.add(star3);

  //pinche
  pinches= loadImage("pinche.png");

  FCircle pinche1 = new FCircle(20);
  pinche1.attachImage(pinches);
  pinche1.setStatic(true);
  pinche1.setPosition (160, 45);
  pinche1.setStroke(255, 0, 0);
  pinche1.setGrabbable(false);
  pinche1.setRotation(110);
  pinche1.setName("pinche");
  world.add(pinche1);

  FCircle pinche2 = new FCircle(20);
  pinche2.setStatic(true);
  pinche2.attachImage(pinches);
  pinche2.setPosition (200, 480);
  pinche2.setStroke(255, 0, 0);
  pinche2.setGrabbable(false);
  pinche2.setName("pinche");
  world.add(pinche2);

  FCircle pinche3 = new FCircle(20);
  pinche3.setStatic(true);
  pinche3.attachImage(pinches);
  pinche3.setPosition (225, 480);
  pinche3.setStroke(255, 0, 0);
  pinche3.setGrabbable(false);
  pinche3.setName("pinche");
  world.add(pinche3);

  FCircle pinche4 = new FCircle(20);
  pinche4.setStatic(true);
  pinche4.attachImage(pinches);
  pinche4.setPosition (10, 640);
  pinche4.setStroke(255, 0, 0);
  pinche4.setGrabbable(false);
  pinche4.setName("pinche");
  world.add(pinche4);

  FCircle pinche5 = new FCircle(20);
  pinche5.setStatic(true);
  pinche5.attachImage(pinches);
  pinche5.setPosition (500, 640);
  pinche5.setStroke(255, 0, 0);
  pinche5.setGrabbable(false);
  pinche5.setName("pinche");
  world.add(pinche5);
}


void draw() {

  background(255);

  switch (estado) {
  case 0: // Estado de inicio
    // Dibuja la imagen de inicio

    inicio.resize(1400, 1000);
    image(inicio, 0, 0);
    break;

  case 1: // Estado de juego
    dia.resize(1400,1000);
    image(dia, 0, 0);
    // Muestra el tiempo restante en la pantalla
    //iniciarJuego();
    int tiempoTranscurrido = millis() - tiempoInicial;

    // Calcula el tiempo restante
    int tiempoRestante = duracion - tiempoTranscurrido;

    // Convierte el tiempo restante a minutos y segundos
    int minutos = tiempoRestante / 60000;
    int segundos = (tiempoRestante % 60000) / 1000;
    textSize(30);
    textAlign(CENTER, CENTER);
    text(nf(minutos, 2) + ":" + nf(segundos, 2), 100, 40);
    fill(0);

    // Pantalla de perder
    if (tiempoRestante <= 0) {
      estado=2;
    }

    //angulo = radians(map( mouseX , 0 , width , -180 , 540 ));
    float gravedad = 900;

    float dx = gravedad * cos( -angulo+radians(90) );
    float dy = gravedad * sin( -angulo+radians(90) );

    fill(0);
    //text( dx+"   "+dy, 100, 100 );

    world.setGravity( dx, dy );
    world.step();


    translate( width/2, height/2 );
    rotate( angulo );
    scale(0.75);
    translate( -250, -250 );
    world.draw();
    break;

  case 2: // Estado de tiempo agotado
    tiempo.resize(1400, 1000);
    image(tiempo, 0, 0);
    //reiniciarJuego();
    break;

  case 3: // Estado de victoria
    ganar.resize(1400, 1000);
    image(ganar, 0, 0);
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(0); // Texto negro
    //text("Completaste el juego en " + nf(millis() - tiempoInicial), width / 2, height / 2);
    //reiniciarJuego();
    break;

  case 4: //pantalla de instrucciones
    textSize(32);
    textAlign(CENTER, CENTER);
    fill(0); // Texto negro
    dia.resize(1400,1000);
    image(dia, 0, 0);
    text("Usá las flechas de izquierda y derecha para rotar el canvas y mover al personaje", width / 2, height / 2);
    break;
  }
}

void contactStarted( FContact colision ) {
  FBody cuerpo1 = colision.getBody1();
  FBody cuerpo2 = colision.getBody2();

  if ( cuerpo1!=null && cuerpo2!=null ) {
    String nombre1 = cuerpo1.getName();
    String nombre2 = cuerpo2.getName();

    if ( nombre1!=null && nombre2!=null ) {
      //println("hola llegue aqui");
      if ( nombre1.equals( "pj" ) && nombre2.equals("star") ) {
        duracion += 15000;
        world.remove(cuerpo2);
      }
      if ( nombre1.equals( "pj" ) && nombre2.equals("pinche") ) {
        world.remove(cuerpo1);
        FCircle pj = new FCircle(40);
        pj.attachImage(gatito);
        pj.setPosition(100, 0);
        pj.setBullet(true);
        pj.setFriction(1);
        pj.setNoStroke();
        pj.setFillColor(color(#FF9203));
        pj.setName("pj");
        world.add(pj);
      }
      if ( nombre1.equals( "pj" ) && nombre2.equals("ganar") ) {
        estado=3;
      }
    }
  }
}

FCompound createCage() {

  FBox b1 = new FBox(10, 500); //derecha
  b1.setPosition(300, 0);
  b1.setFill(220, 175, 234);
  b1.setNoStroke();

  FBox b2 = new FBox(10, 500); //izq
  b2.setPosition(-300, 0);
  b2.setFill(220, 175, 234);
  b2.setNoStroke();

  FBox b3 = new FBox(601, 10); //abajo
  b3.setPosition(0, 246);
  b3.setFill(220, 175, 234);
  b3.setNoStroke();

  FBox b4 = new FBox(500, 10); //arriba
  b4.setPosition(55, -220);
  b4.setFill(220, 175, 234);
  b4.setNoStroke();

  FBox b5 = new FBox(270, 10); //medio vertical
  b5.setPosition(-175, -80);
  b5.setRotation(80);
  b5.setFill(220, 175, 234);
  b5.setNoStroke();

  FBox b6 = new FBox(280, 10); //medio horizontal
  b6.setPosition(-25, 50);
  b6.setFill(220, 175, 234);
  b6.setNoStroke();

  FBox b7 = new FBox(150, 10); //medio vertical chico
  b7.setPosition(105, -20);
  b7.setRotation(80);
  b7.setFill(220, 175, 234);
  b7.setNoStroke();

  FBox b8 = new FBox(150, 10); //medio horizontal chico
  b8.setPosition(25, -90);
  b8.setFill(220, 175, 234);
  b8.setNoStroke();

  FBox b9 = new FBox(1500, 10); //arriba
  b9.setPosition(-50, -410);
  b9.setFill(220, 175, 234);
  b9.setRestitution(1);
  b9.setNoStroke();

  FBox b10 = new FBox(810, 10); //abajo
  b10.setPosition(0, 400);
  b10.setFill(220, 175, 234);
  //b10.setRestitution(1);
  b10.setNoStroke();


  FBox b11 = new FBox(10, 800); //izq
  b11.setPosition(-400, 0);
  b11.setFill(220, 175, 234);
  b11.setRestitution(1);
  b11.setNoStroke();


  FBox b12 = new FBox(10, 700); //dere
  b12.setPosition(400, 50);
  b12.setFill(220, 175, 234);
  b12.setRestitution(1);
  b12.setNoStroke();


  FBox b13 = new FBox(10, 600); //vertical-izq2
  b13.setPosition(-800, -110);
  b13.setFill(220, 175, 234);
  //b13.setRestitution(2.5);
  b13.setNoStroke();

  FBox b14 = new FBox(280, 10); //medio horizontal2
  b14.setPosition(-540, -250);
  //b14.setFill(220, 175, 234);
  b14.setNoStroke();


  FBox b15 = new FBox(10, 200); //vertical-izq3
  b15.setPosition(-680, -150);
  b15.setFill(220, 175, 234);
  //b15.setRestitution(1.5);
  b15.setNoStroke();

  FBox b16 = new FBox(180, 10); //medio horizontal2
  b16.setPosition(-590, -50);
  b16.setFill(220, 175, 234);
  b16.setNoStroke();


  FBox b17 = new FBox(280, 10); //medio horizontal2
  b17.setPosition(-540, 50);
  b17.setFill(220, 175, 234);
  b17.setNoStroke();

  FBox b18 = new FBox(280, 10); //medio horizontal2
  b18.setPosition(-660, 190);
  b18.setFill(220, 175, 234);
  b18.setNoStroke();

  FBox b20 = new FBox(10, 320); //vertical-izq3
  b20.setPosition(-600, 350);
  b20.setFill(220, 175, 234);
  //b20.setRestitution(2.5);
  b20.setNoStroke();

  FBox b21 = new FBox(1300, 10); //abajo
  b21.setPosition(50, 510);
  b21.setFill(220, 175, 234);
  //b21.setRestitution(2.5);
  b21.setNoStroke();

  FBox b22 = new FBox(10, 930); //vertical-izq3
  b22.setPosition(700, 50);
  b22.setFill(220, 175, 234);
  //b22.setRestitution(2.5);
  b22.setNoStroke();
  FBox b23 = new FBox(200, 10); //medio horizontal2
  b23.setPosition(600, 190);
  b23.setFill(220, 175, 234);
  b23.setNoStroke();

  FBox b24 = new FBox(200, 10); //medio horizontal2
  b24.setPosition(500, -300);
  b24.setFill(220, 175, 234);
  b24.setNoStroke();

  //trampolin
  FBox t1 = new FBox(200, 5);
  t1.setRotation(180);
  t1.setPosition(-240, 170);
  t1.setRestitution(2.5);
  t1.setFill(220, 175, 234);
  t1.setNoStroke();
  FBox t2 = new FBox(40, 10); //abajo
  t2.setPosition(280, 230);
  t2.setRotation(-180);
  t2.setFill(220, 175, 234);
  t2.setRestitution(2.5);
  t2.setNoStroke();

  FCompound result = new FCompound();
  result.addBody(b1);
  result.addBody(b2);
  result.addBody(b3);
  result.addBody(b4);
  result.addBody(b5);
  result.addBody(b6);
  result.addBody(b7);
  result.addBody(b8);
  result.addBody(b9);
  result.addBody(b10);
  result.addBody(b11);
  result.addBody(b12);
  result.addBody(b13);
  result.addBody(b14);
  result.addBody(b15);
  result.addBody(b16);
  result.addBody(b17);
  result.addBody(b18);
  result.addBody(b20);
  result.addBody(b21);
  result.addBody(b22);
  result.addBody(b23);
  result.addBody(b24);
  //result.addBody(b25);
  result.addBody(t1);
  result.addBody(t2);
  return result;
}
FCompound createPinche() {

  //pinche 1
  FBox p1 = new FBox(50, 10); //derecha
  p1.setRotation(180);
  p1.setPosition(0, 200);
  p1.setFill(0);
  p1.setNoStroke();

  FBox p2 = new FBox(50, 10); //izq
  p2.setRotation(-180);
  p2.setPosition(-25, 200);
  p2.setFill(0);
  p2.setNoStroke();

  FBox p3 = new FBox(60, 10); //abajo
  p3.setPosition(-13, 225);
  p3.setFill(0);
  p3.setNoStroke();

  FCompound result = new FCompound();

  result.addBody(p1);
  result.addBody(p2);
  result.addBody(p3);

  return result;
}
/*
void iniciarJuego() {

  estado = 1; // Cambia al estado de juego
  tiempoInicial = millis(); // Restablece el tiempo inicial
  juegoEnCurso = true; // Marca que el juego está en curso
}

void reiniciarJuego() {

  estado = 0; // Cambia de nuevo al estado de inicio
  juegoEnCurso = false; // Marca que el juego no está en curso
  juegoGanado = false; // Reinicia el estado de ganar
  tiempoInicial = millis(); // Restablece el tiempo inicial
}
*/
void mouseClicked() {
  switch (estado) {
  case 0:
    if (mouseX > 1090 - 200 && mouseX < 1090 + 200 && mouseY > 700 - 100 && mouseY < 700 + 100) {
      // Si el clic está dentro del rectángulo, empieza juego
      estado=1;
      println("Juego");
    }
    if (mouseX > 1130 - 200 && mouseX < 1130 + 200 && mouseY > 180 - 100 && mouseY < 180 + 100) {
      // Si el clic está dentro del rectángulo, empieza juego
      estado=4;
      println("Juego");
    }
    break;
  case 1:
    //No hay interacción del mouse
    break;
  case 2:
    //Estado de Perder
    estado=1;
    println("Juego");
    break;

  case 3:
    //estado de Victoria
    estado=1;
    println("Juego");
    break;

  case 4:
    //estado de Instrucciones
    estado=1;
    break;
  }
}

void keyPressed() {
  if ( keyPressed ) {
    float paso = radians( 3 );
    if ( keyCode == LEFT ) {
      angulo -= paso;
    } else if ( keyCode == RIGHT ) {
      angulo += paso;
    }
  }
}
