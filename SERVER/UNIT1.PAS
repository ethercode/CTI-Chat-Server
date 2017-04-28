unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ScktComp;

type TUser = record
  avail: boolean;
  nick : string;
  op: boolean;
  silent: boolean;
  static: boolean;
  ip: string;
  hostName: string;
  verified: boolean;
  socket: TClientWinSocket;
end;

type TServerAttributes = record
  totalUsers, ops, users, silenced: integer;
  port: integer;
  active: boolean;
end;

type TCommand = record
  cmd, body: string;
end;

type TUserListItem = record
  slot: integer;
  nick: string;
end;

type
  TserverForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    statLabel: TLabel;
    activateButton: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    clientsLabel: TLabel;
    Label2: TLabel;
    opsLabel: TLabel;
    Label4: TLabel;
    standardLabel: TLabel;
    userDetailsFrame: TGroupBox;
    userList: TListBox;
    specificsFrame: TGroupBox;
    Label6: TLabel;
    curOp: TCheckBox;
    curSil: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    curNick: TLabel;
    curIP: TLabel;
    curHostname: TLabel;
    server: TServerSocket;
    Label12: TLabel;
    portBox: TEdit;
    Label13: TLabel;
    silencedLabel: TLabel;
    pingTimer: TTimer;
    updateTimer: TTimer;
    specificsUpdater: TTimer;
    procedure activateButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure serverListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure clearAllUsers;
    function findFreeUserSlot : integer;
    function findUser(sock: TClientWinSocket) : integer;
    function split(source: string): TCommand;
    function whoIs(usr: string): integer;
    procedure freeSlot(i: integer);
    procedure globalSend(str: string; exc: TClientWinSocket);
    procedure sendUserList(usr: integer);
    function nickUsed(nck: string) : boolean;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure serverClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure serverClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure updateTimerTimer(Sender: TObject);
    procedure serverClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure serverClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure specificsUpdaterTimer(Sender: TObject);
    procedure curOpClick(Sender: TObject);
    procedure curSilClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  serverForm: TserverForm;
  servAttr: TServerAttributes;
  user: array [1..100] of TUser;
  nickList: array[1..100] of TUserListItem;
  topic, topicOwner: string;
  currentSelected: integer;
  specLocked: boolean;
implementation

{$R *.DFM}

function TserverForm.nickUsed(nck: string) : boolean;
var n: integer;
    found: boolean;
begin
  found:=false;
  for n:=1 to 100 do
  begin
    if (uppercase(user[n].nick)=uppercase(nck)) and (user[n].avail=false) and (user[n].verified=true) then
    begin
      found:=true;
    end;
  end;
  nickUsed:=found;
end;

function TserverForm.split(source: string): TCommand;
var x: integer;
    c: string;
    p: string;
    l: integer;
    second: boolean;
    comm: TCommand;
begin
  second:=false;
  c:='';
  p:='';
  l:=strlen(pchar(source));
  for x:=1 to l do
  begin
    if source[x]<>' ' then
    begin
      if second=false then c:=c+source[x]
      else p:=p+source[x];
    end
    else
    begin
      if second=true then p:=p+' ';
      second:=true;
    end;
  end;
  comm.cmd:=c;
  comm.body:=p;
  split:=comm;
end;

procedure TserverForm.freeSlot(i: integer);
begin
    user[i].avail:=true;
    user[i].nick:='';
    user[i].op:=false;
    user[i].silent:=false;
    user[i].ip:='';
    user[i].static:=false;
    user[i].hostName:='';
    user[i].socket:=nil;
    user[i].verified:=false;
end;

function TserverForm.findFreeUserSlot : integer;
var cur: integer;
    fnd: integer;
begin
  fnd:=-1;
  cur:=1;
  while cur<=100 do
  begin
    if user[cur].avail=true then
    begin
      fnd:=cur;
      break;
    end;
    inc(cur);
  end;
  findFreeUserSlot:=fnd;
