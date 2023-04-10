unit uBruitages;

interface

type
{$SCOPEDENUMS ON}
  TTypeBruitage = (ExplosionJoueur, ExplosionVaisseauEnnemi,
    ExplosionTirEnnemi);
{$SCOPEDENUMS OFF}
procedure JouerBruitage(TypeBruitage: TTypeBruitage);
procedure CouperLesBruitages;

implementation

uses system.IOutils, uConfig, Gamolf.fmx.MusicLoop;

procedure JouerBruitage(TypeBruitage: TTypeBruitage);
begin
  if TConfig.BruitagesOnOff then
  begin
    tsoundlist.Current.Volume := TConfig.BruitagesVolume;
    tsoundlist.Current.Play(ord(TypeBruitage));
  end;
end;

procedure CouperLesBruitages;
begin
  tsoundlist.Current.MuteAll;
end;

{ TBruitage }

procedure Prechargement;
var
  Chemin, NomFichier: string;
  TypeBruitage: TTypeBruitage;
begin
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  Chemin := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
{$IFDEF DEBUG}
  Chemin := '..\..\..\assets\TheGameCreators\SoundMatter';
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
  for TypeBruitage := low(TTypeBruitage) to high(TTypeBruitage) do
  begin
    case TypeBruitage of
      TTypeBruitage.ExplosionJoueur:
        NomFichier := tpath.combine(Chemin, 'BlastSoft.wav');
      TTypeBruitage.ExplosionVaisseauEnnemi:
        NomFichier := tpath.combine(Chemin, 'ExploSimple.wav');
      TTypeBruitage.ExplosionTirEnnemi:
        NomFichier := tpath.combine(Chemin, 'ExploMetallic.wav');
    else
      exit;
    end;
    tsoundlist.Current.add(ord(TypeBruitage), NomFichier);
  end;
end;

initialization

Prechargement;

end.
