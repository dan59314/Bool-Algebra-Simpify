//***********************************************
// Daniel Lu CopyRight 2002'11'14
//
// ClasssName: TLogicDesign;
// Description:  Bool Algebra Expression Operation
// Properties:
//
// Functions:
//   1: None limited variable name Text Expression Decoding.
//   2: Simplify bool Expression
//   3: Ors <----> Nand Translation.
//
// Note:
//   Anyone implement or benifit from these source codes,
// please send me an email and note the original CopyRight.
//
// Author: Daniel Lu
// Email: dan59314@ms3.hinet.net
//
// Any email to me will be much appreciated.
//************************************************


{*********************************************************

   !A*B*!C*!D+A*!B*C*!D+A*B*!C*D+A*!B*!C*!D

       A   B   C   D   -->Input Singnals
   ----------------------------
   0 |  0   1   0   0  -->  !A*B*!C*!D
   1 |  1   0   1   0  -->  A*!B*C*!D
   2 |  1   1   0   1  -->  A*B*!C*D
   3 |  1   0   0   0  -->  A*!B*!C*!D
     |
     |


   EX: !A*!B*C+!A*B*C+A*!B*!C+A*!B*C  -->  !A*C+!B*C+A*!B


   Bool Agelbra Theorem:

   T1: 交換律
      A+B = B+A
      A*B = B*A

   T2: 結合律
      a: (A+B)+C = A+(B+C)
      b: (A*B)*C = A*(B*C)

   T3: 分配律
      a: A*(B+C) = A*B + A*C
      b: A+(B*C) = (A+B) * (A+C)

   T4: 等元素
      a: A*1 = A
      b: A+0 = 0

   T5: 空元素
      a: A*0 = 0
      b: A+1 = 1

   T6: 補數
      a: A*!A = 0
      b: A+!A = 1

   T7: 全等性
      a: A*A = A
      b: A+A = A

   T8: 吸收性
      a: A + A*B = A
      b: A +!A*B = A+B
      c: A * (A+B) = A
      d: A * (!A+B) = AB

   T9: 反轉性
      !!A = A

   T10: De Morgan's 定理
      a: !(A+B+C+...) = !A * !B * !C * !.....
      b: !(A*B*C*...) = !A + !B + !C + !.....



************************************************************}



unit BoolOperate;

interface
uses SysUtils,Types;


const
  //運算子 '*':and,  '+':or,  '!':not,  '@':xor,  ' ':式子結束
  SciOpt: set of char=['*','+','!','@','(',')',' '];
  ErrMessage: Array[0..1] of String=('Wrong Expression!','Accepted only Sum of Products!');

type
  ActiveType=(aLow,aHigh);


type
  TAndType=(tAND,tNAND,tAndTrue,tAndFalse);
  TOrType=(tOR,tNOR,tOrTrue,tOrFalse);

  //邏輯閘圖形顯示資料結構-----------------------------------------------------
  GateSymbolPos=record
    Center:TPoint;
    sRect:TRect;
  end;


  //輸出入訊號的資料結構-------------------------------------------------------
  //SignalPtr=^SignalRec;
  SignalRec=record
    SgnlName:String;
    Active:ActiveType;
  end;
  //SignalArrayPtr=^SignalArray;
  SignalArray=Array of SignalRec;

  //布林數值-------------------------------------
  BoolValue=-2..1; //-2:有補數, -1: don't care,  0:low,  1:high
  TInputArray=Array of BoolValue;

  //用來存放多個信號 And 的資料  A*B*C*D----------------------------------------
  AndArray=record
    AndType:TAndType;
    InputNum:word;
    Inputs:TInputArray; //Array of BoolValue;
    InputsDisabled: Array of Boolean;  //如果某些input 被其他連接過來的output取代則設為 true;

    AndSymbol:GateSymbolPos;
  end;
  TOrInputArray=Array of AndArray;


  //用來存放多筆  Or 資料    A + B + C*D ...------------------------------------
  OrTable=record
    strEqua:String;
    OrType:TOrType;
    OrInputNum:word;
    OrInputs:TOrInputArray;//Array of AndArray;  //-1: don't care,  0:low,  1:high
    OrInputsDisabled:Array of Boolean;

    OrSymbol:GateSymbolPos;
  end;

  //一個輸出信號的 原始和簡化後的 布林算式資料---------------------------------
  BoolTablePtr=^BoolTable;
  BoolTable=record
    //第一維是 or 的數目，第二維是 input 數目
    oldOrTable: OrTable; //儲存前一筆簡化步驟的 BoolTable
    newOrTable: OrTable;
  end;


  //一個完整的邏輯設計資料，有多個輸入和輸出------------------------------------
  TLogicUnit=record
    PrjName:String;
    InSgnlAry:SignalArray;  //存放 input 訊號變數
    OutSgnlAry:SignalArray; //存放 output 訊號變數
    BoolTables:Array of BoolTable;
  end;


