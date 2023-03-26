unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Ani,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Effects, System.Generics.Collections, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  Gamolf.RTL.Scores;

const
  CNbMechantMax = 5;

type
  tfrmMain = class;

  TMissileJoueur = class(trectangle)
  private
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
    FicheAssociee: tfrmMain;
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: tfrmMain; AX, AY, AVX, AVY: single);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
  end;

  TMissileJoueurList = TObjectList<TMissileJoueur>;

  TMissileMechant = class(trectangle)
  private
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
    FicheAssociee: tfrmMain;
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: tfrmMain; AX, AY, AVX, AVY: single);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
  end;

  TMissileMechantList = TObjectList<TMissileMechant>;

  TMechant = class(trectangle)
  private
    FVX: single;
    FVY: single;
    procedure SetVX(const Value: single);
    procedure SetVY(const Value: single);
  protected
    FicheAssociee: tfrmMain;
    ATire: boolean;
  public
    property VX: single read FVX write SetVX;
    property VY: single read FVY write SetVY;
    procedure Initialise(AParent: tfrmMain);
    procedure GereCollision;
    procedure Deplace;
    procedure FaitExploser;
    procedure SupprimeApresExplosion(Sender: TObject);
    procedure LanceUnMissile(VYVaisseau: single);
  end;

  TMechantsList = TObjectList<TMechant>;

