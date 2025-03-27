unit SQLTableCommandFactory;

interface

uses
  SysUtils,
  DataField,
  SQLTableCommand,
  SQLParser;

type
  ISQLTableCommandFactory = interface
    ['{D17A7CB3-2073-433D-B4FD-336B3278BBAD}']
    function BuildList(const DataObjectName: String; const DataFieldList: IDataFieldList): ISQLTableCommandList;
  end;

  TSQLTableCommandFactory = class sealed(TInterfacedObject, ISQLTableCommandFactory)
  strict private
  type
    TBuildFunction = function(const SQLParser: ISQLParser; const DataObjectName: String;
      const DataFieldList: IDataFieldList): String;
  strict private
    _SQLParser: ISQLParser;
  public
    function BuildList(const DataObjectName: String; const DataFieldList: IDataFieldList): ISQLTableCommandList;
    constructor Create;
    class function New: ISQLTableCommandFactory;
  end;

implementation

function BuildNavigate(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_NAVIGATION = 'SELECT FIRST 1 0 AS ENABLED FROM {{ObjectName}} WHERE {{Kind=Where,Conditional=<}} ' + 'UNION ALL '
    + 'SELECT FIRST 1 1 AS ENABLED FROM {{ObjectName}} WHERE {{Kind=Where,Conditional=>}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_NAVIGATION, DataObjectName, DataFieldList);
end;

function BuildFirst(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_FIRST = 'SELECT FIRST 1 {{Fields}} FROM {{ObjectName}} ORDER BY {{Kind=OrderBy,Sort=ASC}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_FIRST, DataObjectName, DataFieldList);
end;

function BuildPrevious(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_PREVIOUS =
    'SELECT FIRST 1 {{Fields}} FROM {{ObjectName}} WHERE {{Kind=Where,Conditional=<}} ORDER BY {{Kind=OrderBy,Sort=DESC}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_PREVIOUS, DataObjectName, DataFieldList);
end;

function BuildNext(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_NEXT =
    'SELECT FIRST 1 {{Fields}} FROM {{ObjectName}} WHERE {{Kind=Where,Conditional=>}} ORDER BY {{Kind=OrderBy,Sort=ASC}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_NEXT, DataObjectName, DataFieldList);
end;

function BuildLast(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_LAST = 'SELECT FIRST 1 {{Fields}} FROM {{ObjectName}} ORDER BY {{Kind=OrderBy,Sort=DESC}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_LAST, DataObjectName, DataFieldList);
end;

function BuildExists(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_EXISTS = 'SELECT FIRST 1 1 FROM {{ObjectName}} WHERE {{Kind=Where,Conditional==,NullableConditional=IS NULL}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_EXISTS, DataObjectName, DataFieldList);
end;

function BuildCreate(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_INSERT = 'INSERT INTO {{ObjectName}}({{Fields}})VALUES({{ParametrizedFields}}) RETURNING {{PKFields}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_INSERT, DataObjectName, DataFieldList);
end;

function BuildRead(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_SELECT = 'SELECT {{Fields}} FROM {{ObjectName}} WHERE {{Kind=Where,Conditional==}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_SELECT, DataObjectName, DataFieldList);
end;

function BuildUpdate(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_UPDATE = 'UPDATE {{ObjectName}} SET {{FieldParameters}} WHERE {{Kind=Where,Conditional==}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_UPDATE, DataObjectName, DataFieldList);
end;

function BuildPrepare(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_PREPARE = 'SELECT FIRST 0 {{Fields}} FROM {{ObjectName}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_PREPARE, DataObjectName, DataFieldList);
end;

function BuildDelete(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_DELETE = 'DELETE FROM {{ObjectName}} WHERE {{Kind=Where,Conditional==}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_DELETE, DataObjectName, DataFieldList);
end;

function BuildCreateOrUpdate(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_DELETE = 'DELETE FROM {{ObjectName}} WHERE {{Kind=Where,Conditional==}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_DELETE, DataObjectName, DataFieldList);
end;

function BuildReadList(const SQLParser: ISQLParser; const DataObjectName: String;
  const DataFieldList: IDataFieldList): String;
const
  SQL_SELECT = 'SELECT {{Fields}} FROM {{ObjectName}} ORDER BY {{Kind=OrderBy,Sort=ASC}}';
begin
  Result := SQLParser.ResolveSyntax(SQL_SELECT, DataObjectName, DataFieldList);
end;

function TSQLTableCommandFactory.BuildList(const DataObjectName: String; const DataFieldList: IDataFieldList)
  : ISQLTableCommandList;
const
  BUILD_FUNCTIONS: array [TSQLTableCommandKind] of TBuildFunction = (BuildExists, BuildCreate, BuildRead, BuildUpdate,
    BuildDelete, BuildCreateOrUpdate, BuildReadList, BuildPrepare, BuildNavigate, BuildFirst, BuildPrevious, BuildNext,
    BuildLast);
var
  Kind: TSQLTableCommandKind;
begin
  Result := TSQLTableCommandList.New;
  for Kind := Low(TSQLTableCommandKind) to High(TSQLTableCommandKind) do
    Result.Add(TSQLTableCommand.New(Kind, BUILD_FUNCTIONS[Kind](_SQLParser, DataObjectName, DataFieldList)));
end;

constructor TSQLTableCommandFactory.Create;
begin
  _SQLParser := TSQLParser.New;
end;

class function TSQLTableCommandFactory.New: ISQLTableCommandFactory;
begin
  Result := Create;
end;

end.
