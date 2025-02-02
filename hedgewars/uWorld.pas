(*
 * Hedgewars, a free turn based strategy game
 * Copyright (c) 2004-2014 Andrey Korotaev <unC0Rr@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *)

{$INCLUDE "options.inc"}
{$IF GLunit = GL}{$DEFINE GLunit:=GL,GLext}{$ENDIF}

unit uWorld;
interface
uses SDLh, uGears, uConsts, uFloat, uRandom, uTypes, uRenderUtils;

procedure initModule;
procedure freeModule;

procedure InitWorld;
procedure ResetWorldTex;

procedure DrawWorld(Lag: LongInt);
procedure DrawWorldStereo(Lag: LongInt; RM: TRenderMode);
procedure ShowMission(caption, subcaption, text: ansistring; icon, time : LongInt);
procedure HideMission;
procedure ShakeCamera(amount: LongInt);
procedure InitCameraBorders;
procedure InitTouchInterface;
procedure SetUtilityWidgetState(ammoType: TAmmoType);
procedure animateWidget(widget: POnScreenWidget; fade, showWidget: boolean);
procedure MoveCamera;
procedure onFocusStateChanged;
procedure updateCursorVisibility;

implementation
uses
    uStore
    , uMisc
    , uIO
    , uLocale
    , uSound
    , uAmmos
    , uVisualGears
    , uChat
    , uLandTexture
    , GLunit
    , uVariables
    , uUtils
    , uTextures
    , uRender
    , uCaptions
    , uCursor
    , uCommands
    , uTeams
{$IFDEF USE_VIDEO_RECORDING}
    , uVideoRec
{$ENDIF}
    ;

var AMShiftTargetX, AMShiftTargetY, AMShiftX, AMShiftY, SlotsNum: LongInt;
    AMAnimStartTime, AMState : LongInt;
    AMAnimState: Single;
    tmpSurface: PSDL_Surface;
    fpsTexture: PTexture;
    timeTexture: PTexture;
    FPS: Longword;
    CountTicks: Longword;
    prevPoint{, prevTargetPoint}: TPoint;
    amSel: TAmmoType = amNothing;
    missionTex: PTexture;
    missionTimer: LongInt;
    isFirstFrame: boolean;
    AMAnimType: LongInt;
    recTexture: PTexture;
    AmmoMenuTex     : PTexture;
    HorizontOffset: LongInt;
    cOffsetY: LongInt;
    WorldEnd, WorldFade : array[0..3] of HwColor4f;

const cStereo_Sky           = 0.0500;
      cStereo_Horizon       = 0.0250;
      cStereo_MidDistance   = 0.0175;
      cStereo_Water_distant = 0.0125;
      cStereo_Land          = 0.0075;
      cStereo_Water_near    = 0.0025;
      cStereo_Outside       = -0.0400;

      AMAnimDuration = 200;
      AMHidden    = 0;//AMState values
      AMShowingUp = 1;
      AMShowing   = 2;
      AMHiding    = 3;

      AMTypeMaskX     = $00000001;
      AMTypeMaskY     = $00000002;
      AMTypeMaskAlpha = $00000004;
      //AMTypeMaskSlide = $00000008;

{$IFDEF MOBILE}
      AMSlotSize = 48;
{$ELSE}
      AMSlotSize = 32;
{$ENDIF}
      AMSlotPadding = (AMSlotSize - 32) shr 1;

      cSendCursorPosTime = 50;
      cCursorEdgesDist   = 100;

// helper functions to create the goal/game mode string
function AddGoal(s: ansistring; gf: longword; si: TGoalStrId; i: LongInt): ansistring;
var t: ansistring;
begin
{$IFNDEF PAS2C}
    if (GameFlags and gf) <> 0 then
        begin
        t:= inttostr(i);
        s:= s + FormatA(trgoal[si], t) + '|'
        end;
{$ENDIF}
    AddGoal:= s;
end;

function AddGoal(s: ansistring; gf: longword; si: TGoalStrId): ansistring;
begin
{$IFNDEF PAS2C}
    if (GameFlags and gf) <> 0 then
        s:= s + trgoal[si] + '|';
{$ENDIF}
    AddGoal:= s;
end;

procedure InitWorld;
var i, t: LongInt;
    cp: PClan;
    g: ansistring;
begin
missionTimer:= 0;

if (GameFlags and gfRandomOrder) <> 0 then  // shuffle them up a bit
    begin
    for i:= 0 to ClansCount * 4 do
        begin
        t:= GetRandom(ClansCount);
        if t <> 0 then
            begin
            cp:= ClansArray[0];
            ClansArray[0]:= ClansArray[t];
            ClansArray[t]:= cp;
            ClansArray[t]^.ClanIndex:= t;
            ClansArray[0]^.ClanIndex:= 0;
            if (LocalClan = t) then
                LocalClan:= 0
            else if (LocalClan = 0) then
                LocalClan:= t
            end;
        end;
    CurrentTeam:= ClansArray[0]^.Teams[0];
    end;

// if special game flags/settings are changed, add them to the game mode notice window and then show it
g:= ''; // no text/things to note yet

// add custom goals from lua script if there are any
if LuaGoals <> '' then
    g:= LuaGoals + '|';

// check different game flags (goals/game modes first for now)
g:= AddGoal(g, gfKing, gidKing); // king?
g:= AddGoal(g, gfTagTeam, gidTagTeam); // tag team mode?

// other important flags
g:= AddGoal(g, gfForts, gidForts); // forts?
g:= AddGoal(g, gfLowGravity, gidLowGravity); // low gravity?
g:= AddGoal(g, gfInvulnerable, gidInvulnerable); // invulnerability?
g:= AddGoal(g, gfVampiric, gidVampiric); // vampirism?
g:= AddGoal(g, gfKarma, gidKarma); // karma?
g:= AddGoal(g, gfPlaceHog, gidPlaceHog); // placement?
g:= AddGoal(g, gfArtillery, gidArtillery); // artillery?
g:= AddGoal(g, gfSolidLand, gidSolidLand); // solid land?
g:= AddGoal(g, gfSharedAmmo, gidSharedAmmo); // shared ammo?
g:= AddGoal(g, gfResetHealth, gidResetHealth);
g:= AddGoal(g, gfAISurvival, gidAISurvival);
g:= AddGoal(g, gfInfAttack, gidInfAttack);
g:= AddGoal(g, gfResetWeps, gidResetWeps);
g:= AddGoal(g, gfPerHogAmmo, gidPerHogAmmo);

// modified damage modificator?
if cDamagePercent <> 100 then
    g:= AddGoal(g, gfAny, gidDamageModifier, cDamagePercent);

// fade in
ScreenFade:= sfFromBlack;
ScreenFadeValue:= sfMax;
ScreenFadeSpeed:= 1;

// modified mine timers?
if cMinesTime <> 3000 then
    begin
    if cMinesTime = 0 then
        g:= AddGoal(g, gfAny, gidNoMineTimer)
    else if cMinesTime < 0 then
        g:= AddGoal(g, gfAny, gidRandomMineTimer)
    else
        g:= AddGoal(g, gfAny, gidMineTimer, cMinesTime div 1000);
    end;

// if the string has been set, show it for (default timeframe) seconds
if length(g) > 0 then
    ShowMission(trgoal[gidCaption], trgoal[gidSubCaption], g, 1, 0);

//cWaveWidth:= SpritesData[sprWater].Width;
//cWaveHeight:= SpritesData[sprWater].Height;
cWaveHeight:= 32;

InitCameraBorders();
uCursor.init();
prevPoint.X:= 0;
prevPoint.Y:= cScreenHeight div 2;
//prevTargetPoint.X:= 0;
//prevTargetPoint.Y:= 0;
WorldDx:=  -(LongInt(leftX + (playWidth div 2))); // -(LAND_WIDTH div 2);// + cScreenWidth div 2;
WorldDy:=  -(LAND_HEIGHT - (playHeight div 2)) + (cScreenHeight div 2);

//aligns it to the bottom of the screen, minus the border
SkyOffset:= 0;
HorizontOffset:= 0;

InitTouchInterface();
AMAnimType:= AMTypeMaskX or AMTypeMaskAlpha;
end;

procedure InitCameraBorders;
begin
cGearScrEdgesDist:= min(2 * cScreenHeight div 5, 2 * cScreenWidth div 5);
end;

procedure InitTouchInterface;
begin
{$IFDEF USE_TOUCH_INTERFACE}

//positioning of the buttons
buttonScale:= 1 / cDefaultZoomLevel;


with JumpWidget do
    begin
    show:= true;
    sprite:= sprJumpWidget;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= (cScreenWidth shr 1) - Round(frame.w * 1.2);
    frame.y:= cScreenHeight - frame.h * 2;
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with AMWidget do
    begin
    show:= true;
    sprite:= sprAMWidget;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= (cScreenWidth shr 1) - frame.w * 2;
    frame.y:= cScreenHeight - Round(frame.h * 1.2);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with arrowLeft do
    begin
    show:= true;
    sprite:= sprArrowLeft;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= -(cScreenWidth shr 1) + Round(frame.w * 0.25);
    frame.y:= cScreenHeight - Round(frame.h * 1.5);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with arrowRight do
    begin
    show:= true;
    sprite:= sprArrowRight;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= -(cScreenWidth shr 1) + Round(frame.w * 1.5);
    frame.y:= cScreenHeight - Round(frame.h * 1.5);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with firebutton do
    begin
    show:= true;
    sprite:= sprFireButton;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= arrowRight.frame.x + arrowRight.frame.w;
    frame.y:= arrowRight.frame.y + (arrowRight.frame.w shr 1) - (frame.w shr 1);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with arrowUp do
    begin
    show:= false;
    sprite:= sprArrowUp;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= (cScreenWidth shr 1) - frame.w * 2;
    frame.y:= jumpWidget.frame.y - Round(frame.h * 1.25);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    with moveAnim do
         begin
         target.x:= frame.x;
         target.y:= frame.y;
         source.x:= frame.x - Round(frame.w * 0.75);
         source.y:= frame.y;
         end;
    end;

with arrowDown do
    begin
    show:= false;
    sprite:= sprArrowDown;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= (cScreenWidth shr 1) - frame.w * 2;
    frame.y:= jumpWidget.frame.y - Round(frame.h * 1.25);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    with moveAnim do
        begin
        target.x:= frame.x;
        target.y:= frame.y;
        source.x:= frame.x + Round(frame.w * 0.75);
        source.y:= frame.y;
        end;
    end;

with pauseButton do
    begin
    show:= true;
    sprite:= sprPauseButton;
    frame.w:= Round(spritesData[sprPauseButton].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprPauseButton].Texture^.h * buttonScale);
    frame.x:= cScreenWidth div 2 - frame.w;
    frame.y:= 0;
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    end;

