unit SQLTable;

interface

uses
  DataField,
  SQLTableCommand;

type
  ISQLTable = interface
    ['{AB1D8CE0-F47A-4C7E-A6CC-70D0C5F6B7A8}']
    function Name: String;
    function Fields: IDataFieldList;
    function Commands: ISQLTableCommandList;
  end;

  TSQLTable = class sealed(TInterfacedObject, ISQLTable)
  strict private
    _Name: String;
    _Fields: IDataFieldList;
    _Commands: ISQLTableCommandList;
  public
    function Name: String;
    function Fields: IDataFieldList;
    function Commands: ISQLTableCommandList;
    constructor Create(const Name: String; const Fields: IDataFieldList; const Commands: ISQLTableCommandList);
    class function New(const Name: String; const Fields: IDataFieldList; const Commands: ISQLTableCommandList)
      : ISQLTable;
  end;

implementation

function TSQLTable.Name: String;
begin
  Result := _Name;
end;

function TSQLTable.Fields: IDataFieldList;
begin
  Result := _Fields;
end;

function TSQLTable.Commands: ISQLTableCommandList;
begin
  Result := _Commands;
end;

constructor TSQLTable.Create(const Name: String; const Fields: IDataFieldList; const Commands: ISQLTableCommandList);
begin
  _Name := Name;
  _Fields := Fields;
  _Commands := Commands;
end;

class function TSQLTable.New(const Name: String; const Fields: IDataFieldList; const Commands: ISQLTableCommandList)
  : ISQLTable;
begin
  Result := TSQLTable.Create(Name, Fields, Commands);
end;

end.
