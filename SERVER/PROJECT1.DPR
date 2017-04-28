program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {serverForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TserverForm, serverForm);
  Application.Run;
end.