{$SCOPEDENUMS ON}
  TListeEcrans = (Aucun, Menu, JeuEnCours, FinDePartie, HallOfFame,
    Reglages, Credits);
{$SCOPEDENUMS OFF}

  tfrmMain = class(TForm)
    imgBackground: trectangle;
    BoucleDuJeu: TTimer;
    background: TScaledLayout;
    Spritejoueur: trectangle;
    SpriteMissileJoueur: trectangle;
    btnJouer: TButton;
    StyleBook1: TStyleBook;
    lblScore: TLabel;
    ShadowEffect1: TShadowEffect;
    ElementsGraphiques: TLayout;
    SpriteMechant1: trectangle;
    SpriteMechant2: trectangle;
    SpriteMechant3: trectangle;
    SpriteMechant4: trectangle;
    SpriteMechant5: trectangle;
    SpritesheetExplosion: trectangle;
    SpriteMissileMechant: trectangle;
    EcranMenu: TLayout;
    EcranCredits: TLayout;
    EcranReglages: TLayout;
    EcranHallOfFame: TLayout;
    EcranFinDePartie: TLayout;
    btnReglages: TButton;
    btnHallOfFame: TButton;
    btnCreditsDuJeu: TButton;
    EcranMenuContenu: TLayout;
    EcranReglagesContenu: TLayout;
    lblMusique: TLabel;
    OptionsMusique: TLayout;
    swMusique: TSwitch;
    tbMusique: TTrackBar;
    lblBruitages: TLabel;
    OptionsBruitages: TLayout;
    swBruitages: TSwitch;
    tbBruitages: TTrackBar;
    EcranReglagesBoutons: TLayout;
    btnEcranReglagesFermer: TButton;
    EcranReglagesBackground: trectangle;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    EcranCreditsContenu: TLayout;
    EcranCreditsBackground: trectangle;
    EcranFinDePartieContenu: TLayout;
    EcranFinDePartieBackground: trectangle;
    EcranHallOfFameContenu: TLayout;
    EcranHallOfFameBackground: trectangle;
    EcranHallOfFameBoutons: TLayout;
    btnEcranHallOfFameFermer: TButton;
    EcranFinDePartieBoutons: TLayout;
    btnEcranFinDePartieFermer: TButton;
    EcranCreditsBoutons: TLayout;
    btnEcranCreditsFermer: TButton;
    lblFinDePartiePerdu: TLabel;
    lblFinDePartieScore: TLabel;
    lblCreditsDuJeu: TLabel;
    ShadowEffect4: TShadowEffect;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    lblHallOfFame: TLabel;
    ShadowEffect5: TShadowEffect;
    lstScores: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BoucleDuJeuTimer(Sender: TObject);
    procedure btnJouerClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreditsDuJeuCanFocus(Sender: TObject; var ACanFocus: boolean);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnReglagesClick(Sender: TObject);
    procedure tbMusiqueTracking(Sender: TObject);
    procedure swMusiqueSwitch(Sender: TObject);
    procedure tbBruitagesTracking(Sender: TObject);
    procedure swBruitagesSwitch(Sender: TObject);
    procedure tbBruitagesChange(Sender: TObject);
    procedure btnEcranReglagesFermerClick(Sender: TObject);
    procedure btnEcranCreditsFermerClick(Sender: TObject);
    procedure btnEcranFinDePartieFermerClick(Sender: TObject);
    procedure btnEcranHallOfFameFermerClick(Sender: TObject);
  private
    FLigneAfficheeDuBasDuBackground: single;
    FVitesseDuBackground: single;
    FPartieEnCours: boolean;
    FJoueurVX: single;
    FJoueurX: single;
    FJoueurY: single;
    FScore: integer;
    FEcranActuel: TListeEcrans;
    FBoiteDeDialogueParDessus: TLayout;
    procedure SetLigneAfficheeDuBasDuBackground(const Value: single);
    procedure SetVitesseDuBackground(const Value: single);
    procedure SetPartieEnCours(const Value: boolean);
    procedure SetJoueurVX(const Value: single);
    procedure SetJoueurX(const Value: single);
    procedure SetJoueurY(const Value: single);
    procedure SetScore(const Value: integer);
    procedure SetEcranActuel(const Value: TListeEcrans);
    { Déclarations privées }
    property LigneAfficheeDuBasDuBackground: single
      read FLigneAfficheeDuBasDuBackground
      write SetLigneAfficheeDuBasDuBackground;
    property VitesseDuBackground: single read FVitesseDuBackground
      write SetVitesseDuBackground;
    property PartieEnCours: boolean read FPartieEnCours write SetPartieEnCours;
    procedure InitialiseFormatEcran;
    procedure LanceUnePartie;
    procedure LanceUnMissile;
    procedure AjouteUnMechant;
    procedure PerteDUneVie;
    procedure MettreLeJeuEnPause;
    procedure SupprimeJoueurApresExplosion(Sender: TObject);
    procedure AffichageEcranFinDePartie;
    procedure AffichageEcranDuMenu;
    procedure AffichageEcranDeJeu;
    procedure AffichageEcranHallOfFame;
    procedure AffichageEcranReglages;
    procedure AffichageEcranCredits;
    procedure AjusteHauteurZoneDeContenu(ZoneAAjuster: TLayout);
    procedure BoiteDeDialogueParDessus;
    procedure MigrateOldScoresFileToNewPath;
  public
    { Déclarations publiques }
    MissileJoueurList: TMissileJoueurList;
    MissileMechantList: TMissileMechantList;
    MechantsList: TMechantsList;
    ListeDesScores: TScoreList;
    property Score: integer read FScore write SetScore;
    property JoueurX: single read FJoueurX write SetJoueurX;
    property JoueurY: single read FJoueurY write SetJoueurY;
    property JoueurVX: single read FJoueurVX write SetJoueurVX;
    property EcranActuel: TListeEcrans read FEcranActuel write SetEcranActuel;
  end;

var
  frmMain: tfrmMain;

implementation

{$R *.fmx}

uses
  System.math, System.strutils, uMusic, uConfig, uBruitages, System.Threading,
  Olf.RTL.Params, System.IOUtils;

procedure tfrmMain.btnCreditsDuJeuCanFocus(Sender: TObject;
  var ACanFocus: boolean);
begin
  EcranActuel := TListeEcrans.Credits;
end;

procedure tfrmMain.btnEcranCreditsFermerClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.Menu;
end;

procedure tfrmMain.btnEcranReglagesFermerClick(Sender: TObject);
begin
  tParams.save;
  EcranActuel := TListeEcrans.Menu;
end;

procedure tfrmMain.btnHallOfFameClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.HallOfFame;
end;

procedure tfrmMain.btnJouerClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.JeuEnCours;
end;

procedure tfrmMain.btnReglagesClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.Reglages;
end;

procedure tfrmMain.btnEcranHallOfFameFermerClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.Menu;
end;

procedure tfrmMain.btnEcranFinDePartieFermerClick(Sender: TObject);
begin
  EcranActuel := TListeEcrans.Menu;
end;

