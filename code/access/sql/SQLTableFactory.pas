unit SQLTableFactory;

interface

uses
  DB,
  DataField, DataFieldService,
  SQLTableCommand, SQLTableCommandFactory,
  SQLTable;

type
  ISQLTableFactory = interface
    ['{A8B4166D-9233-450D-BAB5-BECD9AE3879A}']
    function Build(const DataObjectName: String): ISQLTable;
  end;

  TSQLTableFactory = class sealed(TInterfacedObject, ISQLTableFactory)
  strict private
    _DataFieldService: IDataFieldService;
    _SQLTableCommandFactory: ISQLTableCommandFactory;
  public
    function Build(const DataObjectName: String): ISQLTable;
    constructor Create(const DataFieldService: IDataFieldService);
    class function New(const DataFieldService: IDataFieldService): ISQLTableFactory;
  end;

implementation

function TSQLTableFactory.Build(const DataObjectName: String): ISQLTable;
var
  DataFieldList: IDataFieldList;
  SQLList: ISQLTableCommandList;
begin
  DataFieldList := _DataFieldService.GetFields(DataObjectName);
  SQLList := _SQLTableCommandFactory.BuildList(DataObjectName, DataFieldList);
  Result := TSQLTable.New(DataObjectName, DataFieldList, SQLList);
end;

constructor TSQLTableFactory.Create(const DataFieldService: IDataFieldService);
begin
  _DataFieldService := DataFieldService;
  _SQLTableCommandFactory := TSQLTableCommandFactory.New;
end;

class function TSQLTableFactory.New(const DataFieldService: IDataFieldService): ISQLTableFactory;
begin
  Result := Create(DataFieldService);
end;

end.
