unit cTextButton;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _ButtonsAncestor,
  FMX.Effects,
  FMX.Objects,
  Olf.FMX.TextImageFrame;

const
  CTextButtonWidth = 300;

type
  TcadTextButton = class(T__ButtonAncestor)
    rBackUp: TRectangle;
    rBackDown: TRectangle;
    ShadowEffect1: TShadowEffect;
    geHasFocus: TGlowEffect;
    txtDown: TOlfFMXTextImageFrame;
    txtUp: TOlfFMXTextImageFrame;
  private
    procedure Repaint; override;
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
  public
    procedure AfterConstruction; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_377613666;

{ TcadTextButton }

// TODO : prendre en charge les majuscules / minuscules de la typo

procedure TcadTextButton.AfterConstruction;
begin
  inherited;

  txtDown.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  txtDown.Font := dmAdobeStock_377613666.ImageList;

  txtUp.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
  txtUp.Font := dmAdobeStock_377613666.ImageList;
end;

constructor TcadTextButton.Create(AOwner: TComponent);
begin
  inherited;

  width := CTextButtonWidth;
end;

function TcadTextButton.GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
  AChar: char): integer;
begin
  result := Sender.getImageIndexOfChar(UpperCase(AChar));
end;

procedure TcadTextButton.Repaint;
begin
  if IsDown then
  begin
    rBackUp.Visible := false;
    rBackDown.Visible := true;
    txtDown.Height := rBackDown.Height - 16;
    txtDown.Text := Text;
  end
  else
  begin
    rBackDown.Visible := false;
    rBackUp.Visible := true;
    txtUp.Height := rBackUp.Height - 16;
    txtUp.Text := Text;
  end;
  geHasFocus.Enabled := IsFocused;
  if IsFocused then
  begin
    rBackUp.Stroke.Color := talphacolors.Darkblue;
    rBackDown.Stroke.Color := talphacolors.Darkblue;
  end
  else
  begin
    rBackUp.Stroke.Color := talphacolors.Darkslateblue;
    rBackDown.Stroke.Color := talphacolors.Darkslateblue;
  end;
end;

end.
