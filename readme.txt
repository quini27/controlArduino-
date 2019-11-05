ControlArduino for Windows


The program ControlArduino is a program developed in the IDE RAD Studio Tokio 10.2. It let you control an Arduino board
through a user-friendly interface that allows you to configure the digital pins as digital inputs, digital outputs
or PWM outputs. After configuration, the IHM shows the state of the digital and analog inputs as well as allows 
set the state of the digital and PWM outputs.

Before using this program, the sketch delphicontrol3.ino must be downloaded on the Arduino board.
This sketch receives and sends information trhough the serial port stated at 9600 baud rate, 8 bits legth data, 1 stop bit, no parity.
At the beginning, it waits for commands to state the pins as digital inputs or outputs.
In the loop routine it sends a string Ti.Tj.Tk.U0..U1..U2..U3..U4..U5..Z
where i,j,k are the numbers of pin set as inputs, . is the state of the input: 0 or 1, in Ua, a is the number of analog input (0 to 5), 
and .. is the value of the analog input.
A SerialEvent function completes the sketch. This function receives a character between 'A' and 'X', that indicates the number of 
digital output and its state, they are defined by the calculation (int((char+1) / 2)-31 , char % 2). If a character 'Y' is sent,
another two bytes are expected, the first one indicates the number of PWM output and the second one its state, between 0 and 255.

The ControlArduino program is based on the use of the ComPort components, developed by Dejan Crnila, which serves to communicate the 
program via USB port. These components can be downloaded from https://sourceforge.net/projects/comport/files/
and they must be installed in the Delphi IDE to open and compile the source files. Otherwise the executable file for Windows
controlArduino.exe can be run directly. This program allows to configure the USB port to state the communication with the Arduino board,
to initiate the communication, to configure the digital pins as digital inputas, digital outuputs or PWM outputs and to close the connection.
During the execution of this file, users can see the state of the inputs as well as to state the outputs.
A memolog windows reports the received string and tha state of the connection.

Following the phlosophy of this program, it is easy to implement a control staregy in the computer, using the Arduino board as a mere 
input/output interface.