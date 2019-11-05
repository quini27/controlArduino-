program controlArduino;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  aboutunit in 'aboutunit.pas' {AboutBox},
  UnitPinMode in 'UnitPinMode.pas' {configForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Delphi controls Arduino';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TconfigForm, configForm);
  Application.Run;
end.
