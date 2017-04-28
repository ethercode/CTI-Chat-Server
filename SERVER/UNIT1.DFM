object serverForm: TserverForm
  Left = 193
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'sL33k Server'
  ClientHeight = 244
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 3
    Top = 3
    Width = 129
    Height = 94
    Caption = 'Activation status'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 65
      Height = 13
      Caption = 'Server status:'
    end
    object statLabel: TLabel
      Left = 80
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Offline'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 11
      Top = 40
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object activateButton: TButton
      Left = 10
      Top = 61
      Width = 111
      Height = 25
      Caption = 'ACTIVATE'
      TabOrder = 0
      OnClick = activateButtonClick
    end
    object portBox: TEdit
      Left = 37
      Top = 38
      Width = 81
      Height = 19
      AutoSize = False
      TabOrder = 1
      Text = '5090'
    end
  end
  object GroupBox2: TGroupBox
    Left = 139
    Top = 3
    Width = 182
    Height = 94
    Caption = 'Server statistics'
    TabOrder = 1
    object Label3: TLabel
      Left = 9
      Top = 16
      Width = 138
      Height = 13
      Caption = 'Amount of clients connected:'
    end
    object clientsLabel: TLabel
      Left = 149
      Top = 16
      Width = 12
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object Label2: TLabel
      Left = 67
      Top = 32
      Width = 80
      Height = 13
      Caption = 'Operators online:'
    end
    object opsLabel: TLabel
      Left = 149
      Top = 32
      Width = 12
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object Label4: TLabel
      Left = 42
      Top = 48
      Width = 105
      Height = 13
      Caption = 'Standard users online:'
    end
    object standardLabel: TLabel
      Left = 149
      Top = 48
      Width = 12
      Height = 13
      AutoSize = False
      Caption = '0'
    end
    object Label13: TLabel
      Left = 26
      Top = 64
      Width = 121
      Height = 13
      Caption = 'Amount of users silenced:'
    end
    object silencedLabel: TLabel
      Left = 149
      Top = 64
      Width = 12
      Height = 13
      AutoSize = False
      Caption = '0'
    end
  end
  object userDetailsFrame: TGroupBox
    Left = 3
    Top = 104
    Width = 318
    Height = 137
    Caption = 'User details'
    TabOrder = 2
    object userList: TListBox
      Left = 7
      Top = 18
      Width = 130
      Height = 112
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
    end
    object specificsFrame: TGroupBox
      Left = 144
      Top = 13
      Width = 164
      Height = 114
      Caption = 'Specifics'
      TabOrder = 1
      object Label6: TLabel
        Left = 6
        Top = 18
        Width = 57
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Nick:'
      end
      object Label7: TLabel
        Left = 5
        Top = 75
        Width = 57
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'IP Address:'
      end
      object Label8: TLabel
        Left = 5
        Top = 92
        Width = 57
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Hostname:'
      end
      object curNick: TLabel
        Left = 67
        Top = 18
        Width = 57
        Height = 13
        AutoSize = False
        Caption = '<Unknown>'
      end
      object curIP: TLabel
        Left = 67
        Top = 75
        Width = 57
        Height = 13
        AutoSize = False
        Caption = '<Unknown>'
      end
      object curHostname: TLabel
        Left = 67
        Top = 92
        Width = 57
        Height = 13
        AutoSize = False
        Caption = '<Unknown>'
      end
      object curOp: TCheckBox
        Left = 16
        Top = 35
        Width = 63
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Operator:'
        TabOrder = 0
        OnClick = curOpClick
      end
      object curSil: TCheckBox
        Left = 31
        Top = 55
        Width = 48
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Silent:'
        TabOrder = 1
        OnClick = curSilClick
      end
    end
  end
  object server: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = serverListen
    OnClientConnect = serverClientConnect
    OnClientDisconnect = serverClientDisconnect
    OnClientRead = serverClientRead
    OnClientError = serverClientError
    Left = 19
    Top = 195
  end
  object pingTimer: TTimer
    Enabled = False
    Interval = 60000
    Left = 19
    Top = 132
  end
  object updateTimer: TTimer
    OnTimer = updateTimerTimer
    Left = 19
    Top = 164
  end
  object specificsUpdater: TTimer
    Interval = 100
    OnTimer = specificsUpdaterTimer
    Left = 99
    Top = 200
  end
end