with utilityWidget do
    begin
    show:= false;
    sprite:= sprTimerButton;
    frame.w:= Round(spritesData[sprite].Texture^.w * buttonScale);
    frame.h:= Round(spritesData[sprite].Texture^.h * buttonScale);
    frame.x:= arrowLeft.frame.x;
    frame.y:= arrowLeft.frame.y - Round(frame.h * 1.25);
    active.x:= frame.x;
    active.y:= frame.y;
    active.w:= frame.w;
    active.h:= frame.h;
    with moveAnim do
        begin
        target.x:= frame.x;
        target.y:= frame.y;
        source.x:= frame.x;
        source.y:= frame.y;
        end;
    end;
{$ENDIF}
end;

// for uStore texture resetting
procedure ResetWorldTex;
begin
    FreeAndNilTexture(fpsTexture);
    FreeAndNilTexture(timeTexture);
    FreeAndNilTexture(missionTex);
    FreeAndNilTexture(recTexture);
    FreeAndNilTexture(AmmoMenuTex);
    AmmoMenuInvalidated:= true;
end;

function GetAmmoMenuTexture(Ammo: PHHAmmo): PTexture;
const BORDERSIZE = 2;
var x, y, i, t, SlotsNumY, SlotsNumX, AMFrame: LongInt;
    STurns: LongInt;
    amSurface: PSDL_Surface;
    AMRect: TSDL_Rect;
{$IFDEF USE_AM_NUMCOLUMN}tmpsurf: PSDL_Surface;{$ENDIF}
begin
    if cOnlyStats then exit(nil);

    SlotsNum:= 0;
    for i:= 0 to cMaxSlotIndex do
        if((i = 0) and (Ammo^[i,1].Count > 0)) or ((i <> 0) and (Ammo^[i,0].Count > 0)) then
            inc(SlotsNum);
{$IFDEF USE_LANDSCAPE_AMMOMENU}
    SlotsNumX:= SlotsNum;
    SlotsNumY:= cMaxSlotAmmoIndex + 2;
    {$IFDEF USE_AM_NUMCOLUMN}
    inc(SlotsNumY);
    {$ENDIF}
{$ELSE}
    SlotsNumX:= cMaxSlotAmmoIndex + 1;
    SlotsNumY:= SlotsNum + 1;
    {$IFDEF USE_AM_NUMCOLUMN}
    inc(SlotsNumX);
    {$ENDIF}
{$ENDIF}


    AmmoRect.w:= (BORDERSIZE*2) + (SlotsNumX * AMSlotSize) + (SlotsNumX-1);
    AmmoRect.h:= (BORDERSIZE*2) + (SlotsNumY * AMSlotSize) + (SlotsNumY-1);
    amSurface := SDL_CreateRGBSurface(SDL_SWSURFACE, AmmoRect.w, AmmoRect.h, 32, RMask, GMask, BMask, AMask);

    AMRect.x:= BORDERSIZE;
    AMRect.y:= BORDERSIZE;
    AMRect.w:= AmmoRect.w - (BORDERSIZE*2);
    AMRect.h:= AmmoRect.h - (BORDERSIZE*2);

    SDL_FillRect(amSurface, @AMRect, SDL_MapRGB(amSurface^.format, 0,0,0));

    x:= AMRect.x;
    y:= AMRect.y;
    for i:= 0 to cMaxSlotIndex do
        if ((i = 0) and (Ammo^[i, 1].Count > 0)) or ((i <> 0) and (Ammo^[i, 0].Count > 0)) then
            begin
{$IFDEF USE_LANDSCAPE_AMMOMENU}
            y:= AMRect.y;
{$ELSE}
            x:= AMRect.x;
{$ENDIF}
{$IFDEF USE_AM_NUMCOLUMN}
            tmpsurf:= TTF_RenderUTF8_Blended(Fontz[fnt16].Handle, Str2PChar('F' + IntToStr(i+1)), cWhiteColorChannels);
            copyToXY(tmpsurf, amSurface,
                     x + AMSlotPadding + (AMSlotSize shr 1) - (tmpsurf^.w shr 1),
                     y + AMSlotPadding + (AMSlotSize shr 1) - (tmpsurf^.h shr 1));

            SDL_FreeSurface(tmpsurf);
    {$IFDEF USE_LANDSCAPE_AMMOMENU}
            y:= AMRect.y + AMSlotSize + 1;
    {$ELSE}
            x:= AMRect.x + AMSlotSize + 1;
    {$ENDIF}
{$ENDIF}


            for t:=0 to cMaxSlotAmmoIndex do
                begin
                if (Ammo^[i, t].Count > 0)  and (Ammo^[i, t].AmmoType <> amNothing) then
                    begin
                    STurns:= Ammoz[Ammo^[i, t].AmmoType].SkipTurns - CurrentTeam^.Clan^.TurnNumber;
                    AMFrame:= LongInt(Ammo^[i,t].AmmoType) - 1;
                    if STurns >= 0 then //weapon not usable yet, draw grayed out with turns remaining
                        begin
                        DrawSpriteFrame2Surf(sprAMAmmosBW, amSurface, x + AMSlotPadding,
                                                                 y + AMSlotPadding, AMFrame);
                        if STurns < 100 then
                            DrawSpriteFrame2Surf(sprTurnsLeft, amSurface,
                                x + AMSlotSize-16,
                                y + AMSlotSize + 1 - 16, STurns);
                        end
                    else //draw colored version
                        begin
                        DrawSpriteFrame2Surf(sprAMAmmos, amSurface, x + AMSlotPadding,
                                                               y + AMSlotPadding, AMFrame);
                        end;
{$IFDEF USE_LANDSCAPE_AMMOMENU}
        inc(y, AMSlotSize + 1); //the plus one is for the border
{$ELSE}
        inc(x, AMSlotSize + 1);
{$ENDIF}
        end;
    end;
{$IFDEF USE_LANDSCAPE_AMMOMENU}
    inc(x, AMSlotSize + 1);
{$ELSE}
    inc(y, AMSlotSize + 1);
{$ENDIF}
    end;

for i:= 1 to SlotsNumX -1 do
DrawLine2Surf(amSurface, i * (AMSlotSize+1)+1, BORDERSIZE, i * (AMSlotSize+1)+1, AMRect.h + BORDERSIZE - AMSlotSize - 2,160,160,160);
for i:= 1 to SlotsNumY -1 do
DrawLine2Surf(amSurface, BORDERSIZE, i * (AMSlotSize+1)+1, AMRect.w + BORDERSIZE, i * (AMSlotSize+1)+1,160,160,160);

//draw outer border
DrawSpriteFrame2Surf(sprAMCorners, amSurface, 0                    , 0                    , 0);
DrawSpriteFrame2Surf(sprAMCorners, amSurface, AMRect.w + BORDERSIZE, AMRect.y             , 1);
DrawSpriteFrame2Surf(sprAMCorners, amSurface, AMRect.x             , AMRect.h + BORDERSIZE, 2);
DrawSpriteFrame2Surf(sprAMCorners, amSurface, AMRect.w + BORDERSIZE, AMRect.h + BORDERSIZE, 3);

for i:=0 to BORDERSIZE-1 do
begin
DrawLine2Surf(amSurface, BORDERSIZE, i, AMRect.w + BORDERSIZE, i,160,160,160);//top
DrawLine2Surf(amSurface, BORDERSIZE, AMRect.h+BORDERSIZE+i, AMRect.w + BORDERSIZE, AMRect.h+BORDERSIZE+i,160,160,160);//bottom
DrawLine2Surf(amSurface, i, BORDERSIZE, i, AMRect.h + BORDERSIZE,160,160,160);//left
DrawLine2Surf(amSurface, AMRect.w+BORDERSIZE+i, BORDERSIZE, AMRect.w + BORDERSIZE+i, AMRect.h + BORDERSIZE, 160,160,160);//right
end;

GetAmmoMenuTexture:= Surface2Tex(amSurface, false);
if amSurface <> nil then SDL_FreeSurface(amSurface);
end;

procedure ShowAmmoMenu;
const BORDERSIZE = 2;
var Slot, Pos: LongInt;
    Ammo: PHHAmmo;
    c,i,g,t,STurns: LongInt;
begin
if TurnTimeLeft = 0 then bShowAmmoMenu:= false;

// give the assigned ammo to hedgehog
Ammo:= nil;
if (CurrentTeam <> nil) and (CurrentHedgehog <> nil)
and (not CurrentTeam^.ExtDriven) and (CurrentHedgehog^.BotLevel = 0) then
    Ammo:= CurrentHedgehog^.Ammo
else if (LocalAmmo <> -1) then
    Ammo:= GetAmmoByNum(LocalAmmo);
Pos:= -1;
if Ammo = nil then
    begin
    bShowAmmoMenu:= false;
    AMState:= AMHidden;
    exit
    end;

//Init the menu
if(AmmoMenuInvalidated) then
    begin
    AmmoMenuInvalidated:= false;
    FreeAndNilTexture(AmmoMenuTex);
    AmmoMenuTex:= GetAmmoMenuTexture(Ammo);

{$IFDEF USE_LANDSCAPE_AMMOMENU}
    if isPhone() then
        begin
        AmmoRect.x:= -(AmmoRect.w shr 1);
        AmmoRect.y:= (cScreenHeight shr 1) - (AmmoRect.h shr 1);
        end
    else
        begin
        AmmoRect.x:= -(AmmoRect.w shr 1);
        AmmoRect.y:= cScreenHeight - (AmmoRect.h + AMSlotSize);
        end;
{$ELSE}
        AmmoRect.x:= (cScreenWidth shr 1) - AmmoRect.w - AMSlotSize;
        AmmoRect.y:= cScreenHeight - (AmmoRect.h + AMSlotSize);
{$ENDIF}
    if AMState <> AMShowing then
        begin
        AMShiftTargetX:= (cScreenWidth shr 1) - AmmoRect.x;
        AMShiftTargetY:= cScreenHeight        - AmmoRect.y;

        if (AMAnimType and AMTypeMaskX) <> 0 then AMShiftTargetX:= (cScreenWidth shr 1) - AmmoRect.x
        else AMShiftTargetX:= 0;
        if (AMAnimType and AMTypeMaskY) <> 0 then AMShiftTargetY:= cScreenHeight        - AmmoRect.y
        else AMShiftTargetY:= 0;

        AMShiftX:= AMShiftTargetX;
        AMShiftY:= AMShiftTargetY
        end
end;

AMAnimState:= (RealTicks - AMAnimStartTime) / AMAnimDuration;

if AMState = AMShowing then
    begin
    FollowGear:=nil;
    end;

