/// <summary>
/// ***************************************************************************
///
/// Spooch
///
/// Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// A game developed as a FireMonkey project in Delphi.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://spooch.gamolf.fr/
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Spooch
///
/// ***************************************************************************
/// File last update : 2025-04-27T19:39:46.000+02:00
/// Signature : 7eecb9f7d89fdc08b379dce73d8587a27d490770
/// ***************************************************************************
/// </summary>

unit uClasses;

interface

uses
  FMX.Types,
  FMX.Objects,
  FMX.Ani,
  System.Generics.Collections,
  System.Classes;

type
  TSpriteJoueur = class(TRectangle)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;

  var
    FVX: single;
    procedure SetVX(const Value: single);
  protected
    FAni: TBitmapListAnimation;
  public
    property VX: single read FVX write SetVX;
    procedure Initialise(AParent: TFMXObject; AX, AY, AVX: single);
    procedure Clear;
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    constructor Create(AOwner: TComponent); override;
  end;

  TMissileJoueur = class(TRectangle)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;

  var
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: TFMXObject; AX, AY, AVX, AVY: single);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
  end;

  TMissileJoueurList = class(TObjectList<TMissileJoueur>)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;
  public
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
  end;

  TMissileMechant = class(TRectangle)
  private
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;

  var
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: TFMXObject; AX, AY, AVX, AVY: single);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
    constructor Create(AOwner: TComponent); override;
  end;

  TMissileMechantList = class(TObjectList<TMissileMechant>)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;
  public
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
  end;

  TMechant = class(TRectangle)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;

  var
    FVX: single;
    FVY: single;
    FShipType: Byte;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
    function GetShipType: Byte;
    procedure SetShipType(const Value: Byte);
  protected
    ATire: boolean;
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    property ShipType: Byte read GetShipType write SetShipType;
    procedure Initialise(AParent: TFMXObject); overload;
    procedure Initialise(AParent: TFMXObject;
      AX, AY, AVX, AVY: single); overload;
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    procedure LanceUnMissile(VYVaisseau: single; AParent: TFMXObject);
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
    constructor Create(AOwner: TComponent); override;
  end;

  TMechantsList = class(TObjectList<TMechant>)
  private const
    /// <summary>
    /// Version level of this class. It is used to check compatibility between
    /// the program and the files it saves or tries to load.
    /// </summary>
    CVersion = 1;
  public
    procedure LoadFromStream(const AStream: TStream); virtual;
    procedure SaveToStream(const AStream: TStream); virtual;
  end;

implementation

uses
  System.SysUtils,
  System.Types,
  FMX.Controls,
  FMX.Graphics,
  uConsts,
  uSVGBitmapManager_InputPrompts,
  USVGKenneyShips,
  uGameData,
  cSpritesheetExplosion,
  uSoundEffects,
  uScene,
  uSpoochGameData,
  uSceneBackground;

{ TMissileJoueur }

