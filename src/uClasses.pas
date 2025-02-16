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
/// File last update : 2025-02-16T20:13:58.000+01:00
/// Signature : 82cc6ce4df5baf0a5f858af8e5b61aea8145adac
/// ***************************************************************************
/// </summary>

unit uClasses;

interface

uses
  FMX.Types,
  FMX.Objects,
  System.Generics.Collections;

type
  TMissileJoueur = class(TRectangle)
  private
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
  end;

  TMissileJoueurList = TObjectList<TMissileJoueur>;

  TMissileMechant = class(TRectangle)
  private
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
  end;

  TMissileMechantList = TObjectList<TMissileMechant>;

  TMechant = class(TRectangle)
  private
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
    ATire: boolean;
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: TFMXObject);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    procedure LanceUnMissile(VYVaisseau: single; AParent: TFMXObject);
  end;

  TMechantsList = TObjectList<TMechant>;

var // TODO : move the variables in the Spooch game data (and rename them)
  MissileJoueurList: TMissileJoueurList;
  MissileMechantList: TMissileMechantList;
  MechantsList: TMechantsList;
  SpriteJoueur: TRectangle;
  // TODO : initialiser le joueur en démarrage de partie

implementation

uses
  System.Classes,
  System.Types,
  FMX.Controls,
  FMX.Ani,
  FMX.Graphics,
  uConsts,
  uSVGBitmapManager_InputPrompts,
  USVGKenneyShips,
  uGameData,
  cSpritesheetExplosion,
  uSoundEffects,
  uScene;

{ TMissileJoueur }

procedure TMissileJoueur.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        MissileJoueurList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileJoueur.FaitExploser;
var
  Ani: TBitmapListAnimation;
begin
  tag := -1;
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
  if tag = -1 then
    exit;

  Collision := false;

  // collision avec ennemis
  if (MechantsList.count > 0) then
    for Ennemi in MechantsList do
      if (Ennemi.tag = 0) and IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        tgamedata.DefaultGameData.Score :=
          tgamedata.DefaultGameData.Score + 100;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (MissileMechantList.count > 0) then
      for missile in MissileMechantList do
        if (missile.tag = 0) and IntersectRect(BoundsRect, missile.BoundsRect)
        then
        begin
          Collision := true;
          tgamedata.DefaultGameData.Score :=
            tgamedata.DefaultGameData.Score + 10;
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
  MissileJoueurList.Add(self);
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
      MissileJoueurList.Remove(self)
    end);
end;

{ TMissileMechant }

procedure TMissileMechant.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        MissileMechantList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileMechant.FaitExploser;
var
  Ani: TBitmapListAnimation;
begin
  tag := -1;
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
  if tag = -1 then
    exit;

  Collision := false;

  // collision avec ennemis
  if (MechantsList.count > 0) then
    for Ennemi in MechantsList do
      if (TagObject <> Ennemi) and (Ennemi.tag = 0) and
        IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        tgamedata.DefaultGameData.Score :=
          tgamedata.DefaultGameData.Score + 150;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (MissileMechantList.count > 0) then
      for missile in MissileMechantList do
        if (missile <> self) and (missile.tag = 0) and
          IntersectRect(BoundsRect, missile.BoundsRect) then
        begin
          Collision := true;
          tgamedata.DefaultGameData.Score :=
            tgamedata.DefaultGameData.Score + 15;
          missile.FaitExploser;
          break;
        end;
  end;

  // collision avec le joueur
  if (not Collision) and tgamedata.DefaultGameData.isplaying then
  begin
    if (SpriteJoueur.Visible) and (SpriteJoueur.tag = 0) and
      IntersectRect(BoundsRect, SpriteJoueur.BoundsRect) then
    begin
      Collision := true;
      tgamedata.DefaultGameData.NbLives :=
        tgamedata.DefaultGameData.NbLives - 1;
      if (tgamedata.DefaultGameData.NbLives < 1) then
      begin
        tgamedata.DefaultGameData.StopGame;
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
  MissileMechantList.Add(self);
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
      MissileMechantList.Remove(self)
    end);
end;

{ TMechant }

procedure TMechant.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > (parent as tcontrol).width) or
    (Position.Y + height < 0) or (Position.Y > (parent as tcontrol).height) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        MechantsList.Remove(self)
      end);
  end
  else
    GereCollision;

  if (not tgamedata.DefaultGameData.isplaying) then
  begin
    if (random(100) < 10) and (not ATire) then
    begin
      ATire := true;
      LanceUnMissile(VY, parent);
    end;
  end
  else if (not(tag = -1)) and (Position.x < SpriteJoueur.Position.x +
    SpriteJoueur.width) and (Position.x + width > SpriteJoueur.Position.x) then
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
  tag := -1;
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
  if tag = -1 then
    exit;

  // collision avec le joueur
  if tgamedata.DefaultGameData.isplaying then
  begin
    Collision := (SpriteJoueur.Visible) and (SpriteJoueur.tag = 0) and
      IntersectRect(BoundsRect, SpriteJoueur.BoundsRect);

    if Collision then
    begin
      tgamedata.DefaultGameData.NbLives :=
        tgamedata.DefaultGameData.NbLives - 1;
      if (tgamedata.DefaultGameData.NbLives < 1) then
      begin
        tgamedata.DefaultGameData.StopGame;
        TScene.Current := tscenetype.GameOver;
      end;
      FaitExploser;
    end;
  end;
end;

procedure TMechant.Initialise(AParent: TFMXObject);
begin
  ATire := false;
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  case random(5) of
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
  Position.Point :=
    pointf(random(trunc((AParent as tcontrol).width - width)), 0);
  VX := random(11) - 5;
  VY := random(5) + 1;
  MechantsList.Add(self);
end;

procedure TMechant.LanceUnMissile(VYVaisseau: single; AParent: TFMXObject);
var
  missile: TMissileMechant;
begin
  missile := TMissileMechant.Create(AParent);
  missile.TagObject := self;
  missile.Initialise(AParent, Position.x + (width - 9) / 2,
    Position.Y + height - 37, 0, 3 + VYVaisseau);
  // TODO : (9,37) = invader missile size
  BringToFront;
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
      MechantsList.Remove(self)
    end);
end;

initialization

MechantsList := TMechantsList.Create;
MissileJoueurList := TMissileJoueurList.Create;
MissileMechantList := TMissileMechantList.Create;
SpriteJoueur := nil;

finalization

MissileMechantList.Free;
MissileJoueurList.Free;
MechantsList.Free;
SpriteJoueur.Free;

end.
