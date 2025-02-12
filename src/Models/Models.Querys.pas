unit Models.Querys;

interface

Uses
  System.SysUtils, Vcl.Dialogs, System.Types, StrUtils, FireDAC.Phys.Intf, System.Classes,
  FireDAC.Stan.Intf,FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, System.Threading,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON,
  Controllers.Interfaces, DateUtils;

Type
  TModelQuerys = class(TInterfacedObject, iQuerys)

    private
      FParent     : iConexao;
      FQry        : TFDQuery;
    public
      constructor Create(Parent : iConexao);
      destructor Destroy; override;
      class function New (Parent : iConexao): iQuerys;
      function Get(ASql: String): iQuerys;
      function DataSet : TFDQuery;
  end;

implementation

uses
  Models.Conexao;

constructor TModelQuerys.Create(Parent: iConexao);
begin
  FParent := Parent;

  FQry := TFDQuery.Create(nil);

  FQry.Connection := TFDConnection(FParent.Conexao);
end;

function TModelQuerys.DataSet: TFDQuery;
begin
  Result := FQry;
end;

destructor TModelQuerys.Destroy;
begin
  FreeAndNil(FQry);
  inherited;
end;

class function TModelQuerys.New(Parent: iConexao): iQuerys;
begin
  Result := Self.Create(Parent);
end;

function TModelQuerys.Get(ASql: String): iQuerys;
Begin
  Result := Self;
  try
    with FQry do
      Begin
        Close;
        SQL.Clear;
        SQL.Add(ASql);
        Open;
        FetchAll;
      End;
  Except
    raise Exception.Create('Error Message');
  end;
End;


end.
