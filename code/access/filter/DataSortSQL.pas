unit DataSortSQL;

interface

uses
  SysUtils,
  DataSort, DataSortTemplate, DataSortSyntax;

type
  IDataSortSQL = interface
    ['{524A50E3-13BC-4709-BFA4-429F453427FE}']
    function Parse(const DataSort: IDataSort): String;
    function ParseList(const DataSortList: IDataSortList): String;
  end;

  TDataSortSQL = class sealed(TInterfacedObject, IDataSortSQL)
  strict private
    _DataSortSyntax: IDataSortSyntax;
  public
    function Parse(const DataSort: IDataSort): String;
    function ParseList(const DataSortList: IDataSortList): String;
    constructor Create;
    class function New: IDataSortSQL;
  end;

implementation

function TDataSortSQL.Parse(const DataSort: IDataSort): String;
begin
  Result := _DataSortSyntax.Parse(DataSort);
end;

function TDataSortSQL.ParseList(const DataSortList: IDataSortList): String;
const
  SEPARATOR = ',';
var
  DataSort: IDataSort;
begin
  Result := EmptyStr;
  for DataSort in DataSortList do
  begin
    if Result <> EmptyStr then
      Result := Result + SEPARATOR;
    Result := Result + Parse(DataSort);
  end;
end;

constructor TDataSortSQL.Create;
begin
  _DataSortSyntax := TDataSortSyntax.New(TDataSortTemplate.New);
end;

class function TDataSortSQL.New: IDataSortSQL;
begin
  Result := Create;
end;

end.