procedure TMissileJoueur.Deplace;
begin
  if Tag = -1 then
    exit;
  Position.Point := pointf(Position.X + VX, Position.Y + VY);
  if (Position.X + width < 0) or (Position.X > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    Tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        TSpoochGameData.Current.MissileJoueurList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileJoueur.FaitExploser;
var
  Ani: TBitmapListAnimation;
begin
  Tag := -1;
  Ani := TBitmapListAnimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign(TcadSpritesheetExplosion.GetBitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  // Ne pas faire de son, s'il explose, autre chose explose aussi
  // TSoundEffects.Current.Play(TSoundEffectType.PlayerMissileExplode);
end;

procedure TMissileJoueur.GereCollision;
var
  Ennemi: TMechant;
  missile: TMissileMechant;
  Collision: boolean;
begin
  if Tag = -1 then
    exit;

  Collision := false;

  // collision avec ennemis
  if (TSpoochGameData.Current.MechantsList.Count > 0) then
    for Ennemi in TSpoochGameData.Current.MechantsList do
      if (Ennemi.Tag = 0) and IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        TSpoochGameData.Current.Score := TSpoochGameData.Current.Score + 100;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (TSpoochGameData.Current.MissileMechantList.Count > 0) then
      for missile in TSpoochGameData.Current.MissileMechantList do
        if (missile.Tag = 0) and IntersectRect(BoundsRect, missile.BoundsRect)
        then
        begin
          Collision := true;
          TSpoochGameData.Current.Score := TSpoochGameData.Current.Score + 10;
          missile.FaitExploser;
          break;
        end;
  end;

  // Si collision, on explose
  if Collision then
    FaitExploser;
end;

procedure TMissileJoueur.Initialise(AParent: TFMXObject;
AX, AY, AVX, AVY: single);
begin
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  width := 9; // TODO : player missile size
  height := 37;
  fill.Bitmap.Bitmap.assign(getBitmapFromSVG(TSVGKenneyShipsIndex.PlayerMissile,
    width, height, fill.Bitmap.Bitmap.BitmapScale));
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(AX, AY);
  VX := AVX;
  VY := AVY;
  if not TSpoochGameData.Current.MissileJoueurList.contains(self) then
    TSpoochGameData.Current.MissileJoueurList.Add(self);
end;

procedure TMissileJoueur.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y: integer;
begin
  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(X) <> AStream.read(X, sizeof(X))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(Y) <> AStream.read(Y, sizeof(Y))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(FVX) <> AStream.read(FVX, sizeof(FVX))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(FVY) <> AStream.read(FVY, sizeof(FVY))) then
      raise exception.Create('Wrong File format !');
    Initialise(TSceneBackground.GetInstance, X, Y, FVX, FVY);
  end;
end;

procedure TMissileJoueur.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y: single;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  X := Position.X;
  AStream.Write(X, sizeof(X));
  Y := Position.Y;
  AStream.Write(Y, sizeof(Y));
  AStream.Write(FVX, sizeof(FVX));
  AStream.Write(FVY, sizeof(FVY));
end;

procedure TMissileJoueur.SetVX(const Value: single);
begin
  FVX := Value;
end;

procedure TMissileJoueur.SetVY(const Value: single);
begin
  FVY := Value;
end;

procedure TMissileJoueur.SupprimeApresExplosion(Sender: TObject);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      TSpoochGameData.Current.MissileJoueurList.Remove(self)
    end);
end;

{ TMissileMechant }

constructor TMissileMechant.Create(AOwner: TComponent);
begin
  inherited;
  FVX := 0;
  FVY := 0;
end;

procedure TMissileMechant.Deplace;
begin
  if Tag = -1 then
    exit;
  Position.Point := pointf(Position.X + VX, Position.Y + VY);
  if (Position.X + width < 0) or (Position.X > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    Tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        TSpoochGameData.Current.MissileMechantList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileMechant.FaitExploser;
var
  Ani: TBitmapListAnimation;
begin
  Tag := -1;
  Ani := TBitmapListAnimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign(TcadSpritesheetExplosion.GetBitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  TSoundEffects.Current.Play(TSoundEffectType.InvadersMissileExplode);
end;

procedure TMissileMechant.GereCollision;
var
  Ennemi: TMechant;
  missile: TMissileMechant;
  Collision: boolean;
begin
  if Tag = -1 then
    exit;

  Collision := false;

  // collision avec ennemis
  if (TSpoochGameData.Current.MechantsList.Count > 0) then
    for Ennemi in TSpoochGameData.Current.MechantsList do
      if (TagObject <> Ennemi) and (Ennemi.Tag = 0) and
        IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        TSpoochGameData.Current.Score := TSpoochGameData.Current.Score + 150;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (TSpoochGameData.Current.MissileMechantList.Count > 0) then
      for missile in TSpoochGameData.Current.MissileMechantList do
        if (missile <> self) and (missile.Tag = 0) and
          IntersectRect(BoundsRect, missile.BoundsRect) then
        begin
          Collision := true;
          TSpoochGameData.Current.Score := TSpoochGameData.Current.Score + 15;
          missile.FaitExploser;
          break;
        end;
  end;

  // collision avec le joueur
  if (not Collision) and TSpoochGameData.Current.isplaying then
  begin
    if (TSpoochGameData.Current.SpriteJoueur.Visible) and
      (TSpoochGameData.Current.SpriteJoueur.Tag = 0) and
      IntersectRect(BoundsRect, TSpoochGameData.Current.SpriteJoueur.BoundsRect)
    then
    begin
      Collision := true;
      TSpoochGameData.Current.NbLives := TSpoochGameData.Current.NbLives - 1;
      if (TSpoochGameData.Current.NbLives < 1) then
      begin
        TSpoochGameData.Current.StopGame;
        TScene.Current := tscenetype.GameOver;
      end;
    end;
  end;

  // Si collision, on explose
  if Collision then
    FaitExploser;
end;

procedure TMissileMechant.Initialise(AParent: TFMXObject;
AX, AY, AVX, AVY: single);
begin
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  width := 13; // TODO : invader missile size
  height := 37;
  fill.Bitmap.Bitmap.assign
    (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderMissile, width, height,
    fill.Bitmap.Bitmap.BitmapScale));
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(AX, AY);
  VX := AVX;
  VY := AVY;
  if not TSpoochGameData.Current.MissileMechantList.contains(self) then
    TSpoochGameData.Current.MissileMechantList.Add(self);
end;

procedure TMissileMechant.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y, VX, VY: single;
begin
  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(X) <> AStream.read(X, sizeof(X))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(Y) <> AStream.read(Y, sizeof(Y))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(VX) <> AStream.read(VX, sizeof(VX))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(VY) <> AStream.read(VY, sizeof(VY))) then
      raise exception.Create('Wrong File format !');
    Initialise(TSceneBackground.GetInstance, X, Y, VX, VY);
  end;