end;

procedure TserverForm.clearAllUsers;
var i: integer;
begin
  for i:=1 to 100 do
  begin
    user[i].avail:=true;
    user[i].nick:='';
    user[i].op:=false;
    user[i].silent:=false;
    user[i].ip:='';
    user[i].static:=false;
    user[i].hostName:='';
    user[i].socket:=nil;
    user[i].verified:=false;
    nickList[i].slot:=0;
  end;
end;

function TserverForm.findUser(sock: TClientWinSocket) : integer;
var index: integer;
    x: integer;
begin
  index:=-1;
  for x:=1 to 100 do
  begin
    if user[x].socket=sock then
    begin
      index:=x;
      break;
    end;
  end;
  findUser:=index;
end;

procedure TserverForm.activateButtonClick(Sender: TObject);
begin
  topic:='Welcome to CTI Chat Server';
  topicOwner:='Server';
  clearAllUsers;
  if servAttr.active=false then
  begin
    servAttr.totalUsers:=0;
    servAttr.ops:=0;
    servAttr.users:=0;
    servAttr.port:=strtoint(portBox.text);
    servAttr.active:=false;
    userList.clear;
    server.port:=servAttr.port;
    server.active:=true;
  end
  else
  begin
    userDetailsFrame.Hide;
    serverForm.Height:=127;
    server.active:=false;
    statLabel.Font.Color:=CLRED;
    statLabel.Caption:='Offline';
    activateButton.caption:='ACTIVATE';
    servAttr.active:=false;
  end;
end;

procedure TserverForm.FormCreate(Sender: TObject);
begin
  currentSelected:=-1;
  clearAllUsers;
  userDetailsFrame.Hide;
  serverForm.Height:=127;
end;

procedure TserverForm.serverListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  statLabel.Font.Color:=CLGREEN;
  statLabel.Caption:='Online';
  userDetailsFrame.Show;
  serverForm.Height:=271;
  activateButton.caption:='DE-ACTIVATE';
  servAttr.active:=true;
end;

procedure TserverForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  canClose:=not(servAttr.active);
end;

procedure TserverForm.serverClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var slot: integer;
begin
  slot:=findFreeUserSlot;
  if slot<>-1 then
  begin
    user[slot].avail:=false;
    user[slot].ip:=socket.RemoteAddress;
    user[slot].hostName:=socket.RemoteHost;
    user[slot].socket:=TClientWinSocket(socket);
    user[slot].socket.SendText('NCK '+chr(1));
  end
  else
  begin
    user[slot].socket:=TClientWinSocket(socket);
    user[slot].socket.SendText('TMU '+chr(1));
    user[slot].socket.close;
  end;
end;

procedure TserverForm.serverClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var badUser: integer;
begin
  badUser:=findUser(TClientWinSocket(socket));
  if badUser<>-1 then
  begin
    user[baduser].avail:=true;
    if user[badUser].verified=true then
    begin
      globalSend('SVR '+user[badUser].nick+' has left the room.',user[badUser].socket);
      globalSend('LFT '+user[baduser].nick,user[badUser].socket);
    end;
  end;
  freeSlot(badUser);
  errorCode:=0;
end;

procedure TserverForm.updateTimerTimer(Sender: TObject);
var a: integer;
begin
  servAttr.totalUsers:=0;
  servAttr.users:=0;
  servAttr.ops:=0;
  servAttr.silenced:=0;
  for a:=1 to 100 do
  begin
    if user[a].avail=false then
    begin
      inc(servAttr.totalUsers);
      if user[a].op=true then inc(servAttr.ops)
      else if user[a].verified=true then
      begin
        inc(servAttr.users);
        nickList[a].slot:=a;
        nickList[a].nick:=user[a].nick;
      end;
      if user[a].silent=true then inc(servAttr.silenced);
    end;
  end;
  clientsLabel.caption:=inttostr(servAttr.totalUsers);
  opsLabel.caption:=inttostr(servAttr.ops);
  standardLabel.caption:=inttostr(servAttr.users);
  silencedLabel.caption:=inttostr(servAttr.silenced);
