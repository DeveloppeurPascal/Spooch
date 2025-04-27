unit uSpoochGameData;

interface

uses
  System.classes,
  uGameData,
  uClasses;

type
  TSpoochGameData = class(TGameData)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CSpoochGameDataVersion = 1;

  var
    FMissileJoueurList: TMissileJoueurList;
    FMissileMechantList: TMissileMechantList;
    FSpriteJoueur: TSpriteJoueur;
    FMechantsList: TMechantsList;
    procedure SetMechantsList(const Value: TMechantsList);
    procedure SetMissileJoueurList(const Value: TMissileJoueurList);
    procedure SetMissileMechantList(const Value: TMissileMechantList);
    procedure SetSpriteJoueur(const Value: TSpriteJoueur);
  public
    property MissileJoueurList: TMissileJoueurList read FMissileJoueurList
      write SetMissileJoueurList;
    property MissileMechantList: TMissileMechantList read FMissileMechantList
      write SetMissileMechantList;
    property MechantsList: TMechantsList read FMechantsList
      write SetMechantsList;
    property SpriteJoueur: TSpriteJoueur read FSpriteJoueur
      write SetSpriteJoueur;

    class function DefaultGameData: TGameData; override;
    class function Current: TSpoochGameData;
    procedure Clear; override;
    procedure InitGameScreen;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(const AStream: TStream); override;
    procedure SaveToStream(const AStream: TStream); override;
  end;

implementation

Uses
  System.SysUtils;

var
  LSpoochGameData: TSpoochGameData;

  { TSpoochGameData }

procedure TSpoochGameData.Clear;
begin
  inherited;
  InitGameScreen;
end;

constructor TSpoochGameData.Create;
begin
  inherited;

  FMechantsList := TMechantsList.Create;
  FMissileJoueurList := TMissileJoueurList.Create;
  FMissileMechantList := TMissileMechantList.Create;
  FSpriteJoueur := TSpriteJoueur.Create(nil);
end;

class function TSpoochGameData.Current: TSpoochGameData;
begin
  result := DefaultGameData as TSpoochGameData;
end;

class function TSpoochGameData.DefaultGameData: TGameData;
begin
  if not assigned(LSpoochGameData) then
    LSpoochGameData := TSpoochGameData.Create;

  result := LSpoochGameData;
end;

destructor TSpoochGameData.Destroy;
begin
  // TODO : corriger bogue de suppression des listes générant des anomalies en mémoire
  // FMechantsList.Free;
  // FMissileJoueurList.Free;
  // FMissileMechantList.Free;
  // FSpriteJoueur.Free;

  inherited;
end;

procedure TSpoochGameData.InitGameScreen;
begin
  FMissileJoueurList.Clear;
  FMissileMechantList.Clear;
  FSpriteJoueur.Clear;
  FMechantsList.Clear;
end;

procedure TSpoochGameData.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
begin
  inherited;

  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CSpoochGameDataVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    FMissileJoueurList.LoadFromStream(AStream);
    FMissileMechantList.LoadFromStream(AStream);
    FSpriteJoueur.LoadFromStream(AStream);
    FMechantsList.LoadFromStream(AStream);
  end;

  FHasChanged := false;
end;

procedure TSpoochGameData.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
begin
  inherited;

  VersionNum := CSpoochGameDataVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  FMissileJoueurList.SaveToStream(AStream);
  FMissileMechantList.SaveToStream(AStream);
  FSpriteJoueur.SaveToStream(AStream);
  FMechantsList.SaveToStream(AStream);
  FHasChanged := false;
end;

procedure TSpoochGameData.SetMechantsList(const Value: TMechantsList);
begin
  FMechantsList := Value;
end;

procedure TSpoochGameData.SetMissileJoueurList(const Value: TMissileJoueurList);
begin
  FMissileJoueurList := Value;
end;

procedure TSpoochGameData.SetMissileMechantList(const Value
  : TMissileMechantList);
begin
  FMissileMechantList := Value;
end;

procedure TSpoochGameData.SetSpriteJoueur(const Value: TSpriteJoueur);
begin
  FSpriteJoueur := Value;
end;

initialization

LSpoochGameData := nil;

finalization

LSpoochGameData.Free;

end.
