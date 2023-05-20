program Spooch;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  cImgSpaceBackground in 'cImgSpaceBackground.pas' {cadImgSpaceBackground: TFrame},
  JoystickManager in 'JoystickManager.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Scores.pas',
  iOSapi.GameController in '..\lib-externes\FMXGameEngine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\FMXGameEngine\src\Macapi.GameController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