end;

procedure TMissileMechant.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y: single;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  X := Position.X;
  AStream.Write(X, sizeof(X));
  Y := Position.Y;
  AStream.Write(Y, sizeof(Y));
  AStream.Write(FVX, sizeof(FVX));
  AStream.Write(FVY, sizeof(FVY));
end;

procedure TMissileMechant.SetVX(const Value: single);
begin
  FVX := Value;
end;

procedure TMissileMechant.SetVY(const Value: single);
begin
  FVY := Value;
end;

procedure TMissileMechant.SupprimeApresExplosion(Sender: TObject);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      TSpoochGameData.Current.MissileMechantList.Remove(self)
    end);
end;

{ TMechant }

constructor TMechant.Create(AOwner: TComponent);
begin
  inherited;
  FVX := 0;
  FVY := 0;
  FShipType := 0;
  ATire := false;
end;

procedure TMechant.Deplace;
begin
  if Tag = -1 then
    exit;
  Position.Point := pointf(Position.X + VX, Position.Y + VY);
  if (Position.X + width < 0) or (Position.X > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    Tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        TSpoochGameData.Current.MechantsList.Remove(self)
      end);
  end
  else
    GereCollision;

  if (not TSpoochGameData.Current.isplaying) then
  begin
    if (random(100) < 10) and (not ATire) then
    begin
      ATire := true;
      LanceUnMissile(VY, parent);
    end;
  end
  else if (not(Tag = -1)) and
    (Position.X < TSpoochGameData.Current.SpriteJoueur.Position.X +
    TSpoochGameData.Current.SpriteJoueur.width) and
    (Position.X + width > TSpoochGameData.Current.SpriteJoueur.Position.X) then
  begin
    if (not ATire) then
    begin
      ATire := true;
      LanceUnMissile(VY, parent);
    end;
  end
  else
    ATire := false;
end;

procedure TMechant.FaitExploser;
var
  Ani: TBitmapListAnimation;
