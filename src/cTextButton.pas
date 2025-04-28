/// <summary>
/// ***************************************************************************
///
/// Spooch
///
/// Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// A game developed as a FireMonkey project in Delphi.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://spooch.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Spooch
///
/// ***************************************************************************
/// File last update : 2025-04-27T16:56:32.000+02:00
/// Signature : cc644cb1e679a6a763f372de06254f1e6b88c9dd
/// ***************************************************************************
/// </summary>

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