if AMState = AMShowingUp then // show ammo menu
    begin
    if (cReducedQuality and rqSlowMenu) <> 0 then
        begin
        AMShiftX:= 0;
        AMShiftY:= 0;
        AMState:= AMShowing;
        end
    else
        if AMAnimState < 1 then
            begin
            AMShiftX:= Round(AMShiftTargetX * (1 - AMAnimState));
            AMShiftY:= Round(AMShiftTargetY * (1 - AMAnimState));
            if (AMAnimType and AMTypeMaskAlpha) <> 0 then
                Tint($FF, $ff, $ff, Round($ff * AMAnimState));
            end
        else
            begin
            AMShiftX:= 0;
            AMShiftY:= 0;
            CursorPoint.X:= AmmoRect.x + AmmoRect.w;
            CursorPoint.Y:= AmmoRect.y;
            AMState:= AMShowing;
            end;
    end;
if AMState = AMHiding then // hide ammo menu
    begin
    if (cReducedQuality and rqSlowMenu) <> 0 then
        begin
        AMShiftX:= AMShiftTargetX;
        AMShiftY:= AMShiftTargetY;
        AMState:= AMHidden;
        end
    else
        if AMAnimState < 1 then
            begin
            AMShiftX:= Round(AMShiftTargetX * AMAnimState);
            AMShiftY:= Round(AMShiftTargetY * AMAnimState);
            if (AMAnimType and AMTypeMaskAlpha) <> 0 then
                Tint($FF, $ff, $ff, Round($ff * (1-AMAnimState)));
            end
         else
            begin
            AMShiftX:= AMShiftTargetX;
            AMShiftY:= AMShiftTargetY;
            prevPoint:= CursorPoint;
            //prevTargetPoint:= TargetCursorPoint;
            AMState:= AMHidden;
            end;
    end;

DrawTexture(AmmoRect.x + AMShiftX, AmmoRect.y + AMShiftY, AmmoMenuTex);

if ((AMState = AMHiding) or (AMState = AMShowingUp)) and ((AMAnimType and AMTypeMaskAlpha) <> 0 )then
    untint;

Pos:= -1;
Slot:= -1;
{$IFDEF USE_LANDSCAPE_AMMOMENU}
c:= -1;
    for i:= 0 to cMaxSlotIndex do
        if ((i = 0) and (Ammo^[i, 1].Count > 0)) or ((i <> 0) and (Ammo^[i, 0].Count > 0)) then
            begin
            inc(c);
    {$IFDEF USE_AM_NUMCOLUMN}
            g:= 1;
    {$ELSE}
            g:= 0;
    {$ENDIF}
            for t:=0 to cMaxSlotAmmoIndex do
                if (Ammo^[i, t].Count > 0) and (Ammo^[i, t].AmmoType <> amNothing) then
                    begin
                    if (CursorPoint.Y <= (cScreenHeight - AmmoRect.y) - ( g    * (AMSlotSize+1))) and
                       (CursorPoint.Y >  (cScreenHeight - AmmoRect.y) - ((g+1) * (AMSlotSize+1))) and
                       (CursorPoint.X >  AmmoRect.x                   + ( c    * (AMSlotSize+1))) and
                       (CursorPoint.X <= AmmoRect.x                   + ((c+1) * (AMSlotSize+1))) then
                        begin
                        Slot:= i;
                        Pos:= t;
                        STurns:= Ammoz[Ammo^[i, t].AmmoType].SkipTurns - CurrentTeam^.Clan^.TurnNumber;
                        if (STurns < 0) and (AMShiftX = 0) and (AMShiftY = 0) then
                            DrawSprite(sprAMSlot,
                                       AmmoRect.x + BORDERSIZE + (c * (AMSlotSize+1)) + AMSlotPadding,
                                       AmmoRect.y + BORDERSIZE + (g  * (AMSlotSize+1)) + AMSlotPadding -1, 0);
                        end;
                        inc(g);
                   end;
            end;
{$ELSE}
c:= -1;
    for i:= 0 to cMaxSlotIndex do
        if ((i = 0) and (Ammo^[i, 1].Count > 0)) or ((i <> 0) and (Ammo^[i, 0].Count > 0)) then
            begin
            inc(c);
    {$IFDEF USE_AM_NUMCOLUMN}
            g:= 1;
    {$ELSE}
            g:= 0;
    {$ENDIF}
            for t:=0 to cMaxSlotAmmoIndex do
                if (Ammo^[i, t].Count > 0) and (Ammo^[i, t].AmmoType <> amNothing) then
                    begin
                    if (CursorPoint.Y <= (cScreenHeight - AmmoRect.y) - ( c    * (AMSlotSize+1))) and
                       (CursorPoint.Y >  (cScreenHeight - AmmoRect.y) - ((c+1) * (AMSlotSize+1))) and
                       (CursorPoint.X >  AmmoRect.x                   + ( g    * (AMSlotSize+1))) and
                       (CursorPoint.X <= AmmoRect.x                   + ((g+1) * (AMSlotSize+1))) then
                        begin
                        Slot:= i;
                        Pos:= t;
                        STurns:= Ammoz[Ammo^[i, t].AmmoType].SkipTurns - CurrentTeam^.Clan^.TurnNumber;
                        if (STurns < 0) and (AMShiftX = 0) and (AMShiftY = 0) then
                            DrawSprite(sprAMSlot,
                                       AmmoRect.x + BORDERSIZE + (g * (AMSlotSize+1)) + AMSlotPadding,
                                       AmmoRect.y + BORDERSIZE + (c  * (AMSlotSize+1)) + AMSlotPadding -1, 0);
                        end;
                        inc(g);
                   end;
            end;
{$ENDIF}
    if (Pos >= 0) and (Pos <= cMaxSlotAmmoIndex) and (Slot >= 0) and (Slot <= cMaxSlotIndex)then
        begin
        if (AMShiftX = 0) and (AMShiftY = 0) then
        if (Ammo^[Slot, Pos].Count > 0) and (Ammo^[Slot, Pos].AmmoType <> amNothing) then
            begin
            if (amSel <> Ammo^[Slot, Pos].AmmoType) or (WeaponTooltipTex = nil) then
                begin
                amSel:= Ammo^[Slot, Pos].AmmoType;
                RenderWeaponTooltip(amSel)
                end;

            DrawTexture(AmmoRect.x + (AMSlotSize shr 1),
                        AmmoRect.y + AmmoRect.h - BORDERSIZE - (AMSlotSize shr 1) - (Ammoz[Ammo^[Slot, Pos].AmmoType].NameTex^.h shr 1),
                        Ammoz[Ammo^[Slot, Pos].AmmoType].NameTex);
            if Ammo^[Slot, Pos].Count < AMMO_INFINITE then
                DrawTexture(AmmoRect.x + AmmoRect.w - 20 - (CountTexz[Ammo^[Slot, Pos].Count]^.w),
                            AmmoRect.y + AmmoRect.h - BORDERSIZE - (AMslotSize shr 1) - (CountTexz[Ammo^[Slot, Pos].Count]^.w shr 1),
                            CountTexz[Ammo^[Slot, Pos].Count]);

            if bSelected and (Ammoz[Ammo^[Slot, Pos].AmmoType].SkipTurns - CurrentTeam^.Clan^.TurnNumber < 0) then
                begin
                bShowAmmoMenu:= false;
                SetWeapon(Ammo^[Slot, Pos].AmmoType);
                bSelected:= false;
                FreeAndNilTexture(WeaponTooltipTex);
{$IFDEF USE_TOUCH_INTERFACE}//show the aiming buttons + animation
                if (Ammo^[Slot, Pos].Propz and ammoprop_NeedUpDown) <> 0 then
                    begin
                    if (not arrowUp.show) then
                        begin
                        animateWidget(@arrowUp, true, true);
                        animateWidget(@arrowDown, true, true);
                        end;
                    end
                else
                    if arrowUp.show then
                        begin
                        animateWidget(@arrowUp, true, false);
                        animateWidget(@arrowDown, true, false);
                        end;
                SetUtilityWidgetState(Ammo^[Slot, Pos].AmmoType);
{$ENDIF}
                exit
                end;
            end
        end
    else
        FreeAndNilTexture(WeaponTooltipTex);

    if (WeaponTooltipTex <> nil) and (AMShiftX = 0) and (AMShiftY = 0) then
{$IFDEF USE_LANDSCAPE_AMMOMENU}
        if (not isPhone()) then
            ShowWeaponTooltip(-WeaponTooltipTex^.w div 2, AmmoRect.y - WeaponTooltipTex^.h - AMSlotSize);
{$ELSE}
        ShowWeaponTooltip(AmmoRect.x - WeaponTooltipTex^.w - 3, Min(AmmoRect.y + 1, cScreenHeight - WeaponTooltipTex^.h - 40));
{$ENDIF}

    bSelected:= false;
{$IFNDEF USE_TOUCH_INTERFACE}
   if (AMShiftX = 0) and (AMShiftY = 0) then
        DrawSprite(sprArrow, CursorPoint.X, cScreenHeight - CursorPoint.Y, (RealTicks shr 6) mod 8);
{$ENDIF}
end;

procedure DrawRepeated(spr, sprL, sprR: TSprite; Shift, OffsetY: LongInt);
var i, w, h, lw, lh, rw, rh, sw: LongInt;
begin
sw:= round(cScreenWidth / cScaleFactor);
if (SpritesData[sprL].Texture = nil) and (SpritesData[spr].Texture <> nil) then
    begin
    w:= SpritesData[spr].Width * SpritesData[spr].Texture^.Scale;
    h:= SpritesData[spr].Height * SpritesData[spr].Texture^.Scale;
    i:= Shift mod w;
    if i > 0 then
        dec(i, w);
    dec(i, w * (sw div w + 1));
    repeat
    DrawTexture(i, WorldDy + LAND_HEIGHT + OffsetY - h, SpritesData[spr].Texture, SpritesData[spr].Texture^.Scale);
    inc(i, w)
    until i > sw
    end
