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
/// File last update : 2025-02-16T20:14:06.000+01:00
/// Signature : ecfa66bdf7e8d0efcf815b8954e7aa5796f9c025
/// ***************************************************************************
/// </summary>

unit uSceneBackground;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  _ScenesAncestor,
  FMX.Objects;

type
  TSceneBackground = class(T__SceneAncestor)
    GameLoop: TTimer;
    procedure FrameResized(Sender: TObject);
    procedure GameLoopTimer(Sender: TObject);
  private
  protected
    SpaceImage1, SpaceImage2: TRectangle;
    SpaceImageSpeed: single;
    procedure ResizeSpaceBackgroundImage;
    procedure AddAnInvader;
  public
    procedure ShowScene; override;
    procedure AfterConstruction; override;

  end;

implementation

{$R *.fmx}

uses
  cImgSpaceBackground,
  uConsts,
  uClasses,
  uGameData;

procedure TSceneBackground.AddAnInvader;
var
  Mechant: TMechant;
begin
  Mechant := TMechant.Create(self);
  Mechant.Initialise(self);
end;

procedure TSceneBackground.AfterConstruction;
begin
  inherited;
  SpaceImage1 := nil;
  SpaceImage2 := nil;
  SpaceImageSpeed := CSpaceBackgroundSpeed;
end;

procedure TSceneBackground.FrameResized(Sender: TObject);
begin
  ResizeSpaceBackgroundImage;
end;

procedure TSceneBackground.GameLoopTimer(Sender: TObject);
var
  y: single;
  MissileJoueur: TMissileJoueur;
  MissileEnnemi: TMissileMechant;
  Mechant: TMechant;
begin
  // Move the space background
  y := SpaceImage1.Position.y + SpaceImageSpeed;
  if (y >= height) then
    y := y - 2 * SpaceImage1.height;
  SpaceImage1.Position.y := y;

  y := SpaceImage2.Position.y + SpaceImageSpeed;
  if (y >= height) then
    y := y - 2 * SpaceImage2.height;
  SpaceImage2.Position.y := y;

  // Move the player
  if tgamedata.DefaultGameData.IsPlaying then
  begin
    // TODO :   JoueurX := JoueurX + JoueurVX;
  end;

  // Move the player's missiles
  if MissileJoueurList.count > 0 then
    for MissileJoueur in MissileJoueurList do
      MissileJoueur.Deplace;

  // Move the invaders missiles
  if MissileMechantList.count > 0 then
    for MissileEnnemi in MissileMechantList do
      MissileEnnemi.Deplace;

  // Add invaders if we don't have enough on the screen
  if (random(100) < 50) and (MechantsList.count < CNbMaxInvader) then
    AddAnInvader;

  // Move the invaders
  if MechantsList.count > 0 then
    for Mechant in MechantsList do
      Mechant.Deplace;
end;

procedure TSceneBackground.ShowScene;
var
  cadBackground: TcadImgSpaceBackground;
begin
  inherited;

  cadBackground := TcadImgSpaceBackground.Create(self);
  SpaceImage1 := cadBackground.imgBackground;
  SpaceImage1.Parent := self;

  SpaceImage2 := SpaceImage1.Clone(self) as TRectangle;
  assert(SpaceImage2.Fill.Kind = TBrushKind.Bitmap, 'not a bitmap');
  // try
  // assert(SpaceImage2.Parent = SpaceImage1.Parent, 'other parent');
  // except // TODO : create an issue on the quality portal
  // SpaceImage2.Parent := SpaceImage1.Parent;
  // end;
  SpaceImage2.Parent := SpaceImage1.Parent;
  assert(assigned(SpaceImage2.Fill.Bitmap.Bitmap), 'no bitmap');
  assert(SpaceImage2.Fill.Bitmap.Bitmap.width = SpaceImage1.Fill.Bitmap.Bitmap.
    width, 'not the same width');
  assert(SpaceImage2.Fill.Bitmap.Bitmap.height = SpaceImage1.Fill.Bitmap.Bitmap.
    height, 'not the same height');
  assert(SpaceImage1.stroke.Kind = TBrushKind.None, 'stroke for 1');
  assert(SpaceImage2.stroke.Kind = TBrushKind.None, 'stroke for 2');

  SpaceImage1.BeginUpdate;
  try
    SpaceImage1.Position.x := 0;
    SpaceImage1.Position.y := height - SpaceImage1.height;
  finally
    SpaceImage1.EndUpdate;
  end;
  SpaceImage2.BeginUpdate;
  try
    SpaceImage2.Position.x := 0;
    SpaceImage2.Position.y := SpaceImage1.Position.y - SpaceImage2.height;
  finally
    SpaceImage2.EndUpdate;
  end;

  ResizeSpaceBackgroundImage;

  SendToBack;
end;

procedure TSceneBackground.ResizeSpaceBackgroundImage;
var
  w, h, ratio: single;
begin
  if (not assigned(SpaceImage1)) or (not assigned(SpaceImage2)) then
    exit;

  w := SpaceImage1.Fill.Bitmap.Bitmap.width;
  if (w >= width) then
    ratio := 1
  else
    ratio := width / w;

  h := SpaceImage1.Fill.Bitmap.Bitmap.height;

  // TODO : check if the image heigth is lower than the screen height

  SpaceImage1.BeginUpdate;
  try
    SpaceImage1.width := w * ratio;
    SpaceImage1.height := h * ratio;
  finally
    SpaceImage1.EndUpdate;
  end;
  SpaceImage2.BeginUpdate;
  try
    SpaceImage2.width := w * ratio;
    SpaceImage2.height := h * ratio;
  finally
    SpaceImage2.EndUpdate;
  end;

  if (SpaceImage1.Position.y < SpaceImage2.Position.y) then
    SpaceImage1.Position.y := SpaceImage2.Position.y - SpaceImage1.height
  else
    SpaceImage2.Position.y := SpaceImage1.Position.y - SpaceImage2.height;

  SpaceImageSpeed := CSpaceBackgroundSpeed * ratio;
end;

end.
