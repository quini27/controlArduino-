/*Basic program to communicate Arduino with a computer via USB serial port. It states the serial 
 * communication to 9600 baud rate, 8 data bits, no parity, 1 stop bit. 
 * Basically, the application permits a Delphi-based computer app to control the board, just as it were an 
 * interface
*/

int inpin=0;
char inmode=0;
char pinstatus[14];
boolean fim=false;
//The first part set the ports as INPUTS or OUTPUTS
void setup() {
  // put your setup code here, to run once:
  //set the comunication at 9600 baud rate, 8 data bits, no parity, 1 stop bit
  Serial.begin(9600,SERIAL_8N1);
  while (!Serial) {}; // wait for serial port to connect. Needed for native USB port only
  //First, the number of pin and the pinMode are read
  while (inpin!=27)                  //repeat until an Esc char
    {while (!Serial.available()){}; //wait for the first character that is the number of pin
     inpin=Serial.read();
     if (inpin!=27) 
        {while (!Serial.available()){};   //wait for the second char that is the mode of the pin
         inmode=Serial.read();
         if (inmode=='0') {pinMode(inpin,INPUT);}
         if (inmode=='1') {pinMode(inpin,OUTPUT);}
         pinstatus[inpin]=inmode;}
    }
}


//The main loop sends a string Ti.Tj.Tk.U0..U1..U2..U3..U4..U5..Z
//where i,j,k are the numbers of pin set as inputs, . is the state of the input: 0 or 1, in Ua, a is the number of analog input, and .. is the value of the analog input
word val;
byte i;
//String stringOne="";
void loop() {
  // put your main code here, to run repeatedly:
  if (!fim){
    //stringOne="";
    for (i=2;i<=13;i++)    
     if (pinstatus[i]=='0')  //only inputs must be sent because to read a PWM output clears the output. 
        {val = digitalRead(i); Serial.print('T'); Serial.print(i,HEX); Serial.print(val);}  //stringOne+='T'; stringOne+=String(i,HEX); stringOne+=val;} 
        
     for (i=0;i<=5;i++) {val = analogRead(i);  Serial.print('U'); Serial.print(i); Serial.print(val);}  //stringOne+='U'; stringOne+=i; stringOne+=val;} 
     //stringOne+='Z';
     Serial.print('Z');
     delay(500);}
}


/*
  SerialEvent occurs whenever a new data comes in the hardware serial RX. This
  routine is run between each time loop() runs, so using delay inside loop can
  delay response. Multiple bytes of data may be available.
*/
/*Aparentemente, independientemente de cuántos bytes o caracteres sean enviados, 
 * sólo el primero es leído correctamente. Eso también independe de la cantidad 
 * de lecturas hechas, sólo la primera lectura es válida. Inclusive puedo tener 
 * sólo una lectura  y enviar muchos bytes, que esa primera lectura es válida.
 * Por eso es enviado sólo un caracter entre 'A' y 'X' que indica qué salida es 
 * activada o desactivada.
 */
 /*Ultima modificación realizada para que lea dos bytes indicando el número y estado de salida PWM*/
 /*Os mesmos começam com o char Y*/

char inchar=0;
byte pwmout[2];
void serialEvent() {
  if (Serial.available()>0) {
    // get the new byte:
    inchar = Serial.read();
    if (inchar==27) {Serial.end(); fim=true;}
    else 
      if (inchar>='A' && inchar<='X') 
        digitalWrite(int((inchar+1) / 2)-31 , inchar % 2);
      else
        if (inchar=='Y') 
           {Serial.readBytes(pwmout, 2); analogWrite(pwmout[0],pwmout[1]);}
    }}
    
          /*if (inpin=='A') digitalWrite(2,HIGH);   //pesquisar (int((inpin+1) / 2) - 31 , inpin % 2
          if (inpin=='B') digitalWrite(2,LOW);
          if (inpin=='C') digitalWrite(3,HIGH);
          if (inpin=='D') digitalWrite(3,LOW);   
          if (inpin=='E') digitalWrite(4,HIGH);
          if (inpin=='F') digitalWrite(4,LOW);   
          if (inpin=='G') digitalWrite(5,HIGH);
          if (inpin=='H') digitalWrite(5,LOW);   
          if (inpin=='I') digitalWrite(6,HIGH);
          if (inpin=='J') digitalWrite(6,LOW);   
          if (inpin=='K') digitalWrite(7,HIGH);
          if (inpin=='L') digitalWrite(7,LOW);   
          if (inpin=='M') digitalWrite(8,HIGH);
          if (inpin=='N') digitalWrite(8,LOW);   
          if (inpin=='O') digitalWrite(9,HIGH);
          if (inpin=='P') digitalWrite(9,LOW);   
          if (inpin=='Q') digitalWrite(10,HIGH);
          if (inpin=='R') digitalWrite(10,LOW);   
          if (inpin=='S') digitalWrite(11,HIGH);
          if (inpin=='T') digitalWrite(11,LOW);   
          if (inpin=='U') digitalWrite(12,HIGH);
          if (inpin=='V') digitalWrite(12,LOW);   
          if (inpin=='W') digitalWrite(13,HIGH);
          if (inpin=='X') digitalWrite(13,LOW);}
  }}*/