else if SpritesData[spr].Texture <> nil then
    begin
    w:= SpritesData[spr].Width * SpritesData[spr].Texture^.Scale;
    h:= SpritesData[spr].Height * SpritesData[spr].Texture^.Scale;
    lw:= SpritesData[sprL].Width * SpritesData[spr].Texture^.Scale;
    lh:= SpritesData[sprL].Height * SpritesData[spr].Texture^.Scale;
    if SpritesData[sprR].Texture <> nil then
        begin
        rw:= SpritesData[sprR].Width * SpritesData[spr].Texture^.Scale;
        rh:= SpritesData[sprR].Height * SpritesData[spr].Texture^.Scale
        end;
    dec(Shift, w div 2);
    DrawTexture(Shift, WorldDy + LAND_HEIGHT + OffsetY - h, SpritesData[spr].Texture, SpritesData[spr].Texture^.Scale);

    i:= Shift - lw;
    while i >= -sw - lw do
        begin
        DrawTexture(i, WorldDy + LAND_HEIGHT + OffsetY - lh, SpritesData[sprL].Texture, SpritesData[sprL].Texture^.Scale);
        dec(i, lw);
        end;

    i:= Shift + w;
    if SpritesData[sprR].Texture <> nil then
        while i <= sw do
            begin
            DrawTexture(i, WorldDy + LAND_HEIGHT + OffsetY - rh, SpritesData[sprR].Texture, SpritesData[sprR].Texture^.Scale);
            inc(i, rw)
            end
    else
        while i <= sw do
            begin
            DrawTexture(i, WorldDy + LAND_HEIGHT + OffsetY - lh, SpritesData[sprL].Texture, SpritesData[sprL].Texture^.Scale);
            inc(i, lw)
            end
    end
end;


procedure DrawWorld(Lag: LongInt);
begin
    if ZoomValue < zoom then
    begin
        zoom:= zoom - 0.002 * Lag;
        if ZoomValue > zoom then
            zoom:= ZoomValue
    end
    else
        if ZoomValue > zoom then
        begin
        zoom:= zoom + 0.002 * Lag;
        if ZoomValue < zoom then
            zoom:= ZoomValue
        end
    else
        ZoomValue:= zoom;

    // Sky
    glClear(GL_COLOR_BUFFER_BIT);
    //glPushMatrix;
    //glScalef(1.0, 1.0, 1.0);

    if (not isPaused) and (not isAFK) and (GameType <> gmtRecord) then
        MoveCamera;

    if cStereoMode = smNone then
        begin
        glClear(GL_COLOR_BUFFER_BIT);
        DrawWorldStereo(Lag, rmDefault)
        end
{$IFDEF USE_S3D_RENDERING}
    else if (cStereoMode = smHorizontal) or (cStereoMode = smVertical) then
        begin
        // create left fb
        glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framel);
        glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
        DrawWorldStereo(Lag, rmLeftEye);

        // create right fb
        glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framer);
        glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
        DrawWorldStereo(0, rmRightEye);

        // detatch drawing from fbs
        glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, defaultFrame);
        glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
        SetScale(cDefaultZoomLevel);

        // draw left frame
        glBindTexture(GL_TEXTURE_2D, texl);
        glBegin(GL_QUADS);
            if cStereoMode = smHorizontal then
                begin
                glTexCoord2f(0.0, 0.0);
                glVertex2d(cScreenWidth / -2, cScreenHeight);
                glTexCoord2f(1.0, 0.0);
                glVertex2d(0, cScreenHeight);
                glTexCoord2f(1.0, 1.0);
                glVertex2d(0, 0);
                glTexCoord2f(0.0, 1.0);
                glVertex2d(cScreenWidth / -2, 0);
                end
            else
                begin
                glTexCoord2f(0.0, 0.0);
                glVertex2d(cScreenWidth / -2, cScreenHeight / 2);
                glTexCoord2f(1.0, 0.0);
                glVertex2d(cScreenWidth / 2, cScreenHeight / 2);
                glTexCoord2f(1.0, 1.0);
                glVertex2d(cScreenWidth / 2, 0);
                glTexCoord2f(0.0, 1.0);
                glVertex2d(cScreenWidth / -2, 0);
                end;
        glEnd();

        // draw right frame
        glBindTexture(GL_TEXTURE_2D, texr);
        glBegin(GL_QUADS);
            if cStereoMode = smHorizontal then
                begin
                glTexCoord2f(0.0, 0.0);
                glVertex2d(0, cScreenHeight);
                glTexCoord2f(1.0, 0.0);
                glVertex2d(cScreenWidth / 2, cScreenHeight);
                glTexCoord2f(1.0, 1.0);
                glVertex2d(cScreenWidth / 2, 0);
                glTexCoord2f(0.0, 1.0);
                glVertex2d(0, 0);
                end
            else
                begin
                glTexCoord2f(0.0, 0.0);
                glVertex2d(cScreenWidth / -2, cScreenHeight);
                glTexCoord2f(1.0, 0.0);
                glVertex2d(cScreenWidth / 2, cScreenHeight);
                glTexCoord2f(1.0, 1.0);
                glVertex2d(cScreenWidth / 2, cScreenHeight / 2);
                glTexCoord2f(0.0, 1.0);
                glVertex2d(cScreenWidth / -2, cScreenHeight / 2);
                end;
        glEnd();
        SetScale(zoom);
        end
    else
        begin
        // clear scene
        glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
        glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
        // draw left eye in red channel only
        if cStereoMode = smGreenRed then
            glColorMask(GL_FALSE, GL_TRUE, GL_FALSE, GL_TRUE)
        else if cStereoMode = smBlueRed then
            glColorMask(GL_FALSE, GL_FALSE, GL_TRUE, GL_TRUE)
        else if cStereoMode = smCyanRed then
            glColorMask(GL_FALSE, GL_TRUE, GL_TRUE, GL_TRUE)
        else
            glColorMask(GL_TRUE, GL_FALSE, GL_FALSE, GL_TRUE);
        DrawWorldStereo(Lag, rmLeftEye);
        // draw right eye in selected channel(s) only
        if cStereoMode = smRedGreen then
            glColorMask(GL_FALSE, GL_TRUE, GL_FALSE, GL_TRUE)
        else if cStereoMode = smRedBlue then
            glColorMask(GL_FALSE, GL_FALSE, GL_TRUE, GL_TRUE)
        else if cStereoMode = smRedCyan then
            glColorMask(GL_FALSE, GL_TRUE, GL_TRUE, GL_TRUE)
        else
            glColorMask(GL_TRUE, GL_FALSE, GL_FALSE, GL_TRUE);
        DrawWorldStereo(Lag, rmRightEye);
        end
{$ENDIF}
end;

procedure ChangeDepth(rm: TRenderMode; d: GLfloat);
var tmp: LongInt;
begin
{$IFNDEF USE_S3D_RENDERING}
    rm:= rm; d:= d; tmp:= tmp; // avoid hint
{$ELSE}
    d:= d / 5;
    if rm = rmDefault then
        exit
    else if rm = rmLeftEye then
        d:= -d;
    cStereoDepth:= cStereoDepth + d;
    openglTranslProjMatrix(d, 0, 0);
    tmp:= round(d / cScaleFactor * cScreenWidth);
    ViewLeftX := ViewLeftX  - tmp;
    ViewRightX:= ViewRightX - tmp;
{$ENDIF}
end;

procedure ResetDepth(rm: TRenderMode);
var tmp: LongInt;
begin
{$IFNDEF USE_S3D_RENDERING}
    rm:= rm; tmp:= tmp; // avoid hint
{$ELSE}
    if rm = rmDefault then
        exit;
    openglTranslProjMatrix(-cStereoDepth, 0, 0);
    tmp:= round(cStereoDepth / cScaleFactor * cScreenWidth);
    ViewLeftX := ViewLeftX  + tmp;
    ViewRightX:= ViewRightX + tmp;
    cStereoDepth:= 0;
{$ENDIF}
end;

procedure RenderWorldEdge;
var
    //VertexBuffer: array [0..3] of TVertex2f;
    tmp, w: LongInt;
    rect: TSDL_Rect;
    //c1, c2: LongWord; // couple of colours for edges
begin
if (WorldEdge <> weNone) and (WorldEdge <> weSea) then
    begin
(* I think for a bounded world, will fill the left and right areas with black or something. Also will probably want various border effects/animations based on border type.  Prob also, say, trigger a border animation timer on an impact. *)

    rect.y:= ViewTopY;
    rect.h:= ViewHeight;
    tmp:= LongInt(leftX) + WorldDx;
    w:= tmp - ViewLeftX;

    if w > 0 then
        begin
        rect.w:= w;
        rect.x:= ViewLeftX;
        DrawRect(rect, $10, $10, $10, $80, true);
        if WorldEdge = weBounce then
            DrawLineOnScreen(tmp - 1, ViewTopY, tmp - 1, ViewBottomY, 2, $54, $54, $FF, $FF);
        end;

    tmp:= LongInt(rightX) + WorldDx;
    w:= ViewRightX - tmp;

    if w > 0 then
        begin
        rect.w:= w;
        rect.x:= tmp;
        DrawRect(rect, $10, $10, $10, $80, true);
        if WorldEdge = weBounce then
            DrawLineOnScreen(tmp - 1, ViewTopY, tmp - 1, ViewBottomY, 2, $54, $54, $FF, $FF);
        end;

    (*
    WARNING: the following render code is outdated and does not work with
             current Render.pas ! - don't just uncomment without fixing it first

    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    if (WorldEdge = weWrap) or (worldEdge = weBounce) then
        glColor4ub($00, $00, $00, $40)
    else
        begin
        glEnableClientState(GL_COLOR_ARRAY);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, @WorldFade[0]);
        end;

    glPushMatrix;
    glTranslatef(WorldDx, WorldDy, 0);

    VertexBuffer[0].X:= leftX-20;
    VertexBuffer[0].Y:= -3500;
    VertexBuffer[1].X:= leftX-20;
    VertexBuffer[1].Y:= cWaterLine+cVisibleWater;
    VertexBuffer[2].X:= leftX+30;
    VertexBuffer[2].Y:= cWaterLine+cVisibleWater;
    VertexBuffer[3].X:= leftX+30;
    VertexBuffer[3].Y:= -3500;

    glVertexPointer(2, GL_FLOAT, 0, @VertexBuffer[0]);
    glDrawArrays(GL_TRIANGLE_FAN, 0, Length(VertexBuffer));

    VertexBuffer[0].X:= rightX+20;
    VertexBuffer[1].X:= rightX+20;
    VertexBuffer[2].X:= rightX-30;
    VertexBuffer[3].X:= rightX-30;

    glVertexPointer(2, GL_FLOAT, 0, @VertexBuffer[0]);
    glDrawArrays(GL_TRIANGLE_FAN, 0, Length(VertexBuffer));

    glColorPointer(4, GL_UNSIGNED_BYTE, 0, @WorldEnd[0]);

    VertexBuffer[0].X:= -5000;
    VertexBuffer[1].X:= -5000;
    VertexBuffer[2].X:= leftX-20;
    VertexBuffer[3].X:= leftX-20;

    glVertexPointer(2, GL_FLOAT, 0, @VertexBuffer[0]);
    glDrawArrays(GL_TRIANGLE_FAN, 0, Length(VertexBuffer));

    VertexBuffer[0].X:= rightX+5000;
    VertexBuffer[1].X:= rightX+5000;
    VertexBuffer[2].X:= rightX+20;
    VertexBuffer[3].X:= rightX+20;

    glVertexPointer(2, GL_FLOAT, 0, @VertexBuffer[0]);
    glDrawArrays(GL_TRIANGLE_FAN, 0, Length(VertexBuffer));

    glPopMatrix;
    glDisableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    glColor4ub($FF, $FF, $FF, $FF); // must not be Tint() as color array seems to stay active and color reset is required
    glEnable(GL_TEXTURE_2D);

    // I'd still like to have things happen to the border when a wrap or bounce just occurred, based on a timer
    if WorldEdge = weBounce then
        begin
        // could maybe alternate order of these on a bounce, or maybe drop the outer ones.
        if LeftImpactTimer mod 2 = 0 then
            begin
            c1:= $5454FFFF; c2:= $FFFFFFFF;
            end
        else begin
            c1:= $FFFFFFFF; c2:= $5454FFFF;
            end;
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 7.0,   c1);
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 5.0,   c2);
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 3.0,   c1);
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 1.0,   c2);
        if RightImpactTimer mod 2 = 0 then
            begin
            c1:= $5454FFFF; c2:= $FFFFFFFF;
            end
        else begin
            c1:= $FFFFFFFF; c2:= $5454FFFF;
            end;
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 7.0, c1);
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 5.0, c2);
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 3.0, c1);
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 1.0, c2)
        end
    else if WorldEdge = weWrap then
        begin
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 5.0, $A0, $30, $60, max(50,255-LeftImpactTimer));
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 2.0, $FF0000FF);
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 5.0, $A0, $30, $60, max(50,255-RightImpactTimer));
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 2.0, $FF0000FF);
        end
    else
        begin
        DrawLine(leftX, -3000, leftX, cWaterLine+cVisibleWater, 5.0, $2E8B5780);
        DrawLine(rightX, -3000, rightX, cWaterLine+cVisibleWater, 5.0, $2E8B5780)
        end;
    if LeftImpactTimer > Lag then dec(LeftImpactTimer,Lag) else LeftImpactTimer:= 0;
    if RightImpactTimer > Lag then dec(RightImpactTimer,Lag) else RightImpactTimer:= 0
    *)
    end;