type
  TLogicDesign = class
    constructor Create;
    destructor Destroy;

  private
    procedure ReleaseOrInputs(var andAry:AndArray);
    procedure ReleaseOrTable(var ortbl:OrTable);
    procedure ReleaseBoolTable(var blTable:BoolTable);
    procedure ReleaseSignalArray(var SgnlAry:SignalArray);
    procedure ReleaseAll;

    function  ArrayExistsIn(ary:AndArray; ortbl:OrTable):boolean;

    function  DescendCompare(var BlTable:BoolTable; BaseID:integer):boolean; // 此步驟是否可簡化
    Procedure SimplifyBoolTableEX(var BlTable:BoolTable; InSgnl:SignalArray);

    procedure ProcessBool_T6_T7_T8(var ortbl:OrTable);

    procedure OrTable2BoolStr(ortbl:OrTable; InSgnl:SignalArray; var StrEq:String);
    procedure BoolStr2OrTable(var ortbl:OrTable; var InSgnl:SignalArray; StrEq:String);

    procedure CreateBoolTable(strEq:String; Var blTable:BoolTable; var InSgnl:SignalArray);

    function GetAndInputNum(andary:AndArray; var id:integer):word;

    procedure CopyAndArray(srcAndAry:AndArray; var tarAndAry:AndArray);
    procedure RefreshOrTable(var ortbl:OrTable);

  public
    procedure DeleteBlank(var str:String);
    function  IsRightExpression(strEq:String; var errId,errMsgID:integer):boolean;

    //User 自訂的單筆布林代式的轉換------------------------
    procedure CreateUserBoolTable(strEq:String);
    function  GetUserNewBoolStr:String;
    procedure ORsUserBoolTable;
    procedure NandUserBoolTable;

    procedure ORs2NAND(var Ortbl:OrTable);
    procedure NAND2ORs(var Ortbl:OrTable);
  end;



var
  //整個真值表的所有 輸出訊號的 布林代式----------------------------
  LogicUnit:TLogicUnit;//Array of BoolTable; //維度為 ouput 訊號的數目

  //使用者自訂單一輸出訊號的 布林代式----------------------------
  UserBoolTable:BoolTable; //維度為 ouput 訊號的數目
  UserInSgnlAry:SignalArray;  //存放 input 訊號變數

  tmpOrTable:OrTable; //用來做布林算式簡化時的暫時記錄檔，紀錄兩式合併時的新簡化算式
  SimplyAry:Array of boolean; //用來檢查 oldOrTable 的 OrInputs 各個式子是否已被合併做簡化  


implementation
{$ASSERTIONS ON/OFF	(long form)}




//釋放某筆 AndArray 的空間************************************************************
procedure TLogicDesign.ReleaseOrInputs(var andAry: AndArray);
var
  i:integer;
begin
  Setlength(andAry.Inputs,0);
  Setlength(andAry.InputsDisabled,0);
  fillchar(andAry,SizeOf(AndArray),0);
end;



//釋放某筆 OrTable 的空間************************************************************
procedure TLogicDesign.ReleaseOrTable(var ortbl:OrTable);
var
  i:integer;
begin
  with ortbl do
  begin
    for i:=0 to High(OrInputs) do ReleaseOrInputs(OrInputs[i]);
    Setlength(OrInputs,0);//Array of -1..1;  //-1: don't care,  0:low,  1:high
    Setlength(OrInputsDisabled,0);
    fillchar(OrSymbol,sizeof(GateSymbolPos),0);

    fillchar(Ortbl,SizeOf(OrTable),0);
  end;
end;



//釋放某筆 BoolTable 的空間 ************************************************************
procedure TLogicDesign.ReleaseBoolTable(var blTable:BoolTable);
var
  i:integer;
begin
  with blTable do
  begin
    ReleaseOrTable(oldOrTable);
    ReleaseOrTable(newOrTable);
  end;
end;

//釋放某筆 SignalArray 的空間************************************************************
procedure TLogicDesign.ReleaseSignalArray(var SgnlAry:SignalArray);
var
  i:integer;
begin
  Setlength(SgnlAry,0);
end;


//釋放此類別所有變數空間************************************************************
procedure TLogicDesign.ReleaseAll;
var
  i:integer;
begin

  with LogicUnit do
  begin
    PrjName:='';
    ReleaseSignalArray(InSgnlAry);
    ReleaseSignalArray(OutSgnlAry);
    for i:=0 to High(BoolTables) do
      ReleaseBoolTable(LogicUnit.BoolTables[i]);
  end;


  ReleaseBoolTable(UserBoolTable);
  ReleaseSignalArray(UserInSgnlAry);

  ReleaseOrTable(tmpOrTable);
end;

//Constructor ************************************************************************
constructor TLogicDesign.Create;
begin
  ReleaseAll;
end;

//Destructor ***************************************************************************
destructor TLogicDesign.Destroy;
begin
  ReleaseAll;
end;


//殺掉字串中的所有空白字元***********************************************************
procedure TLogicDesign.DeleteBlank(var str:String);
var
  tmpstr:String;
  i:integer;
begin
  tmpStr:='';
  for i:=1 to length(str) do
  if str[i]<> ' ' then
    tmpStr:=tmpStr+str[i];

  str:=tmpStr;
end;




//根據 BoolTable 簡化 布林代數式*********************************************************
function TLogicDesign.DescendCompare(var BlTable:BoolTable; BaseID:integer):boolean;
var
  i,j,idiffer,differID,iH,iSgnl,iUnique:integer;
  nextResult:boolean;
