unit uConfig;

interface

uses Gamolf.FMX.MusicLoop;

type
  TConfig = class
  private
    class procedure SetBruitagesOnOff(const Value: boolean); static;
    class procedure SetInterfaceTactileOnOff(const Value: boolean); static;
    class procedure SetMusiqueDAmbianceOnOff(const Value: boolean); static;
    class function getBruitagesOnOff: boolean; static;
    class function getInterfaceTactileOnOff: boolean; static;
    class function getMusiqueDAmbianceOnOff: boolean; static;
    class procedure SetCheminPartageCapturesEcran(const Value: string); static;
    class function getCheminPartageCapturesEcran: string; static;
    class function GetEffetsVisuelsOnOff: boolean; static;
    class procedure SetEffetsVisuelsOnOff(const Value: boolean); static;
    class procedure SetBruitagesVolume(const Value: TVolumeSonore); static;
    class procedure SetMusiqueDAmbianceVolume(const Value
      : TVolumeSonore); static;
    class function getBruitagesVolume: TVolumeSonore; static;
    class function getMusiqueDAmbianceVolume: TVolumeSonore; static;
  public
    class property InterfaceTactileOnOff: boolean read getInterfaceTactileOnOff
      write SetInterfaceTactileOnOff;
    class property BruitagesOnOff: boolean read getBruitagesOnOff
      write SetBruitagesOnOff;
    class property BruitagesVolume: TVolumeSonore read getBruitagesVolume
      write SetBruitagesVolume;
    class property MusiqueDAmbianceOnOff: boolean read getMusiqueDAmbianceOnOff
      write SetMusiqueDAmbianceOnOff;
    class property MusiqueDAmbianceVolume: TVolumeSonore
      read getMusiqueDAmbianceVolume write SetMusiqueDAmbianceVolume;
    class property CheminPartageCapturesEcran: string
      read getCheminPartageCapturesEcran write SetCheminPartageCapturesEcran;
    class property EffetsVisuelsOnOff: boolean read GetEffetsVisuelsOnOff
      write SetEffetsVisuelsOnOff;
  end;

implementation

uses
  system.sysutils, system.IOUtils, Olf.RTL.Params;

const
  CBruitagesOnOff = 'BruitagesOnOff';
  CBruitagesVolume = 'BruitagesVolume';
  CMusiqueAmbianceOnOff = 'MusiqueAmbianceOnOff';
  CMusiqueAmbianceVolume = 'MusiqueAmbianceVolume';
  CInterfaceTactileOnOff = 'InterfaceTactileOnOff';
  CEffetsVisuelsOnOff = 'EffetsVisuelsOnOff';
  CCheminPartageCapturesEcran = 'CheminPartageCapturesEcran';

  { TConfig }

class function TConfig.getBruitagesOnOff: boolean;
begin
{$IFDEF DEBUG}
  result := tParams.getValue(CBruitagesOnOff, false);
{$ELSE}
  result := tParams.getValue(CBruitagesOnOff, true);
{$ENDIF}
end;

class function TConfig.getBruitagesVolume: TVolumeSonore;
begin
  result := tParams.getValue(CBruitagesVolume, 100);
end;

class function TConfig.getCheminPartageCapturesEcran: string;
var
  DossierParDefaut: string;
begin
{$IFDEF DEBUG}
{$IF Defined(IOS) or Defined(ANDROID)}
  DossierParDefaut := tpath.combine(tpath.combine(tpath.GetPicturesPath,
    'Gamolf-debug'), 'Spooch-debug');
{$ELSE}
  DossierParDefaut := tpath.combine(tpath.combine(tpath.GetDocumentsPath,
    'Gamolf-debug'), 'Spooch-debug');
{$ENDIF}
{$ELSE}
  DossierParDefaut := tpath.combine(tpath.combine(tpath.GetPicturesPath,
    'Gamolf'), 'Spooch');
{$ENDIF}
  result := tParams.getValue(CCheminPartageCapturesEcran, DossierParDefaut);
  if not TDirectory.Exists(result) then
    TDirectory.CreateDirectory(result);
end;

class function TConfig.GetEffetsVisuelsOnOff: boolean;
begin
{$IFDEF DEBUG}
  result := tParams.getValue(CEffetsVisuelsOnOff, false);
{$ELSE}
  result := tParams.getValue(CEffetsVisuelsOnOff, true);
{$ENDIF}
end;

class function TConfig.getInterfaceTactileOnOff: boolean;
begin
{$IF Defined(iOS) or Defined(ANDROID)}
  result := tParams.getValue(CInterfaceTactileOnOff, true);
{$ELSE}
  result := tParams.getValue(CInterfaceTactileOnOff, false);
{$ENDIF}
end;

class function TConfig.getMusiqueDAmbianceOnOff: boolean;
begin
{$IFDEF DEBUG}
  result := tParams.getValue(CMusiqueAmbianceOnOff, false);
{$ELSE}
  result := tParams.getValue(CMusiqueAmbianceOnOff, true);
{$ENDIF}
end;

class function TConfig.getMusiqueDAmbianceVolume: TVolumeSonore;
begin
  result := tParams.getValue(CMusiqueAmbianceVolume, 100);
end;

class procedure TConfig.SetBruitagesOnOff(const Value: boolean);
begin
  tParams.setValue(CBruitagesOnOff, Value);
end;

class procedure TConfig.SetBruitagesVolume(const Value: TVolumeSonore);
begin
  tParams.setValue(CBruitagesVolume, Value);
end;

class procedure TConfig.SetCheminPartageCapturesEcran(const Value: string);
begin
  tParams.setValue(CCheminPartageCapturesEcran, Value);
end;

class procedure TConfig.SetEffetsVisuelsOnOff(const Value: boolean);
begin
  tParams.setValue(CEffetsVisuelsOnOff, Value);
end;

class procedure TConfig.SetInterfaceTactileOnOff(const Value: boolean);
begin
  tParams.setValue(CInterfaceTactileOnOff, Value);
end;

class procedure TConfig.SetMusiqueDAmbianceOnOff(const Value: boolean);
begin
  tParams.setValue(CMusiqueAmbianceOnOff, Value);
end;

class procedure TConfig.SetMusiqueDAmbianceVolume(const Value: TVolumeSonore);
begin
  tParams.setValue(CMusiqueAmbianceVolume, Value);
end;

end.
