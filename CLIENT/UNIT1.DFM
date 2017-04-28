object Form1: TForm1
  Left = 199
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'sL33k Chat Client'
  ClientHeight = 440
  ClientWidth = 642
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 280
    Top = 13
    Width = 49
    Height = 16
    Caption = 'Server:'
  end
  object Label2: TLabel
    Left = 460
    Top = 13
    Width = 33
    Height = 16
    Caption = 'Port:'
  end
  object Label3: TLabel
    Left = 6
    Top = 13
    Width = 33
    Height = 16
    Caption = 'Nick:'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 35
    Width = 642
    Height = 8
    Shape = bsTopLine
    Style = bsRaised
  end
  object Label4: TLabel
    Left = 176
    Top = 13
    Width = 33
    Height = 16
    Caption = 'Pwd:'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 67
    Width = 642
    Height = 8
    Shape = bsTopLine
    Style = bsRaised
  end
  object Label5: TLabel
    Left = 8
    Top = 45
    Width = 99
    Height = 16
    Caption = 'Channel Topic:'
  end
  object topic: TLabel
    Left = 112
    Top = 45
    Width = 210
    Height = 16
    Caption = '<NOT CONNECTED TO SERVER>'
    ParentShowHint = False
    ShowHint = False
  end
  object textBox: TEdit
    Left = 7
    Top = 411
    Width = 498
    Height = 20
    AutoSize = False
    Color = 10841402
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnChange = textBoxChange
  end
  object nickBox: TEdit
    Left = 47
    Top = 8
    Width = 124
    Height = 20
    AutoSize = False
    Color = 10841402
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = nickBoxChange
  end
  object IPBox: TEdit
    Left = 332
    Top = 8
    Width = 121
    Height = 20
    AutoSize = False
    Color = 10841402
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object connectBut: TButton
    Left = 546
    Top = 8
    Width = 89
    Height = 21
    Caption = 'Connect'
    Default = True
    Enabled = False
    TabOrder = 4
    TabStop = False
    OnClick = connectButClick
  end
  object portBox: TMaskEdit
    Left = 495
    Top = 8
    Width = 47
    Height = 20
    AutoSize = False
    Color = 10841402
    EditMask = '99999;1; '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    MaxLength = 5
    ParentFont = False
    TabOrder = 3
    Text = '05090'
  end
  object nickList: TListBox
    Left = 512
    Top = 76
    Width = 123
    Height = 328
    TabStop = False
    Color = 10841402
    ItemHeight = 16
    Sorted = True
    TabOrder = 6
  end
  object passwordBox: TEdit
    Left = 208
    Top = 8
    Width = 66
    Height = 20
    AutoSize = False
    Color = 223
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    PasswordChar = 'x'
    TabOrder = 1
  end
  object sayThis: TButton
    Left = 512
    Top = 411
    Width = 123
    Height = 21
    Caption = 'Say this (enter)'
    Default = True
    Enabled = False
    TabOrder = 7
    OnClick = sayThisClick
  end
  object mainBox: TRichEdit
    Left = 6
    Top = 76
    Width = 499
    Height = 328
    Color = 10841402
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object client: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnLookup = clientLookup
    OnConnecting = clientConnecting
    OnConnect = clientConnect
    OnDisconnect = clientDisconnect
    OnRead = clientRead
    OnError = clientError
    Left = 592
    Top = 368
  end
  object MainMenu1: TMainMenu
    Left = 560
    Top = 368
    object Connection1: TMenuItem
      Caption = 'Connection'
      object Connect1: TMenuItem
        Caption = 'Connect'
        OnClick = Connect1Click
      end
      object Disconnect1: TMenuItem
        Caption = 'Disconnect'
        Enabled = False
        OnClick = Disconnect1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Nick1: TMenuItem
      Caption = 'Nick'
      Enabled = False
      object Changenick1: TMenuItem
        Caption = 'Change nick'
        OnClick = Changenick1Click
      end
    end
    object Maintainance1: TMenuItem
      Caption = 'Maintainance'
      Enabled = False
      object Opuser1: TMenuItem
        Caption = 'Op user'
        OnClick = Opuser1Click
      end
      object Deopuser1: TMenuItem
        Caption = 'Deop user'
        OnClick = Deopuser1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Silenceuser1: TMenuItem
        Caption = 'Silence user'
      end
      object Unsilenceuser1: TMenuItem
        Caption = 'Unsilence user'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Kickuser1: TMenuItem
        Caption = 'Kick user'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object ChangeTopic1: TMenuItem
        Caption = 'Change Topic'
        OnClick = ChangeTopic1Click
      end
    end
    object Userdetails1: TMenuItem
      Caption = 'User details'
      Enabled = False
      object WhoisUser1: TMenuItem
        Caption = 'Whois User'
        OnClick = WhoisUser1Click
      end
    end
  end
end
