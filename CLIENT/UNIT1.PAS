unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, Mask, ScktComp, Menus, ComCtrls;

type TCommand = record
  cmd, body: string;
end;

type
  TForm1 = class(TForm)
    textBox: TEdit;
    nickBox: TEdit;
    IPBox: TEdit;
    Label1: TLabel;
    connectBut: TButton;
    Label2: TLabel;
    portBox: TMaskEdit;
    Label3: TLabel;
    nickList: TListBox;
    Bevel1: TBevel;
    passwordBox: TEdit;
    client: TClientSocket;
    sayThis: TButton;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    Connection1: TMenuItem;
    Nick1: TMenuItem;
    Maintainance1: TMenuItem;
    Connect1: TMenuItem;
    Disconnect1: TMenuItem;
    Changenick1: TMenuItem;
    Opuser1: TMenuItem;
    Kickuser1: TMenuItem;
    Silenceuser1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    Deopuser1: TMenuItem;
    Unsilenceuser1: TMenuItem;
    N3: TMenuItem;
    Userdetails1: TMenuItem;
    WhoisUser1: TMenuItem;
    mainBox: TRichEdit;
    Bevel2: TBevel;
    Label5: TLabel;
    topic: TLabel;
    N4: TMenuItem;
    ChangeTopic1: TMenuItem;
    procedure connectButClick(Sender: TObject);
    procedure setList(nicks:string);
    procedure clientLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure clientConnecting(Sender: TObject; Socket: TCustomWinSocket);
    function split(source: string): TCommand;
    procedure clientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure clientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure clientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure clientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure nickBoxChange(Sender: TObject);
    procedure sayThisClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Connect1Click(Sender: TObject);
    procedure Disconnect1Click(Sender: TObject);
    procedure Changenick1Click(Sender: TObject);
    procedure WhoisUser1Click(Sender: TObject);
    procedure textBoxChange(Sender: TObject);
    procedure ChangeTopic1Click(Sender: TObject);
    procedure Opuser1Click(Sender: TObject);
    procedure Deopuser1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  connected:boolean;

implementation

{$R *.DFM}

procedure TForm1.connectButClick(Sender: TObject);
begin
  mainBox.clear;
  nickList.clear;
  if connected=false then
  begin
    client.port:=strtoint(portBox.text);
    client.Address:=IPBox.text;
    client.active:=true;
  end
  else
  begin
    client.active:=false;
  end;
end;

procedure TForm1.clientLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
  mainBox.selattributes.Color:=CLAQUA;
  mainBox.lines.add('Looking up server...');
end;

procedure TForm1.clientConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  mainBox.selattributes.Color:=CLAQUA;
  mainBox.lines.add('Attempting to connect...');
end;

procedure TForm1.clientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  mainBox.selattributes.Color:=CLYELLOW;
  mainBox.lines.add('Error: The server is either down or invalid.');
  connected:=false;
  errorCode:=0;
end;

procedure TForm1.clientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  mainBox.selattributes.Color:=CLAQUA;
  mainBox.lines.add('Connected!');
  connectBut.caption:='Disconnect';
  connected:=true;
  textBox.enabled:=true;
  textBox.SetFocus;
  nickBox.enabled:=false;
  passwordBox.enabled:=false;
  connectBut.Default:=false;
  sayThis.Default:=true;
  connect1.enabled:=false;
  disconnect1.enabled:=true;
  nick1.enabled:=true;
  maintainance1.enabled:=true;
  userDetails1.enabled:=true;
end;

procedure TForm1.clientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  connectBut.caption:='Connect';
  mainBox.selattributes.Color:=CLAQUA;
  mainBox.Lines.add('Disconnected.');
  textBox.enabled:=false;
  sayThis.enabled:=false;
  connected:=false;
  nickBox.enabled:=true;
  passwordBox.enabled:=true;
  sayThis.Default:=false;
  connectBut.Default:=true;
  textBox.clear;
  connect1.enabled:=true;
  disconnect1.enabled:=false;
  nick1.enabled:=false;
  maintainance1.enabled:=false;
  userDetails1.enabled:=false;