procedure tfrmMain.AffichageEcranCredits;
begin
  EcranCredits.Visible := true;
  EcranCredits.BringToFront;
  lblCreditsDuJeu.Text :=
    'Spooch a été développé lors de sessions de codage en direct sur Twitch avec FireMonkey sous Delphi.'
    + linefeed + linefeed + 'La musique d''ambiance est de Ginny Culp.' +
    linefeed + linefeed +
    'Les effets sonores sont de The Game Creators (librairie SoundMatter).' +
    linefeed + linefeed +
    'Les graphismes proviennent de Adobe Stock (fond d''écran), Kenney.nl (vaisseaux & tirs) et OpenGameArt.org (explosions).'
    + linefeed + linefeed +
    'Développé par Patrick Prémartin (et parfois ses viewers) avec Delphi 10.4.2 Sydney.'
    + linefeed + linefeed + 'c) Olf Software / Gamolf 2021';
  // TODO : activer les liens dans le texte
  AjusteHauteurZoneDeContenu(EcranCreditsContenu);
end;

procedure tfrmMain.AffichageEcranDeJeu;
begin
  LanceUnePartie;
end;

procedure tfrmMain.AffichageEcranDuMenu;
begin
  EcranMenu.Visible := true;
  EcranMenu.BringToFront;
  AjusteHauteurZoneDeContenu(EcranMenuContenu);
end;

procedure tfrmMain.AffichageEcranFinDePartie;
begin
  PartieEnCours := false;
  Spritejoueur.Visible := false;
  EcranFinDePartie.Visible := true;
  EcranFinDePartie.BringToFront;
  lblFinDePartieScore.Text := 'Score final : ' + Score.ToString + ' point' +
    ifthen(Score > 1, 's', '');
  if Score > 0 then
    ListeDesScores.Add('n/a', Score); // TODO : Faire saisie du pseudo
  AjusteHauteurZoneDeContenu(EcranFinDePartieContenu);
end;

procedure tfrmMain.AffichageEcranHallOfFame;
var
  i: integer;
  Item: TListViewItem;
begin
  EcranHallOfFame.Visible := true;
  EcranHallOfFame.BringToFront;
  lstScores.Items.Clear;
  for i := 0 to ListeDesScores.count - 1 do
  begin
    Item := lstScores.Items.Add;
    Item.Text := ListeDesScores[i].points.ToString;
  end;
  AjusteHauteurZoneDeContenu(EcranHallOfFameContenu);
end;

procedure tfrmMain.AffichageEcranReglages;
begin
  EcranReglages.Visible := true;
  EcranReglages.BringToFront;
  swMusique.IsChecked := tconfig.MusiqueDAmbianceOnOff;
  tbMusique.Visible := tconfig.MusiqueDAmbianceOnOff;
  tbMusique.Value := tconfig.MusiqueDAmbianceVolume;
  swBruitages.IsChecked := tconfig.BruitagesOnOff;
  tbBruitages.Visible := tconfig.BruitagesOnOff;
  tbBruitages.Value := tconfig.BruitagesVolume;
  AjusteHauteurZoneDeContenu(EcranReglagesContenu);
end;

procedure tfrmMain.AjouteUnMechant;
var
  Mechant: TMechant;
begin
  Mechant := TMechant.Create(self);
  Mechant.Initialise(self);
end;

procedure tfrmMain.AjusteHauteurZoneDeContenu(ZoneAAjuster: TLayout);
var
  Hauteur: single;
  i: integer;
  ctrl: TControl;
begin
  // Calcul vrai qu'en cas de composants alignés en TOP
  // sinon choisir le composant le plus bas, ajouter sa hauteur, sa marge basse et le padding bas du conteneur
  Hauteur := ZoneAAjuster.Padding.top;
  for i := 0 to ZoneAAjuster.ChildrenCount - 1 do
    if (ZoneAAjuster.children[i] is TControl) then
    begin
      ctrl := ZoneAAjuster.children[i] as TControl;
      if ctrl.Align = TAlignLayout.top then
        Hauteur := Hauteur + ctrl.margins.top + ctrl.height +
          ctrl.margins.bottom;
    end;
  Hauteur := Hauteur + ZoneAAjuster.Padding.bottom;
  ZoneAAjuster.height := Hauteur;
  // Si contenu => on a un conteneur en plein écran
  if (ZoneAAjuster.parent is TLayout) then
    FBoiteDeDialogueParDessus := ZoneAAjuster.parent as TLayout;
