unit uMusic;

interface

implementation

uses
  System.SysUtils, System.IOUtils, uConfig, Gamolf.FMX.MusicLoop;

procedure Prechargement;
var
  Chemin, NomFichier: string;
begin
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  Chemin := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
{$IFDEF DEBUG}
  Chemin := '..\..\..\assets\GinnyCulp\';
{$ELSE}
  Chemin := extractfilepath(paramstr(0));
{$ENDIF}
{$ELSEIF defined(IOS)}
  // deploy in .\
  Chemin := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  Chemin := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
  Chemin := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
  NomFichier := tpath.combine(Chemin, 'traveller-1min20.mp3');
  tmusicloop.current.Load(NomFichier);
  tmusicloop.current.Volume := tconfig.MusiqueDAmbianceVolume;
end;

initialization

Prechargement;

end.
