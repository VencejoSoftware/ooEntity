unit DataFilterSQL;

interface

uses
  SysUtils,
  ValueSyntax, ValueSyntaxCoalesce,
  DataFilter, DataFilterTemplate, DataFilterSyntax;

type
  IDataFilterSQL = interface
    ['{8D5D29D1-8BE5-4814-8C15-4763105F86AE}']
    function Parse(const DataFilter: IDataFilter): String;
    function ParseList(const DataFilterList: IDataFilterList): String;
  end;

  TDataFilterSQL = class sealed(TInterfacedObject, IDataFilterSQL)
  strict private
    _DataFilterSyntax: IDataFilterSyntax;
  public
    function Parse(const DataFilter: IDataFilter): String;
    function ParseList(const DataFilterList: IDataFilterList): String;
    constructor Create;
    class function New: IDataFilterSQL;
  end;

implementation

function TDataFilterSQL.Parse(const DataFilter: IDataFilter): String;
begin
  Result := _DataFilterSyntax.Parse(DataFilter);
end;

function TDataFilterSQL.ParseList(const DataFilterList: IDataFilterList): String;
var
  DataFilter: IDataFilter;
begin
  Result := EmptyStr;
  for DataFilter in DataFilterList do
    Result := Result + Parse(DataFilter);
end;

constructor TDataFilterSQL.Create;
begin
  _DataFilterSyntax := TDataFilterSyntax.New(TValueSyntaxCoalesce.New, TDataFilterTemplate.New);
end;

class function TDataFilterSQL.New: IDataFilterSQL;
begin
  Result := Create;
end;

end.