begin
  result:=false;
  if BlTable.oldOrTable.OrInputs=nil then exit;

  iH:=High(BlTable.oldOrTable.OrInputs);
  if BaseID>=iH then exit;

  with BlTable do
  if OldOrTable.OrInputs[BaseID].AndType<> tAndFalse then
  begin

    iSgnl:=High(oldOrTable.OrInputs[BaseID].Inputs);

    //Move(oldOrTable,tmpOrTable,SizeOf(BlAry)); //只有Move 位址沒有Move 內容
    tmpOrTable:=OldOrTable;
    tmpOrTable.OrInputs:=nil;
    //tmpOrTable.OrInputsDisabled:=nil;
    Setlength(tmpOrTable.OrInputs,High(oldOrTable.OrInputs)+1);
    for i:=0 to High(oldOrTable.OrInputs) do
    begin
      CopyAndArray(oldOrTable.OrInputs[i], tmpOrTable.OrInputs[i]);
      {Setlength(tmpOrTable.OrInputs[i].Inputs,High(oldOrTable.OrInputs[i].Inputs)+1);
      for j:=0 to High(tmpOrTable.OrInputs[i].Inputs) do
        tmpOrTable.OrInputs[i].Inputs[j]:=oldOrTable.OrInputs[i].Inputs[j]; }
    end;

    for i:=BaseID+1 to iH do
    if oldOrTable.OrInputs[i].AndType<>tAndFalse then
    begin
      idiffer:=0;
      for j:=0 to iSgnl do//High(oldOrTable.OrInputs[i].Inputs) do
      if oldOrTable.OrInputs[BaseID].Inputs[j]<>oldOrTable.OrInputs[i].Inputs[j] then
      begin
        inc(idiffer);
        differID:=j;
        if idiffer>1 then break;
      end;

      if idiffer=1 then //只有一個不同，開始將不同的設為-1，並將新值填入newOrTable
      begin
        // A+!A = 1  (all true)------------------------------
        if (GetAndInputNum(oldOrTable.OrInputs[BaseID],iUnique)=1) and
           (GetAndInputNum(oldOrTable.OrInputs[i],iUnique)=1) then
        begin
          newOrTable.OrType:=tOrTrue;
        end;  

        result:=true; //可簡化
        SimplyAry[BaseID]:=true;
        SimplyAry[i]:=true;

        tmpOrTable.OrInputs[i].Inputs[differID]:=-1; //將參考基準的不同點設為-1

        //如果 newOrTable 內沒有 tmpOrTable[i] 的話--------------------------------
        if not ArrayExistsIn(tmpOrTable.OrInputs[i], newOrTable) then
        begin
          Setlength(newOrTable.OrInputs, High(newOrTable.OrInputs)+2);
          CopyAndArray(tmpOrTable.OrInputs[i], newOrTable.OrInputs[High(newOrTable.OrInputs)]);

          {Setlength(newOrTable.OrInputs[High(newOrTable.OrInputs)].Inputs,High(tmpOrTable.OrInputs[i].Inputs)+1);
          for j:=0 to High(tmpOrTable.OrInputs[i].Inputs) do
          begin
            newOrTable.OrInputs[High(newOrTable.OrInputs)].Inputs[j]:=tmpOrTable.OrInputs[i].Inputs[j];
          end;}
        end;
      end
      else if idiffer=0 then //完全相同---------------------------
      begin
        result:=true; //可簡化

        SimplyAry[BaseID]:=true;
        SimplyAry[i]:=true;

        //如果 newOrTable 內沒有 tmpOrTable[i] 的話--------------------------------
        if not ArrayExistsIn(tmpOrTable.OrInputs[i], newOrTable) then
        begin
          Setlength(newOrTable.OrInputs, High(newOrTable.OrInputs)+2);
          CopyAndArray(tmpOrTable.OrInputs[i], newOrTable.OrInputs[High(newOrTable.OrInputs)]);

          {Setlength(newOrTable.OrInputs[High(newOrTable.OrInputs)].Inputs,High(tmpOrTable.OrInputs[i].Inputs)+1);
          for j:=0 to High(tmpOrTable.OrInputs[i].Inputs) do
          begin
            newOrTable.OrInputs[High(newOrTable.OrInputs)].Inputs[j]:=tmpOrTable.OrInputs[i].Inputs[j];
          end;}
        end;
      end;
    end;
  end;

  NextResult:=DescendCompare(BlTable, BaseID+1);

  result:=result or NextResult;
end;



//根據 BoolTable 建立 布林代數式***********************************************************
procedure TLogicDesign.OrTable2BoolStr(ortbl:OrTable; InSgnl:SignalArray; var StrEq:String);
var
  i,j,iH,iAnd:integer;
  blhasOrStr:boolean;
  AndStr:String;

 function GetBoolStr(SgnlID,BlValue:integer):String;
 begin
   result:='';
   if Blvalue=0 then
     result:='!'+InSgnl[SgnlID].SgnlName
   else if BlValue=1 then
     result:=InSgnl[SgnlID].SgnlName
   else if BlValue=-2 then
     result:=InSgnl[SgnlID].SgnlName+'*!'+InSgnl[SgnlID].SgnlName;
 end;

