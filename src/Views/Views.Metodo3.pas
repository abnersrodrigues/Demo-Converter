unit Views.Metodo3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Threading,
  Vcl.ExtCtrls;

type
  TViewConversao = class(TForm)
    Button1: TButton;
    edt_inicio: TLabeledEdit;
    edt_fim: TLabeledEdit;
    edt_tempo_execucao: TLabeledEdit;
    edt_tabela_origem: TLabeledEdit;
    edt_tabela_destino: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
  private
    procedure SetDataHoraFinal;
    procedure SetDataHoraInicial;
    procedure ZeraContador;

  public
    FDataInicial, FDataFinal: TDateTime;
  end;

var
  ViewConversao: TViewConversao;

implementation

uses
  Convert4Delphi, Controllers.Interfaces, Models.Conexao, FireDAC.Comp.Client;

{$R *.dfm}

procedure TViewConversao.Button1Click(Sender: TObject);
begin
  // Inicio da rotina ..
  TTask.Run(procedure
  Var
    FConexao : iConexao;
  Begin
    SetDataHoraInicial;

    FConexao := TModelConexao.New('MSSQL');
    TConverter4Delphi.New.TabelaTabela(TFDConnection(FConexao.Conexao), TFDConnection(FConexao.Conexao), edt_tabela_origem.Text, edt_tabela_destino.Text);

    TThread.Synchronize(TThread.CurrentThread, procedure
    Begin
      SetDataHoraFinal;
      // Fim.
    End);
  End);
end;

procedure TViewConversao.SetDataHoraInicial;
Begin
  FDataInicial := Now();
  edt_inicio.Text := FormatDateTime('HH:MM:SS', FDataInicial);
End;

procedure TViewConversao.SetDataHoraFinal;
Begin
  FDataFinal := Now();
  edt_fim.Text := FormatDateTime('HH:MM:SS', FDataFinal);

  edt_tempo_execucao.Text := TimeToStr(FDataFinal-FDataInicial);
End;

procedure TViewConversao.ZeraContador;
Begin
  edt_inicio.Text         := EmptyStr;
  edt_fim.Text            := EmptyStr;
  edt_tempo_execucao.Text := EmptyStr;
End;

end.
