unit UnitPinMode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, Buttons;

type
  TconfigForm = class(TForm)
    ValueListEditor1: TValueListEditor;
    OKConfigBtn: TBitBtn;
    procedure OKConfigBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  configForm: TconfigForm;

implementation

{$R *.dfm}



procedure TconfigForm.OKConfigBtnClick(Sender: TObject);
begin
  configForm.Visible:=false
end;

procedure TconfigForm.FormCreate(Sender: TObject);
var i:0..13;
    ItensList, ItensList2:TStrings;
begin
  ItensList:=TStringList.Create; ItensList2:=TStringList.Create;
  ItensList.Text:='entrada digital'+chr(13)+'saída digital';
  ItensList2.Text:='entrada digital'+chr(13)+'saída digital'+chr(13)+'saída PWM';
  with ValueListEditor1 do
    begin
      for i:=0 to 13 do
        begin
          InsertRow('pin '+chr($20+$11*(i div 10))+chr($30+i mod 10),'',true);
          ItemProps[i].ReadOnly:=true;
          if i>1 then ItemProps[i].EditStyle:=esPickList;
          case i of
            2,4,7,8,12,13: ItemProps[i].PickList:=ItensList;
            3,5,6,9,10,11: ItemProps[i].PickList:=ItensList2;
          end;
        end;
      Cells[1,1]:='Rx'; Cells[1,2]:='Tx';
    end;
  ItensList.Free; ItensList2.Free
end;


end.