end;

procedure tfrmMain.BoiteDeDialogueParDessus;
begin
  if assigned(FBoiteDeDialogueParDessus) then
    FBoiteDeDialogueParDessus.BringToFront;
end;

procedure tfrmMain.BoucleDuJeuTimer(Sender: TObject);
var
  MissileJoueur: TMissileJoueur;
  MissileEnnemi: TMissileMechant;
  Mechant: TMechant;
begin
  // Déplace le background
  LigneAfficheeDuBasDuBackground := LigneAfficheeDuBasDuBackground -
    VitesseDuBackground;

  // Déplace le joueur
  JoueurX := JoueurX + JoueurVX;

  // Déplace les tirs du joueur
  if MissileJoueurList.count > 0 then
    for MissileJoueur in MissileJoueurList do
      MissileJoueur.Deplace;

  // Déplace les tirs ennemis
  if MissileMechantList.count > 0 then
    for MissileEnnemi in MissileMechantList do
      MissileEnnemi.Deplace;

  // Ajoute des ennemis s'ils n'y en a pas assez
  if (random(100) < 50) and (MechantsList.count < CNbMechantMax) then
    AjouteUnMechant;

  // Déplace les ennemis
  if MechantsList.count > 0 then
    for Mechant in MechantsList do
      Mechant.Deplace;
end;

procedure tfrmMain.FormCreate(Sender: TObject);
begin
  ListeDesScores := TScoreList.Create('Gamolf', 'Spooch');
  MigrateOldScoresFileToNewPath;
  ListeDesScores.Load;

  FEcranActuel := TListeEcrans.Aucun;
  // Masquer tous les TLayout 'EcranXXX' masque aussi 'EcranMenuBouton'
  // dans 'EcranMenu' donc un filtrage sur le parent permet d'éviter
  // les couacs.
  for var i := 0 to componentcount - 1 do
    if (components[i] is TLayout) and ((components[i] as TLayout).parent = self)
      and (string((components[i] as TLayout).Name).tolower.StartsWith('ecran'))
    then
      (components[i] as TLayout).Visible := false;

  // Liste de sprites (hors joueur)
  MechantsList := TMechantsList.Create;
  MissileJoueurList := TMissileJoueurList.Create;
  MissileMechantList := TMissileMechantList.Create;

  // Paramétrage background et scroll infini
  background.Position.Point := pointf(0, 0);
  imgBackground.width := imgBackground.fill.Bitmap.Bitmap.width;
  background.OriginalWidth := imgBackground.width;
  imgBackground.height := imgBackground.fill.Bitmap.Bitmap.height +
    max(imgBackground.fill.Bitmap.Bitmap.height, screen.height);
  InitialiseFormatEcran;
  LigneAfficheeDuBasDuBackground := imgBackground.height - 1;
  VitesseDuBackground := 2;
  BoucleDuJeu.Enabled := true;

  // Paramétrage joueur
  Spritejoueur.Visible := false;

  // Autres infos à initialiser
  ElementsGraphiques.Visible := false;
  PartieEnCours := false;
  Score := 0;

  // Lance la musique
  if tconfig.MusiqueDAmbianceOnOff then
    TMusiques.Ambiance.Play;

  tthread.ForceQueue(nil,
    procedure
    begin
      EcranActuel := TListeEcrans.Menu;
    end);
end;

procedure tfrmMain.FormDestroy(Sender: TObject);
begin
  MissileMechantList.Free;
  MissileJoueurList.Free;
  MechantsList.Free;
  ListeDesScores.Free;
end;

procedure tfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if (Key in [vkEscape, vkHardwareBack]) then
  begin
    if PartieEnCours then
    begin
      MettreLeJeuEnPause;
      Key := 0;
    end
    else if (EcranActuel <> TListeEcrans.Menu) then
    begin
      if EcranActuel = TListeEcrans.Reglages then
        tParams.save;
      EcranActuel := TListeEcrans.Menu;
      Key := 0;
    end
    else
    begin
      close;
      Key := 0;
    end;
  end
  else if PartieEnCours then
  begin
    if Key = vkLeft then
    begin
      Key := 0;
      if JoueurVX > 0 then
        JoueurVX := -1
      else
        JoueurVX := JoueurVX - 1;
    end;
    if Key = vkRight then
    begin
      Key := 0;
      if JoueurVX < 0 then
        JoueurVX := 1
      else
        JoueurVX := JoueurVX + 1;
    end;
    if KeyChar = ' ' then
    begin
      KeyChar := #0;
      LanceUnMissile;
    end;
  end;
