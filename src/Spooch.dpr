program Spooch;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  Gamolf.RTL.Scores in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Scores.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.MusicLoop.pas' {MusicLoop: TDataModule},
  cImgSpaceBackground in 'cImgSpaceBackground.pas' {cadImgSpaceBackground: TFrame},
  Gamolf.FMX.Joystick in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.Joystick.Windows in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.Joystick.Windows.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