begin
  Tag := -1;
  Ani := TBitmapListAnimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign(TcadSpritesheetExplosion.GetBitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  TSoundEffects.Current.Play(TSoundEffectType.InvadersExplode);
end;

procedure TMechant.GereCollision;
var
  Collision: boolean;
begin
  if Tag = -1 then
    exit;

  // collision avec le joueur
  if TSpoochGameData.Current.isplaying then
  begin
    Collision := (TSpoochGameData.Current.SpriteJoueur.Visible) and
      (TSpoochGameData.Current.SpriteJoueur.Tag = 0) and
      IntersectRect(BoundsRect,
      TSpoochGameData.Current.SpriteJoueur.BoundsRect);

    if Collision then
    begin
      TSpoochGameData.Current.NbLives := TSpoochGameData.Current.NbLives - 1;
      if (TSpoochGameData.Current.NbLives < 1) then
      begin
        TSpoochGameData.Current.StopGame;
        TScene.Current := tscenetype.GameOver;
      end;
      FaitExploser;
    end;
  end;
end;

function TMechant.GetShipType: Byte;
begin
  if FShipType < 1 then
    FShipType := random(5) + 1;
  result := FShipType;
end;

procedure TMechant.Initialise(AParent: TFMXObject; AX, AY, AVX, AVY: single);
begin
  Initialise(AParent);
  Position.X := AX;
  Position.Y := AY;
  FVX := AVX;
  FVY := AVY;
end;

procedure TMechant.Initialise(AParent: TFMXObject);
begin
  ATire := false;
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  case ShipType of
    1:
      begin
        width := 92.8; // TODO : invader ship size 1
        height := 82.8;
        fill.Bitmap.Bitmap.assign
          (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderShip1, width, height,
          fill.Bitmap.Bitmap.BitmapScale));
      end;
    2:
      begin
        width := 103.8; // TODO : invader ship size 2
        height := 82.95;
        fill.Bitmap.Bitmap.assign
          (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderShip2, width, height,
          fill.Bitmap.Bitmap.BitmapScale));
      end;
    3:
      begin
        width := 102.5; // TODO : invader ship size 3
        height := 83.6;
        fill.Bitmap.Bitmap.assign
          (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderShip3, width, height,
          fill.Bitmap.Bitmap.BitmapScale));
      end;
    4:
      begin
        width := 81; // TODO : invader ship size 4
        height := 84;
        fill.Bitmap.Bitmap.assign
          (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderShip4, width, height,
          fill.Bitmap.Bitmap.BitmapScale));
      end;
  else
    width := 96.76; // TODO : invader ship size 5
    height := 84;
    fill.Bitmap.Bitmap.assign
      (getBitmapFromSVG(TSVGKenneyShipsIndex.InvaderShip5, width, height,
      fill.Bitmap.Bitmap.BitmapScale));
  end;
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(random(trunc((AParent as tcontrol).width - width)
    ), -height);
  VX := random(11) - 5;
  VY := random(5) + 1;
  if not TSpoochGameData.Current.MechantsList.contains(self) then
    TSpoochGameData.Current.MechantsList.Add(self);
end;

procedure TMechant.LanceUnMissile(VYVaisseau: single; AParent: TFMXObject);
var
  missile: TMissileMechant;
begin
  missile := TMissileMechant.Create(nil);
  missile.TagObject := self;
  missile.Initialise(AParent, Position.X + (width - 9) / 2,
    Position.Y + height - 37, 0, 3 + VYVaisseau);
  // TODO : (9,37) = invader missile size
  BringToFront;
end;

procedure TMechant.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y, VX, VY: single;
begin
  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(X) <> AStream.read(X, sizeof(X))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(Y) <> AStream.read(Y, sizeof(Y))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(VX) <> AStream.read(VX, sizeof(VX))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(VY) <> AStream.read(VY, sizeof(VY))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(FShipType) <> AStream.read(FShipType, sizeof(FShipType))) then
      raise exception.Create('Wrong File format !');
    Initialise(TSceneBackground.GetInstance, X, Y, VX, VY);
  end;
end;

procedure TMechant.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y: single;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  X := Position.X;
  AStream.Write(X, sizeof(X));
  Y := Position.Y;
  AStream.Write(Y, sizeof(Y));
  AStream.Write(FVX, sizeof(FVX));
  AStream.Write(FVY, sizeof(FVY));
  AStream.Write(FShipType, sizeof(FShipType));
end;

procedure TMechant.SetShipType(const Value: Byte);
begin

end;

procedure TMechant.SetVX(const Value: single);
begin
  FVX := Value;
end;

procedure TMechant.SetVY(const Value: single);
begin
  FVY := Value;
end;

procedure TMechant.SupprimeApresExplosion(Sender: TObject);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      TSpoochGameData.Current.MechantsList.Remove(self)
    end);
end;

{ TSpriteJoueur }

procedure TSpriteJoueur.Clear;
begin
  // TODO : calculer position en X et Y par défaut : centré en bas de l'écran
  FVX := 0;
  FreeAndNil(FAni);
  Tag := 0;
end;

constructor TSpriteJoueur.Create(AOwner: TComponent);
begin
  inherited;
  FAni := nil;
  Tag := 0;
end;