end;


procedure RenderTeamsHealth;
var t, i, h, smallScreenOffset, TeamHealthBarWidth : LongInt;
    r: TSDL_Rect;
    highlight: boolean;
    htex: PTexture;
begin
if TeamsCount * 20 > Longword(cScreenHeight) div 7 then  // take up less screen on small displays
    begin
    SetScale(1.5);
    smallScreenOffset:= cScreenHeight div 6;
    if TeamsCount * 100 > Longword(cScreenHeight) then
        Tint($FF,$FF,$FF,$80);
    end
else smallScreenOffset:= 0;
for t:= 0 to Pred(TeamsCount) do
    with TeamsArray[t]^ do
      if TeamHealth > 0 then
        begin
        highlight:= bShowFinger and (CurrentTeam = TeamsArray[t]) and ((RealTicks mod 1000) < 500);

        if highlight then
            begin
            Tint(Clan^.Color shl 8 or $FF);
            htex:= GenericHealthTexture
            end
        else
            htex:= Clan^.HealthTex;

        // draw owner
        if OwnerTex <> nil then
            DrawTexture(-OwnerTex^.w - NameTagTex^.w - 18, cScreenHeight + DrawHealthY + smallScreenOffset, OwnerTex);

        // draw name
        DrawTexture(-NameTagTex^.w - 16, cScreenHeight + DrawHealthY + smallScreenOffset, NameTagTex);

        // draw flag
        DrawTexture(-14, cScreenHeight + DrawHealthY + smallScreenOffset, FlagTex);

        TeamHealthBarWidth:= cTeamHealthWidth * TeamHealthBarHealth div MaxTeamHealth;

        // draw health bar
        r.x:= 0;
        r.y:= 0;
        r.w:= 2 + TeamHealthBarWidth;
        r.h:= htex^.h;
        DrawTextureFromRect(14, cScreenHeight + DrawHealthY + smallScreenOffset, @r, htex);

        // draw health bars right border
        inc(r.x, cTeamHealthWidth + 2);
        r.w:= 3;
        DrawTextureFromRect(TeamHealthBarWidth + 15, cScreenHeight + DrawHealthY + smallScreenOffset, @r, htex);

        h:= 0;
        if not hasGone then
            for i:= 0 to cMaxHHIndex do
                begin
                inc(h, Hedgehogs[i].HealthBarHealth);
                if (h < TeamHealthBarHealth) and (Hedgehogs[i].HealthBarHealth > 0) then
                    DrawTexture(15 + h * TeamHealthBarWidth div TeamHealthBarHealth, cScreenHeight + DrawHealthY + smallScreenOffset + 1, SpritesData[sprSlider].Texture);
                end;

        // draw ai kill counter for gfAISurvival
        if (GameFlags and gfAISurvival) <> 0 then
            begin
            DrawTexture(TeamHealthBarWidth + 22, cScreenHeight + DrawHealthY + smallScreenOffset, AIKillsTex);
            end;

        // if highlighted, draw flag and other contents again to keep their colors
        // this approach should be faster than drawing all borders one by one tinted or not
        if highlight then
            begin
            if TeamsCount * 100 > Longword(cScreenHeight) then
                Tint($FF,$FF,$FF,$80)
            else untint;

            // draw name
            r.x:= 2;
            r.y:= 2;
            r.w:= NameTagTex^.w - 4;
            r.h:= NameTagTex^.h - 4;
            DrawTextureFromRect(-NameTagTex^.w - 14, cScreenHeight + DrawHealthY + smallScreenOffset + 2, @r, NameTagTex);

            if OwnerTex <> nil then
                begin
                r.w:= OwnerTex^.w - 4;
                r.h:= OwnerTex^.h - 4;
                DrawTextureFromRect(-OwnerTex^.w - NameTagTex^.w - 16, cScreenHeight + DrawHealthY + smallScreenOffset + 2, @r, OwnerTex)
                end;

            if (GameFlags and gfAISurvival) <> 0 then
                begin
                r.w:= AIKillsTex^.w - 4;
                r.h:= AIKillsTex^.h - 4;
                DrawTextureFromRect(TeamHealthBarWidth + 24, cScreenHeight + DrawHealthY + smallScreenOffset + 2, @r, AIKillsTex);
                end;

            // draw flag
            r.w:= 22;
            r.h:= 15;
            DrawTextureFromRect(-12, cScreenHeight + DrawHealthY + smallScreenOffset + 2, @r, FlagTex);
            end
        // draw an arrow next to active team
        else if (CurrentTeam = TeamsArray[t]) and (TurnTimeLeft > 0) then
            begin
            h:= -NameTagTex^.w - 24;
            if OwnerTex <> nil then
                h:= h - OwnerTex^.w - 4;
            DrawSpriteRotatedF(sprFinger, h, cScreenHeight + DrawHealthY + smallScreenOffset + 2 + SpritesData[sprFinger].Width div 4, 0, 1, -90);
            end;
        end;
if smallScreenOffset <> 0 then
    begin
    SetScale(cDefaultZoomLevel);
    if TeamsCount * 20 > Longword(cScreenHeight) div 5 then
        untint;
    end;
end;


var preShiftWorldDx: LongInt;

procedure ShiftWorld(Dir: LongInt); inline;
begin
    preShiftWorldDx:= WorldDx;
    WorldDx:= WorldDx + Dir * LongInt(playWidth);

end;

procedure UnshiftWorld(); inline;
begin
    WorldDx:= preShiftWorldDx;
end;

procedure DrawWorldStereo(Lag: LongInt; RM: TRenderMode);
var i, t: LongInt;
    r: TSDL_Rect;
    tdx, tdy: Double;
    s: shortstring;
    offsetX, offsetY, screenBottom: LongInt;
    VertexBuffer: array [0..3] of TVertex2f;
    replicateToLeft, replicateToRight, tmp: boolean;
begin
if WorldEdge <> weWrap then
    begin
    replicateToLeft := false;
    replicateToRight:= false;
    end
else
    begin
    replicateToLeft := (LongInt(leftX)  + WorldDx > ViewLeftX);
    replicateToRight:= (LongInt(rightX) + WorldDx < ViewRightX);
    end;

ScreenBottom:= (WorldDy - trunc(cScreenHeight/cScaleFactor) - (cScreenHeight div 2) + cWaterLine);

// note: offsetY is negative!
offsetY:= 10 *  Min(0, -145 - ScreenBottom); // TODO limit this in the other direction too

if (cReducedQuality and rqNoBackground) = 0 then
    begin
        // Offsets relative to camera - spare them to wimpier cpus, no bg or flakes for them anyway
        SkyOffset:= offsetY div 35 + cWaveHeight;
        HorizontOffset:= SkyOffset;
        if ScreenBottom > SkyOffset then
            HorizontOffset:= HorizontOffset + ((ScreenBottom-SkyOffset) div 20);

        // background
        ChangeDepth(RM, cStereo_Sky);
        if SuddenDeathDmg then
            Tint(SDTint, SDTint, SDTint, $FF);
        DrawRepeated(sprSky, sprSkyL, sprSkyR, (WorldDx + LAND_WIDTH div 2) * 3 div 8, SkyOffset);
        ChangeDepth(RM, -cStereo_Horizon);
        DrawRepeated(sprHorizont, sprHorizontL, sprHorizontR, (WorldDx + LAND_WIDTH div 2) * 3 div 5, HorizontOffset);
        if SuddenDeathDmg then
            untint;
    end;

DrawVisualGears(0);
ChangeDepth(RM, -cStereo_MidDistance);
DrawVisualGears(4);

if (cReducedQuality and rq2DWater) = 0 then
    begin
        // Waves
        DrawWater(255, SkyOffset, 0);
        ChangeDepth(RM, -cStereo_Water_distant);
        DrawWaves( 1,  0 - WorldDx div 32, offsetY div 35, -49, 64);
        ChangeDepth(RM, -cStereo_Water_distant);
        DrawWaves( -1,  25 + WorldDx div 25, offsetY div 38, -37, 48);
        ChangeDepth(RM, -cStereo_Water_distant);
        DrawWaves( 1,  75 - WorldDx div 19, offsetY div 45, -23, 32);
        ChangeDepth(RM, -cStereo_Water_distant);
        DrawWaves(-1, 100 + WorldDx div 14, offsetY div 70, -7, 24);
    end
else
    DrawWaves(-1, 100, - cWaveHeight div 2, - cWaveHeight div 2, 0);

ChangeDepth(RM, cStereo_Land);
DrawVisualGears(5);
DrawLand(WorldDx, WorldDy);

