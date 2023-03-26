program Spooch;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uMusicLoop in 'uMusicLoop.pas' {MusicLoop: TDataModule},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  uParam in 'uParam.pas',
  u_scores in 'u_scores.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TMusicLoop, MusicLoop);
  Application.Run;
end.
