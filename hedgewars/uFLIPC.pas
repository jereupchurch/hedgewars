unit uFLIPC;
interface
uses SDLh;

type TIPCMessage = record
                   str: shortstring;
                   len: Longword;
                   buf: Pointer
               end;
    TIPCCallback = procedure (p: pointer; s: shortstring);

var msgFrontend, msgEngine: TIPCMessage;
    mutFrontend, mutEngine: PSDL_mutex;
    condFrontend, condEngine: PSDL_cond;

procedure initIPC;
procedure freeIPC;

procedure ipcToEngine(s: shortstring); cdecl; export;
function  ipcReadFromEngine: shortstring;
function  ipcCheckFromEngine: boolean;

procedure ipcToFrontend(s: shortstring);
function ipcReadFromFrontend: shortstring;
function ipcCheckFromFrontend: boolean;

procedure registerIPCCallback(p: pointer; f: TIPCCallback); cdecl; export;

implementation

var callbackPointer: pointer;
    callbackFunction: TIPCCallback;
    callbackListenerThread: PSDL_Thread;

procedure ipcSend(var s: shortstring; var msg: TIPCMessage; mut: PSDL_mutex; cond: PSDL_cond);
begin
    SDL_LockMutex(mut);
    writeln(stdout, 'ipc send', s);
    while (msg.str[0] > #0) or (msg.buf <> nil) do
        SDL_CondWait(cond, mut);

    msg.str:= s;
    SDL_CondSignal(cond);
    SDL_UnlockMutex(mut);
    writeln(stdout, 'ipc sent', s[1])
end;

function ipcRead(var msg: TIPCMessage; mut: PSDL_mutex; cond: PSDL_cond): shortstring;
begin
    SDL_LockMutex(mut);
    while (msg.str[0] = #0) and (msg.buf = nil) do
        SDL_CondWait(cond, mut);

    ipcRead:= msg.str;
    writeln(stdout, 'engine ipc received', msg.str[1]);
    msg.str[0]:= #0;
    if msg.buf <> nil then
    begin
        FreeMem(msg.buf, msg.len);
        msg.buf:= nil
    end;

    SDL_CondSignal(cond);
    SDL_UnlockMutex(mut)
end;

function ipcCheck(var msg: TIPCMessage; mut: PSDL_mutex): boolean;
begin
    SDL_LockMutex(mut);
    ipcCheck:= (msg.str[0] > #0) or (msg.buf <> nil);
    SDL_UnlockMutex(mut)
end;

procedure ipcToEngine(s: shortstring); cdecl; export;
begin
    ipcSend(s, msgEngine, mutEngine, condEngine)
end;

procedure ipcToFrontend(s: shortstring);
begin
    ipcSend(s, msgFrontend, mutFrontend, condFrontend)
end;

function ipcReadFromEngine: shortstring;
begin
    ipcReadFromEngine:= ipcRead(msgFrontend, mutFrontend, condFrontend)
end;

function ipcReadFromFrontend: shortstring;
begin
    ipcReadFromFrontend:= ipcRead(msgEngine, mutEngine, condEngine)
end;

function ipcCheckFromEngine: boolean;
begin
    ipcCheckFromEngine:= ipcCheck(msgFrontend, mutFrontend)
end;

function ipcCheckFromFrontend: boolean;
begin
    ipcCheckFromFrontend:= ipcCheck(msgEngine, mutEngine)
end;

function  listener(p: pointer): Longint; cdecl; export;
begin
    listener:= 0;
    repeat
        callbackFunction(callbackPointer, ipcReadFromEngine())
    until false
end;

procedure registerIPCCallback(p: pointer; f: TIPCCallback); cdecl; export;
begin
    callbackPointer:= p;
    callbackFunction:= f;
    callbackListenerThread:= SDL_CreateThread(@listener{$IFDEF SDL2}, 'ipcListener'{$ENDIF}, nil);
end;

procedure initIPC;
begin
    msgFrontend.str:= '';
    msgFrontend.buf:= nil;
    msgEngine.str:= '';
    msgEngine.buf:= nil;

    callbackPointer:= nil;
    callbackListenerThread:= nil;

    mutFrontend:= SDL_CreateMutex;
    mutEngine:= SDL_CreateMutex;
    condFrontend:= SDL_CreateCond;
    condEngine:= SDL_CreateCond;
end;

procedure freeIPC;
begin
    SDL_KillThread(callbackListenerThread);
    SDL_DestroyMutex(mutFrontend);
    SDL_DestroyMutex(mutEngine);
    SDL_DestroyCond(condFrontend);
    SDL_DestroyCond(condEngine);
end;

end.
