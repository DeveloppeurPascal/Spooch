unit uMusic;

interface

uses Gamolf.FMX.MusicLoop;

type
  TMusiques = class
  private
    class function getAmbiance: tmusicloop; static;
  protected
    class var fAmbiance: tmusicloop;
  public
    class property Ambiance: tmusicloop read getAmbiance;
  end;

implementation

uses

  System.SysUtils, System.IOUtils, FMX.forms, uConfig;

{ TMusiques }

class function TMusiques.getAmbiance: tmusicloop;
var
  NomFichier: string;
begin
  if not assigned(fAmbiance) then
  begin
    fAmbiance := tmusicloop.current;
{$IF defined(ANDROID)}
    // deploy in .\assets\internal\
    NomFichier := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
    // deploy in ;\
{$IFDEF DEBUG}
    NomFichier := '..\..\..\assets\GinnyCulp\';
{$ELSE}
    NomFichier := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
    // deploy in .\
    NomFichier := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
    // deploy in Contents\MacOS
    NomFichier := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
    NomFichier := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
    NomFichier := tpath.combine(NomFichier, 'traveller-1min20.mp3');
    fAmbiance.Load(NomFichier);
    fAmbiance.Volume := tconfig.MusiqueDAmbianceVolume;
  end;
  result := fAmbiance;
end;

initialization

TMusiques.fAmbiance := nil;

finalization

if assigned(TMusiques.fAmbiance) then
  TMusiques.fAmbiance.Free;

end.