end;

procedure tfrmMain.FormResize(Sender: TObject);
begin
  InitialiseFormatEcran;
  JoueurY := clientheight - Spritejoueur.height - 20;
  if (JoueurX + Spritejoueur.width > ClientWidth) then
    JoueurX := ClientWidth - Spritejoueur.width;
end;

procedure tfrmMain.InitialiseFormatEcran;
begin
  background.width := ClientWidth;
  background.originalheight := clientheight;
  background.height := clientheight;
end;

procedure tfrmMain.LanceUnePartie;
begin
  JoueurX := (ClientWidth - Spritejoueur.width) / 2;
  JoueurY := clientheight - Spritejoueur.height - 20;
  JoueurVX := 0;
  Spritejoueur.Visible := true;
  Spritejoueur.BringToFront;
  Score := 0;
  PartieEnCours := true;
end;

procedure tfrmMain.LanceUnMissile;
var
  missile: TMissileJoueur;
begin
  missile := TMissileJoueur.Create(self);
  missile.Initialise(self, JoueurX + (Spritejoueur.width -
    SpriteMissileJoueur.width) / 2, JoueurY, 0, -3);
  Spritejoueur.BringToFront;
end;

procedure tfrmMain.MettreLeJeuEnPause;
begin
  // TODO : gérer la pause
  PartieEnCours := false;
  // à gérer en stopperpartie        (commun à findepartie)
  Spritejoueur.Visible := false;
  // à gérer en stopperpartie (commun à findepartie)
  EcranActuel := TListeEcrans.Menu;
end;

procedure tfrmMain.MigrateOldScoresFileToNewPath;
var
  OldFileName: string;
begin
  OldFileName := ListeDesScores.GetOldScoreFileName('Gamolf', 'Spooch');
  if tfile.exists(OldFileName) then
  begin
    ListeDesScores.LoadFromFile(OldFileName);
    ListeDesScores.save;
    tfile.Delete(OldFileName);
  end;
end;

procedure tfrmMain.PerteDUneVie;
var
  Ani: tbitmaplistanimation;
