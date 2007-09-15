(*
 * Hedgewars, a worms-like game
 * Copyright (c) 2007 Andrey Korotaev <unC0Rr@gmail.com>
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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 *)

unit uTriggers;

interface
uses SDLh, uConsts;
{$INCLUDE options.inc}
const trigTurns = $80000001;

procedure AddTrigger(id, Ticks, Lives: Longword);
procedure TickTrigger(id: Longword);

implementation
uses uGears, uFloat, uMisc;
type PTrigger = ^TTrigger;
     TTrigger = record
                id: Longword;
                Ticks: Longword;
                Lives: Longword;
                TicksPerLife: LongWord;
                Next: PTrigger;
                end;
var TriggerList: PTrigger = nil;

procedure AddTrigger(id, Ticks, Lives: Longword);
var tmp: PTrigger;
begin
if (Ticks = 0) or (Lives = 0) then exit;
{$IFDEF DEBUGFILE}AddFileLog('Add trigger: ' + inttostr(id));{$ENDIF}
new(tmp);
FillChar(tmp^, sizeof(TGear), 0);

tmp^.id:= id;
tmp^.Ticks:= Ticks;
tmp^.TicksPerLife:= Ticks;
tmp^.Lives:= Lives;
if TriggerList <> nil then tmp^.Next:= TriggerList;
TriggerList:= tmp
end;

procedure TickTriggerT(Trigger: PTrigger);
begin
AddGear(1024, -140, gtTarget, 0, _0, _0, 0)
end;

procedure TickTrigger(id: Longword);
var t, pt, nt: PTrigger;
begin
t:= TriggerList;
pt:= nil;

while (t <> nil) do
  begin
  nt:= t^.Next;
  if (t^.id = id) then
    begin
    dec(t^.Ticks);
    if (t^.Ticks = 0) then
       begin
       TickTriggerT(t);
       dec(t^.Lives);
       t^.Ticks:= t^.TicksPerLife;
       if (t^.Lives = 0) then
          begin
          if t = TriggerList then TriggerList:= nt
                             else pt^.Next:= nt;
          Dispose(t)
          end
       end
    end;
  pt:= t;
  t:= nt
  end
end;

end.