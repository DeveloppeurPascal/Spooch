unit JoystickManager;

interface

procedure StartJoystick;

implementation

uses
{$IFDEF DEBUG}
  FMX.Types, System.SysUtils,
{$ENDIF}
  System.Classes, System.UITypes, FMX.Forms, Gamolf.RTL.Joystick, FMX.Platform,
  uConfig;

const
  CButtonPressed = 65535;

var
  JoystickService: IGamolfJoystickService;

procedure StartJoystick;
begin
  if TPlatformServices.Current.SupportsPlatformService(IGamolfJoystickService,
    JoystickService) then
    tthread.CreateAnonymousThread(
      procedure
      var
        Infos: TJoystickInfo;
        ID: integer;
        DPad: word;
        Key: word;
        KeyChar: char;
        ClickedJoystickID: tjoystickid;
        ClickedKey: word;
        ClickedKeyChar: char;
      begin
        try
          ClickedJoystickID := JoystickService.Count + 1;
          ClickedKey := 0;
          ClickedKeyChar := #0;
          while not tthread.CheckTerminated do
          begin // TODO : voir condition de sortie si JoystickService n'existe plus avant sortie du thread
            tthread.sleep(50);
            for ID := 0 to JoystickService.Count - 1 do
              if JoystickService.isConnected(ID) then
                try
                  JoystickService.getInfo(ID, Infos);
                  if JoystickService.hasDPad(ID) then
                    DPad := Infos.DPad
                  else
                    DPad := ord(TJoystickDPad.Center);
{$IFDEF DEBUG}
                  // log.d('dpad : ' + DPad.tostring);
{$ENDIF}
                  if JoystickService.isdpad(DPad, TJoystickDPad.Center) then
                    DPad := JoystickService.getDPadFromXY(Infos.Axes[0],
                      Infos.Axes[1]);
                  Key := 0;
                  KeyChar := #0;
                  // if (length(Infos.Buttons) > 0) and Infos.Buttons[0] then
                  if (length(Infos.PressedButtons) > 0) then
                    // tir de missile (en jeu) ou bouton par défaut (en menu)
                    Key := CButtonPressed
                    // else if (length(Infos.Buttons) > 1) and Infos.Buttons[1] then
                    // Key := vkescape
                  else if JoystickService.isdpad(DPad, TJoystickDPad.top) then
                    Key := vkUp
                  else if JoystickService.isdpad(DPad, TJoystickDPad.right) then
                    Key := vkright
                  else if JoystickService.isdpad(DPad, TJoystickDPad.bottom)
                  then
                    Key := vkDown
                  else if JoystickService.isdpad(DPad, TJoystickDPad.left) then
                    Key := vkleft;
                  if (ClickedJoystickID = ID) then
                    if (ClickedKey = Key) and (ClickedKeyChar = KeyChar) then
                    begin
                      // Touche annulée
                      Key := 0;
                      KeyChar := #0;
                    end
                    else
                    begin
                      // Touche envoyée
                      ClickedKey := Key;
                      ClickedKeyChar := KeyChar;
                    end;
                  if (Key <> 0) or (KeyChar <> #0) then
                    tthread.Synchronize(nil,
                      procedure
                      var
                        i: integer;
                        c: tcomponent;
                        f: tform;
                      begin
                        for i := 0 to application.ComponentCount - 1 do
                        begin
                          c := application.Components[i];
                          if (c is tform) then
                          begin
                            f := c as tform;
                            if f.Active then
                            begin
                              ClickedJoystickID := ID;
                              ClickedKey := Key;
                              ClickedKeyChar := KeyChar;
                              // Send the good key for pressed buttons
                              // depending on the scene (game or dialog)
                              if Key = CButtonPressed then
                                if partieencours then
                                  // tir missile
                                  KeyChar := ' '
                                else
                                  // OK sur bouton actif par défaut
                                  Key := vkreturn;
                              f.KeyDown(Key, KeyChar, []);
{$IFDEF DEBUG}
                              // log.d(ClickedJoystickID.ToString + ' - ' +
                              // ClickedKey.ToString + ' - ' +
                              // ord(ClickedKeyChar).ToString);
{$ENDIF}
                              break;
                            end;
                          end;
                        end;
                      end);
                except
                  // pas joli
                end;
          end;
        except
          // pas bien
        end;
      end).Start;
end;

initialization

JoystickService := nil;

end.
