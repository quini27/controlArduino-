object configForm: TconfigForm
  Left = 579
  Top = 218
  BorderIcons = [biSystemMenu]
  Caption = 'Config. entrada-sa'#237'da'
  ClientHeight = 419
  ClientWidth = 324
  Color = clMoneyGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ValueListEditor1: TValueListEditor
    Left = 8
    Top = 8
    Width = 241
    Height = 305
    DropDownRows = 13
    GridLineWidth = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    ScrollBars = ssNone
    TabOrder = 0
    TitleCaptions.Strings = (
      'pin'
      'mode')
    ColWidths = (
      118
      117)
  end
  object OKConfigBtn: TBitBtn
    Left = 88
    Top = 320
    Width = 97
    Height = 33
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKConfigBtnClick
  end
end
