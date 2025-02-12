unit Views.Metodo2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  Vcl.FileCtrl, Controllers.Interfaces, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls;

type
  TViewImportacao = class(TForm)
    edt_inicio: TLabeledEdit;
    edt_fim: TLabeledEdit;
    edt_tempo_execucao: TLabeledEdit;
    btn_new: TButton;
    btn_old: TButton;
    prgGerar: TProgressBar;
    edt_tabela_destino: TLabeledEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_newClick(Sender: TObject);
    procedure btn_oldClick(Sender: TObject);


  private
    procedure SetDataHoraFinal;
    procedure SetDataHoraInicial;
    procedure ZeraContador;

  public
    FDataInicial, FDataFinal: TDateTime;
    FOpen: TOpenDialog;
  end;

function SelecionaCaminho(ANomeArquivo: String): String;

var
  ViewImportacao: TViewImportacao;
  FCaminho: String;

implementation

uses
  Convert4Delphi, Models.Conexao, Models.Querys, System.Threading,
  System.Types, System.StrUtils;

{$R *.dfm}

procedure TViewImportacao.btn_newClick(Sender: TObject);
begin
  if (FOpen.Execute) then
    begin
       FCaminho := FOpen.FileName;
    end;

  // Inicio da rotina ..
  TTask.Run(procedure
  Var
    FConexao : iConexao;
    FQryI: iQuerys;
  Begin
    SetDataHoraInicial;

    FConexao := TModelConexao.New('MSSQL');

    FQryI := TModelQuerys.New(FConexao)
                         .Get('Select * from '+edt_tabela_destino.Text);

    TConverter4Delphi.New.Importar(TModelQuerys(FQryI).DataSet, FCaminho);

    TThread.Synchronize(TThread.CurrentThread, procedure
    Begin
      SetDataHoraFinal;
      // Fim.
    End);
  End);
end;

procedure TViewImportacao.btn_oldClick(Sender: TObject);
var
  FList   : TStringList;
  FSplit  : TStringDynArray;
  FConexao : iConexao;
  FQryI: iQuerys;
begin
  ZeraContador;
  SetDataHoraInicial;

  FList := TStringList.Create;
  Try
    if (FOpen.Execute) then
      begin
         FCaminho := FOpen.FileName;
      end;

    FList.LoadFromFile(FCaminho);

    prgGerar.Max        := FList.Count;
    prgGerar.Position   := 0;

    FConexao  := TModelConexao.New('MSSQL');
    FQryI     := TModelQuerys.New(FConexao);

    for var I := 1 to FList.Count -1 do  // despresando o titulo
      Begin

        Try
          FSplit := SplitString(FList.Strings[i], ';');

          FQryI.DataSet.Close;
          FQryI.DataSet.SQL.Clear;
          FQryI.DataSet.SQL.Add('INSERT INTO '+edt_tabela_destino.Text+' (XNCM, XDESCRICAO, XCD_INT_UNIDADES)');
          FQryI.DataSet.SQL.Add('VALUES');
          FQryI.DataSet.SQL.Add('(:XNCM, :XDESCRICAO, :XCD_INT_UNIDADES)');
          FQryI.DataSet.Params.ParamByName('XNCM').asString               := StringReplace(FSplit[1], '"', '', [rfReplaceAll]);
          FQryI.DataSet.Params.ParamByName('XDESCRICAO').AsString         := StringReplace(Copy(FSplit[2], 1, 2000), '"', '', [rfReplaceAll]);
          FQryI.DataSet.Params.ParamByName('XCD_INT_UNIDADES').AsInteger  := FSplit[3].ToInteger;
          FQryI.DataSet.ExecSQL;

        Except
          Continue;
          prgGerar.Position :=  prgGerar.Position+1;
        End;

        prgGerar.Position :=  prgGerar.Position+1;
      End;

  Finally
    FreeAndNil(FList);
    SetDataHoraFinal;
  End;
end;

procedure TViewImportacao.FormCreate(Sender: TObject);
begin
  FOpen := TOpenDialog.Create(nil);
end;

procedure TViewImportacao.FormDestroy(Sender: TObject);
begin
  FOpen.Free;
end;

function SelecionaCaminho(ANomeArquivo: String): String;
Begin
  Try
    SelectDirectory('Selecione caminho da exporta��o', '', FCaminho);
    FCaminho := FCaminho + '\' + ANomeArquivo;

    if FileExists(FCaminho) then
      Begin
        if MessageDlg('Arquivo j� existe e ser� apagado! '+ #13 +'Deseja prosseguir?', mtConfirmation,
          [mbYes, mbNo], 0) = mrYes then
          begin
             DeleteFile(FCaminho);
          end;
      End;

  Finally
    Result := FCaminho;
  End;
End;

procedure TViewImportacao.SetDataHoraInicial;
Begin
  FDataInicial := Now();
  edt_inicio.Text := FormatDateTime('HH:MM:SS', FDataInicial);
End;

procedure TViewImportacao.SetDataHoraFinal;
Begin
  FDataFinal := Now();
  edt_fim.Text := FormatDateTime('HH:MM:SS', FDataFinal);

  edt_tempo_execucao.Text := TimeToStr(FDataFinal-FDataInicial);
End;

procedure TViewImportacao.ZeraContador;
Begin
  edt_inicio.Text         := EmptyStr;
  edt_fim.Text            := EmptyStr;
  edt_tempo_execucao.Text := EmptyStr;
End;

end.
