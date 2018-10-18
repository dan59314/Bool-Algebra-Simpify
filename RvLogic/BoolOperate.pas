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

   T1: �洫��
      A+B = B+A
      A*B = B*A

   T2: ���X��
      a: (A+B)+C = A+(B+C)
      b: (A*B)*C = A*(B*C)

   T3: ���t��
      a: A*(B+C) = A*B + A*C
      b: A+(B*C) = (A+B) * (A+C)

   T4: ������
      a: A*1 = A
      b: A+0 = 0

   T5: �Ť���
      a: A*0 = 0
      b: A+1 = 1

   T6: �ɼ�
      a: A*!A = 0
      b: A+!A = 1

   T7: ������
      a: A*A = A
      b: A+A = A

   T8: �l����
      a: A + A*B = A
      b: A +!A*B = A+B
      c: A * (A+B) = A
      d: A * (!A+B) = AB

   T9: �����
      !!A = A

   T10: De Morgan's �w�z
      a: !(A+B+C+...) = !A * !B * !C * !.....
      b: !(A*B*C*...) = !A + !B + !C + !.....



************************************************************}



unit BoolOperate;

interface
uses SysUtils,Types;


const
  //�B��l '*':and,  '+':or,  '!':not,  '@':xor,  ' ':���l����
  SciOpt: set of char=['*','+','!','@','(',')',' '];
  ErrMessage: Array[0..1] of String=('Wrong Expression!','Accepted only Sum of Products!');

type
  ActiveType=(aLow,aHigh);


type
  TAndType=(tAND,tNAND,tAndTrue,tAndFalse);
  TOrType=(tOR,tNOR,tOrTrue,tOrFalse);

  //�޿�h�ϧ���ܸ�Ƶ��c-----------------------------------------------------
  GateSymbolPos=record
    Center:TPoint;
    sRect:TRect;
  end;


  //��X�J�T������Ƶ��c-------------------------------------------------------
  //SignalPtr=^SignalRec;
  SignalRec=record
    SgnlName:String;
    Active:ActiveType;
  end;
  //SignalArrayPtr=^SignalArray;
  SignalArray=Array of SignalRec;

  //���L�ƭ�-------------------------------------
  BoolValue=-2..1; //-2:���ɼ�, -1: don't care,  0:low,  1:high
  TInputArray=Array of BoolValue;

  //�ΨӦs��h�ӫH�� And �����  A*B*C*D----------------------------------------
  AndArray=record
    AndType:TAndType;
    InputNum:word;
    Inputs:TInputArray; //Array of BoolValue;
    InputsDisabled: Array of Boolean;  //�p�G�Y��input �Q��L�s���L�Ӫ�output���N�h�]�� true;

    AndSymbol:GateSymbolPos;
  end;
  TOrInputArray=Array of AndArray;


  //�ΨӦs��h��  Or ���    A + B + C*D ...------------------------------------
  OrTable=record
    strEqua:String;
    OrType:TOrType;
    OrInputNum:word;
    OrInputs:TOrInputArray;//Array of AndArray;  //-1: don't care,  0:low,  1:high
    OrInputsDisabled:Array of Boolean;

    OrSymbol:GateSymbolPos;
  end;

  //�@�ӿ�X�H���� ��l�M²�ƫ᪺ ���L�⦡���---------------------------------
  BoolTablePtr=^BoolTable;
  BoolTable=record
    //�Ĥ@���O or ���ƥءA�ĤG���O input �ƥ�
    oldOrTable: OrTable; //�x�s�e�@��²�ƨB�J�� BoolTable
    newOrTable: OrTable;
  end;


  //�@�ӧ��㪺�޿�]�p��ơA���h�ӿ�J�M��X------------------------------------
  TLogicUnit=record
    PrjName:String;
    InSgnlAry:SignalArray;  //�s�� input �T���ܼ�
    OutSgnlAry:SignalArray; //�s�� output �T���ܼ�
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

    function  DescendCompare(var BlTable:BoolTable; BaseID:integer):boolean; // ���B�J�O�_�i²��
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

    //User �ۭq���浧���L�N�����ഫ------------------------
    procedure CreateUserBoolTable(strEq:String);
    function  GetUserNewBoolStr:String;
    procedure ORsUserBoolTable;
    procedure NandUserBoolTable;

    procedure ORs2NAND(var Ortbl:OrTable);
    procedure NAND2ORs(var Ortbl:OrTable);
  end;



