unit Models.Conexao;

interface

uses
  System.SysUtils, System.Classes, System.JSON,

  // Units Firedac
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, Filectrl,
  FireDAC.Phys.SQLiteWrapper.Stat, Convert4Delphi, FireDAC.Comp.BatchMove.SQL,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet, FireDAC.Comp.UI, System.UITypes,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.PGDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.PG, FireDAC.Phys.MySQL, FireDAC.Stan.StorageBin,

  // Unist Sistema
  Controllers.Interfaces, Models.Params;

Type

  TModelConexao = class(TInterfacedObject, iConexao)

    private
      FConexao            : TFDConnection;
      FDPhysPgDriverLink  : TFDPhysPgDriverLink;
    public
      constructor Create(ADriverID: String);
      destructor Destroy; override;
      class function New(ADriverID: String): iConexao;

      function Conexao : TCustomConnection;
      function TesteConexaoBanco: Boolean;

  end;

implementation

{ TModelConexao }

uses Vcl.Forms;

function TModelConexao.Conexao: TCustomConnection;
begin
  Result := FConexao;
end;

constructor TModelConexao.Create(ADriverID: String);
Var
  CaminhoDll : String;
begin
  FConexao  := TFDConnection.Create(nil);
  FConexao.ResourceOptions.SilentMode := true;

  with FConexao do
    Begin
      Connected                     := false;

      if ADriverID = 'MSSQL' then
        DMParams.GetParamsMSSQL;

      Params.Values['DriverID']     := ADriverID;
      Params.Values['Database']     := DMParams.Database;
      Params.Values['Password']     := DMParams.Password;
      Params.Values['Port']         := DMParams.Port;
      Params.Values['User_Name']    := DMParams.UserName;
      Params.Values['Server']       := DMParams.Server;
    End;


  {$IFDEF WIN32}
    CaminhoDll := DMParams.DllConexao32x;
  {$ENDIF$}

  {$IFDEF WIN64}
    CaminhoDll := FParent.DllConexao64x;
  {$ENDIF}

  FDPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);
  FDPhysPgDriverLink.VendorLib      := CaminhoDll;

  FConexao.Connected := true;
end;

destructor TModelConexao.Destroy;
begin
  FreeAndNil(FDPhysPgDriverLink);
  FreeAndNil(FConexao);
  inherited;
end;

class function TModelConexao.New(ADriverID: String): iConexao;
begin
  Result := Self.Create(ADriverID);
end;

function TModelConexao.TesteConexaoBanco:Boolean;
BEgin
  if FConexao.Connected then
    Result := true
  else
    Result := false;
End;

end.
