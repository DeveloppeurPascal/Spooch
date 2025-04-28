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
/// File last update : 2025-04-27T15:25:48.000+02:00
/// Signature : ecbdd6dbfa81796978443ebf6bd301c68905e66f
/// ***************************************************************************
/// </summary>

unit cTitle;

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
  Olf.FMX.TextImageFrame;

type
  TcadTitle = class(TFrame)
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    procedure FrameResized(Sender: TObject);
  private
    procedure AfterConstruction; override;
  public
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_311048871;

{ TcadTitle }

procedure TcadTitle.AfterConstruction;
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_311048871.ImageList;
  OlfFMXTextImageFrame1.Height := Height - 10;
  OlfFMXTextImageFrame1.Text := 'SPOOCH';
end;

procedure TcadTitle.FrameResized(Sender: TObject);
begin
  OlfFMXTextImageFrame1.Height := Height - 10;
  OlfFMXTextImageFrame1.Text := 'SPOOCH';
end;

end.