begin
  if not PartieEnCours then
    exit;
  tag := -1;
  Ani := tbitmaplistanimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign(Spritejoueur.fill.Bitmap.Bitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeJoueurApresExplosion;
  Ani.Enabled := true;
  JouerBruitage(TTypeBruitage.ExplosionJoueur);
end;

procedure tfrmMain.SetEcranActuel(const Value: TListeEcrans);
begin
  // Masque l'écran précédent
  case FEcranActuel of
    TListeEcrans.Menu:
      EcranMenu.Visible := false;
    TListeEcrans.FinDePartie:
      EcranFinDePartie.Visible := false;
    TListeEcrans.HallOfFame:
      EcranHallOfFame.Visible := false;
    TListeEcrans.Reglages:
      EcranReglages.Visible := false;
    TListeEcrans.Credits:
      EcranCredits.Visible := false;
    TListeEcrans.JeuEnCours, TListeEcrans.Aucun: // rien à masquer
      ;
  else
    raise Exception.Create('Masquage de cet écran non géré.');
  end;
  FBoiteDeDialogueParDessus := nil;
  // Enregistre le nouvel écran
  FEcranActuel := Value;
  // Initialise et affiche le nouvel écran
  // TODO : gérer les affichages des différents écrans
  case FEcranActuel of
    TListeEcrans.Menu:
      AffichageEcranDuMenu;
    TListeEcrans.JeuEnCours:
      AffichageEcranDeJeu;
    TListeEcrans.FinDePartie:
      AffichageEcranFinDePartie;
    TListeEcrans.HallOfFame:
      AffichageEcranHallOfFame;
    TListeEcrans.Reglages:
      AffichageEcranReglages;
    TListeEcrans.Credits:
      AffichageEcranCredits;
    TListeEcrans.Aucun: // rien à afficher
      ;
  else
    raise Exception.Create('Affichage de cet écran non géré.');
  end;
end;

procedure tfrmMain.SetJoueurVX(const Value: single);
begin
  FJoueurVX := Value;
end;

procedure tfrmMain.SetJoueurX(const Value: single);
begin
  FJoueurX := Value;
  if (FJoueurX < 0) then
    FJoueurX := 0
  else if (FJoueurX + Spritejoueur.width > ClientWidth) then
    FJoueurX := ClientWidth - Spritejoueur.width;
  Spritejoueur.Position.x := FJoueurX;
end;

procedure tfrmMain.SetJoueurY(const Value: single);
begin
  FJoueurY := Value;
  Spritejoueur.Position.Y := FJoueurY;
end;

procedure tfrmMain.SetLigneAfficheeDuBasDuBackground(const Value: single);
begin
  if not tconfig.EffetsVisuelsOnOff then
    exit;
  FLigneAfficheeDuBasDuBackground := Value;
  while (FLigneAfficheeDuBasDuBackground <= imgBackground.fill.Bitmap.Bitmap.
    height - background.originalheight) do
    FLigneAfficheeDuBasDuBackground := FLigneAfficheeDuBasDuBackground +
      imgBackground.fill.Bitmap.Bitmap.height;
  imgBackground.Position.Point :=
    pointf(0, background.originalheight - FLigneAfficheeDuBasDuBackground);
end;

procedure tfrmMain.SetPartieEnCours(const Value: boolean);
begin
  FPartieEnCours := Value;
end;

procedure tfrmMain.SetScore(const Value: integer);
begin
  if PartieEnCours or (Value = 0) then
  begin
    FScore := Value;
    lblScore.Text := 'Score : ' + FScore.ToString;
  end;
end;

procedure tfrmMain.SetVitesseDuBackground(const Value: single);
begin
  FVitesseDuBackground := Value;
end;

procedure tfrmMain.SupprimeJoueurApresExplosion(Sender: TObject);
begin
  if (Sender is tbitmaplistanimation) then
    tthread.ForceQueue(nil,
      procedure
      begin
        (Sender as tbitmaplistanimation).Free;
      end);
  EcranActuel := TListeEcrans.FinDePartie;
end;

procedure tfrmMain.swBruitagesSwitch(Sender: TObject);
begin
  tbBruitages.Visible := swBruitages.IsChecked;
  if swBruitages.IsChecked then
    // todo : ajouter un bruitage juste pour les réglages
    JouerBruitage(TTypeBruitage.ExplosionJoueur)
  else
    CouperLesBruitages;
  tconfig.BruitagesOnOff := swBruitages.IsChecked;
end;

procedure tfrmMain.swMusiqueSwitch(Sender: TObject);
begin
  tbMusique.Visible := swMusique.IsChecked;
  if swMusique.IsChecked then
    TMusiques.Ambiance.Play
  else
    TMusiques.Ambiance.stop;
  tconfig.MusiqueDAmbianceOnOff := swMusique.IsChecked;
end;

procedure tfrmMain.tbMusiqueTracking(Sender: TObject);
begin
  tconfig.MusiqueDAmbianceVolume := round(tbMusique.Value);
  TMusiques.Ambiance.Volume := tconfig.MusiqueDAmbianceVolume;
end;

procedure tfrmMain.tbBruitagesChange(Sender: TObject);
begin
  JouerBruitage(TTypeBruitage.ExplosionJoueur);
end;

procedure tfrmMain.tbBruitagesTracking(Sender: TObject);
begin
  tconfig.BruitagesVolume := round(tbBruitages.Value);
end;

{ TMissileJoueur }

procedure TMissileJoueur.SupprimeApresExplosion(Sender: TObject);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      FicheAssociee.MissileJoueurList.Remove(self)
    end);
end;

procedure TMissileJoueur.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > FicheAssociee.ClientWidth) or
    (Position.Y + height < 0) or (Position.Y > FicheAssociee.clientheight) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        FicheAssociee.MissileJoueurList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileJoueur.FaitExploser;
var
  Ani: tbitmaplistanimation;
