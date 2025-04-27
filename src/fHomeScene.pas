unit fHomeScene;

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
  cTitle,
  FMX.Layouts,
  _ButtonsAncestor,
  cTextButton;

type
  TSceneHome = class(T__SceneAncestor)
    cadTitle1: TcadTitle;
    lButtons: TLayout;
    flButtons: TFlowLayout;
    btnContinue: TcadTextButton;
    btnPlay: TcadTextButton;
    btnOptions: TcadTextButton;
    btnHallOfFame: TcadTextButton;
    btnCredits: TcadTextButton;
    btnQuit: TcadTextButton;
    procedure FrameResized(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
  private
  protected
    procedure CalcButtonLayout;
  public
    procedure ShowScene; override;
    procedure HideScene; override;
    procedure TranslateTexts(const Language: string); override;
  end;

implementation

{$R *.fmx}

uses
  uScene,
  uConsts,
  System.Messaging,
  uUIElements,
  Gamolf.RTL.GamepadDetected,
  uSpoochGameData;

const
  CTextButtonWidth = CTextButtonWidth + 2 * 5;

procedure TSceneHome.btnContinueClick(Sender: TObject);
begin
  TSpoochGameData.Current.ContinueGame;
  tscene.Current := TSceneType.Game;
end;

procedure TSceneHome.btnCreditsClick(Sender: TObject);
begin
  tscene.Current := TSceneType.Credits;
end;

procedure TSceneHome.btnHallOfFameClick(Sender: TObject);
begin
  tscene.Current := TSceneType.HallOfFame;
end;

procedure TSceneHome.btnOptionsClick(Sender: TObject);
begin
  tscene.Current := TSceneType.Options;
end;

procedure TSceneHome.btnPlayClick(Sender: TObject);
begin
  TSpoochGameData.Current.StartANewGame;
  tscene.Current := TSceneType.Game;
end;

procedure TSceneHome.btnQuitClick(Sender: TObject);
begin
  tscene.Current := TSceneType.exit;
end;

procedure TSceneHome.CalcButtonLayout;
var
  i, nb: integer;
  Height1Col, Height2Col, Height3Col: Single;
begin
  // This calcul is right only if elements in the TFlowLayout have the same size
  // (height and width).
  Height1Col := 0;
  Height2Col := 0;
  Height3Col := 0;
  nb := 0;
  for i := 0 to flButtons.ChildrenCount - 1 do
    if (flButtons.Children[i] is TControl) and
      (flButtons.Children[i] as TControl).visible then
    begin
      Height1Col := Height1Col + (flButtons.Children[i] as TControl).margins.top
        + (flButtons.Children[i] as TControl).height +
        (flButtons.Children[i] as TControl).margins.Bottom;
      if (nb mod 2 = 0) then
        Height2Col := Height2Col + (flButtons.Children[i] as TControl)
          .margins.top + (flButtons.Children[i] as TControl).height +
          (flButtons.Children[i] as TControl).margins.Bottom;
      if (nb mod 3 = 0) then
        Height3Col := Height3Col + (flButtons.Children[i] as TControl)
          .margins.top + (flButtons.Children[i] as TControl).height +
          (flButtons.Children[i] as TControl).margins.Bottom;
      inc(nb);
    end;

  if (Height1Col + lButtons.Position.y < height) then
    flButtons.width := CTextButtonWidth
  else if (Height2Col + lButtons.Position.y < height) then
    flButtons.width := CTextButtonWidth * 2
  else if (Height3Col + lButtons.Position.y < height) then
    flButtons.width := CTextButtonWidth * 3
  else
    flButtons.width := CTextButtonWidth * 4;
  // TODO : revoir l'ordre de déplacement entre contrôles à l'écran selon le nombre de colonnes
end;

procedure TSceneHome.FrameResized(Sender: TObject);
begin
  CalcButtonLayout;
end;

procedure TSceneHome.HideScene;
begin
  inherited;
  TUIItemsList.Current.RemoveLayout;
end;

procedure TSceneHome.ShowScene;
begin
  inherited;

  TUIItemsList.Current.NewLayout;

  if TSpoochGameData.Current.IsPaused then
  begin
    btnContinue.visible := true;
    TUIItemsList.Current.AddControl(btnContinue, nil, btnPlay, btnPlay,
      nil, true);
    TUIItemsList.Current.AddControl(btnPlay, btnContinue, btnOptions,
      btnOptions, btnContinue);
  end
  else
  begin
    btnContinue.visible := false;
    TUIItemsList.Current.AddControl(btnPlay, nil, btnOptions, btnOptions,
      nil, true);
  end;
  TUIItemsList.Current.AddControl(btnOptions, btnPlay, btnHallOfFame,
    btnHallOfFame, btnPlay);
  TUIItemsList.Current.AddControl(btnHallOfFame, btnOptions, btnCredits,
    btnCredits, btnOptions);
{$IF Defined(IOS) or Defined(ANDROID)}
  TUIItemsList.Current.AddControl(btnCredits, btnHallOfFame, nil, nil,
    btnHallOfFame);
  TUIItemsList.Current.AddQuit;
  btnQuit.visible := false;
{$ELSE}
  TUIItemsList.Current.AddControl(btnCredits, btnHallOfFame, btnQuit, btnQuit,
    btnHallOfFame);
  TUIItemsList.Current.AddControl(btnQuit, btnCredits, nil, nil, btnCredits,
    false, true);
{$ENDIF}
  CalcButtonLayout;
end;

procedure TSceneHome.TranslateTexts(const Language: string);
begin
  inherited;

  if Language = 'fr' then
  begin
    btnContinue.Text := 'Continuer';
    btnPlay.Text := 'Jouer';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Scores';
    btnCredits.Text := 'Credits';
    btnQuit.Text := 'Quitter';
  end
  else
  begin
    btnContinue.Text := 'Continue';
    btnPlay.Text := 'Play';
    btnOptions.Text := 'Options';
    btnHallOfFame.Text := 'Hall of fame';
    btnCredits.Text := 'Credits';
    btnQuit.Text := 'Quit';
  end;
end;

initialization

TMessageManager.DefaultManager.SubscribeToMessage(TSceneFactory,
  procedure(const Sender: TObject; const Msg: TMessage)
  var
    NewScene: TSceneHome;
  begin
    if (Msg is TSceneFactory) and
      ((Msg as TSceneFactory).SceneType = TSceneType.Home) then
    begin
      NewScene := TSceneHome.Create(application.mainform);
      NewScene.Parent := application.mainform;
      tscene.RegisterScene(TSceneType.Home, NewScene);
    end;
  end);

end.
