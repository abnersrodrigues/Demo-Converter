object ViewImportacao: TViewImportacao
  Left = 0
  Top = 0
  Caption = 'ViewImportacao'
  ClientHeight = 501
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object edt_inicio: TLabeledEdit
    Left = 312
    Top = 40
    Width = 121
    Height = 21
    EditLabel.Width = 29
    EditLabel.Height = 13
    EditLabel.Caption = 'Inicio:'
    Enabled = False
    TabOrder = 0
  end
  object edt_fim: TLabeledEdit
    Left = 312
    Top = 96
    Width = 121
    Height = 21
    EditLabel.Width = 20
    EditLabel.Height = 13
    EditLabel.Caption = 'Fim:'
    Enabled = False
    TabOrder = 1
  end
  object edt_tempo_execucao: TLabeledEdit
    Left = 312
    Top = 152
    Width = 121
    Height = 27
    EditLabel.Width = 96
    EditLabel.Height = 13
    EditLabel.Caption = 'Tempo de Execu'#231#227'o'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object btn_new: TButton
    Left = 16
    Top = 216
    Width = 75
    Height = 25
    Caption = 'btn_new'
    TabOrder = 3
    OnClick = btn_newClick
  end
  object btn_old: TButton
    Left = 16
    Top = 166
    Width = 75
    Height = 25
    Caption = 'btn_old'
    TabOrder = 4
    OnClick = btn_oldClick
  end
  object prgGerar: TProgressBar
    Left = 97
    Top = 171
    Width = 150
    Height = 17
    TabOrder = 5
  end
  object edt_tabela_destino: TLabeledEdit
    Left = 16
    Top = 91
    Width = 217
    Height = 27
    EditLabel.Width = 71
    EditLabel.Height = 13
    EditLabel.Caption = 'Tabela Destino'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
  end
end