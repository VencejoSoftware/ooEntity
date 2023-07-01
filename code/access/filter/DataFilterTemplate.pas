unit DataFilterTemplate;

interface

uses
  SysUtils,
  CalculatedDataField,
  DataFilter;

type
  IDataFilterTemplate = interface
    ['{D89E459E-7396-4048-B26B-ECE0B8D0C525}']
    function Template(const DataFilter: IDataFilter): String;
  end;

  TDataFilterTemplate = class sealed(TInterfacedObject, IDataFilterTemplate)
  public
    function Template(const DataFilter: IDataFilter): String;
    class function New: IDataFilterTemplate;
  end;

implementation

function TDataFilterTemplate.Template(const DataFilter: IDataFilter): String;
begin
  case DataFilter.CompareOperator of
    IsNull_:
      Result := '%s IS NULL';
    IsNotNull_:
      Result := '%s IS NOT NULL';
    In_:
      Result := '%s IN (%s)';
    Like_:
      Result := 'UPPER(%s) LIKE UPPER(%s)';
    Between_:
      Result := '%s BETWEEN %s AND %s';
    Equal_:
      Result := '%s=%s';
    NotEqual_:
      Result := '%s<>%s';
    Greater_:
      Result := '%s>%s';
    Lesser_:
      Result := '%s<%s';
    GreaterOrEqual_:
      Result := '%s>=%s';
    LesserOrEqual_:
      Result := '%s<=%s';
    Template_:
      if Supports(DataFilter.DataField, ICalculatedDataField) then
        Result := ICalculatedDataField(DataFilter.DataField).Code
      else
        raise Exception.Create('Template operator needs a ICalculatedDataField');
  end;
end;

class function TDataFilterTemplate.New: IDataFilterTemplate;
begin
  Result := TDataFilterTemplate.Create;
end;

end.
