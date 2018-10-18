unit PPaintBoxChip;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, PBBase,Types,Graphics;

const
  PinSpace=100;  //100 mil

type
  ActiveType=(aLow,aHigh);


type

  //輸出入訊號的資料結構-------------------------------------------------------
  //SignalPtr=^SignalRec;
  SignalRec=record
    SgnlName:String;
    Active:ActiveType;
    Center:TPoint;
    Sel:Boolean;
  end;

  ICRec=record
    Rect:TRect;
    InSgnlNum:integer;
    InSgnl:Array of SignalRec;
    OutSgnlNum:integer;
    OutSgnl:Array of SignalRec;
  end;


type
  TPPaintBoxChip = class(TPBBase)

    Constructor Create(AOwner: TComponent);override;
    Destructor Destroy; override;
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure paint;override;
  public
    { Public declarations }
    procedure CreateSignals(InNum,OutNum:integer);
  published
    { Published declarations }
  end;

procedure Register;

var
  IC:ICRec;

implementation

procedure Register;
begin
  RegisterComponents('Daniel', [TPPaintBoxChip]);
end;

{ TPPaintBoxChip }

constructor TPPaintBoxChip.Create(AOwner: TComponent);
begin
  inherited;
  CreateSignals(16,12);//inNum,outNum:integer);
end;

procedure TPPaintBoxChip.CreateSignals(InNum, OutNum: integer);
var
  i:integer;
begin

  with IC do
  begin
    InSgnlNum:=InNum;
    OutSgnlNum:=OutNum;
    Setlength(InSgnl,InSgnlNum);
    Setlength(OutSgnl,OutSgnlNum);

    for i:=0 to InSgnlNum-1 do
    with InSgnl[i] do
    begin
      Active:=aHigh;
      SgnlName:=format('A%d',[i]);
      sel:=false;
      Center.X:=0;
      Center.Y:=PinSpace*(i+1);
    end;

    for i:=0 to OutSgnlNum-1 do
    with OutSgnl[i] do
    begin
      Active:=aHigh;
      SgnlName:=format('B%d',[i]);
      sel:=false;
      Center.X:=20*PinSpace;
      Center.Y:=PinSpace*(i+1);
    end;

    if InSgnlNum>OutSgnlNum then
    with rect do
    begin
      left:=5*PinSpace;
      Bottom:=0;
      Right:=15*PinSpace;
      Top:=PinSpace*(InSgnlNum+1);
    end
    else
    with rect do
    begin
      left:=5*PinSpace;
      Bottom:=0;
      Right:=15*PinSpace;
      Top:=PinSpace*(OutSgnlNum+1);
    end;

    With MainDisp do
    begin
      HX1:=-2*PinSpace;
      HY1:=0;
      HX2:=22*PinSpace;//rect.Right;
      HY2:=rect.Top;

      ZX1:=0; //zoom min max. xy
      ZY1:=0;
      ZX2:=HX2;
      ZY2:=HY2;

      CX0:=(ZX1+ZX2) div 2;//integer;
      CY0:=(ZY1+ZY2) div 2;//integer;

      Scale:=1;//double;  //current scale of  Real/Screen
      SpaceRate:=1.2;//double;
      PPI:=72;
    end;
    updateDispRec;
  end;

end;

destructor TPPaintBoxChip.Destroy;
begin
  with IC do
  begin
    Setlength(InSgnl,0);
    Setlength(OutSgnl,0);
  end;
  inherited;
end;

procedure TPPaintBoxChip.paint;
const
  BoolAry:Array[aLow..aHigh] of String=('0','1');
var
  i, scrx1,scrx2, scry1, scry2, scrpinR:integer;
begin
  inherited;

  with Maindisp do
  with IC do
  With Canvas do
  begin
    ScrPinR:=round(PinSpace/3/Scale)+1;

    //先畫出 Inputs ------------------------------------------------------
    pen.Width:=round(pinSpace/4/Scale);
    for i:=0 to InSgnlNum-1 do
    with InSgnl[i] do
    begin
      scrx1:=Round((width/2)+(Center.x-CX0)/Scale);
      scry1:=Round((height/2)-(Center.Y-CY0)/Scale);
      scrx2:=Round((width/2)+(rect.Left-CX0)/Scale);
      scry2:=Round((height/2)-(Center.Y-CY0)/Scale);

      if sel then
        pen.Color:=clWhite
      else
        pen.Color:=ClGray;

      Font.Color:=clLime;
      SetBkMode(handle,TRANSPARENT);
      MoveTo(Scrx1,scry1);
      LineTo(scrx2,scry2);//rect.Left,center.Y);

      Ellipse(scrx1-scrpinR, scry1-scrpinR, scrx1+scrpinR,scry1+scrpinR);

      Textout(scrx1-60, scry1-10, format('%4s %-3s',[SgnlName,'('+BoolAry[Active]+')']));
    end;


    //接著畫出 Outputs ------------------------------------------------------
    pen.Width:=round(pinSpace/4/Scale);
    for i:=0 to OutSgnlNum-1 do
    with OutSgnl[i] do
    begin
      scrx1:=Round((width/2)+(rect.Right-CX0)/Scale);
      scry1:=Round((height/2)-(Center.Y-CY0)/Scale);
      scrx2:=Round((width/2)+(Center.x-CX0)/Scale);
      scry2:=Round((height/2)-(Center.Y-CY0)/Scale);

      if sel then
        pen.Color:=clWhite
      else
        pen.Color:=ClGray;

      Font.Color:=clAqua;
      SetBkMode(handle,TRANSPARENT);
      MoveTo(Scrx1,scry1);
      LineTo(scrx2,scry2);//rect.Left,center.Y);

      Ellipse(scrx2-scrpinR, scry2-scrpinR, scrx2+scrpinR,scry2+scrpinR);
      Textout(scrx2+5, scry1-10, format('%-3s %-4s',['('+BoolAry[Active]+')',SgnlName]));
    end;


    //最後畫出 IC -----------------------------------------------------------
    scrx1:=Round((width/2)+(rect.left-CX0)/Scale);
    scry1:=Round((height/2)-(rect.top-CY0)/Scale);
    scrx2:=Round((width/2)+(rect.right-CX0)/Scale);
    scry2:=Round((height/2)-(rect.bottom-CY0)/Scale);

    Pen.Width:=2;
    Pen.Color:=clGray;//Black;
    Brush.Color:=clBlue;
    Rectangle(scrx1,scry1,scrx2,scry2);
    Font.Color:=clYellow;
    SetBkMode(handle,TRANSPARENT);
    TextOut(scrX1+5,scry1+5,'Input');
    TextOut(scrX2-35,scry2-20,'Output');

    TextOut((scrX1+scrx2)div 2-15,(scry1+scry2)div 2,'IC');
  end;
  
end;

end.
