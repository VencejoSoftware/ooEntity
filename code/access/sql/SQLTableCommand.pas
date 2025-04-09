unit SQLTableCommand;

interface

uses
  SysUtils,
  IterableList;

type
  TSQLTableCommandKind = (Exists, Create, Read, Update, Delete, CreateOrUpdate, ReadList, Prepare, Navigate, First,
    Previous, Next, Last);

  ISQLTableCommand = interface
    ['{B01EB6E9-722A-4FA8-B018-12A4E3B60BD4}']
    function Kind: TSQLTableCommandKind;
    function SQL: String;
  end;

  TSQLTableCommand = class sealed(TInterfacedObject, ISQLTableCommand)
  strict private
    _Kind: TSQLTableCommandKind;
    _SQL: String;
  public
    function Kind: TSQLTableCommandKind;
    function SQL: String;
    constructor Create(const Kind: TSQLTableCommandKind; const SQL: String);
    class function New(const Kind: TSQLTableCommandKind; const SQL: String): ISQLTableCommand;
  end;

  ISQLTableCommandList = interface(IIterableList<ISQLTableCommand>)
    ['{E79CCD84-77A9-4DB3-99A5-4F833C145232}']
    function ItemByKind(const Kind: TSQLTableCommandKind): ISQLTableCommand;
  end;

  TSQLTableCommandList = class sealed(TIterableList<ISQLTableCommand>, ISQLTableCommandList)
  public
    function ItemByKind(const Kind: TSQLTableCommandKind): ISQLTableCommand;
    class function New: ISQLTableCommandList;
  end;

implementation

function TSQLTableCommand.Kind: TSQLTableCommandKind;
begin
  Result := _Kind;
end;

function TSQLTableCommand.SQL: String;
begin
  Result := _SQL;
end;

constructor TSQLTableCommand.Create(const Kind: TSQLTableCommandKind; const SQL: String);
begin
  _Kind := Kind;
  _SQL := SQL;
end;

class function TSQLTableCommand.New(const Kind: TSQLTableCommandKind; const SQL: String): ISQLTableCommand;
begin
  Result := TSQLTableCommand.Create(Kind, SQL);
end;

{ TSQLTableCommandList }

function TSQLTableCommandList.ItemByKind(const Kind: TSQLTableCommandKind): ISQLTableCommand;
var
  Item: ISQLTableCommand;
begin
  Result := nil;
  for Item in Self do
    if Item.Kind = Kind then
      Exit(Item);
end;

class function TSQLTableCommandList.New: ISQLTableCommandList;
begin
  Result := Create;
end;

end.