end;

function TForm1.split(source: string): TCommand;
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

procedure TForm1.setList(nicks: string);
var p: word;
    b: string;
begin
  p:=1;
  while p<=strlen(pchar(nicks)) do
  begin
    if nicks[p]=' ' then
    begin
      nickList.items.add(b);
      b:='';
    end
    else
    begin
      b:=b+nicks[p];
    end;
    p:=p+1;
  end;
  nickList.items.add(b);
end;

procedure TForm1.clientRead(Sender: TObject; Socket: TCustomWinSocket);
var command: TCommand;
    r: string;
    c: char;
begin
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
      socket.sendtext('NCK '+nickBox.text+chr(1));
    end
    else if command.cmd='LST' then
    begin
      setList(command.body);
    end
    else if command.cmd='JND' then
    begin
      nickList.items.add(command.body);
    end
    else if command.cmd='LFT' then
      nickList.items.Delete(nicklist.items.indexof(command.body))
    else if command.cmd='SRM' then
    begin
      mainBox.selattributes.Color:=CLLIME;
      mainBox.lines.add(command.body);
    end
    else if command.cmd='SAY' then
    begin
      mainBox.selattributes.Color:=CLWHITE;
      mainBox.lines.add(command.body);
    end
    else if command.cmd='NKI' then
    begin
      mainBox.selattributes.Color:=CLYELLOW;
      mainBox.lines.add('ERROR: Nick invalid. Nick may not be blank, or contain spaces!');
    end
    else if command.cmd='NIU' then
    begin
      mainBox.selattributes.Color:=CLYELLOW;
      mainBox.lines.add('ERROR: This nick is already bieng used!')
    end
    else if command.cmd='NNK' then
    begin
      command:=split(command.body);
      nickList.items.Delete(nicklist.items.indexof(command.cmd));
      nickList.items.add(command.body)
    end
    else if command.cmd='TPC' then
    begin
      topic.caption:=command.body;
    end
  end;
end;

procedure TForm1.nickBoxChange(Sender: TObject);
begin
  if strLen(pchar(nickBox.text))>0 then connectBut.enabled:=true
  else connectBut.enabled:=false;
end;

procedure TForm1.sayThisClick(Sender: TObject);
begin
  client.socket.sendtext('SAY '+textBox.text+chr(1));
  textBox.clear;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Form1.close;
end;

procedure TForm1.Connect1Click(Sender: TObject);
begin
  connectBut.onClick(self);
end;

procedure TForm1.Disconnect1Click(Sender: TObject);
begin
  connectBut.onClick(self);
end;

procedure TForm1.Changenick1Click(Sender: TObject);
var newNick: string;
begin
  newNick:=InputBox('New nick', 'Enter new nick', nickBox.text);
  if newNick<>nickBox.text then
  begin
    client.socket.sendText('NCK '+newNick+chr(1));
    nickBox.text:=newNick;
  end;
end;

procedure TForm1.WhoisUser1Click(Sender: TObject);
begin
  client.socket.sendtext('WHO '+inputBox('Whois user','User:',nickBox.text)+chr(1));
end;

procedure TForm1.textBoxChange(Sender: TObject);
begin
  if strlen(pchar(textBox.text))=0 then sayThis.enabled:=false
  else sayThis.enabled:=true;
end;

procedure TForm1.ChangeTopic1Click(Sender: TObject);
begin
  client.socket.sendtext('TPC '+inputBox('New topic','Topic',topic.caption)+chr(1));
end;

procedure TForm1.Opuser1Click(Sender: TObject);
begin
  client.socket.sendtext('SOP '+inputBox('Give user ops','User:','')+chr(1));
end;

procedure TForm1.Deopuser1Click(Sender: TObject);
begin
  client.socket.sendtext('DOP '+inputBox('Revoke user ops','User:','')+chr(1));
end;

end.