begin
  StrEq:='';

  if (InSgnl=nil) then exit;

  with ortbl do
  begin
    //if (OrInputs=nil) or (InSgnl=nil) then exit;

    iH:=High(OrInputs);

    for i:=0 to iH do
    //if OrInputs[i].AndType in [tAnd..tNand] then
    begin
      blhasOrStr:=false;

      AndStr:='';
      iAnd:=0;

      //求出 AndGroup--------------------------------
      for j:=0 to High(OrInputs[i].Inputs) do
      begin
        if OrInputs[i].Inputs[j]<>-1 then
        begin
          inc(iAnd);
          if AndStr='' then
            AndStr:=GetBoolStr(j,OrInputs[i].Inputs[j])
          else
            AndStr:=AndStr+'*'+GetBoolStr(j,OrInputs[i].Inputs[j]);
        end;
      end;

      //如果只有一組 Inputs, 且其中一個有補數的話------
      if (OrInputs[i].AndType=tAndFalse) then
      begin
        if (iH=0) then
        begin
          StrEq:='All_False, '+AndStr;
          exit;
        end
        else
          AndStr:='';
      end;

      if (AndStr<>'') then
      begin
        if OrInputs[i].AndType=tNAnd then
        begin
          if iAnd>1 then
            AndStr:='!('+AndStr+')'
          else
            AndStr:='!'+AndStr;
        end;

        if (StrEq='') then
          StrEq:=AndStr
        else
          StrEq:=StrEq+'+'+AndStr;
      end;
    end;

    Case OrType of
      tOr:      StrEq:=StrEq;
      tNor:     StrEq:='!('+StrEq+')';
      tOrTrue:  StrEq:='All_True, '+StrEq+'+X+!X';
      tOrFalse: StrEq:='All_False, '+StrEq;
    end;
  end;

end;




//檢查某個 AndArray 是否存在 某個 OrTable 內*******************************************
//可另外用來掃描 此 OrTable 內的 AndArray 是否和別的 OrTable 內重複, 用以作 Input 轉連接, 例如:
// 因為 e=A*B*C,   f=A*B*C+D
// 所以 f=e+f  可將 e 的某個 And ouput 連接到 f 的某個 OrInput 減少線路和邏輯電路使用
function TLogicDesign.ArrayExistsIn(ary: AndArray;
  ortbl: OrTable): boolean;
var
  i,j:integer;
  blSame:boolean;
begin

  with ortbl do
  begin

    if OrInputs=nil then begin result:=false; exit; end;

    for i:=0 to High(OrInputs) do
    begin
      blSame:=true;

      for j:=0 to High(OrInputs[i].Inputs) do
      if ary.Inputs[j]<>OrInputs[i].Inputs[j] then
      begin
        blSame:=false;
        break;
      end;

      if blSame=true then begin result:=blSame; exit; end;
    end;
  end;

  result:=false;
end;









//根據 布林代數式 建立 BoolTable***********************************************************
procedure  TLogicDesign.BoolStr2OrTable(var ortbl:OrTable; var InSgnl:SignalArray; StrEq:String);
var
  i,j,curID,orNum:integer;
  blExists:boolean;
  tmpStr:String;
  tpBool:0..1;
  tpAnd:TAndType;
