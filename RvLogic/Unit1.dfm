object Form1: TForm1
  Left = 286
  Top = 153
  Caption = 'RvLogic'
  ClientHeight = 579
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000010000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00CBCC
    BCCBCCEEECCCCCEEECCCBCCBCCBCFBCBCCBCCEECC7777CCCECCCBCCBCCBC000B
    CCBCCEC3788878CCCEECBCCBCCBC0000000CC0888777F78FCCECBCCBCC000000
    0007087777FFFFF8FCCC000000000000000088777777FFFF8000000000000000
    00078777777FFFFFF00000444444000000087777300088FFF0000EEEEEEE0000
    00877777777FFFFFFF000E40000E00000087777788888FFFFF000E44444E0000
    8887777780808FFFFFF80EEEEEEE00008877777787FFFFFFFFF88000E4000000
    8777777777FFFFFFFFF88004E444000083077777FFFFFFFFFFF780EEEEE40000
    8007770077FFF00FFFF780E400E4000020077000777FF0008FF480E444E40000
    00072777777F77FFFFF000EEEEE000000003000077FF00000770400000000000
    000137777FFFFF7FF80040100000000400000777777777778100000000000000
    0000077777777788000000000000000000000067777778800000000000000000
    0000000777777760000F00000000000000F000000000000000F0000000000000
    000F0000000000000F000000000000000000F000000000000000000000000000
    00000000000000000F00000000000000000000FF00000000F000000000000000
    000000FF0000000F000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000E0000000FE000003FE0000FFFF0007FFFE0007C0FE000780FC00
    039EFC000380F0000080F0000073F0000060F0000040D000004CC0000040E000
    0041F000003FF000001FE000001FE000001FE000001FE000001FE0000007C000
    003FB000003FF8000067F8000066F6000021FF00018FFF8043FFFFF0FFFF}
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 767
    Height = 579
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabPosition = tpBottom
    object TabSheet1: TTabSheet
      Caption = 'Simplify Bools'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      object Splitter2: TSplitter
        Left = 439
        Top = 0
        Width = 9
        Height = 550
        Beveled = True
        ExplicitTop = 29
        ExplicitHeight = 435
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 439
        Height = 550
        Align = alLeft
        TabOrder = 0
        object Panel10: TPanel
          Left = 1
          Top = 102
          Width = 437
          Height = 447
          Align = alClient
          Caption = 'Panel10'
          TabOrder = 0
          object StaticText3: TStaticText
            Left = 1
            Top = 1
            Width = 435
            Height = 20
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BevelInner = bvLowered
            BevelOuter = bvRaised
            BorderStyle = sbsSunken
            Caption = 'Bool Algebraic Expression'
            Color = clBlue
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
          end
          object lbxBool: TListBox
            Left = 1
            Top = 21
            Width = 435
            Height = 362
            Hint = 'Click to select a expression into Question field.'
            Style = lbOwnerDrawVariable
            Align = alClient
            BevelKind = bkFlat
            Color = clBlack
            Font.Charset = ANSI_CHARSET
            Font.Color = clSilver
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            ItemHeight = 14
            Items.Strings = (
              'A*B+!(A*B*!C*D)=All_True, A*B+!A+!B+C+!D->!A+B+!B+C+!D'
              '!A+!B+!C=!A+!B+!C , !(A*B*C)'
              
                '!A+!B+!C+!A*D+B*E*F=!A+!B+!C+E*F, !A+!B+!C+B*E*F , !(A*B*C)+B*E*' +
                'F'
              'A=A'
              'A*A=A'
              'A*!A=All_False'
              'A+A=A'
              'A+!A=All_True'
              'A+A*B=A'
              'A+!A*B=A+B'
              '!A*B+A+C*D+!C=B+A+D+!C'
              'A*!B+A*B=A'
              'In1*!In2+In1*In2=In1'
              'A*B*!C+!A*B*!C=B*!C'
              'A+!B=A+!B'
              '!A*B+A*!B+A*B=A+B'
              '!A*!B*!C+A*!B*!C+!A*B*!C+A*B*!C=!C'
              'abc+!x+x=All_True'
              '!A*!B*C+!A*B*C+A*!B*!C+A*!B*C=!A*C+!B*C+A*!B'
              '!A*B*!C*D+!A*B*C*D+A*B*!C*D+A*B*C*D=B*D'
              'X1*X2*X3+!X1*X2*X3+X1*!X2*!X3=X2*X3+X1*!X2*!X3'
              'A*!B*C+!A*!B*C+B*C=C'
              '!A*B+A*C+B*C=!A*B+A*C+B*C'
              '!A*!B*!C+!A*!B*C+A*!B*!C+A*!B*C=!B'
              
                '!A*!B*!C*!D+!A*!B*!C*D+!A*!B*C*!D+A*!B*!C*!D+!A*!B*C*D+!A*B*!C*D' +
                '+A*!B*C*!D+A*B*!C*!D+!A*B*C*D+A*B*!C*D+A*B*C*D=!A*!B+!B*!D+!A*D+' +
                'B*D+A*!C*!D+A*B*!C  ,  !B*!D+B*D+!A*!B+A*!C*!D'
              
                '!A*!B*!C*!D+!A*!B*C*!D+!A*B*!C*!D+A*!B*!C*!D+!A*B*!C*D+A*!B*!C*D' +
                '+A*B*!C*!D=!A*!B*!D+!A*B*!C+A*!B*!C+!C*!D'
              
                '!A*!B*!C*!D+!A*!B*!C*D+!A*B*!C*!D+!A*B*!C*D+A*!B*C*!D+A*B*!C*!D+' +
                'A*B*C*!D=!A*!C+B*!C*!D+A*C*!D , !A*!C+A*C*!D+A*B*!D ??'
              
                'A*!B*C*!D+!A*!B*C*D+!A*!B*C*!D+!A*B*!C*!D+A*B*!C*!D+A*!B*C+A*C*D' +
                '+B*C*D=!B*C+B*!C*!D+C*D ??')
            MultiSelect = True
            ParentFont = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnDrawItem = lbxBoolDrawItem
            OnMouseDown = lbxBoolMouseDown
            OnMouseMove = lbxBoolMouseMove
          end
          object Panel8: TPanel
            Left = 1
            Top = 383
            Width = 435
            Height = 63
            Align = alBottom
            Color = clNavy
            TabOrder = 2
            OnResize = Panel8Resize
            DesignSize = (
              435
              63)
            object edNew: TEdit
              Left = 8
              Top = 33
              Width = 417
              Height = 22
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = clNavy
              Font.Height = -11
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Text = '!A*B*!C*!D+A*!B*C*!D+A*B*C*!D    '
            end
            object Button2: TButton
              Left = 10
              Top = 4
              Width = 47
              Height = 25
              Hint = 'Add new bool expression into upper listbox.'
              Caption = 'Add'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = Button2Click
            end
            object Button3: TButton
              Left = 384
              Top = 4
              Width = 43
              Height = 25
              Hint = 'Delete selected expressions in upper listbox'
              Anchors = [akTop, akRight]
              Caption = 'Del'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = Button3Click
            end
          end
        end
        object Panel3: TPanel
          Left = 1
          Top = 35
          Width = 437
          Height = 34
          Align = alTop
          TabOrder = 1
          OnResize = Panel3Resize
          object StaticText2: TStaticText
            Left = 1
            Top = 1
            Width = 48
            Height = 32
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkTile
            BorderStyle = sbsSunken
            Caption = 'A'
            Color = clGreen
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -20
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
          end
          object Panel6: TPanel
            Left = 49
            Top = 1
            Width = 292
            Height = 32
            Align = alClient
            TabOrder = 1
            object edBoolTarget: TEdit
              Left = 6
              Top = 4
              Width = 275
              Height = 24
              Hint = 'Simplified bool algebraic expression'
              AutoSize = False
              Color = clBlack
              Font.Charset = ANSI_CHARSET
              Font.Color = clLime
              Font.Height = -11
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ReadOnly = True
              ShowHint = True
              TabOrder = 0
            end
          end
          object Panel17: TPanel
            Left = 341
            Top = 1
            Width = 95
            Height = 32
            Align = alRight
            TabOrder = 2
            object sbORs: TSpeedButton
              Left = 8
              Top = 6
              Width = 35
              Height = 22
              Caption = 'ORs'
              Flat = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clGreen
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = sbORsClick
            end
            object sbNand: TSpeedButton
              Left = 50
              Top = 6
              Width = 35
              Height = 22
              Caption = 'NAND'
              Flat = True
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = sbNandClick
            end
          end
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 437
          Height = 34
          Align = alTop
          TabOrder = 2
          object StaticText1: TStaticText
            Left = 1
            Top = 1
            Width = 48
            Height = 32
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkTile
            BevelOuter = bvRaised
            BorderStyle = sbsSunken
            Caption = 'Q'
            Color = clMaroon
            Font.Charset = ANSI_CHARSET
            Font.Color = clYellow
            Font.Height = -20
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
          end
          object Panel5: TPanel
            Left = 49
            Top = 1
            Width = 292
            Height = 32
            Align = alClient
            TabOrder = 1
            OnResize = Panel5Resize
            object edBoolSource: TEdit
              Left = 8
              Top = 3
              Width = 273
              Height = 24
              AutoSize = False
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Text = '!A*B*!C*!D+A*!B*C*!D+A*B*!C*D+A*!B*!C*!D    '
            end
          end
          object Panel4: TPanel
            Left = 341
            Top = 1
            Width = 95
            Height = 32
            Align = alRight
            TabOrder = 2
            DesignSize = (
              95
              32)
            object Button1: TButton
              Left = 8
              Top = 3
              Width = 79
              Height = 25
              Hint = 'Simplify Q: bool algebraic expression'
              Anchors = [akTop, akRight]
              Caption = 'Simplify'
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = Button1Click
            end
          end
        end
        object Panel15: TPanel
          Left = 1
          Top = 69
          Width = 437
          Height = 33
          Align = alTop
          Caption = 'Panel15'
          TabOrder = 3
          object Panel16: TPanel
            Left = 49
            Top = 1
            Width = 387
            Height = 31
            Align = alClient
            Caption = 'Panel15'
            TabOrder = 0
            OnResize = Panel15Resize
            object edAnswer: TEdit
              Left = 6
              Top = 4
              Width = 370
              Height = 24
              Hint = 'Simplified bool algebraic expression'
              AutoSize = False
              Color = clBlack
              Font.Charset = ANSI_CHARSET
              Font.Color = clAqua
              Font.Height = -11
              Font.Name = 'Courier New'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ReadOnly = True
              ShowHint = True
              TabOrder = 0
            end
          end
          object StaticText6: TStaticText
            Left = 1
            Top = 1
            Width = 48
            Height = 31
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkTile
            BorderStyle = sbsSunken
            Caption = 'A'
            Color = clMaroon
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -20
            Font.Name = 'Courier'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            TabOrder = 1
          end
        end
      end
      object Panel14: TPanel
        Left = 448
        Top = 0
        Width = 311
        Height = 550
        Align = alClient
        BevelInner = bvRaised
        BorderStyle = bsSingle
        Caption = 'Auto-Drawing Logic Diagram here, coming soon....'
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Logic Design'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Splitter1: TSplitter
        Left = 554
        Top = 29
        Width = 9
        Height = 521
        Beveled = True
        ExplicitHeight = 416
      end
      object Panel1: TPanel
        Left = 0
        Top = 29
        Width = 554
        Height = 521
        Align = alLeft
        Caption = 'Panel1'
        TabOrder = 0
        object Splitter4: TSplitter
          Left = 208
          Top = 342
          Width = 9
          Height = 144
          Beveled = True
          ExplicitHeight = 39
        end
        object Splitter3: TSplitter
          Left = 1
          Top = 339
          Width = 552
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object Panel9: TPanel
          Left = 1
          Top = 486
          Width = 552
          Height = 34
          Align = alBottom
          TabOrder = 0
          OnResize = Panel9Resize
          object edBoolEq: TEdit
            Left = 8
            Top = 7
            Width = 401
            Height = 23
            Color = clNavy
            Font.Charset = ANSI_CHARSET
            Font.Color = clLime
            Font.Height = -12
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'Bool Algebraic Expression'
          end
        end
        object Panel12: TPanel
          Left = 1
          Top = 342
          Width = 207
          Height = 144
          Align = alLeft
          Caption = 'Panel11'
          TabOrder = 1
          object StringGrid2: TStringGrid
            Left = 1
            Top = 25
            Width = 205
            Height = 118
            Align = alClient
            Color = clBlack
            DefaultColWidth = 30
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clYellow
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
            ParentFont = False
            TabOrder = 0
            ColWidths = (
              30
              30
              30
              30
              30)
            RowHeights = (
              24
              24
              24
              24
              24)
          end
          object StaticText5: TStaticText
            Left = 1
            Top = 1
            Width = 205
            Height = 24
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkSoft
            Caption = 'Input Signals'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
        object Panel11: TPanel
          Left = 217
          Top = 342
          Width = 336
          Height = 144
          Align = alClient
          Caption = 'Panel11'
          TabOrder = 2
          object StringGrid1: TStringGrid
            Left = 1
            Top = 25
            Width = 334
            Height = 118
            Align = alClient
            Color = clBlack
            DefaultColWidth = 30
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clLime
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
            ParentFont = False
            TabOrder = 0
            ColWidths = (
              30
              30
              30
              30
              30)
            RowHeights = (
              24
              24
              24
              24
              24)
          end
          object StaticText4: TStaticText
            Left = 1
            Top = 1
            Width = 334
            Height = 24
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            BevelKind = bkSoft
            Caption = 'Output Signals'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
        object Panel18: TPanel
          Left = 1
          Top = 1
          Width = 552
          Height = 338
          Align = alTop
          TabOrder = 3
        end
      end
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 759
        Height = 29
        Caption = 'ToolBar2'
        TabOrder = 1
        object ToolButton4: TToolButton
          Left = 0
          Top = 0
          Caption = 'ToolButton4'
          ImageIndex = 0
        end
        object ToolButton5: TToolButton
          Left = 23
          Top = 0
          Caption = 'ToolButton5'
          ImageIndex = 1
        end
        object ToolButton6: TToolButton
          Left = 46
          Top = 0
          Caption = 'ToolButton6'
          ImageIndex = 2
        end
      end
      object Panel13: TPanel
        Left = 563
        Top = 29
        Width = 196
        Height = 521
        Align = alClient
        BorderWidth = 2
        BorderStyle = bsSingle
        Caption = 'Auto-Drawing Logic Diagram here, coming soon....'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 296
    object File1: TMenuItem
      Caption = 'File'
      object OpenFile1: TMenuItem
        Caption = 'Open File'
        object OpenBoolExpressionfileble1: TMenuItem
          Caption = 'Open Bool Expression file (*.ble)'
          OnClick = OpenBoolExpressionfileble1Click
        end
        object OpenLogicDesignFilelgd1: TMenuItem
          Caption = 'Open Logic Design File (*.lgd)'
        end
      end
      object SaveFile1: TMenuItem
        Caption = 'Save File'
        object Expressionsble1: TMenuItem
          Caption = 'Expressions file (*.ble)'
          OnClick = Expressionsble1Click
        end
        object LogicDesignFilelgd1: TMenuItem
          Caption = 'Logic Design File (*.lgd)'
        end
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Caption = 'Print'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
    end
    object Display1: TMenuItem
      Caption = 'Display'
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object aboutDlg: TMenuItem
        Caption = 'About Logic Design'
        OnClick = aboutDlgClick
      end
      object RasVectorWeb1: TMenuItem
        Caption = 'RasVector Web'
        OnClick = RasVectorWeb1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 320
  end
  object SaveDialog1: TSaveDialog
    Left = 320
    Top = 65520
  end
end