if replicateToLeft then
    begin
    ShiftWorld(-1);
    DrawLand(WorldDx, WorldDy);
    UnshiftWorld();
    end;

if replicateToRight then
    begin
    ShiftWorld(1);
    DrawLand(WorldDx, WorldDy);
    UnshiftWorld();
    end;

DrawWater(255, 0, 0);

(*
// Attack bar
    if CurrentTeam <> nil then
        case AttackBar of
        //1: begin
        //r:= StuffPoz[sPowerBar];
        //{$WARNINGS OFF}
        //r.w:= (CurrentHedgehog^.Gear^.Power * 256) div cPowerDivisor;
        //{$WARNINGS ON}
        //DrawSpriteFromRect(r, cScreenWidth - 272, cScreenHeight - 48, 16, 0, Surface);
        //end;
        2: with CurrentHedgehog^ do
                begin
                tdx:= hwSign(Gear^.dX) * Sin(Gear^.Angle * Pi / cMaxAngle);
                tdy:= - Cos(Gear^.Angle * Pi / cMaxAngle);
                for i:= (Gear^.Power * 24) div cPowerDivisor downto 0 do
                    DrawSprite(sprPower,
                            hwRound(Gear^.X) + GetLaunchX(CurAmmoType, hwSign(Gear^.dX), Gear^.Angle) + LongInt(round(WorldDx + tdx * (24 + i * 2))) - 16,
                            hwRound(Gear^.Y) + GetLaunchY(CurAmmoType, Gear^.Angle) + LongInt(round(WorldDy + tdy * (24 + i * 2))) - 16,
                            i)
                end
        end;
*)

tmp:= bShowFinger;
bShowFinger:= false;

if replicateToLeft then
    begin
    ShiftWorld(-1);
    DrawVisualGears(1);
    DrawGears();
    DrawVisualGears(6);
    UnshiftWorld();
    end;

if replicateToRight then
    begin
    ShiftWorld(1);
    DrawVisualGears(1);
    DrawGears();
    DrawVisualGears(6);
    UnshiftWorld();
    end;

bShowFinger:= tmp;

DrawVisualGears(1);
DrawGears;
DrawVisualGears(6);


if SuddenDeathDmg then
    DrawWater(SDWaterOpacity, 0, 0)
else
    DrawWater(WaterOpacity, 0, 0);

    // Waves
ChangeDepth(RM, cStereo_Water_near);
DrawWaves( 1, 25 - WorldDx div 9, 0, 0, 12);

if (cReducedQuality and rq2DWater) = 0 then
    begin
    //DrawWater(WaterOpacity, - offsetY div 40);
    ChangeDepth(RM, cStereo_Water_near);
    DrawWaves(-1, 50 + WorldDx div 6, - offsetY div 40, 23, 8);
    if SuddenDeathDmg then
        DrawWater(SDWaterOpacity, - offsetY div 20, 23)
    else
        DrawWater(WaterOpacity, - offsetY div 20, 23);
    ChangeDepth(RM, cStereo_Water_near);
    DrawWaves( 1, 75 - WorldDx div 4, - offsetY div 20, 37, 2);
        if SuddenDeathDmg then
            DrawWater(SDWaterOpacity, - offsetY div 10, 47)
        else
            DrawWater(WaterOpacity, - offsetY div 10, 47);
        ChangeDepth(RM, cStereo_Water_near);
        DrawWaves( -1, 25 + WorldDx div 3, - offsetY div 10, 59, 0);
        end
    else
        DrawWaves(-1, 50, cWaveHeight div 2, cWaveHeight div 2, 0);

// everything after this ChangeDepth will be drawn outside the screen
// note: negative parallax gears should last very little for a smooth stereo effect
    ChangeDepth(RM, cStereo_Outside);

    if replicateToLeft then
        begin
        ShiftWorld(-1);
        DrawVisualGears(2);
        UnshiftWorld();
        end;

    if replicateToRight then
        begin
        ShiftWorld(1);
        DrawVisualGears(2);
        UnshiftWorld();
        end;

    DrawVisualGears(2);

// everything after this ResetDepth will be drawn at screen level (depth = 0)
// note: everything that needs to be readable should be on this level
    ResetDepth(RM);

    if replicateToLeft then
        begin
        ShiftWorld(-1);
        DrawVisualGears(3);
        UnshiftWorld();
        end;

    if replicateToRight then
        begin
        ShiftWorld(1);
        DrawVisualGears(3);
        UnshiftWorld();
        end;

    DrawVisualGears(3);

{$WARNINGS OFF}
// Target
if (TargetPoint.X <> NoPointX) and (CurrentTeam <> nil) and (CurrentHedgehog <> nil) then
    begin
    with PHedgehog(CurrentHedgehog)^ do
        begin
        if CurAmmoType = amBee then
            DrawSpriteRotatedF(sprTargetBee, TargetPoint.X + WorldDx, TargetPoint.Y + WorldDy, 0, 0, (RealTicks shr 3) mod 360)
        else
            DrawSpriteRotatedF(sprTargetP, TargetPoint.X + WorldDx, TargetPoint.Y + WorldDy, 0, 0, (RealTicks shr 3) mod 360)
        end
    end;
{$WARNINGS ON}

RenderWorldEdge();

// this scale is used to keep the various widgets at the same dimension at all zoom levels
SetScale(cDefaultZoomLevel);

// Turn time
if UIDisplay <> uiNone then
    begin
{$IFDEF USE_TOUCH_INTERFACE}
    offsetX:= cScreenHeight - 13;
{$ELSE}
    offsetX:= 48;
{$ENDIF}
    offsetY:= cOffsetY;
    if ((TurnTimeLeft <> 0) and (TurnTimeLeft < 1000000)) or (ReadyTimeLeft <> 0) then
        begin
        if ReadyTimeLeft <> 0 then
            i:= Succ(Pred(ReadyTimeLeft) div 1000)
        else
            i:= Succ(Pred(TurnTimeLeft) div 1000);

        if i>99 then
            t:= 112
        else if i>9 then
            t:= 96
        else
            t:= 80;
        DrawSprite(sprFrame, -(cScreenWidth shr 1) + t + offsetY, cScreenHeight - offsetX, 1);
        while i > 0 do
            begin
            dec(t, 32);
            DrawSprite(sprBigDigit, -(cScreenWidth shr 1) + t + offsetY, cScreenHeight - offsetX, i mod 10);
            i:= i div 10
            end;
        DrawSprite(sprFrame, -(cScreenWidth shr 1) + t - 4 + offsetY, cScreenHeight - offsetX, 0);
        end;

// Captions
    DrawCaptions
    end;

{$IFDEF USE_TOUCH_INTERFACE}
// Draw buttons Related to the Touch interface
DrawScreenWidget(@arrowLeft);
DrawScreenWidget(@arrowRight);
DrawScreenWidget(@arrowUp);
DrawScreenWidget(@arrowDown);

DrawScreenWidget(@fireButton);
DrawScreenWidget(@jumpWidget);
DrawScreenWidget(@AMWidget);
DrawScreenWidget(@pauseButton);
DrawScreenWidget(@utilityWidget);
{$ENDIF}

if UIDisplay = uiAll then
    RenderTeamsHealth;

// Lag alert
if isInLag then
    DrawSprite(sprLag, 32 - (cScreenWidth shr 1), 32, (RealTicks shr 7) mod 12);

// Wind bar
if UIDisplay <> uiNone then
    begin
{$IFDEF USE_TOUCH_INTERFACE}
    offsetX:= cScreenHeight - 13;
    offsetY:= (cScreenWidth shr 1) + 74;
{$ELSE}
    offsetX:= 30;
    offsetY:= 180;
{$ENDIF}
    DrawSprite(sprWindBar, (cScreenWidth shr 1) - offsetY, cScreenHeight - offsetX, 0);
    if WindBarWidth > 0 then
        begin
        {$WARNINGS OFF}
        r.x:= 8 - (RealTicks shr 6) mod 8;
        {$WARNINGS ON}
        r.y:= 0;
        r.w:= WindBarWidth;
        r.h:= 13;
        DrawSpriteFromRect(sprWindR, r, (cScreenWidth shr 1) - offsetY + 77, cScreenHeight - offsetX + 2, 13, 0);
        end
    else
        if WindBarWidth < 0 then
        begin
        {$WARNINGS OFF}
        r.x:= (Longword(WindBarWidth) + RealTicks shr 6) mod 8;
        {$WARNINGS ON}
        r.y:= 0;
        r.w:= - WindBarWidth;
        r.h:= 13;
        DrawSpriteFromRect(sprWindL, r, (cScreenWidth shr 1) - offsetY + 74 + WindBarWidth, cScreenHeight - offsetX + 2, 13, 0);
        end
    end;

// AmmoMenu
if bShowAmmoMenu and ((AMState = AMHidden) or (AMState = AMHiding)) then
    begin
    if (AMState = AMHidden) then
        AMAnimStartTime:= RealTicks
    else
        AMAnimStartTime:= RealTicks - (AMAnimDuration - (RealTicks - AMAnimStartTime));
    AMState:= AMShowingUp;
    end;
if (not bShowAmmoMenu) and ((AMstate = AMShowing) or (AMState = AMShowingUp)) then
    begin
    if (AMState = AMShowing) then
        AMAnimStartTime:= RealTicks
    else
        AMAnimStartTime:= RealTicks - (AMAnimDuration - (RealTicks - AMAnimStartTime));
    AMState:= AMHiding;
    end;

if bShowAmmoMenu or (AMState = AMHiding) then
    ShowAmmoMenu;

// Cursor
if isCursorVisible and bShowAmmoMenu then
    DrawSprite(sprArrow, CursorPoint.X, cScreenHeight - CursorPoint.Y, (RealTicks shr 6) mod 8);

// Chat
DrawChat;


// various captions
if fastUntilLag then
    DrawTextureCentered(0, (cScreenHeight shr 1), SyncTexture);
if isPaused then
    DrawTextureCentered(0, (cScreenHeight shr 1), PauseTexture);
if isAFK then
    DrawTextureCentered(0, (cScreenHeight shr 1), AFKTexture);
if not isFirstFrame and (missionTimer <> 0) or isPaused or fastUntilLag or (GameState = gsConfirm) then
    begin
    if (ReadyTimeLeft = 0) and (missionTimer > 0) then
        dec(missionTimer, Lag);
    if missionTimer < 0 then
        missionTimer:= 0; // avoid subtracting below 0
    if missionTex <> nil then
        DrawTextureCentered(0, Min((cScreenHeight shr 1) + 100, cScreenHeight - 48 - missionTex^.h), missionTex);
    end;