end;

procedure TserverForm.serverClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var usr: integer;
begin
  usr:=findUser(TClientWinSocket(socket));
  if usr>0 then
  begin
    if user[usr].verified=true then
    begin
      globalSend('SRM '+user[usr].nick+' has just left the room.',user[usr].socket);
      globalSend('LFT '+user[usr].nick,user[usr].socket);
    end;
    userList.items.Delete(userList.items.indexOf(user[usr].nick));
    user[usr].avail:=true;
    freeSlot(usr);
  end;
end;

procedure TserverForm.globalSend(str: string; exc: TClientWinSocket);
var cli: integer;
begin
  for cli:=1 to 100 do
  begin
    if (exc<>user[cli].socket) and (user[cli].socket<>nil) and (user[cli].avail=false) and (user[cli].verified=true) then user[cli].socket.SendText(str+chr(1));
  end;
end;

procedure TserverForm.sendUserList(usr: integer);
var lst: string;
    n  : integer;
begin
  lst:='LST';
  for n:=1 to 100 do
  begin
    if user[n].avail=false then
    begin
      lst:=lst+' '+user[n].nick;
    end;
  end;
  user[usr].socket.SendText(lst+chr(1));
end;

function TserverForm.whoIs(usr: string): integer;
var index: integer;
    x: integer;
begin
  index:=-1;
  for x:=1 to 100 do
  begin
    if (lowercase(user[x].nick)=lowercase(usr)) and (user[x].avail=false) and (user[x].verified=true) then
    begin
      index:=x;
      break;
    end;
  end;
  whoIs:=index;
end;


procedure TserverForm.serverClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var source: integer;
    command: TCommand;
    oldNick: string;
    r: string;
    c: char;
    whoUser: integer;
begin
  source:=findUser(TClientWinSocket(Socket));
  if socket.ReceiveLength>0 then
  begin
    r:='';
    socket.receivebuf(c,1);
    while(c<>chr(1)) do
    begin
      r:=r+c;
      socket.receivebuf(c,1);
    end;
    command:=split(r);
    if command.cmd='NCK' then
    begin
      if (command.body='') or (strscan(pchar(command.body),' ')<>nil) then
      begin
        user[source].socket.sendText('NKI '+chr(1));
        user[source].socket.close;
      end
      else
      if (not(nickUsed(command.body))) then
      begin
        oldNick:=user[source].nick;
        user[source].nick:=command.body;
        if user[source].verified=false then
        begin
          userList.items.add(user[source].nick);
          user[source].socket.sendtext('SRM *** Channel topic is "'+topic+'"'+chr(1));
          user[source].socket.sendtext('SRM *** Set by '+topicOwner+chr(1));
          user[source].socket.sendText('TPC '+topic+chr(1));
          globalSend('JND '+user[source].nick,nil);
          globalSend('SRM '+user[source].nick+' has joined the room.',nil);
          user[source].verified:=true;
          sendUserList(source);
        end
        else
        begin
          globalSend('SRM '+oldNick+' is now known as '+user[source].nick,nil);
          globalSend('NNK '+oldNick+' '+user[source].nick,nil);
        end;
      end
      else
      begin
        user[source].socket.sendText('NIU '+chr(1));
        user[source].socket.close;
      end;
    end;
    if command.cmd='SAY' then
    begin
      if user[source].silent=false then
        globalSend('SAY <'+user[source].nick+'> '+command.body,nil)
      else
        user[source].socket.sendText('SRM You have been silenced! You may not contribute to the channel.'+chr(1));
    end;
    if command.cmd='SOP' then
    begin
      if user[source].op=true then
      begin
        whoUser:=whoIs(command.body);
        if user[whoUser].op=true then
        begin
          user[source].socket.sendText('SRM User '+user[whoUser].nick+' is already an operator.'+chr(1));
        end
        else
        begin
          user[whoUser].op:=true;
          globalSend('SRM '+user[whoUser].nick+' has been opped by '+user[source].nick+'.'+chr(1),nil);
        end;
      end
      else
      begin
        user[source].socket.sendtext('SRM You must me an operator to give a user ops.'+chr(1));
      end;
    end;
    if command.cmd='DOP' then
    begin
      if user[source].op=true then
      begin
        whoUser:=whoIs(command.body);
        if user[whoUser].op=false then
        begin
          user[source].socket.sendText('SRM User '+user[whoUser].nick+' is not an operator anyway.'+chr(1));
        end
        else
        begin
          user[whoUser].op:=false;
          globalSend('SRM '+user[whoUser].nick+' has been deopped by '+user[source].nick+'.'+ chr(1),nil);
        end;
      end
      else
      begin
        user[source].socket.sendtext('SRM You must me an operator to take away a user''s ops.'+chr(1));
      end;
    end;
    if command.cmd='TPC' then
    begin
      topic:=command.body;
      topicOwner:=user[source].nick;
      globalSend('TPC '+topic+chr(1),nil);
      globalSend('SRM '+topicOwner+' sets topic to: '+topic,nil);
    end;
    if command.cmd='WHO' then
    begin
      whoUser:=whoIs(command.body);
      if whoUser<>-1 then
      begin
        user[source].socket.SendText('SRM ----------------------------------'+chr(1));
        user[source].socket.SendText('SRM User details:'+chr(1));
        user[source].socket.SendText('SRM -------------'+chr(1));
        user[source].socket.sendText('SRM User: '+command.body+chr(1));
        user[source].socket.sendText('SRM Hostname: '+user[whoUser].hostName+chr(1));
        user[source].socket.sendText('SRM IP: '+user[whoUser].ip+chr(1));
        user[source].socket.SendText('SRM ----------------------------------'+chr(1))
      end
      else
      begin
        user[source].socket.SendText('SRM User "'+command.body+'" does not exist!'+chr(1))
      end;
    end;
  end;
