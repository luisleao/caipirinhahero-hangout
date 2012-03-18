import processing.serial.*;


String[] lines;

Timer timer_url;
Timer timer_seq;
int note_position = 0;
Serial comm;
boolean playing = true;



String nota_do;
String nota_re;
String nota_mi;
String nota_fa;
String nota_sol;
String nota_la;
String nota_si;


void get_update() {
  println("GETTING UPDATES...");
  try {
    lines = loadStrings("http://caipirinha-hangout.appspot.com/get/");
    
    for (int i=0; i<lines.length; i++) {
      String[] valores = lines[i].split("=");
      
      if (valores[0].equals("do")) nota_do = valores[1];
      if (valores[0].equals("re")) nota_re = valores[1];
      if (valores[0].equals("mi")) nota_mi = valores[1];
      if (valores[0].equals("fa")) nota_fa = valores[1];
      if (valores[0].equals("sol")) nota_sol = valores[1];
      if (valores[0].equals("la")) nota_la = valores[1];
      if (valores[0].equals("si")) nota_si = valores[1];
      
    }
  } catch(Exception ex) {
    println("ERRO HTTP");
  }

}


void setup() {
  println(Serial.list());
  comm = new Serial(this, Serial.list()[0], 57600); //"/dev/tty.usbmodem411"

  
  timer_url = new Timer(5000);
  timer_url.start();
  
  timer_seq = new Timer(250); //300 400
  timer_seq.start();


  
  get_update();
}

void draw() {
  
  if(playing && timer_seq.isFinished()) {
    print("PLAY: ");
    print(note_position);
    print(" ");
    
    print_music();
    put_music();
    
    note_position++;
    if (note_position >= 32) {
      get_update();
      note_position = 0;
    }
    timer_seq.start();
  }
  
}

void serialEvent(Serial myPort) {
  int inByte = myPort.read();
  print((char)inByte);
}


void put_music() {
    comm.write(nota_do.charAt(note_position));
    comm.write(nota_re.charAt(note_position));
    comm.write(nota_mi.charAt(note_position));
    comm.write(nota_fa.charAt(note_position));
    comm.write(nota_sol.charAt(note_position));
    comm.write(nota_la.charAt(note_position));
    comm.write(nota_si.charAt(note_position));
    comm.write('\n');

}

void print_music() {
  print(nota_do.charAt(note_position));
  print(nota_re.charAt(note_position));
  print(nota_mi.charAt(note_position));
  print(nota_fa.charAt(note_position));
  print(nota_sol.charAt(note_position));
  print(nota_la.charAt(note_position));
  print(nota_si.charAt(note_position));
  
  println();
}

void stop() {
  super.stop();
}

