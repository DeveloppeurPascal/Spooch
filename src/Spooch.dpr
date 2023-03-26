program Spooch;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uMusicLoop in 'uMusicLoop.pas' {MusicLoop: TDataModule},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  u_scores in '..\lib-externes\FMXGameEngine\src\u_scores.pas',
  Gamolf.RTL.Scores in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Scores.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TMusicLoop, MusicLoop);
  Application.Run;
end.
