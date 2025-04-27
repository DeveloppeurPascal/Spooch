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