begin
  tag := -1;
  Ani := tbitmaplistanimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign
    (FicheAssociee.SpritesheetExplosion.fill.Bitmap.Bitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  // Ne pas faire de son, s'il explose, autre chose explose aussi
  // JouerBruitage(TTypeBruitage.ExplosionTirDuJoueur);
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
  if (FicheAssociee.MechantsList.count > 0) then
    for Ennemi in FicheAssociee.MechantsList do
      if (Ennemi.tag = 0) and IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        FicheAssociee.Score := FicheAssociee.Score + 100;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (FicheAssociee.MissileMechantList.count > 0) then
      for missile in FicheAssociee.MissileMechantList do
        if (missile.tag = 0) and IntersectRect(BoundsRect, missile.BoundsRect)
        then
        begin
          Collision := true;
          FicheAssociee.Score := FicheAssociee.Score + 10;
          missile.FaitExploser;
          break;
        end;
  end;

  // Si collision, on explose
  if Collision then
    FaitExploser;
end;

procedure TMissileJoueur.Initialise(AParent: tfrmMain;
AX, AY, AVX, AVY: single);
begin
  FicheAssociee := AParent;
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  fill.Bitmap.Bitmap.assign(AParent.SpriteMissileJoueur.fill.Bitmap.Bitmap);
  width := fill.Bitmap.Bitmap.width;
  height := fill.Bitmap.Bitmap.height;
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(AX, AY);
  VX := AVX;
  VY := AVY;
  AParent.MissileJoueurList.Add(self);
end;

procedure TMissileJoueur.SetVX(const Value: single);
begin
  FVX := Value;
end;

procedure TMissileJoueur.SetVY(const Value: single);
begin
  FVY := Value;
end;

{ TMechant }

procedure TMechant.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > FicheAssociee.ClientWidth) or
    (Position.Y + height < 0) or (Position.Y > FicheAssociee.clientheight) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        FicheAssociee.MechantsList.Remove(self)
      end);
  end
  else
    GereCollision;

  if (not FicheAssociee.PartieEnCours) then
  begin
    if (random(100) < 10) and (not ATire) then
    begin
      ATire := true;
      LanceUnMissile(VY);
    end;
  end
  else if (not(tag = -1)) and
    (Position.x < FicheAssociee.Spritejoueur.Position.x +
    FicheAssociee.Spritejoueur.width) and
    (Position.x + width > FicheAssociee.Spritejoueur.Position.x) then
  begin
    if (not ATire) then
    begin
      ATire := true;
      LanceUnMissile(VY);
    end;
  end
  else
    ATire := false;
end;

procedure TMechant.FaitExploser;
var
  Ani: tbitmaplistanimation;
begin
  tag := -1;
  Ani := tbitmaplistanimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign
    (FicheAssociee.SpritesheetExplosion.fill.Bitmap.Bitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  JouerBruitage(TTypeBruitage.ExplosionVaisseauEnnemi);
end;

procedure TMechant.GereCollision;
var
  Collision: boolean;
begin
  if tag = -1 then
    exit;

  // collision avec le joueur
  Collision := (FicheAssociee.Spritejoueur.Visible) and
    (FicheAssociee.Spritejoueur.tag = 0) and
    IntersectRect(BoundsRect, FicheAssociee.Spritejoueur.BoundsRect);

  if Collision then
  begin
    FicheAssociee.PerteDUneVie;
    FaitExploser;
  end;
end;

procedure TMechant.Initialise(AParent: tfrmMain);
var
  NumeroMechantChoisi: trectangle;
begin
  ATire := false;
  case random(5) of
    1:
      NumeroMechantChoisi := AParent.SpriteMechant1;
    2:
      NumeroMechantChoisi := AParent.SpriteMechant2;
    3:
      NumeroMechantChoisi := AParent.SpriteMechant3;
    4:
      NumeroMechantChoisi := AParent.SpriteMechant4;
  else
    NumeroMechantChoisi := AParent.SpriteMechant5;
  end;
  FicheAssociee := AParent;
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  fill.Bitmap.Bitmap.assign(NumeroMechantChoisi.fill.Bitmap.Bitmap);
  width := fill.Bitmap.Bitmap.width;
  height := fill.Bitmap.Bitmap.height;
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(random(trunc(AParent.ClientWidth - width)), 0);
  VX := random(11) - 5;
  VY := random(5) + 1;
  AParent.MechantsList.Add(self);
  FicheAssociee.BoiteDeDialogueParDessus;
end;

procedure TMechant.LanceUnMissile(VYVaisseau: single);
var
  missile: TMissileMechant;
begin
  missile := TMissileMechant.Create(FicheAssociee);
  missile.TagObject := self;
  missile.Initialise(FicheAssociee,
    Position.x + (width - FicheAssociee.SpriteMissileMechant.width) / 2,
    Position.Y + height - FicheAssociee.SpriteMissileMechant.height, 0,
    3 + VYVaisseau);
  BringToFront;
  FicheAssociee.BoiteDeDialogueParDessus;
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
      FicheAssociee.MechantsList.Remove(self)
    end);
