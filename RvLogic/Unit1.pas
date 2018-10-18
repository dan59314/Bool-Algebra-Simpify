unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Booloperate, Buttons, ComCtrls,
   Menus, ToolWin, Grids,

  CrsFileManage

  ;

const
  ClAry:Array[0..6] of TColor=($00FF0000,$0000FF00, $000000FF, $00007dFF, $00FF007d, $0000FF7d, $007d00FF);
  AppName='EzLogic';

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Help1: TMenuItem;
    Display1: TMenuItem;
    OpenFile1: TMenuItem;
    SaveFile1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    Panel7: TPanel;
    Splitter2: TSplitter;
    Panel10: TPanel;
    StaticText3: TStaticText;
    lbxBool: TListBox;
    Panel3: TPanel;
    StaticText2: TStaticText;
    Panel6: TPanel;
    edBoolTarget: TEdit;
    Panel2: TPanel;
    StaticText1: TStaticText;
    Panel5: TPanel;
    edBoolSource: TEdit;
    Panel8: TPanel;
    edNew: TEdit;
    Button2: TButton;
    Button3: TButton;
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Panel9: TPanel;
    edBoolEq: TEdit;
    Splitter1: TSplitter;
    Splitter4: TSplitter;
    Panel12: TPanel;
    StringGrid2: TStringGrid;
    StaticText5: TStaticText;
    Panel11: TPanel;
    StringGrid1: TStringGrid;
    StaticText4: TStaticText;
    Expressionsble1: TMenuItem;
    LogicDesignFilelgd1: TMenuItem;
    OpenBoolExpressionfileble1: TMenuItem;
    OpenLogicDesignFilelgd1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    aboutDlg: TMenuItem;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    edAnswer: TEdit;
    StaticText6: TStaticText;
    Panel4: TPanel;
    Panel17: TPanel;
    sbORs: TSpeedButton;
    sbNand: TSpeedButton;
    Button1: TButton;
    Panel18: TPanel;
    Splitter3: TSplitter;
    RasVectorWeb1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Panel5Resize(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Panel8Resize(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Panel9Resize(Sender: TObject);
    procedure Expressionsble1Click(Sender: TObject);
    procedure OpenBoolExpressionfileble1Click(Sender: TObject);
    procedure aboutDlgClick(Sender: TObject);
    procedure lbxBoolDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbxBoolMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Panel15Resize(Sender: TObject);
    procedure lbxBoolMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbORsClick(Sender: TObject);
    procedure sbNandClick(Sender: TObject);
    procedure PPaintBoxChip1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure RasVectorWeb1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DelBlank(str:String):String;
    procedure OpenBoolExpFile(fn:String);
  end;

var
  Form1: TForm1;
  Logic1:TLogicDesign;


implementation

{$R *.dfm}
uses About;


function TForm1.DelBlank(str:String):String;
var
  tmpstr:String;
  i:integer;
begin
  tmpStr:='';
  for i:=1 to length(str) do
  if str[i]<> ' ' then
    tmpStr:=tmpStr+str[i];

  result:=tmpStr;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  str:String;
begin
  edBoolSource.Text:=Uppercase(edBoolSource.Text);

  Logic1.CreateUserBoolTable(edBoolSource.Text);

  str:=Logic1.GetUserNewBoolStr;

  //if str<>'' then
    edBoolTarget.Text:=str
  //else
  //  edboolTarget.Text:='All_True.';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Are you sure to exit this program?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    CanClose:=true
  else
    CanClose:=false;
end;

procedure TForm1.Panel5Resize(Sender: TObject);
begin
  edBoolSource.Width:=Panel5.Width-20;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TForm1.Panel8Resize(Sender: TObject);
begin
  edNew.Width:=Panel8.Width-20;
end;

procedure TForm1.Panel3Resize(Sender: TObject);
begin
  edBoolTarget.Width:=Panel6.Width-20;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i,msgid:integer;
  blExists:boolean;
  str:String;
begin
  str:=DelBlank(edNew.Text);
  edNew.Text:=str;

  //字串式檢查函數----------------------------------------------------------
  Assert(Logic1.IsRightExpression(str, i, msgid)=true,
      format('%s ',[ErrMessage[msgid]])+#$0A+#$0D+#$0A+#$0D+
      format('代數式 :  %s ',[str])+#$0A+#$0D+#$0A+#$0D+
      format('第 %d 個字元 "%s" 或前後字元錯誤。',[i,str[i]])+#$0A+#$0D+#$0A+#$0D);


  blExists:=false;
  
  with lbxBool do
  for i:=0 to Items.Count-1 do
  if str=Items[i] then
  begin
    blExists:=true;
    break;
  end;

  if blExists then
    ShowMessage('Already Exists!')
  else
    lbxBool.Items.Add(str);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with lbxbool do
  if ItemIndex>=0 then
  if MessageDlg('Are you sure to delete selected ones?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    DeleteSelected;
end;

procedure TForm1.Panel9Resize(Sender: TObject);
begin
  edBoolEq.Width:=Panel9.Width-20;
end;

procedure TForm1.Expressionsble1Click(Sender: TObject);
var
  i,id:integer;
  hf:TextFile;

begin
  with lbxBool do
  if Items.Count>0 then
  begin
    Savedialog1.Filter:='Bool Expression files (*.ble)|*.ble| All files (*.*)|*.*';
    with Savedialog1 do
    if execute then
    begin
      id:=pos('.',FileName);
      if id>0 then
        FileName:=copy(Filename,1, id)+'ble'
      else
        FileName:=FileName+'.ble';

      if FileExists(FileName) then
      if MessageDlg('File exists. Do you want to override it?',
              mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin
        Expressionsble1Click(Sender);
        exit;
      end;

      AssignFile(hf,FileName);
      ReWrite(hf);

      for i:=0 to Items.count-1 do
      begin  
        Writeln(hf,Items[i]);
      end;

      CloseFile(hf);
    end;
  end;
end;

procedure TForm1.OpenBoolExpressionfileble1Click(Sender: TObject);
var  
  str:String;
begin
  with lbxBool do
  begin
    Opendialog1.Filter:='Bool Expression files (*.ble)|*.ble|All files (*.*)|*.*';
    with opendialog1 do
    if execute then
    begin
      OpenBoolExpFile(FileName);
      PageControl1.ActivePageIndex:=0;
    end;
  end;
end;


procedure TForm1.aboutDlgClick(Sender: TObject);
begin
  ShowMessage('Any suggestion will be much appreciated.'+#$0A+#$0A+
              'Your feedback will boost this application.'+#$0A+#$0A+
              'Please email me at :   dan59314@gmail.com'+#$0A+#$0A+
              'with your valuable suggestion.'+#$0A+#$0A+
              'Web : http://www.rasvector.url.tw'+#$0A+#$0A+
              '              Best Regards, Daniel Lu' );

  Application.CreateForm(TAboutBox,AboutBox);
  AboutBox.ShowModal;
  AboutBox.Free; 
end;

procedure TForm1.lbxBoolDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with lbxBool.Canvas do
  begin
    Font.Color:=ClAry[Index mod (High(ClAry)+1)];
    TextRect(Rect,Rect.Left,Rect.Top, lbxBool.Items[Index]);
  end;
end;

procedure TForm1.lbxBoolMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
  i,id:integer;
  str:String;
  ListBoxItem:TRect;
begin
  exit;
  
  with Sender as TListBox do
  if Items.Count=0 then exit
  else
  begin
    i:=ItemAtPos(Point(X,Y),true); //如果不在Item內 -> false: 會傳回最後一個Index. true: 不會傳回
    if i>=0 then
    begin
      id:=pos('=',Items[i]);
      if id>0 then  str:=copy(Items[i],id+1,length(Items[i])-id)
      else str:='';

      edAnswer.Text:=str;
    end
    else edAnswer.Text:='';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SendMessage(lbxBool.Handle,  LB_SetHorizontalExtent,2000,  longint(0));
  OpenBoolExpFile(ExtractFilePath(Paramstr(0))+'Template.ble');

  Caption:=AppName;
end;

procedure TForm1.Panel15Resize(Sender: TObject);
begin
  edAnswer.Width:=panel15.Width-20;
end;

procedure TForm1.OpenBoolExpFile(fn: String);
var
  hf:TextFile;
  str:String;
begin
  if FileExists(fn) then
  with lbxBool do
  begin
    Clear;

    AssignFile(hf,fn);
    Reset(hf);

    while not Eof(hf) do
    begin
      Readln(hf,str);
      str:=DelBlank(str);
      if str<>'' then Items.Add(str);
    end;

    CloseFile(hf);
  end;
end;

procedure TForm1.lbxBoolMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  id,strl:integer;
  tmpStr,str1,str2:String;
begin
  With Sender as TListBox do
  if ItemIndex>=0 then
  begin
    tmpStr:=Items[ItemIndex];
    strL:=length(tmpStr);
    id:=pos('=',tmpStr);
    if id>0 then
    begin
      str1:=copy(tmpStr,1,id-1);
      str2:=copy(tmpStr,id+1,strL-id);
    end
    else
    begin
      str1:=tmpStr;
      str2:='';
    end;

    edBoolSource.Text:=str1;
    edAnswer.Text:=str2;
    edBoolTarget.Text:='';

    if ssAlt in Shift then Button1Click(Sender);
  end;
end;

procedure TForm1.sbORsClick(Sender: TObject);
var
  str:String;
begin
  Logic1.ORsUserBoolTable;

  str:=Logic1.GetUserNewBoolStr;

  if str<>'' then
    edBoolTarget.Text:=str
  else
    edboolTarget.Text:='All pass.';
end;

procedure TForm1.sbNandClick(Sender: TObject);
var
  str:String;
begin
  Logic1.NandUserBoolTable;
  str:=Logic1.GetUserNewBoolStr;

  if str<>'' then
    edBoolTarget.Text:=str
  else
    edboolTarget.Text:='All pass.';
end;

procedure TForm1.PPaintBoxChip1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  RX,RY:integer;
begin
  {With PPaintBoxChip1 do
  with MainDisp do
  begin
    RX:=Round((x-Width/2)*Scale+CX0);
    RY:=Round((Height/2-y)*Scale+CY0);
    statusbarProgress1.Panels[0].text:=format('(%d, %d)',[RX,RY]);
  end;  }
end;

procedure TForm1.RasVectorWeb1Click(Sender: TObject);
begin
  CrsFileManager.CrsOpenUrL('http://www.rasvector.url.tw');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //PPaintBoxChip1.homePaint; 
end;

end.
