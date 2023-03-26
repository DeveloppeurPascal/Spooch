program Spooch;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uMusicLoop in 'uMusicLoop.pas' {MusicLoop: TDataModule},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  u_scores in 'u_scores.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TMusicLoop, MusicLoop);
  Application.Run;
end.
