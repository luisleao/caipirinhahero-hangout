


#include <TimedAction.h>
#include <AccelStepper.h>
#include <Servo.h>



#define  TOTAL_SERVOS   7



#define TEMPO 100
#define TOTAL_SERVOS 8
#define ANGULO_ON 45 //45
#define ANGULO_OFF 60 //60

#define SERVO_PINO 5





#define TEMPO 100
#define PULSO 10



Servo servos[TOTAL_SERVOS];


char buffer[15];
int posicao = 0;

/*
PROTOCOLO:

  1: DO 1
  2: RE 1
  3: MI 1
  4: FA
  5: SOL
  6: LA
  7: SI
  
  
  0100100\n

*/



TimedAction t_reset_servo_0 = TimedAction(TEMPO, reset_servo_0);
TimedAction t_reset_servo_1 = TimedAction(TEMPO, reset_servo_1);
TimedAction t_reset_servo_2 = TimedAction(TEMPO, reset_servo_2);
TimedAction t_reset_servo_3 = TimedAction(TEMPO, reset_servo_3);
TimedAction t_reset_servo_4 = TimedAction(TEMPO, reset_servo_4);
TimedAction t_reset_servo_5 = TimedAction(TEMPO, reset_servo_5);
TimedAction t_reset_servo_6 = TimedAction(TEMPO, reset_servo_6);






  
void setup()
{

  reset_servo_0();
  reset_servo_1();
  reset_servo_2();
  reset_servo_3();
  reset_servo_4();
  reset_servo_5();
  reset_servo_6();

  for (int i=0; i<TOTAL_SERVOS; i++) {
    servos[i].attach(SERVO_PINO+i);
    servos[i].write(ANGULO_OFF);
  }

  
  Serial.begin(57600);

}

void ativa_do(){ t_reset_servo_0.reset(); t_reset_servo_0.enable(); servos[0].write(ANGULO_ON); }
void ativa_re(){ t_reset_servo_1.reset(); t_reset_servo_1.enable(); servos[1].write(ANGULO_ON); }
void ativa_mi(){ t_reset_servo_2.reset(); t_reset_servo_2.enable(); servos[2].write(ANGULO_ON); }
void ativa_fa(){ t_reset_servo_3.reset(); t_reset_servo_3.enable(); servos[3].write(ANGULO_ON); }
void ativa_sol(){ t_reset_servo_4.reset(); t_reset_servo_4.enable(); servos[4].write(ANGULO_ON); }
void ativa_la(){ t_reset_servo_5.reset(); t_reset_servo_5.enable(); servos[5].write(ANGULO_ON); }
void ativa_si(){ t_reset_servo_6.reset(); t_reset_servo_6.enable(); servos[6].write(ANGULO_ON); }





void loop()
{

  t_reset_servo_0.check();
  t_reset_servo_1.check();
  t_reset_servo_2.check();
  t_reset_servo_3.check();
  t_reset_servo_4.check();
  t_reset_servo_5.check();
  t_reset_servo_6.check();


  if (Serial.available()) {
    byte inByte = Serial.read();
    if (inByte == '\n') {
      buffer[posicao] = '\0';
      //Serial.println(buffer);
      if (posicao > 6) {
        
        if (buffer[0] == '1') { ativa_do(); /*Serial.print("DO ");*/ }
        if (buffer[1] == '1') { ativa_re(); /*Serial.print("RE ");*/ }
        if (buffer[2] == '1') { ativa_mi(); /*Serial.print("MI ");*/ }
        if (buffer[3] == '1') { ativa_fa(); /*Serial.print("FA ");*/ }
        if (buffer[4] == '1') { ativa_sol(); /*Serial.print("SOL ");*/ }
        if (buffer[5] == '1') { ativa_la(); /*Serial.print("LA ");*/ }
        if (buffer[6] == '1') { ativa_si(); /*Serial.print("SI ");*/ }
      }
      posicao = 0;
      //Serial.println();
      posicao = 0;
    } else if (inByte == '0' || inByte == '1') {
      buffer[posicao] = inByte;
      posicao++;
      //if (posicao == 7) {
        //Serial.println("EXECUTAR");
        
        //executar comandos
        //posicao = 0;
        
      //}
    }
    //Serial.println(" serial" );
  }



}













void reset_servo(int servo) {
  
  if (servo > TOTAL_SERVOS - 1)
    return;

  servos[servo].write(ANGULO_OFF);
  //servos[servo].detach();

}



void reset_servo_0() { t_reset_servo_0.disable(); reset_servo(0); }
void reset_servo_1() { t_reset_servo_1.disable(); reset_servo(1); }
void reset_servo_2() { t_reset_servo_2.disable(); reset_servo(2); }
void reset_servo_3() { t_reset_servo_3.disable(); reset_servo(3); }
void reset_servo_4() { t_reset_servo_4.disable(); reset_servo(4); }
void reset_servo_5() { t_reset_servo_5.disable(); reset_servo(5); }
void reset_servo_6() { t_reset_servo_6.disable(); reset_servo(6); }



