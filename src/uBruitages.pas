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

uses system.IOutils, system.SysUtils, system.Threading, uConfig,
  classes, system.Generics.Collections, fmx.forms, Gamolf.fmx.MusicLoop;

type
  TBruitage = class(tmusicloop)
  private
    FTypeBruitage: TTypeBruitage;
    procedure SetTypeBruitage(const Value: TTypeBruitage);
  public
    property TypeBruitage: TTypeBruitage read FTypeBruitage
      write SetTypeBruitage;
  end;

  TBruitagesListe = TObjectList<TBruitage>;

var
  ListeDeSons: TBruitagesListe;

function AjouteSon(TypeBruitage: TTypeBruitage): TBruitage;
begin
  result := TBruitage.Create; // TODO : remplacer par TSoundList
  try
    result.TypeBruitage := TypeBruitage;
    ListeDeSons.Add(result);
  except
    result.free;
    result := nil;
  end;
end;

procedure Prechargement;
var
  TypeBruitage: TTypeBruitage;
begin
  for TypeBruitage := low(TTypeBruitage) to high(TTypeBruitage) do
    AjouteSon(TypeBruitage);
end;

procedure JouerBruitage(TypeBruitage: TTypeBruitage);
var
  son: TBruitage;
begin
  if TConfig.BruitagesOnOff then
  begin
    if (ListeDeSons.Count > 0) then
      for son in ListeDeSons do
        if (son.TypeBruitage = TypeBruitage) and (not son.IsPlaying) then
        begin
          son.Volume := TConfig.BruitagesVolume;
          son.PlaySound;
          exit;
        end;
    son := AjouteSon(TypeBruitage);
    if assigned(son) then
    begin
      son.Volume := TConfig.BruitagesVolume;
      son.PlaySound;
    end;
  end;
end;

procedure CouperLesBruitages;
var
  son: TBruitage;
begin
  if (ListeDeSons.Count > 0) then
    for son in ListeDeSons do
      son.stop;
end;

{ TBruitage }

procedure TBruitage.SetTypeBruitage(const Value: TTypeBruitage);
var
  NomFichier: string;
begin
  FTypeBruitage := Value;
{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  NomFichier := tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
{$IFDEF DEBUG}
  NomFichier := '..\..\..\assets\TheGameCreators\SoundMatter';
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
{$MESSAGE FATAL 'OS non support�'}
{$ENDIF}
  case TypeBruitage of
    TTypeBruitage.ExplosionJoueur:
      NomFichier := tpath.combine(NomFichier, 'BlastSoft.wav');
    TTypeBruitage.ExplosionVaisseauEnnemi:
      NomFichier := tpath.combine(NomFichier, 'ExploSimple.wav');
    TTypeBruitage.ExplosionTirEnnemi:
      NomFichier := tpath.combine(NomFichier, 'ExploMetallic.wav');
  else
    exit;
  end;
  Load(NomFichier);
end;

initialization

ListeDeSons := TBruitagesListe.Create;
Prechargement;

finalization

ListeDeSons.free;

end.