var
  //��ӯu�Ȫ��Ҧ� ��X�T���� ���L�N��----------------------------
  LogicUnit:TLogicUnit;//Array of BoolTable; //���׬� ouput �T�����ƥ�

  //�ϥΪ̦ۭq��@��X�T���� ���L�N��----------------------------
  UserBoolTable:BoolTable; //���׬� ouput �T�����ƥ�
  UserInSgnlAry:SignalArray;  //�s�� input �T���ܼ�

  tmpOrTable:OrTable; //�ΨӰ����L�⦡²�Ʈɪ��ȮɰO���ɡA�����⦡�X�֮ɪ��s²�ƺ⦡
  SimplyAry:Array of boolean; //�Ψ��ˬd oldOrTable �� OrInputs �U�Ӧ��l�O�_�w�Q�X�ְ�²��  


implementation
{$ASSERTIONS ON/OFF	(long form)}




//����Y�� AndArray ���Ŷ�************************************************************
procedure TLogicDesign.ReleaseOrInputs(var andAry: AndArray);
var
  i:integer;
begin
  Setlength(andAry.Inputs,0);
  Setlength(andAry.InputsDisabled,0);
  fillchar(andAry,SizeOf(AndArray),0);
end;



//����Y�� OrTable ���Ŷ�************************************************************
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



//����Y�� BoolTable ���Ŷ� ************************************************************
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

//����Y�� SignalArray ���Ŷ�************************************************************
procedure TLogicDesign.ReleaseSignalArray(var SgnlAry:SignalArray);
var
  i:integer;
begin
  Setlength(SgnlAry,0);
end;


//�������O�Ҧ��ܼƪŶ�************************************************************
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


//�����r�ꤤ���Ҧ��ťզr��***********************************************************
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




//�ھ� BoolTable ²�� ���L�N�Ʀ�*********************************************************
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

    //Move(oldOrTable,tmpOrTable,SizeOf(BlAry)); //�u��Move ��}�S��Move ���e
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

      if idiffer=1 then //�u���@�Ӥ��P�A�}�l�N���P���]��-1�A�ñN�s�ȶ�JnewOrTable
      begin
        // A+!A = 1  (all true)------------------------------
        if (GetAndInputNum(oldOrTable.OrInputs[BaseID],iUnique)=1) and
           (GetAndInputNum(oldOrTable.OrInputs[i],iUnique)=1) then
        begin
          newOrTable.OrType:=tOrTrue;
        end;  

        result:=true; //�i²��
        SimplyAry[BaseID]:=true;
        SimplyAry[i]:=true;

        tmpOrTable.OrInputs[i].Inputs[differID]:=-1; //�N�ѦҰ�Ǫ����P�I�]��-1

        //�p�G newOrTable ���S�� tmpOrTable[i] ����--------------------------------
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
      else if idiffer=0 then //�����ۦP---------------------------
      begin
        result:=true; //�i²��

        SimplyAry[BaseID]:=true;
        SimplyAry[i]:=true;

        //�p�G newOrTable ���S�� tmpOrTable[i] ����--------------------------------
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



//�ھ� BoolTable �إ� ���L�N�Ʀ�***********************************************************
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

      //�D�X AndGroup--------------------------------
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

      //�p�G�u���@�� Inputs, �B�䤤�@�Ӧ��ɼƪ���------
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




//�ˬd�Y�� AndArray �O�_�s�b �Y�� OrTable ��*******************************************
//�i�t�~�Ψӱ��y �� OrTable ���� AndArray �O�_�M�O�� OrTable ������, �ΥH�@ Input ��s��, �Ҧp:
// �]�� e=A*B*C,   f=A*B*C+D
// �ҥH f=e+f  �i�N e ���Y�� And ouput �s���� f ���Y�� OrInput ��ֽu���M�޿�q���ϥ�
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









