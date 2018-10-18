program RvLogic;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  BoolOperate in 'BoolOperate.pas',
  Paint in 'Paint.pas',
  about in 'about.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'EzLogic';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