// fps
{$IFDEF USE_TOUCH_INTERFACE}
offsetX:= pauseButton.frame.y + pauseButton.frame.h + 12;
{$ELSE}
offsetX:= 10;
{$ENDIF}
offsetY:= cOffsetY;
if (RM = rmDefault) or (RM = rmRightEye) then
    begin
    inc(Frames);

    if cShowFPS or (GameType = gmtDemo) then
        inc(CountTicks, Lag);
    if (GameType = gmtDemo) and (CountTicks >= 1000) then
        begin
        i:= GameTicks div 1000;
        t:= i mod 60;
        s:= inttostr(t);
        if t < 10 then
            s:= '0' + s;
        i:= i div 60;
        t:= i mod 60;
        s:= inttostr(t) + ':' + s;
        if t < 10 then
            s:= '0' + s;
        s:= inttostr(i div 60) + ':' + s;


        tmpSurface:= TTF_RenderUTF8_Blended(Fontz[fnt16].Handle, Str2PChar(s), cWhiteColorChannels);
        tmpSurface:= doSurfaceConversion(tmpSurface);
        FreeAndNilTexture(timeTexture);
        timeTexture:= Surface2Tex(tmpSurface, false);
        SDL_FreeSurface(tmpSurface)
        end;

    if timeTexture <> nil then
        DrawTexture((cScreenWidth shr 1) - 20 - timeTexture^.w - offsetY, offsetX + timeTexture^.h+5, timeTexture);

    if cShowFPS then
        begin
        if CountTicks >= 1000 then
            begin
            FPS:= Frames;
            Frames:= 0;
            CountTicks:= 0;
            s:= inttostr(FPS) + ' fps';
            tmpSurface:= TTF_RenderUTF8_Blended(Fontz[fnt16].Handle, Str2PChar(s), cWhiteColorChannels);
            tmpSurface:= doSurfaceConversion(tmpSurface);
            FreeAndNilTexture(fpsTexture);
            fpsTexture:= Surface2Tex(tmpSurface, false);
            SDL_FreeSurface(tmpSurface)
            end;
        if fpsTexture <> nil then
            DrawTexture((cScreenWidth shr 1) - 60 - offsetY, offsetX, fpsTexture);
        end;
end;


if GameState = gsConfirm then
    DrawTextureCentered(0, (cScreenHeight shr 1)-40, ConfirmTexture);

if ScreenFade <> sfNone then
    begin
    if (not isFirstFrame) then
        case ScreenFade of
            sfToBlack, sfToWhite:     if ScreenFadeValue + Lag * ScreenFadeSpeed < sfMax then
                                          inc(ScreenFadeValue, Lag * ScreenFadeSpeed)
                                      else
                                          ScreenFadeValue:= sfMax;
            sfFromBlack, sfFromWhite: if ScreenFadeValue - Lag * ScreenFadeSpeed > 0 then
                                          dec(ScreenFadeValue, Lag * ScreenFadeSpeed)
                                      else
                                          ScreenFadeValue:= 0;
            end;
    if ScreenFade <> sfNone then
        begin
        case ScreenFade of
            sfToBlack, sfFromBlack: Tint(0, 0, 0, ScreenFadeValue * 255 div 1000);
            sfToWhite, sfFromWhite: Tint($FF, $FF, $FF, ScreenFadeValue * 255 div 1000);
            end;

        VertexBuffer[0].X:= -cScreenWidth;
        VertexBuffer[0].Y:= cScreenHeight;
        VertexBuffer[1].X:= -cScreenWidth;
        VertexBuffer[1].Y:= 0;
        VertexBuffer[2].X:= cScreenWidth;
        VertexBuffer[2].Y:= 0;
        VertexBuffer[3].X:= cScreenWidth;
        VertexBuffer[3].Y:= cScreenHeight;

        EnableTexture(false);

        SetVertexPointer(@VertexBuffer[0], 4);
        glDrawArrays(GL_TRIANGLE_FAN, 0, High(VertexBuffer) - Low(VertexBuffer) + 1);

        EnableTexture(true);
        untint;
        if not isFirstFrame and ((ScreenFadeValue = 0) or (ScreenFadeValue = sfMax)) then
            ScreenFade:= sfNone
        end
    end;

{$IFDEF USE_VIDEO_RECORDING}
// during video prerecording draw red blinking circle and text 'rec'
if flagPrerecording then
    begin
    if recTexture = nil then
        begin
        s:= 'rec';
        tmpSurface:= TTF_RenderUTF8_Blended(Fontz[fntBig].Handle, Str2PChar(s), cWhiteColorChannels);
        tmpSurface:= doSurfaceConversion(tmpSurface);
        FreeAndNilTexture(recTexture);
        recTexture:= Surface2Tex(tmpSurface, false);
        SDL_FreeSurface(tmpSurface)
        end;
    DrawTexture( -(cScreenWidth shr 1) + 50, 20, recTexture);

    // draw red circle
    glDisable(GL_TEXTURE_2D);
    Tint($FF, $00, $00, Byte(Round(127*(1 + sin(SDL_GetTicks()*0.007)))));
    glBegin(GL_POLYGON);
    for i:= 0 to 20 do
        glVertex2f(-(cScreenWidth shr 1) + 30 + sin(i*2*Pi/20)*10, 35 + cos(i*2*Pi/20)*10);
    glEnd();
    untint;
    glEnable(GL_TEXTURE_2D);
    end;
{$ENDIF}

SetScale(zoom);

// Attack bar
    if CurrentTeam <> nil then
        case AttackBar of
(*        1: begin
        r:= StuffPoz[sPowerBar];
        {$WARNINGS OFF}
        r.w:= (CurrentHedgehog^.Gear^.Power * 256) div cPowerDivisor;
        {$WARNINGS ON}
        DrawSpriteFromRect(r, cScreenWidth - 272, cScreenHeight - 48, 16, 0, Surface);
        end;*)
        2: with CurrentHedgehog^ do
                begin
                tdx:= hwSign(Gear^.dX) * Sin(Gear^.Angle * Pi / cMaxAngle);
                tdy:= - Cos(Gear^.Angle * Pi / cMaxAngle);
                for i:= (Gear^.Power * 24) div cPowerDivisor downto 0 do
                    DrawSprite(sprPower,
                            hwRound(Gear^.X) + GetLaunchX(CurAmmoType, hwSign(Gear^.dX), Gear^.Angle) + LongInt(round(WorldDx + tdx * (24 + i * 2))) - 16,
                            hwRound(Gear^.Y) + GetLaunchY(CurAmmoType, Gear^.Angle) + LongInt(round(WorldDy + tdy * (24 + i * 2))) - 16,
                            i)
                end
        end;


// Cursor
if isCursorVisible then
    begin
    if (not bShowAmmoMenu) then
        begin
        if not CurrentTeam^.ExtDriven then TargetCursorPoint:= CursorPoint;
        with CurrentHedgehog^ do
            if (Gear <> nil) and ((Gear^.State and gstChooseTarget) <> 0) then
                begin
            if (CurAmmoType = amNapalm) or (CurAmmoType = amMineStrike) or (((GameFlags and gfMoreWind) <> 0) and ((CurAmmoType = amDrillStrike) or (CurAmmoType = amAirAttack))) then
                DrawLine(-3000, topY-300, 7000, topY-300, 3.0, (Team^.Clan^.Color shr 16), (Team^.Clan^.Color shr 8) and $FF, Team^.Clan^.Color and $FF, $FF);
            i:= GetCurAmmoEntry(CurrentHedgehog^)^.Pos;
            with Ammoz[CurAmmoType] do
                if PosCount > 1 then
                    begin
                    if (CurAmmoType = amGirder) or (CurAmmoType = amTeleport) then
                        begin
                    // pulsating transparency
                        if ((GameTicks div 16) mod $80) >= $40 then
                            Tint($FF, $FF, $FF, $C0 - (GameTicks div 16) mod $40)
                        else
                            Tint($FF, $FF, $FF, $80 + (GameTicks div 16) mod $40);
                        end;
                    DrawSprite(PosSprite, TargetCursorPoint.X - (SpritesData[PosSprite].Width shr 1), cScreenHeight - TargetCursorPoint.Y - (SpritesData[PosSprite].Height shr 1),i);
                    Untint();
                    end;
                end;
        //DrawSprite(sprArrow, TargetCursorPoint.X, cScreenHeight - TargetCursorPoint.Y, (RealTicks shr 6) mod 8)
        DrawTextureF(SpritesData[sprArrow].Texture, cDefaultZoomLevel / cScaleFactor, TargetCursorPoint.X + round(SpritesData[sprArrow].Width / cScaleFactor), cScreenHeight + round(SpritesData[sprArrow].Height / cScaleFactor) - TargetCursorPoint.Y, (RealTicks shr 6) mod 8, 1, SpritesData[sprArrow].Width, SpritesData[sprArrow].Height);
        end
    end;

// debug stuff
if cViewLimitsDebug then
    begin
    r.x:= ViewLeftX;
    r.y:= ViewTopY;
    r.w:= ViewWidth;
    r.h:= ViewHeight;
    DrawRect(r, 255, 0, 0, 128, false);
    end;

isFirstFrame:= false
end;

var PrevSentPointTime: LongWord = 0;

procedure MoveCamera;
var EdgesDist, wdy, shs,z, amNumOffsetX, amNumOffsetY, cameraJump: LongInt;
    inbtwnTrgtAttks: Boolean;
begin
{$IFNDEF MOBILE}
if (not (CurrentTeam^.ExtDriven and isCursorVisible and (not bShowAmmoMenu) and autoCameraOn)) and cHasFocus and (GameState <> gsConfirm) then
    uCursor.updatePosition();
{$ENDIF}
z:= round(200/zoom);
inbtwnTrgtAttks := ((GameFlags and gfInfAttack) <> 0) and (CurrentHedgehog <> nil) and ((CurrentHedgehog^.Gear = nil) or (CurrentHedgehog^.Gear <> FollowGear)) and ((Ammoz[CurrentHedgehog^.CurAmmoType].Ammo.Propz and ammoprop_NeedTarget) <> 0);
if autoCameraOn and (not PlacingHogs) and (FollowGear <> nil) and (not isCursorVisible) and (not bShowAmmoMenu) and (not fastUntilLag) and (not inbtwnTrgtAttks) then
    if ((abs(CursorPoint.X - prevPoint.X) + abs(CursorPoint.Y - prevpoint.Y)) > 4) then
        begin
        FollowGear:= nil;
        prevPoint:= CursorPoint;
        exit
        end
    else
        begin
        if (WorldEdge = weWrap) then
            cameraJump:= LongInt(playWidth) div 2 + 50
        else
            cameraJump:= LongInt(rightX) - leftX - 100;

        if abs(prevPoint.X - WorldDx - hwRound(FollowGear^.X)) > cameraJump then
            begin
            if prevPoint.X - WorldDx < LongInt(playWidth div 2) then
                cameraJump:= LongInt(playWidth)
            else
                cameraJump:= -LongInt(playWidth);
            WorldDx:= WorldDx - cameraJump;
            end;

        CursorPoint.X:= (prevPoint.X * 7 + hwRound(FollowGear^.X) + hwSign(FollowGear^.dX) * z + WorldDx) div 8;

        if isPhone() or (cScreenHeight < 600) or ((hwSign(FollowGear^.dY) * z) < 10)  then
            CursorPoint.Y:= (prevPoint.Y * 7 + cScreenHeight - (hwRound(FollowGear^.Y) + WorldDy)) div 8
        else
            CursorPoint.Y:= (prevPoint.Y * 7 + cScreenHeight - (hwRound(FollowGear^.Y) + hwSign(FollowGear^.dY) * z + WorldDy)) div 8;
        end;

