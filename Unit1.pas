unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CPortCtl, CPort, Menus, ExtCtrls, Buttons; //Vcl.Buttons, //so no RAD studio

type
  TForm1 = class(TForm)
    ComPort1: TComPort;
    ComLed1: TComLed;
    LabelCom: TLabel;
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    ConfigconexMenuItem: TMenuItem;
    AbrirconexMenuItem: TMenuItem;
    inoutMenuItem: TMenuItem;
    FecharconexMenuItem: TMenuItem;
    SobreMenuItem: TMenuItem;
    AjudaMenuItem: TMenuItem;
    SairMenuItem: TMenuItem;
    FixLabelio: TLabel;
    Label1: TLabel;
    Labelpin1: TLabel;
    Labelpin2: TLabel;
    Labelpin3: TLabel;
    Labelpin4: TLabel;
    Labelpin5: TLabel;
    Labelpin6: TLabel;
    Labelpin7: TLabel;
    Labelpin8: TLabel;
    Labelpin9: TLabel;
    Labelpin10: TLabel;
    Labelpin11: TLabel;
    Labelpin12: TLabel;
    Labelpin0: TLabel;
    Labelpin13: TLabel;
    led2: TShape;
    led3: TShape;
    led4: TShape;
    led5: TShape;
    led6: TShape;
    led7: TShape;
    led8: TShape;
    led9: TShape;
    led10: TShape;
    led11: TShape;
    led12: TShape;
    led13: TShape;
    LabelRx: TLabel;
    LabelTx: TLabel;
    EditPWM3: TEdit;
    EditPWM5: TEdit;
    EditPWM6: TEdit;
    EditPWM9: TEdit;
    EditPWM10: TEdit;
    EditPWM11: TEdit;
    Labelan0: TLabel;
    Labelan1: TLabel;
    Labelan2: TLabel;
    Labelan3: TLabel;
    Labelan4: TLabel;
    Labelan5: TLabel;
    Editan0: TEdit;
    Editan1: TEdit;
    Editan2: TEdit;
    Editan3: TEdit;
    Editan4: TEdit;
    Editan5: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    SBpwmsend3: TSpeedButton;
    SBpwmsend5: TSpeedButton;
    SBpwmsend6: TSpeedButton;
    SBpwmsend9: TSpeedButton;
    SBpwmsend10: TSpeedButton;
    SBpwmsend11: TSpeedButton;
    procedure ConfigconexMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SairMenuItemClick(Sender: TObject);
    procedure AbrirconexMenuItemClick(Sender: TObject);
    procedure FecharconexMenuItemClick(Sender: TObject);
    procedure AjudaMenuItemClick(Sender: TObject);
    procedure SobreMenuItemClick(Sender: TObject);
    procedure inoutMenuItemClick(Sender: TObject);
    procedure MostraDispIo;
    procedure CheckBox2Click(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure EditPWMClick(Sender: TObject);
    procedure SBpwmsendClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses aboutunit,unitpinmode;

{$R *.dfm}

{variável que guarda o modo de cada pino digital}
var pin: array [0..13] of (nada,entrada,saida,saidaPWM) = (nada,nada,nada,nada,nada,nada,nada,nada,nada,nada,nada,nada,nada,nada);

{Procedimentos da barra de menu}
(*****************************************************************************)
{Procedimento para configurar a conexão serial}
procedure TForm1.ConfigconexMenuItemClick(Sender: TObject);
begin
  Comport1.ShowSetupDialog;
  AbrirconexMenuItem.Enabled:=true;
  LabelCom.Caption:='Conectado à porta '+comport1.Port
end;


{Procedimento para abrir a conexão}
procedure TForm1.AbrirconexMenuItemClick(Sender: TObject);
begin
  try
    ComPort1.Open;
    if ComPort1.Connected then
      begin
        configconexMenuItem.Enabled:=false;
        abrirconexMenuItem.Enabled:=false;
        inoutMenuItem.Enabled:=true;
        fecharconexMenuItem.Enabled:=true;
        //ComLed1.State:=On;
        Memo1.Text:=Memo1.Text+'Comunicação serial conectada à porta '+Comport1.Port;
        Memo1.Lines.Add('')
      end
      else
      begin
        Memo1.Lines.Add('');
        Memo1.Text:=Memo1.Text+'Falha ao abrir a comunicação serial com porta '+ComPort1.port;
        Memo1.Lines.Add('')
      end
  Except on E : Exception do
      begin
         Memo1.Lines.Add('');
         Memo1.Text := Memo1.Text + 'ERRO ao abrir conexão: Detalhes> '+E.Message;
         Memo1.Lines.Add('')
      end
  end
end;

{Procedimento para encerrar a conexão}
procedure TForm1.FecharconexMenuItemClick(Sender: TObject);
begin
  //Esc encerra a conexão no Arduino
  ComPort1.WriteStr(chr(27));
  ComPort1.Close;
  if not ComPort1.Connected then
    begin
      ConfigconexMenuItem.Enabled:=true;
      abrirconexMenuItem.Enabled:=true;
      fecharconexMenuItem.Enabled:=false;
      inoutMenuItem.Enabled:=false;
      Memo1.Lines.Add('');
      Memo1.Text:=Memo1.Text+'Conexão serial encerrada com sucesso';
      //ComLed1.State:=isOff;
      Memo1.Lines.Add('')
    end
  else
    begin
      Memo1.Lines.Add('');
      Memo1.Text := Memo1.Text + 'Falha ao finalizar conexão serial.';
      Memo1.Lines.Add('')
    end
end;

{Procedimento de scroll down}
procedure TForm1.Memo1Change(Sender: TObject);
begin
  SendMessage(Memo1.Handle, EM_LINESCROLL, 0,Memo1.Lines.Count);
end;


(*****************************************************************************)
{Procedimentos para encerrar o programa}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ComPort1.Connected then
    begin
      //Esc encerra a conexão no Arduino
      ComPort1.WriteStr(chr(27));
      ComPort1.Close;
    end
end;




procedure TForm1.SairMenuItemClick(Sender: TObject);
begin
  if ComPort1.Connected then
    begin
      //Esc encerra a conexão no Arduino
      ComPort1.WriteStr(chr(27));
      ComPort1.Close;
    end;
    Close
end;



{Não há menu de ajuda}
procedure TForm1.AjudaMenuItemClick(Sender: TObject);
begin
  ShowMessage('Sem ajuda por enquanto')
end;

{Menu de sobre}
procedure TForm1.SobreMenuItemClick(Sender: TObject);
begin
  AboutBox.Visible:=true
end;

(*******************************************************************************)
(*******************************************************************************)
{Procedimento para mostrar os dispositivos de entrada e saída de dados das entradas
e saídas digitais, que são os check boxes onde setear os estados das saídas e as
janelas de edição onde mostrar os estados das saídas PWM. Feito isso envia os
comandos para o Arduino para setear o modo desses pinos.}


procedure TForm1.MostraDispIo;
var i:0..14;
   pinmode:array[0..1] of byte;
begin
  for i:=3 to 14 do
    with ConfigForm.ValueListEditor1 do
      begin
        if Values[Keys[i]]='entrada digital' then pin[i-1]:=entrada;
        if Values[Keys[i]]='saída digital' then pin[i-1]:=saida;
        if Values[Keys[i]]='saída PWM' then pin[i-1]:=saidaPWM;
      end;
  //mostra os dispositivos de input output necessários
  if pin[2]=saida then CheckBox2.Visible:=true;
  if pin[3]=saida then CheckBox3.Visible:=true;
  if pin[3]=saidaPWM then begin EditPWM3.Visible:=true; SBpwmsend3.Visible:=true; end;
  if pin[4]=saida then CheckBox4.Visible:=true;
  if pin[5]=saida then CheckBox5.Visible:=true;
  if pin[5]=saidaPWM then begin EditPWM5.Visible:=true; SBpwmsend5.Visible:=true; end;
  if pin[6]=saida then CheckBox6.Visible:=true;
  if pin[6]=saidaPWM then begin EditPWM6.Visible:=true; SBpwmsend6.Visible:=true; end;
  if pin[7]=saida then CheckBox7.Visible:=true;
  if pin[8]=saida then CheckBox8.Visible:=true;
  if pin[9]=saida then CheckBox9.Visible:=true;
  if pin[9]=saidaPWM then begin EditPWM9.Visible:=true; SBpwmsend9.Visible:=true; end;
  if pin[10]=saida then CheckBox10.Visible:=true;
  if pin[10]=saidaPWM then begin EditPWM10.Visible:=true; SBpwmsend10.Visible:=true; end;
  if pin[11]=saida then CheckBox11.Visible:=true;
  if pin[11]=saidaPWM then begin EditPWM11.Visible:=true; SBpwmsend11.Visible:=true; end;
  if pin[12]=saida then CheckBox12.Visible:=true;
  if pin[13]=saida then CheckBox13.Visible:=true;
  //envia os dados necessários para estabelecer o modo de cada pino
  //o primeiro byte é o número de porta em hexadecimal, o segundo é '0' (entrada) ou '1' (saída)
  for i:=2 to 13 do
    begin
      pinmode[0]:=i;
      if (pin[i]=saida) or (pin[i]=saidaPWM) then pinmode[1]:=ord('1')
        else if (pin[i]=entrada) then pinmode[1]:=ord('0')
          else pinmode[1]:=0;
      if (pinmode[1]<>0) then Comport1.Write(pinmode,2)
    end;
   //finalizado o envio dos comandos de modo de cada pin, envia 27
   ComPort1.WriteStr(chr(27))
end;


procedure TForm1.inoutMenuItemClick(Sender: TObject);
begin
  ConfigForm.Visible:=true;
  repeat Application.ProcessMessages until ConfigForm.Visible=false;   {dudas...}
  MostraDispIo;
  inoutMenuItem.Enabled:=false
end;


(*******************************************************************************)
{Procedimentos de entrada e saída de dados}

(*******************************************************************************)
{Procedimento que envia os comandos para acender/apagar uma saída digital}
{O comando é apenas um caracter entre 'A' e 'X' que indica porta e estado}
{Isto porque o Arduino parece ler errado quando se enviam dois caracteres}
procedure TForm1.CheckBox2Click(Sender: TObject);
var   pinmode:array[0..13] of byte;
      check:byte;
begin
   if sender=CheckBox2 then begin check:=2; if CheckBox2.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('A') else Comport1.WriteStr('B');
   if sender=CheckBox3 then begin check:=3; if CheckBox3.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('C') else Comport1.WriteStr('D');
   if sender=CheckBox4 then begin check:=4; if CheckBox4.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('E') else Comport1.WriteStr('F');
   if sender=CheckBox5 then begin check:=5; if CheckBox2.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('G') else Comport1.WriteStr('H');
   if sender=CheckBox6 then begin check:=6; if CheckBox6.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('I') else Comport1.WriteStr('J');
   if sender=CheckBox7 then begin check:=7; if CheckBox7.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('K') else Comport1.WriteStr('L');
   if sender=CheckBox8 then begin check:=8; if CheckBox8.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('M') else Comport1.WriteStr('N');
   if sender=CheckBox9 then begin check:=9; if CheckBox9.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('O') else Comport1.WriteStr('P');
   if sender=CheckBox10 then begin check:=10; if CheckBox10.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('Q') else Comport1.WriteStr('R');
   if sender=CheckBox11 then begin check:=11; if CheckBox11.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('S') else Comport1.WriteStr('T');
   if sender=CheckBox12 then begin check:=12; if CheckBox12.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('U') else Comport1.WriteStr('V');
   if sender=CheckBox13 then begin check:=13; if CheckBox13.Checked=true then pinmode[check]:=1 else pinmode[check]:=0 end; //Comport1.WriteStr('W') else Comport1.WriteStr('X')
   ComPort1.WriteStr(chr(ord('A')+1-pinmode[check]+(check-2)*2));
   case check of
   2: if CheckBox2.Checked=true then led2.Brush.Color:=clRed else led2.Brush.Color:=clWhite;
   3: if CheckBox3.Checked=true then led3.Brush.Color:=clRed else led3.Brush.Color:=clWhite;
   4: if CheckBox4.Checked=true then led4.Brush.Color:=clRed else led4.Brush.Color:=clWhite;
   5: if CheckBox5.Checked=true then led5.Brush.Color:=clRed else led5.Brush.Color:=clWhite;
   6: if CheckBox6.Checked=true then led6.Brush.Color:=clRed else led6.Brush.Color:=clWhite;
   7: if CheckBox7.Checked=true then led7.Brush.Color:=clRed else led7.Brush.Color:=clWhite;
   8: if CheckBox8.Checked=true then led8.Brush.Color:=clRed else led8.Brush.Color:=clWhite;
   9: if CheckBox9.Checked=true then led9.Brush.Color:=clRed else led9.Brush.Color:=clWhite;
   10: if CheckBox10.Checked=true then led10.Brush.Color:=clRed else led10.Brush.Color:=clWhite;
   11: if CheckBox11.Checked=true then led11.Brush.Color:=clRed else led11.Brush.Color:=clWhite;
   12: if CheckBox12.Checked=true then led12.Brush.Color:=clRed else led12.Brush.Color:=clWhite;
   13: if CheckBox13.Checked=true then led13.Brush.Color:=clRed else led13.Brush.Color:=clWhite;
   end
end;


(****************************************************************************************************)
{Procedimento que é chamado toda vez que um caracter chega ao buffer de entrada da transmissão serial}
{O stream enviado com dados de entradas digitais e analógicas pelo Arduino tem a forma:
T2.T3.T4.T5.T6.T7.T8.T9.TA.TB.TC.TD.U0..U1..U2..U3..U4..U5..Z
onde . é o valor da entrada digital (0 ou 1) e .. é o valor da entrada analógica (0 a 1023)}
{O grande problema é que o procedimento é chamado a qualquer momento depois de um dado ser enviado,
não necessariamente quando se envia o stream inteiro. Portanto quando se leem os dados do buffer posso
ter qualquer porção desse stream.
{Ler RxCount bytes. Revisar até achar um 'T'. Ler de a 3 bytes até achar um 'U'. Ler até outro 'U'
repetitivamente ou até um 'Z'}
procedure TForm1.ComPort1RxChar(Sender: TObject; Count: Integer);
var
    RxCount: Integer;
    RxStr: string;
    analogval: string;
    i:integer;
    j:byte;
begin
    RxCount := ComPort1.InputCount;

    //temporario para controlar a quantidade de bytes recebidos
    Memo1.Text := Memo1.Text + 'recebidos '+IntToStr(RxCount)+' bytes';
    Memo1.Lines.Add('');

    ComPort1.ReadStr(RxStr,RxCount);

    Memo1.Text:=Memo1.Text+RxStr;
    Memo1.Lines.Add('');

 {   if RxStr[1]='5' then         //estas 3 linhas funcionam!!!!
      if RxStr[2]='1' then led5.Brush.Color:=clRed
        else if RxStr[2]='0' then led5.Brush.Color:=clWhite;
  {  try
      TryStrToInt(RxStr[1],i) ;
    except on E : Exception do
      ShowMessage('error: '+E.Message)
    end;}
    j:=1;
    repeat
      while (not (RxStr[j] in ['T','U','Z'])) and (j<RxCount) do j:=j+1;  //acha um caracter 'T' ou 'U' ou 'Z'
      if RxStr[j]='T' then      //se for dado de entrada digital
        begin
          case RxStr[j+1] of
            '0'..'9': TryStrToInt(RxStr[j+1],i) ;            //i= número de entrada
            'A'..'F': i:=ord(RxStr[j+1])-55;
          end;
          if pin[i]=entrada then  //se ha alguma entrada digital
            begin
              if i=2 then if  RxStr[j+2]='1' then led2.Brush.Color:=clRed else led2.Brush.Color:=clWhite;
              if i=3 then if  RxStr[j+2]='1' then led3.Brush.Color:=clRed else led3.Brush.Color:=clWhite;
              if i=4 then if  RxStr[j+2]='1' then led4.Brush.Color:=clRed else led4.Brush.Color:=clWhite;
              if i=5 then if  RxStr[j+2]='1' then led5.Brush.Color:=clRed else led5.Brush.Color:=clWhite;
              if i=6 then if  RxStr[j+2]='1' then led6.Brush.Color:=clRed else led6.Brush.Color:=clWhite;
              if i=7 then if  RxStr[j+2]='1' then led7.Brush.Color:=clRed else led7.Brush.Color:=clWhite;
              if i=8 then if  RxStr[j+2]='1' then led8.Brush.Color:=clRed else led8.Brush.Color:=clWhite;
              if i=9 then if  RxStr[j+2]='1' then led9.Brush.Color:=clRed else led9.Brush.Color:=clWhite;
              if i=10 then if  RxStr[j+2]='1' then led10.Brush.Color:=clRed else led10.Brush.Color:=clWhite;
              if i=11 then if  RxStr[j+2]='1' then led11.Brush.Color:=clRed else led11.Brush.Color:=clWhite;
              if i=12 then if  RxStr[j+2]='1' then led12.Brush.Color:=clRed else led12.Brush.Color:=clWhite;
              if i=13 then if  RxStr[j+2]='1' then led13.Brush.Color:=clRed else led13.Brush.Color:=clWhite
            end;
          j:=j+3;
        end;
      if RxStr[j]='U' then  //se for dado de entrada analógica
          begin
            analogval:=''; i:=2;
            repeat analogval:=analogval+RxStr[j+i]; i:=i+1; until (RxStr[j+i]='U') or (RxStr[j+i]='Z') or (j+i>RxCount);
            if RxStr[j+1]='0' then Editan0.Text:=analogval;
            if RxStr[j+1]='1' then Editan1.Text:=analogval;
            if RxStr[j+1]='2' then Editan2.Text:=analogval;
            if RxStr[j+1]='3' then Editan3.Text:=analogval;
            if RxStr[j+1]='4' then Editan4.Text:=analogval;
            if RxStr[j+1]='5' then Editan5.Text:=analogval;
            j:=j+i
          end       
    until (RxStr[j]='Z') or (j>=RxCount)
end;

(********************************************************************************************)
{Procedimentos para estabelecer a saída PWM}
(********************************************************************************************)

{Procedimento para limpar a janela de texto}
procedure TForm1.EditPWMClick(Sender: TObject);
begin
  if sender=EditPWM3 then  EditPWM3.Text:='';
  if sender=EditPWM5 then  EditPWM5.Text:='';
  if sender=EditPWM6 then  EditPWM6.Text:='';
  if sender=EditPWM9 then  EditPWM9.Text:='';
  if sender=EditPWM10 then  EditPWM10.Text:='';
  if sender=EditPWM11 then  EditPWM11.Text:='';
end;



{Procedimento que é chamado quando clico no botão para enviar o dado PWM à saída}
procedure TForm1.SBpwmsendClick(Sender: TObject);
var  PWMout:array[0..1] of byte;
begin
   ComPort1.WriteStr('Y') ;
   if sender=SBpwmsend3 then  begin PWMout[0]:=3; PWMout[1]:=StrToInt(EditPWM3.Text) end;
   if sender=SBpwmsend5 then  begin PWMout[0]:=5; PWMout[1]:=StrToInt(EditPWM5.Text) end;
   if sender=SBpwmsend6 then  begin PWMout[0]:=6; PWMout[1]:=StrToInt(EditPWM6.Text) end;
   if sender=SBpwmsend9 then  begin PWMout[0]:=9; PWMout[1]:=StrToInt(EditPWM9.Text) end;
   if sender=SBpwmsend10 then begin PWMout[0]:=10; PWMout[1]:=StrToInt(EditPWM10.Text) end;
   if sender=SBpwmsend11 then begin PWMout[0]:=11; PWMout[1]:=StrToInt(EditPWM11.Text) end;
   if (PWMout[1]>=0) and (PWMout[1]<=255) then  Comport1.Write(PWMout,2)
end;

end.