begin
  OrNum:=1;
  setlength(InSgnl,0);
  ReleaseOrTable(ortbl);

  strEq:=UpperCase(strEq);
  DeleteBlank(strEq);
  strEq:=strEq+' ';

  //先計算有多少個 變數,  多少個 Or -----------------------------
  i:=1;
  tmpStr:='';
  while i<=length(strEq) do
  begin
    if strEq[i] in SciOpt then
    begin
      if tmpStr<>'' then
      begin
        if strEq[i]='+' then  inc(OrNum);

        blExists:=false;

        for j:=0 to High(InSgnl) do
        if tmpStr=InSgnl[j].SgnlName then
        begin
          blExists:=true;
          break;
        end;

        if not blExists then
        begin
          setlength(InSgnl,High(InSgnl)+2);
          InSgnl[High(InSgnl)].SgnlName:=tmpStr;
          InSgnl[High(InSgnl)].Active:=aHigh;
        end;
      end;

      tmpStr:='';
    end
    else
      tmpStr:=tmpStr+strEq[i];
    inc(i);
  end;


  //接下來填入BoolTable ----------------------------------------
  with ortbl do
  begin
    Setlength(OrInputs,OrNum);
    //Setlength(OrInputsDisabled,OrNum);
    strEqua:=strEq;
    OrType:=tOR;
    OrInputNum:=High(OrInputs)+1;
    fillchar(OrSymbol, Sizeof(GateSymbolPos),0);


    for i:=0 to High(OrInputs) do
      fillchar(OrInputs[i],SizeOf(TOrInputArray),0);//OrInputs[i].AndType:=tAnd;

    //先配置 BoolTable 空間---------------------------
    for i:=0 to High(OrInputs) do
    with OrInputs[i] do
    begin
      AndType:=tAND;
      InputNum:=0;

      Setlength(Inputs, High(InSgnl)+1);
      //Setlength(InputsDisabled, High(InSgnl)+1);

      for j:=0 to High(Inputs) do
      begin
        Inputs[j]:=-1;
        //InputsDisabled[j]:=false;
      end;
    end;

    //開始填入----------------------------------------
    i:=1;
    tmpStr:='';
    tpBool:=1;
    curID:=0;
    while i<=length(strEq) do
    begin
      if strEq[i] in SciOpt then
      begin
        if strEq[i]='!' then tpBool:=0;

        if StrEq[i]='(' then
        begin
          tpBool:=1;
          case StrEq[i-1] of
           '!': OrInputs[curID].AndType:=tNAND;
           '*': Assert(2=3,
                  format('%s ',[ErrMessage[1]])+#$0A+#$0D+#$0A+#$0D+
                  format('代數式 :  %s ',[strEq])+#$0A+#$0D+#$0A+#$0D+
                  format('第 %d 個字元 "%s" 或前後字元錯誤。',[i-1,strEq[i-1]])+#$0A+#$0D+#$0A+#$0D);
          end;
        end;

        if tmpStr<>'' then
        begin
          for j:=0 to High(InSgnl) do
          if tmpStr=InSgnl[j].SgnlName then
          begin
            if (OrInputs[curID].Inputs[j]<>-1) and (OrInputs[curID].Inputs[j]<>tpBool) then//A*!A
            begin
              OrInputs[curID].AndType:=tAndFalse;
              OrInputs[curID].Inputs[j]:=-2;
              //有空加入 字串式檢查函數----------------------------------------------------------
              {Assert(1=2,
                  format('%s ',['illegal expression.'])+#$0A+#$0D+#$0A+#$0D+
                  format('代數式 :  %s 第 %d 個字元',[strEq,i-1])+#$0A+#$0D+#$0A+#$0D+
                  format('"%s" 與 "!%s" 互為補數，錯誤。',[strEq[i-1],strEq[i-1]])+#$0A+#$0D+#$0A+#$0D);}
            end
            else
              OrInputs[curID].Inputs[j]:=tpBool;
            tpBool:=1;
            break;
          end;
        end;

        if strEq[i]='+' then  inc(curID);
        tmpStr:='';
      end
      else
        tmpStr:=tmpStr+strEq[i];
      inc(i);
    end;
  end;
end;




////根據 布林代數式 建立 SignalArray 和 ToolTable 並完成簡化 *******************************
procedure TLogicDesign.CreateBoolTable(strEq:String;
                  Var blTable:BoolTable; var InSgnl:SignalArray);
var
  i,msgid:integer; 
begin
  DeleteBlank(strEq);

  ReleaseBoolTable(blTable);
  ReleaseSignalArray(InSgnl);

  //有空加入 字串式檢查函數----------------------------------------------------------
  Assert(IsRightExpression(strEq, i, msgid)=true,
      format('%s ',[ErrMessage[msgid]])+#$0A+#$0D+#$0A+#$0D+
      format('代數式 :  %s ',[strEq])+#$0A+#$0D+#$0A+#$0D+
      format('第 %d 個字元 "%s" 或前後字元錯誤。',[i,strEq[i]])+#$0A+#$0D+#$0A+#$0D);


  with blTable do
  begin
    //根據 布林代式 產生 原始的 BoolAry 放在 oldOrTable---------------------------------
    BoolStr2OrTable(oldOrTable, InSgnl, strEq);
    Assert(High(InSgnl)+1>0,format('變數為 %d 個，必須至少一個變數',[High(InSgnl)+1])+
        #$0A+#$0D+#$0A+#$0D);

    //簡化布林代式 ----------------------------------------------------------------------
    SimplifyBoolTableEX(BlTable,InSgnl);
  end;
end;


//判斷是否為正確的布林運算式子*************************************************
function TLogicDesign.IsRightExpression(strEq:String; var errId,errMsgID:integer):boolean;
var
  i,j,curID,orNum,strL,iLevel:integer;
  blExists:boolean;
  tmpStr:String;
  tpBool:0..1;
begin
  DeleteBlank(strEq);
  result:=true;
  errID:=-1;
  strL:=length(strEq);

  errMsgID:=0;

  if (strL)=1 then
  case strEq[1] of
    '*','+','!','(',')': begin errID:=1; result:=false; end;
  end
  else
  begin
    if strEq[1] in ['*','+',')'] then
    begin
      errID:=1;
      result:=false;
      exit;
    end
    else if strEq[strL] in ['*','+','!','('] then
    begin
      errID:=strL;
      result:=false;
      exit;
    end;
  end;

  //分析每個運算子前後面字元，從第1個字元開始到倒數第二個字元---------------------
  i:=2;
  iLevel:=0;
  tmpStr:='';
  while i<strL do
  begin
    case strEq[i] of
      '*':
        if strEq[i-1] in ['*','+','!','('] then //運算子前不可為...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //運算子後不可為...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;
      '+':
        if strEq[i-1] in ['*','+','!','('] then  //運算子前不可為...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //運算子後不可為...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;
      '!':
        if not (strEq[i-1] in ['*','+','(']) then  //運算子前只能為...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+','!',')'] then  //運算子後不可為...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;
      '(':
        begin
          inc(ilevel);
          if iLevel>1 then
          begin
            errID:=i;
            errMsgID:=1;
            result:=false;
            exit;
          end;
        end;
        {if not (strEq[i-1] in ['*','+','!','(']) then //運算子前只能為...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //運算子後不可為...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;}
      ')':
        begin
          dec(iLevel);
          errID:=i;
          errMsgID:=1;
          result:=false;
          exit;
        end;
        {if strEq[i-1] in ['*','+','!','('] then  //運算子前不可為...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if not (strEq[i+1] in ['*','+',')']) then  //運算子後只能為...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;}
    end;
    inc(i);
  end;

end;




//建立  User 的 ToolTable 和 SignalArray*************************************************
procedure TLogicDesign.CreateUserBoolTable(strEq:String);
begin
  CreateBoolTable(strEq,UserBoolTable,UserInSgnlAry);
end;



//取得 userBoolTable 內簡化後的 布林代數式 StrEq******************************************
function  TLogicDesign.GetUserNewBoolStr:String;
begin
  result:=UserBoolTable.newOrTable.StrEqua;
end;


//將 ORs 轉成 not Ands --->   !A+!B+!C -->  !(A*B*C)  *************************************
procedure TLogicDesign.ORs2NAND(var Ortbl: OrTable);
var
  i,iH,NandID,refID0,refID,j:integer;
  blMerged:boolean;
begin
  with ortbl do
  begin
    iH:=High(OrInputs);

    //先找到NandID, 目的 ID---------------------------
    for i:=0 to iH-1 do
    begin
      blMerged:=false;

      //如果找到只有一個input的參考點
      if (OrInputs[i].AndType=tAND) and
       (GetAndInputNum(OrInputs[i],refID0)=1) then
      begin
        //找找看有沒有只有一個input,且是互補或相同的˙A+B*C...+!A = 1 (All True) , A+B*C..+A=A+B*C..
        for j:=i+1 to iH do
        if (OrInputs[j].AndType=tAND) and    //如果type 相同 且
           (GetAndInputNum(OrInputs[j],refID)=1) and //目的處也是只有一個 input,
           (refID0=refID) then  //且相同 input 位置
        begin
          //如果互補----------
          if  OrInputs[j].Inputs[refID]<>OrInputs[i].Inputs[refID] then
          begin
            OrType:=tOrTrue; // 全部為True
            RefreshOrTable(Ortbl);//,tmpOrtbl)
            exit;
          end
          else //如果相同
            OrInputs[j].Inputs[refID]:=-1;
        end;  

        OrInputs[i].AndType:=tNAND;
        case  OrInputs[i].Inputs[refID0] of
        0: OrInputs[i].Inputs[refID0]:=1;
        1: OrInputs[i].Inputs[refID0]:=0;
        end;

        for j:=i+1 to iH do
        if (OrInputs[j].AndType=tAND) and //如果目的處也是只有一個 input
           (GetAndInputNum(OrInputs[j],refID)=1) and
           (refID<>refID0) then
        begin               
          blMerged:=true;
          case  OrInputs[j].Inputs[refID] of
          0: OrInputs[i].Inputs[refID]:=1;
          1: OrInputs[i].Inputs[refID]:=0;
          end;

          OrInputs[j].Inputs[refID]:=-1;
        end;

        if blMerged then
          RefreshOrTable(Ortbl)//,tmpOrtbl)
        else
        begin
          OrInputs[i].AndType:=tAND;
          case  OrInputs[i].Inputs[refID0] of
          0: OrInputs[i].Inputs[refID0]:=1;
          1: OrInputs[i].Inputs[refID0]:=0;
          end;
        end;

        exit;        
      end;
    end;
  end;
end;


//將 NAND 轉成 Ors --->    !(A*B*C)  -->  !A+!B+!C  ************************************
procedure TLogicDesign.NAND2ORs(var Ortbl: OrTable);
var
  i,NandID,j,k,iHold,iHnew,iHgrp:integer;
  baseID:integer;
begin
  with Ortbl do
  begin
    iHold:=High(OrInputs);
    for i:=0 to iHold do
    if OrInputs[i].AndType=tNAND then
    begin
      OrInputs[i].AndType:=tAnd;

      iHgrp:= High(OrInputs[i].Inputs);

      for j:=0 to iHgrp do
      if OrInputs[i].Inputs[j]<>-1 then
      begin
        OrInputs[i].Inputs[j]:=(OrInputs[i].Inputs[j]+1) mod 2;
        BaseID:=j;
        break;
      end;
      

      for j:=BaseID+1 to iHgrp do
      if OrInputs[i].Inputs[j]<>-1 then
      begin
        Setlength(OrInputs,High(OrInputs)+2);
        iHnew:=High(OrInputs);
        
        OrInputs[iHnew]:=OrInputs[i];
        OrInputs[iHnew].Inputs:=nil;
        Setlength(OrInputs[iHnew].Inputs,iHgrp+1);

        for k:=0 to iHgrp do OrInputs[iHnew].Inputs[k]:=-1;

        OrInputs[iHnew].Inputs[j]:=(OrInputs[i].Inputs[j]+1) mod 2;
        OrInputs[i].Inputs[j]:=-1;
      end;
    end;
  end
end;




//取得某個 AndArray 內有多少 Inputs *****************************************************
function TLogicDesign.GetAndInputNum(andary: AndArray; var id:integer): word;
var
 i:integer;
begin
  result:=0;
  id:=-1;
  for i:=0 to High(andAry.Inputs ) do
  if andAry.Inputs[i]<>-1 then
  begin
    inc(result);
    id:=i;
  end;
end;




//將某筆 AndArray 拷貝到某筆 AndArray****************************************************
procedure TLogicDesign.CopyAndArray(srcAndAry: AndArray; var tarAndAry: AndArray);
var
 i,iH,refID:integer;
begin
  with srcAndAry do
  //if GetAndInputNum(srcAndAry,refID)<>0 then
  begin
    setlength(tarAndAry.Inputs,0);
    setlength(tarAndAry.InputsDisabled,0);

    tarAndAry:=srcAndAry;
    tarAndAry.Inputs:=nil;
    tarAndAry.InputsDisabled:=nil;
    //setlength(tarAndAry.Inputs,0);

    iH:=High(Inputs);
    if Inputs<>nil then
    begin
      setlength(tarAndary.Inputs,iH+1);
      for i:=0 to iH do
       tarAndAry.Inputs[i]:=srcAndAry.Inputs[i];
    end;


    iH:=High(InputsDisabled);
    if InputsDisabled<>nil then
    begin
      setlength(tarAndary.InputsDisabled,iH+1);
      for i:=0 to iH do
       tarAndAry.InputsDisabled[i]:=srcAndAry.InputsDisabled[i];
    end;


  end;
end;




//重新更新某筆 OrTable ，將 全為 -1 的 OrInputs[] 殺掉******************************
procedure TLogicDesign.RefreshOrTable(var Ortbl: OrTable);
var
  i,iH,refID:integer;
  tmpOrTbl:Ortable;
begin

  with ortbl do
  begin
    tmportbl:=Ortbl;
    tmportbl.OrInputs:=nil;
    tmpOrtbl.OrInputsDisabled:=nil;

    iH:=High(ortbl.OrInputs);

    for i:=0 to iH do
    if GetAndInputNum(OrInputs[i],refID)<>0 then
    begin
      Setlength(tmpOrtbl.OrInputs,High(tmpOrtbl.OrInputs)+2);
      CopyAndArray(OrInputs[i],tmportbl.OrInputs[High(tmpOrtbl.OrInputs)]);
    end;

    //產生對應的 OrInputsDisabled[]--------------------------------------------
    Setlength(tmpOrtbl.OrInputsDisabled,High(tmpOrtbl.OrInputs)+1);

    ReleaseOrTable(OrTbl);

    OrTbl:=tmpOrtbl;
  end;
end;



procedure TLogicDesign.NandUserBoolTable;
begin
  //將 ORs 轉成 not Ands --->   !A+!B+!C -->  !(A*B*C)
  with UserBoolTable do
  begin
    Ors2Nand(newOrTable);
    OrTable2BoolStr(newOrTable, UserInSgnlAry, newOrTable.StrEqua);
  end;
end;

procedure TLogicDesign.ORsUserBoolTable;
begin
  with UserBoolTable do
  begin
    Nand2Ors(newOrTable);   
    OrTable2BoolStr(newOrTable, UserInSgnlAry, newOrTable.StrEqua);
  end;
end;



procedure TLogicDesign.SimplifyBoolTableEX(var BlTable: BoolTable; InSgnl:SignalArray);
var
  i,j,msgid:integer;
  blSimplify:boolean;
  str:String;
  tmpOldOrTable:OrTable;
  tmpOrType:TOrType;
begin
  with blTable do
  begin
    tmpOldORTable:=OldOrTable;
    tmpOldOrTable.OrInputs:=nil;
    tmpOldOrTable.OrInputsDisabled:=nil;
    Setlength(tmpOldOrTable.OrInputs,High(OldOrTable.OrInputs)+1);
    Setlength(tmpOldOrTable.OrInputsDisabled,High(OldOrTable.OrInputsDisabled)+1);
    for i:=0 to High(OldOrTable.OrInputs) do
       CopyAndArray(OldOrTable.OrInputs[i] ,tmpoldOrTable.OrInputs[i]);    


    //開始簡化 布林代式 DescendCompare()---------------------------------------------
    blSimplify:=true;
    while blSimplify do
    begin
      //先將簡化後要存的空間 初始化，準備放簡化後的代式-----------------------------
      tmpOrType:=newOrTable.OrType;
      ReleaseORTable(newOrTable);//,0);
      newOrTable.OrType:=tmpOrType;

      //用來記錄本次簡化後，有哪些式子沒有簡化到----------------------------------
      Setlength(SimplyAry,High(oldOrTable.OrInputs)+1);
      for i:=0 to High(SimplyAry) do SimplyAry[i]:=false;

      //開始簡化 (recursive)，傳回是否有簡化動作----------------------------------
      blSimplify:=DescendCompare(blTable, 0);

      for i:=0 to High(SimplyAry) do
      if SimplyAry[i]=false then  //未被簡化
      begin
        //如果 newOrTable 內沒有 OldOrTable.OrInputs[i] 的話--------------------------------
        if not ArrayExistsIn(oldOrTable.OrInputs[i], newOrTable) then
        begin
          Setlength(newOrTable.OrInputs, High(newOrTable.OrInputs)+2);
          CopyAndArray(oldOrTable.OrInputs[i], newOrTable.OrInputs[High(newOrTable.OrInputs)]); 
        end;
      end;

      RefreshOrTable(newOrTable);

      if blSimplify then
      begin
        ReleaseOrTable(oldOrTable);//,0);
        Setlength(oldOrTable.OrInputs,High(newOrTable.OrInputs)+1);

        //將新的簡化步驟複製到 oldboolstable 內--------------------------
        //if blSimplify then
        for i:=0 to High(newOrTable.OrInputs) do
        begin
          CopyAndArray(newOrTable.OrInputs[i] ,oldOrTable.OrInputs[i] );
        end;
      end;
    end;
    
    //執行布林定理的運算-----------------------------------------------------
    ProcessBool_T6_T7_T8(NewOrTable);

    //回復 OldOrTable---------------------------------------------------------
    ReleaseOrTable(OldOrTable);
    OldOrTable:=tmpOldOrTable;

    //由新的簡化 boolAry，產生 布林代式字串----------------------------------
    OrTable2BoolStr(newOrTable, InSgnl, newOrTable.StrEqua);
  end;
end;

procedure TLogicDesign.ProcessBool_T6_T7_T8(var OrTbl: OrTable);
var
  i,iH,refID0,refID1,j,k:integer;
begin  
  //先化成 Ors 型態，不可有 tNAND
  Nand2Ors(OrTbl);

  with ortbl do
  begin
    iH:=High(OrInputs);

    //先找到NandID, 目的 ID---------------------------
    for i:=0 to iH do
    if (OrInputs[i].AndType=tAND) and //參考處為 tAND 且 只有一個 input
       (GetAndInputNum(OrInputs[i],refID0)=1) then
    begin
      //先向上結合-----------------------
      if i>0 then
      for j:=i-1 downto 0 do
      if (OrInputs[j].AndType=tAND) and //目的處同為 tAND 且 相對應的input 有值 (<>-1)
         (OrInputs[j].Inputs[refID0]<>-1) then //存在
      if (GetAndInputNum(OrInputs[j],refID1)=1) then   //定律 T6b  A+!A = 1  A+A = A
      begin
        //如果互補------------------  A+!A= 1,
        if (OrInputs[j].Inputs[refID1]<>OrInputs[i].Inputs[refID1]) then
        begin
          //將目的處的 refID 值設為 -1
          OrInputs[i].Inputs[refID1]:=-1;
          OrInputs[j].Inputs[refID1]:=-1;
          OrType:=tOrTrue;
          break;
        end
        else //如果相同------------------ A+A = A
        begin
          //將目的處的值設為-1
          OrInputs[j].Inputs[refID1]:=-1;
        end;
      end
      else  //定律 T8 A+!A*B = A+B,   A+A*B = A
      begin
        //如果互補------------------  A+!A*B=A+B,  !A+A*B=!A+B
        if (OrInputs[j].Inputs[refID0]<>OrInputs[i].Inputs[refID0]) then
          //將目的處的 refID 值設為 -1
          OrInputs[j].Inputs[refID0]:=-1
        else //如果相同------------------A+A*B=A, !A+!A*B=!A
        begin
          //將目的處的 所有值都設為-1
          for k:=0 to High(OrInputs[j].Inputs) do
            OrInputs[j].Inputs[k]:=-1;
        end;
      end;

      //再向下結合-----------------------
      if i<iH then
      for j:=i+1 to iH do
      if (OrInputs[j].AndType=tAND) and //目的處同為 tAND 且 相對應的input 有值 (<>-1)
         (OrInputs[j].Inputs[refID0]<>-1) then //存在
      if (GetAndInputNum(OrInputs[j],refID1)=1) then   //定律 T6b  A+!A = 1  A+A = A
      begin
        //如果互補------------------  A+!A= 1,
        if (OrInputs[j].Inputs[refID1]<>OrInputs[i].Inputs[refID1]) then
        begin
          //將目的處的 refID 值設為 -1
          OrInputs[i].Inputs[refID1]:=-1;
          OrInputs[j].Inputs[refID1]:=-1;
          OrType:=tOrTrue;
          break;
        end
        else //如果相同------------------ A+A = A
        begin
          //將目的處的值設為-1
          OrInputs[j].Inputs[refID1]:=-1;
        end;
      end
      else  //定律 T8 A+!A*B = A+B,   A+A*B = A
      begin
        //如果互補------------------  A+!A*B=A+B,  !A+A*B=!A+B
        if (OrInputs[j].Inputs[refID0]<>OrInputs[i].Inputs[refID0]) then
          //將目的處的 refID 值設為 -1
          OrInputs[j].Inputs[refID0]:=-1
        else //如果相同------------------A+A*B=A, !A+!A*B=!A
        begin
          //將目的處的 所有值都設為-1
          for k:=0 to High(OrInputs[j].Inputs) do
            OrInputs[j].Inputs[k]:=-1;
        end;
      end;
    end;

    RefreshOrTable(Ortbl);//,tmpOrtbl)
  end;
end;

end.
