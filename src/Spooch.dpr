program Spooch;

uses
  FMX.Forms,
  FMX.Types,
  FMX.Skia,
  fMain in 'fMain.pas' {frmMain},
  uBruitages in 'uBruitages.pas',
  uConfig in 'uConfig.pas',
  uMusic in 'uMusic.pas',
  cImgSpaceBackground in 'cImgSpaceBackground.pas' {cadImgSpaceBackground: TFrame},
  JoystickManager in 'JoystickManager.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\FMXGameEngine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Joystick.pas',
  Gamolf.RTL.Scores in '..\lib-externes\FMXGameEngine\src\Gamolf.RTL.Scores.pas',
  iOSapi.GameController in '..\lib-externes\FMXGameEngine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\FMXGameEngine\src\Macapi.GameController.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  GlobalUseSkiaRasterWhenAvailable:=false;
  {$IFDEF MACOS}
  globalusemetal:=true;
  {$ENDIF}
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