end;

procedure TserverForm.specificsUpdaterTimer(Sender: TObject);
var cur: integer;
begin
  cur:=0;
  if servAttr.active=true then
  begin
    if userList.itemIndex<>-1 then
    begin
      cur:=whoIs(userList.items.Strings[userList.itemIndex]);
      if cur<>currentSelected then
      begin
        specLocked:=true;
        curNick.caption:=user[cur].nick;
        curOp.checked:=user[cur].op;
        curSil.checked:=user[cur].silent;
        curIP.caption:=user[cur].ip;
        curHostname.caption:=user[cur].hostname;
        specLocked:=false;
      end;
      specificsFrame.enabled:=true;
    end
    else
    begin
      specLocked:=true;
      curNick.caption:='';
      curOp.checked:=false;
      curSil.checked:=false;
      curIP.caption:='';
      curHostname.caption:='';
      specificsFrame.enabled:=false;
      specLocked:=false;
    end;
    currentSelected:=cur;
  end;
end;

procedure TserverForm.curOpClick(Sender: TObject);
begin
  if specLocked=false then
  begin
    if curOp.checked=true then
    begin
      globalSend('SRM '+user[currentSelected].nick+' has been opped by the server.',nil);
      user[currentSelected].op:=true;
    end
    else
    begin
      globalSend('SRM '+user[currentSelected].nick+' has been deopped by the server.',nil);
      user[currentSelected].op:=false;
    end
  end;
end;

procedure TserverForm.curSilClick(Sender: TObject);
begin
  if specLocked=false then
  begin
    if curOp.checked=true then
    begin
      globalSend('SRM '+user[currentSelected].nick+' has been opped by the server.',nil);
      user[currentSelected].op:=true;
    end
    else
    begin
      globalSend('SRM '+user[currentSelected].nick+' has been deopped by the server.',nil);
      user[currentSelected].op:=false;
    end
  end;
end;

end.