//�ھ� ���L�N�Ʀ� �إ� BoolTable***********************************************************
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

  //���p�⦳�h�֭� �ܼ�,  �h�֭� Or -----------------------------
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


  //���U�Ӷ�JBoolTable ----------------------------------------
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

    //���t�m BoolTable �Ŷ�---------------------------
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

    //�}�l��J----------------------------------------
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
                  format('�N�Ʀ� :  %s ',[strEq])+#$0A+#$0D+#$0A+#$0D+
                  format('�� %d �Ӧr�� "%s" �Ϋe��r�����~�C',[i-1,strEq[i-1]])+#$0A+#$0D+#$0A+#$0D);
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
              //���ť[�J �r�ꦡ�ˬd���----------------------------------------------------------
              {Assert(1=2,
                  format('%s ',['illegal expression.'])+#$0A+#$0D+#$0A+#$0D+
                  format('�N�Ʀ� :  %s �� %d �Ӧr��',[strEq,i-1])+#$0A+#$0D+#$0A+#$0D+
                  format('"%s" �P "!%s" �����ɼơA���~�C',[strEq[i-1],strEq[i-1]])+#$0A+#$0D+#$0A+#$0D);}
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




////�ھ� ���L�N�Ʀ� �إ� SignalArray �M ToolTable �ç���²�� *******************************
procedure TLogicDesign.CreateBoolTable(strEq:String;
                  Var blTable:BoolTable; var InSgnl:SignalArray);
var
  i,msgid:integer; 
begin
  DeleteBlank(strEq);

  ReleaseBoolTable(blTable);
  ReleaseSignalArray(InSgnl);

  //���ť[�J �r�ꦡ�ˬd���----------------------------------------------------------
  Assert(IsRightExpression(strEq, i, msgid)=true,
      format('%s ',[ErrMessage[msgid]])+#$0A+#$0D+#$0A+#$0D+
      format('�N�Ʀ� :  %s ',[strEq])+#$0A+#$0D+#$0A+#$0D+
      format('�� %d �Ӧr�� "%s" �Ϋe��r�����~�C',[i,strEq[i]])+#$0A+#$0D+#$0A+#$0D);


  with blTable do
  begin
    //�ھ� ���L�N�� ���� ��l�� BoolAry ��b oldOrTable---------------------------------
    BoolStr2OrTable(oldOrTable, InSgnl, strEq);
    Assert(High(InSgnl)+1>0,format('�ܼƬ� %d �ӡA�����ܤ֤@���ܼ�',[High(InSgnl)+1])+
        #$0A+#$0D+#$0A+#$0D);

    //²�ƥ��L�N�� ----------------------------------------------------------------------
    SimplifyBoolTableEX(BlTable,InSgnl);
  end;
end;


//�P�_�O�_�����T�����L�B�⦡�l*************************************************
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

  //���R�C�ӹB��l�e�᭱�r���A�q��1�Ӧr���}�l��˼ƲĤG�Ӧr��---------------------
  i:=2;
  iLevel:=0;
  tmpStr:='';
  while i<strL do
  begin
    case strEq[i] of
      '*':
        if strEq[i-1] in ['*','+','!','('] then //�B��l�e���i��...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //�B��l�ᤣ�i��...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;
      '+':
        if strEq[i-1] in ['*','+','!','('] then  //�B��l�e���i��...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //�B��l�ᤣ�i��...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;
      '!':
        if not (strEq[i-1] in ['*','+','(']) then  //�B��l�e�u�ର...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+','!',')'] then  //�B��l�ᤣ�i��...
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
        {if not (strEq[i-1] in ['*','+','!','(']) then //�B��l�e�u�ର...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if strEq[i+1] in ['*','+',')'] then  //�B��l�ᤣ�i��...
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
        {if strEq[i-1] in ['*','+','!','('] then  //�B��l�e���i��...
        begin
          errID:=i-1;
          result:=false;
          exit;
        end
        else if not (strEq[i+1] in ['*','+',')']) then  //�B��l��u�ର...
        begin
          errID:=i+1;
          result:=false;
          exit;
        end;}
    end;
    inc(i);
  end;

end;




//�إ�  User �� ToolTable �M SignalArray*************************************************
procedure TLogicDesign.CreateUserBoolTable(strEq:String);
begin
  CreateBoolTable(strEq,UserBoolTable,UserInSgnlAry);
end;



//���o userBoolTable ��²�ƫ᪺ ���L�N�Ʀ� StrEq******************************************
function  TLogicDesign.GetUserNewBoolStr:String;
begin
  result:=UserBoolTable.newOrTable.StrEqua;
end;


//�N ORs �ন not Ands --->   !A+!B+!C -->  !(A*B*C)  *************************************
procedure TLogicDesign.ORs2NAND(var Ortbl: OrTable);
var
  i,iH,NandID,refID0,refID,j:integer;
  blMerged:boolean;
begin
  with ortbl do
  begin
    iH:=High(OrInputs);

    //�����NandID, �ت� ID---------------------------
    for i:=0 to iH-1 do
    begin
      blMerged:=false;

      //�p�G���u���@��input���Ѧ��I
      if (OrInputs[i].AndType=tAND) and
       (GetAndInputNum(OrInputs[i],refID0)=1) then
      begin
        //���ݦ��S���u���@��input,�B�O���ɩάۦP����A+B*C...+!A = 1 (All True) , A+B*C..+A=A+B*C..
        for j:=i+1 to iH do
        if (OrInputs[j].AndType=tAND) and    //�p�Gtype �ۦP �B
           (GetAndInputNum(OrInputs[j],refID)=1) and //�ت��B�]�O�u���@�� input,
           (refID0=refID) then  //�B�ۦP input ��m
        begin
          //�p�G����----------
          if  OrInputs[j].Inputs[refID]<>OrInputs[i].Inputs[refID] then
          begin
            OrType:=tOrTrue; // ������True
            RefreshOrTable(Ortbl);//,tmpOrtbl)
            exit;
          end
          else //�p�G�ۦP
            OrInputs[j].Inputs[refID]:=-1;
        end;  

        OrInputs[i].AndType:=tNAND;
        case  OrInputs[i].Inputs[refID0] of
        0: OrInputs[i].Inputs[refID0]:=1;
        1: OrInputs[i].Inputs[refID0]:=0;
        end;

        for j:=i+1 to iH do
        if (OrInputs[j].AndType=tAND) and //�p�G�ت��B�]�O�u���@�� input
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


//�N NAND �ন Ors --->    !(A*B*C)  -->  !A+!B+!C  ************************************
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




//���o�Y�� AndArray �����h�� Inputs *****************************************************
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




//�N�Y�� AndArray ������Y�� AndArray****************************************************
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




//���s��s�Y�� OrTable �A�N ���� -1 �� OrInputs[] ����******************************
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

    //���͹����� OrInputsDisabled[]--------------------------------------------
    Setlength(tmpOrtbl.OrInputsDisabled,High(tmpOrtbl.OrInputs)+1);

    ReleaseOrTable(OrTbl);

    OrTbl:=tmpOrtbl;
  end;
end;



procedure TLogicDesign.NandUserBoolTable;
begin
  //�N ORs �ন not Ands --->   !A+!B+!C -->  !(A*B*C)
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


    //�}�l²�� ���L�N�� DescendCompare()---------------------------------------------
    blSimplify:=true;
    while blSimplify do
    begin
      //���N²�ƫ�n�s���Ŷ� ��l�ơA�ǳƩ�²�ƫ᪺�N��-----------------------------
      tmpOrType:=newOrTable.OrType;
      ReleaseORTable(newOrTable);//,0);
      newOrTable.OrType:=tmpOrType;

      //�ΨӰO������²�ƫ�A�����Ǧ��l�S��²�ƨ�----------------------------------
      Setlength(SimplyAry,High(oldOrTable.OrInputs)+1);
      for i:=0 to High(SimplyAry) do SimplyAry[i]:=false;

      //�}�l²�� (recursive)�A�Ǧ^�O�_��²�ưʧ@----------------------------------
      blSimplify:=DescendCompare(blTable, 0);

      for i:=0 to High(SimplyAry) do
      if SimplyAry[i]=false then  //���Q²��
      begin
        //�p�G newOrTable ���S�� OldOrTable.OrInputs[i] ����--------------------------------
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

        //�N�s��²�ƨB�J�ƻs�� oldboolstable ��--------------------------
        //if blSimplify then
        for i:=0 to High(newOrTable.OrInputs) do
        begin
          CopyAndArray(newOrTable.OrInputs[i] ,oldOrTable.OrInputs[i] );
        end;
      end;
    end;
    
    //���楬�L�w�z���B��-----------------------------------------------------
    ProcessBool_T6_T7_T8(NewOrTable);

    //�^�_ OldOrTable---------------------------------------------------------
    ReleaseOrTable(OldOrTable);
    OldOrTable:=tmpOldOrTable;

    //�ѷs��²�� boolAry�A���� ���L�N���r��----------------------------------
    OrTable2BoolStr(newOrTable, InSgnl, newOrTable.StrEqua);
  end;
end;

procedure TLogicDesign.ProcessBool_T6_T7_T8(var OrTbl: OrTable);
var
  i,iH,refID0,refID1,j,k:integer;
begin  
  //���Ʀ� Ors ���A�A���i�� tNAND
  Nand2Ors(OrTbl);

  with ortbl do
  begin
    iH:=High(OrInputs);

    //�����NandID, �ت� ID---------------------------
    for i:=0 to iH do
    if (OrInputs[i].AndType=tAND) and //�ѦҳB�� tAND �B �u���@�� input
       (GetAndInputNum(OrInputs[i],refID0)=1) then
    begin
      //���V�W���X-----------------------
      if i>0 then
      for j:=i-1 downto 0 do
      if (OrInputs[j].AndType=tAND) and //�ت��B�P�� tAND �B �۹�����input ���� (<>-1)
         (OrInputs[j].Inputs[refID0]<>-1) then //�s�b
      if (GetAndInputNum(OrInputs[j],refID1)=1) then   //�w�� T6b  A+!A = 1  A+A = A
      begin
        //�p�G����------------------  A+!A= 1,
        if (OrInputs[j].Inputs[refID1]<>OrInputs[i].Inputs[refID1]) then
        begin
          //�N�ت��B�� refID �ȳ]�� -1
          OrInputs[i].Inputs[refID1]:=-1;
          OrInputs[j].Inputs[refID1]:=-1;
          OrType:=tOrTrue;
          break;
        end
        else //�p�G�ۦP------------------ A+A = A
        begin
          //�N�ت��B���ȳ]��-1
          OrInputs[j].Inputs[refID1]:=-1;
        end;
      end
      else  //�w�� T8 A+!A*B = A+B,   A+A*B = A
      begin
        //�p�G����------------------  A+!A*B=A+B,  !A+A*B=!A+B
        if (OrInputs[j].Inputs[refID0]<>OrInputs[i].Inputs[refID0]) then
          //�N�ت��B�� refID �ȳ]�� -1
          OrInputs[j].Inputs[refID0]:=-1
        else //�p�G�ۦP------------------A+A*B=A, !A+!A*B=!A
        begin
          //�N�ت��B�� �Ҧ��ȳ��]��-1
          for k:=0 to High(OrInputs[j].Inputs) do
            OrInputs[j].Inputs[k]:=-1;
        end;
      end;

      //�A�V�U���X-----------------------
      if i<iH then
      for j:=i+1 to iH do
      if (OrInputs[j].AndType=tAND) and //�ت��B�P�� tAND �B �۹�����input ���� (<>-1)
         (OrInputs[j].Inputs[refID0]<>-1) then //�s�b
      if (GetAndInputNum(OrInputs[j],refID1)=1) then   //�w�� T6b  A+!A = 1  A+A = A
      begin
        //�p�G����------------------  A+!A= 1,
        if (OrInputs[j].Inputs[refID1]<>OrInputs[i].Inputs[refID1]) then
        begin
          //�N�ت��B�� refID �ȳ]�� -1
          OrInputs[i].Inputs[refID1]:=-1;
          OrInputs[j].Inputs[refID1]:=-1;
          OrType:=tOrTrue;
          break;
        end
        else //�p�G�ۦP------------------ A+A = A
        begin
          //�N�ت��B���ȳ]��-1
          OrInputs[j].Inputs[refID1]:=-1;
        end;
      end
      else  //�w�� T8 A+!A*B = A+B,   A+A*B = A
      begin
        //�p�G����------------------  A+!A*B=A+B,  !A+A*B=!A+B
        if (OrInputs[j].Inputs[refID0]<>OrInputs[i].Inputs[refID0]) then
          //�N�ت��B�� refID �ȳ]�� -1
          OrInputs[j].Inputs[refID0]:=-1
        else //�p�G�ۦP------------------A+A*B=A, !A+!A*B=!A
        begin
          //�N�ت��B�� �Ҧ��ȳ��]��-1
          for k:=0 to High(OrInputs[j].Inputs) do
            OrInputs[j].Inputs[k]:=-1;
        end;
      end;
    end;

    RefreshOrTable(Ortbl);//,tmpOrtbl)
  end;
end;

end.
