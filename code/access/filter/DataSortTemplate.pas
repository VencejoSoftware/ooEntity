unit DataSortTemplate;

interface

uses
  SysUtils,
  CalculatedDataField,
  DataSort;

type
  IDataSortTemplate = interface
    ['{0F47A573-A10A-481D-BF9F-C0B0F061532E}']
    function Template(const DataSort: IDataSort): String;
  end;

  TDataSortTemplate = class sealed(TInterfacedObject, IDataSortTemplate)
  public
    function Template(const DataSort: IDataSort): String;
    class function New: IDataSortTemplate;
  end;

implementation

function TDataSortTemplate.Template(const DataSort: IDataSort): String;
begin
  case DataSort.Order of
    Ascending:
      Result := '%s ASC';
    Descending:
      Result := '%s DESC';
  Else
    Result := '%s';
  end;
end;

class function TDataSortTemplate.New: IDataSortTemplate;
begin
  Result := TDataSortTemplate.Create;
end;

end.