procedure TSpriteJoueur.FaitExploser;
begin
  Tag := -1;
  FAni := TBitmapListAnimation.Create(self);
  FAni.parent := self;
  FAni.PropertyName := 'Fill.Bitmap.Bitmap';
  FAni.AnimationBitmap.assign(TcadSpritesheetExplosion.GetBitmap);
  FAni.AnimationCount := 46;
  FAni.AnimationRowCount := 7;
  FAni.OnFinish := SupprimeApresExplosion;
  FAni.Enabled := true;
  TSoundEffects.Current.Play(TSoundEffectType.PlayerExplode);
end;

procedure TSpriteJoueur.Initialise(AParent: TFMXObject; AX, AY, AVX: single);
begin
  parent := AParent;
  Position.Point := pointf(AX, AY);
  VX := AVX;
end;

procedure TSpriteJoueur.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y, VX: single;
begin
  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(X) <> AStream.read(X, sizeof(X))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(Y) <> AStream.read(Y, sizeof(Y))) then
      raise exception.Create('Wrong File format !');
    if (sizeof(VX) <> AStream.read(VX, sizeof(VX))) then
      raise exception.Create('Wrong File format !');
    Initialise(TSceneBackground.GetInstance, X, Y, VX);
  end;
end;

procedure TSpriteJoueur.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  X, Y: single;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  X := Position.X;
  AStream.Write(X, sizeof(X));
  Y := Position.Y;
  AStream.Write(Y, sizeof(Y));
  AStream.Write(FVX, sizeof(FVX));
end;

procedure TSpriteJoueur.SetVX(const Value: single);
begin
  FVX := Value;
end;

procedure TSpriteJoueur.SupprimeApresExplosion(Sender: TObject);
begin
  if assigned(TagObject) then
    tthread.ForceQueue(nil,
      procedure
      begin
        FreeAndNil(FAni);
      end);
  if TSpoochGameData.Current.NbLives > 0 then
    TSpoochGameData.Current.InitGameScreen
  else
  begin
    TSpoochGameData.Current.StopGame;
    TScene.Current := tscenetype.GameOver;
  end;
end;

{ TMissileJoueurList }

procedure TMissileJoueurList.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
  Item: TMissileJoueur;
begin
  Clear;

  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(Nb) <> AStream.read(Nb, sizeof(Nb))) then
      raise exception.Create('Wrong File format !');

    while (Nb > 0) do
    begin
      dec(Nb);
      Item := TMissileJoueur.Create(nil);
      Item.LoadFromStream(AStream);
      if not contains(Item) then
        Add(Item);
    end;
  end;
end;

procedure TMissileJoueurList.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));

  Nb := Count;
  AStream.Write(Nb, sizeof(Nb));

  if Nb > 0 then
    for var Item in self do
      Item.SaveToStream(AStream);
end;

{ TMissileMechantList }

procedure TMissileMechantList.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
  Item: TMissileMechant;
begin
  Clear;

  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(Nb) <> AStream.read(Nb, sizeof(Nb))) then
      raise exception.Create('Wrong File format !');

    while (Nb > 0) do
    begin
      dec(Nb);
      Item := TMissileMechant.Create(nil);
      Item.LoadFromStream(AStream);
      if not contains(Item) then
        Add(Item);
    end;
  end;
end;

procedure TMissileMechantList.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));

  Nb := Count;
  AStream.Write(Nb, sizeof(Nb));

  if Nb > 0 then
    for var Item in self do
      Item.SaveToStream(AStream);
end;

{ TMechantsList }

procedure TMechantsList.LoadFromStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
  Item: TMechant;
begin
  Clear;

  // Check if the game data file has a block version number.
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    raise exception.Create('Wrong File format !');

  // Check if the program can open the game data.
  if (VersionNum > CVersion) then
    raise exception.Create
      ('Can''t open this file. Please update the game before trying again.');

  if (VersionNum >= 1) then
  begin
    if (sizeof(Nb) <> AStream.read(Nb, sizeof(Nb))) then
      raise exception.Create('Wrong File format !');

    while (Nb > 0) do
    begin
      dec(Nb);
      Item := TMechant.Create(nil);
      Item.LoadFromStream(AStream);
      if not contains(Item) then
        Add(Item);
    end;
  end;
end;

procedure TMechantsList.SaveToStream(const AStream: TStream);
var
  VersionNum: integer;
  Nb: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));

  Nb := Count;
  AStream.Write(Nb, sizeof(Nb));

  if Nb > 0 then
    for var Item in self do
      Item.SaveToStream(AStream);
end;

end.