wdy:= trunc(cScreenHeight / cScaleFactor) + cScreenHeight div 2 - cWaterLine - cVisibleWater;
if WorldDy < wdy then
    WorldDy:= wdy;

if ((CursorPoint.X = prevPoint.X) and (CursorPoint.Y = prevpoint.Y)) then
    exit;

if (AMState = AMShowingUp) or (AMState = AMShowing) then
begin
{$IFDEF USE_LANDSCAPE_AMMOMENU}
    amNumOffsetX:= 0;
    {$IFDEF USE_AM_NUMCOLUMN}
    amNumOffsetY:= AMSlotSize;
    {$ELSE}
    amNumOffsetY:= 0;
    {$ENDIF}
{$ELSE}
    amNumOffsetY:= 0;
    {$IFDEF USE_AM_NUMCOLUMN}
    amNumOffsetX:= AMSlotSize;
    {$ELSE}
    amNumOffsetX:= 0;
    {$ENDIF}

{$ENDIF}
    if CursorPoint.X < AmmoRect.x + amNumOffsetX + 3 then//check left
        CursorPoint.X:= AmmoRect.x + amNumOffsetX + 3;
    if CursorPoint.X > AmmoRect.x + AmmoRect.w - 3 then//check right
        CursorPoint.X:= AmmoRect.x + AmmoRect.w - 3;
    if CursorPoint.Y > cScreenHeight - AmmoRect.y -amNumOffsetY - 1 then//check top
        CursorPoint.Y:= cScreenHeight - AmmoRect.y - amNumOffsetY - 1;
    if CursorPoint.Y < cScreenHeight - (AmmoRect.y + AmmoRect.h - AMSlotSize - 5) then//check bottom
        CursorPoint.Y:= cScreenHeight - (AmmoRect.y + AmmoRect.h - AMSlotSize - 5);
    prevPoint:= CursorPoint;
    //if cHasFocus then SDL_WarpMouse(CursorPoint.X + cScreenWidth div 2, cScreenHeight - CursorPoint.Y);
    exit
end;

if isCursorVisible then
    begin
    if (not CurrentTeam^.ExtDriven) and (GameTicks >= PrevSentPointTime + cSendCursorPosTime) then
        begin
        SendIPCXY('P', CursorPoint.X - WorldDx, cScreenHeight - CursorPoint.Y - WorldDy);
        PrevSentPointTime:= GameTicks
        end;
    EdgesDist:= cCursorEdgesDist
    end
else
    EdgesDist:= cGearScrEdgesDist;

// this generates the border around the screen that moves the camera when cursor is near it
if (CurrentTeam^.ExtDriven and isCursorVisible and autoCameraOn) or
   (not CurrentTeam^.ExtDriven and isCursorVisible) or ((FollowGear <> nil) and autoCameraOn) then
    begin
    if CursorPoint.X < - cScreenWidth div 2 + EdgesDist then
        begin
        WorldDx:= WorldDx - CursorPoint.X - cScreenWidth div 2 + EdgesDist;
        CursorPoint.X:= - cScreenWidth div 2 + EdgesDist
        end
    else
        if CursorPoint.X > cScreenWidth div 2 - EdgesDist then
            begin
            WorldDx:= WorldDx - CursorPoint.X + cScreenWidth div 2 - EdgesDist;
            CursorPoint.X:= cScreenWidth div 2 - EdgesDist
            end;

    shs:= min(cScreenHeight div 2 - trunc(cScreenHeight / cScaleFactor) + EdgesDist, cScreenHeight - EdgesDist);
    if CursorPoint.Y < shs then
        begin
        WorldDy:= WorldDy + CursorPoint.Y - shs;
        CursorPoint.Y:= shs;
        end
    else
        if (CursorPoint.Y > cScreenHeight - EdgesDist) then
            begin
           WorldDy:= WorldDy + CursorPoint.Y - cScreenHeight + EdgesDist;
           CursorPoint.Y:= cScreenHeight - EdgesDist
            end;
    end
else
    if cHasFocus then
        begin
        WorldDx:= WorldDx - CursorPoint.X + prevPoint.X;
        WorldDy:= WorldDy + CursorPoint.Y - prevPoint.Y;
        CursorPoint.X:= 0;
        CursorPoint.Y:= cScreenHeight div 2;
        end;

// this moves the camera according to CursorPoint X and Y
prevPoint:= CursorPoint;
//if cHasFocus then SDL_WarpMouse(CursorPoint.X + (cScreenWidth shr 1), cScreenHeight - CursorPoint.Y);
if WorldDy > LAND_HEIGHT + 1024 then
    WorldDy:= LAND_HEIGHT + 1024;
if WorldDy < wdy then
    WorldDy:= wdy;
if WorldDx < - LAND_WIDTH - 1024 then
    WorldDx:= - LAND_WIDTH - 1024;
if WorldDx > 1024 then
    WorldDx:= 1024;
end;

procedure ShowMission(caption, subcaption, text: ansistring; icon, time : LongInt);
var r: TSDL_Rect;
begin
if cOnlyStats then exit;

r.w:= 32;
r.h:= 32;

if time = 0 then
    time:= 5000;
missionTimer:= time;
FreeAndNilTexture(missionTex);

if icon > -1 then
    begin
    r.x:= 0;
    r.y:= icon * 32;
    missionTex:= RenderHelpWindow(caption, subcaption, text, ansistring(''), 0, MissionIcons, @r)
    end
else
    begin
    r.x:= ((-icon - 1) shr 4) * 32;
    r.y:= ((-icon - 1) mod 16) * 32;
    missionTex:= RenderHelpWindow(caption, subcaption, text, ansistring(''), 0, SpritesData[sprAMAmmos].Surface, @r)
    end;
end;

procedure HideMission;
begin
    missionTimer:= 0;
end;

procedure ShakeCamera(amount: LongInt);
begin
if isCursorVisible then
    exit;
amount:= Max(1, round(amount*zoom/2));
WorldDx:= WorldDx - amount + LongInt(random(1 + amount * 2));
WorldDy:= WorldDy - amount + LongInt(random(1 + amount * 2));
//CursorPoint.X:= CursorPoint.X - amount + LongInt(random(1 + amount * 2));
//CursorPoint.Y:= CursorPoint.Y - amount + LongInt(random(1 + amount * 2))
end;


procedure onFocusStateChanged;
begin
if (not cHasFocus) and (GameState <> gsConfirm) then
    ParseCommand('quit', true);
{$IFDEF MOBILE}
// when created SDL receives an exposure event that calls UndampenAudio at full power, muting audio
exit;
{$ENDIF}

{$IFDEF USE_VIDEO_RECORDING}
// do not change volume during prerecording as it will affect sound in video file
if (not flagPrerecording) then
{$ENDIF}
    begin
    if (not cHasFocus) then DampenAudio()
    else UndampenAudio();
    end;
end;

procedure updateCursorVisibility;
begin
    if isPaused or isAFK then
        SDL_ShowCursor(1)
    else
        SDL_ShowCursor(ord(GameState = gsConfirm))
end;

procedure SetUtilityWidgetState(ammoType: TAmmoType);
begin
{$IFDEF USE_TOUCH_INTERFACE}
if(ammoType = amNothing)then
    ammoType:= CurrentHedgehog^.CurAmmoType;

if(CurrentHedgehog <> nil)then
    if (Ammoz[ammoType].Ammo.Propz and ammoprop_Timerable) <> 0 then
        begin
        utilityWidget.sprite:= sprTimerButton;
        animateWidget(@utilityWidget, true, true);
        end
    else if (Ammoz[ammoType].Ammo.Propz and ammoprop_NeedTarget) <> 0 then
        begin
        utilityWidget.sprite:= sprTargetButton;
        animateWidget(@utilityWidget, true, true);
        end
    else if ammoType = amSwitch then
        begin
        utilityWidget.sprite:= sprTargetButton;
        animateWidget(@utilityWidget, true, true);
        end
    else if utilityWidget.show then
        animateWidget(@utilityWidget, true, false);
{$ELSE}
ammoType:= ammoType; // avoid hint
{$ENDIF}
end;

procedure animateWidget(widget: POnScreenWidget; fade, showWidget: boolean);
begin
with widget^ do
    begin
    show:= showWidget;
    if fade then fadeAnimStart:= RealTicks;

    with moveAnim do
        begin
        animate:= true;
        startTime:= RealTicks;
        source.x:= source.x xor target.x; //swap source <-> target
        target.x:= source.x xor target.x;
        source.x:= source.x xor target.x;
        source.y:= source.y xor target.y;
        target.y:= source.y xor target.y;
        source.y:= source.y xor target.y;
        end;
    end;
end;


procedure initModule;
begin
    fpsTexture:= nil;
    recTexture:= nil;
    FollowGear:= nil;
    WindBarWidth:= 0;
    bShowAmmoMenu:= false;
    bSelected:= false;
    bShowFinger:= false;
    Frames:= 0;
    WorldDx:= -512;
    WorldDy:= -256;
    PrevSentPointTime:= 0;

    FPS:= 0;
    CountTicks:= 0;
    SoundTimerTicks:= 0;
    prevPoint.X:= 0;
    prevPoint.Y:= 0;
    missionTimer:= 0;
    missionTex:= nil;
    cOffsetY:= 0;
    AMState:= AMHidden;
    isFirstFrame:= true;

    FillChar(WorldFade, sizeof(WorldFade), 0);
    WorldFade[0].a:= 255;
    WorldFade[1].a:= 255;
    FillChar(WorldEnd, sizeof(WorldEnd), 0);
    WorldEnd[0].a:= 255;
    WorldEnd[1].a:= 255;
    WorldEnd[2].a:= 255;
    WorldEnd[3].a:= 255;

    AmmoMenuTex:= nil;
    AmmoMenuInvalidated:= true
end;

procedure freeModule;
begin
    ResetWorldTex();
end;

end.