end;

{ TMissileMechant }

procedure TMissileMechant.Deplace;
begin
  if tag = -1 then
    exit;
  Position.Point := pointf(Position.x + VX, Position.Y + VY);
  if (Position.x + width < 0) or (Position.x > FicheAssociee.ClientWidth) or
    (Position.Y + height < 0) or (Position.Y > FicheAssociee.clientheight) then
  begin
    tag := -1;
    tthread.ForceQueue(nil,
      procedure
      begin
        FicheAssociee.MissileMechantList.Remove(self)
      end);
  end
  else
    GereCollision;
end;

procedure TMissileMechant.FaitExploser;
var
  Ani: tbitmaplistanimation;
begin
  tag := -1;
  Ani := tbitmaplistanimation.Create(self);
  Ani.parent := self;
  Ani.PropertyName := 'Fill.Bitmap.Bitmap';
  Ani.AnimationBitmap.assign
    (FicheAssociee.SpritesheetExplosion.fill.Bitmap.Bitmap);
  Ani.AnimationCount := 46;
  Ani.AnimationRowCount := 7;
  Ani.OnFinish := SupprimeApresExplosion;
  Ani.Enabled := true;
  JouerBruitage(TTypeBruitage.ExplosionTirEnnemi);
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
  if (FicheAssociee.MechantsList.count > 0) then
    for Ennemi in FicheAssociee.MechantsList do
      if (TagObject <> Ennemi) and (Ennemi.tag = 0) and
        IntersectRect(BoundsRect, Ennemi.BoundsRect) then
      begin
        Collision := true;
        FicheAssociee.Score := FicheAssociee.Score + 150;
        Ennemi.FaitExploser;
        break;
      end;

  // collision avec tirs ennemis
  if not Collision then
  begin
    if (FicheAssociee.MissileMechantList.count > 0) then
      for missile in FicheAssociee.MissileMechantList do
        if (missile <> self) and (missile.tag = 0) and
          IntersectRect(BoundsRect, missile.BoundsRect) then
        begin
          Collision := true;
          FicheAssociee.Score := FicheAssociee.Score + 15;
          missile.FaitExploser;
          break;
        end;
  end;

  // collision avec le joueur
  if not Collision then
  begin
    if (FicheAssociee.Spritejoueur.Visible) and
      (FicheAssociee.Spritejoueur.tag = 0) and
      IntersectRect(BoundsRect, FicheAssociee.Spritejoueur.BoundsRect) then
    begin
      Collision := true;
      FicheAssociee.PerteDUneVie;
    end;
  end;

  // Si collision, on explose
  if Collision then
    FaitExploser;
end;

procedure TMissileMechant.Initialise(AParent: tfrmMain;
AX, AY, AVX, AVY: single);
begin
  FicheAssociee := AParent;
  parent := AParent;
  HitTest := false;
  fill.Kind := TBrushKind.Bitmap;
  fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  fill.Bitmap.Bitmap.assign(AParent.SpriteMissileMechant.fill.Bitmap.Bitmap);
  width := fill.Bitmap.Bitmap.width;
  height := fill.Bitmap.Bitmap.height;
  stroke.Kind := TBrushKind.none;
  Position.Point := pointf(AX, AY);
  VX := AVX;
  VY := AVY;
  AParent.MissileMechantList.Add(self);
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
      FicheAssociee.MissileMechantList.Remove(self)
    end);
end;

initialization

randomize;
{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
