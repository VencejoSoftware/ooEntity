unit DataFilterSyntax;

interface

uses
  SysUtils,
  Value, ValueList, ValueSyntax,
  DataField, CalculatedDataField,
  DataFilter, DataFilterTemplate;

type
  TFormatValues = array of TVarRec;

  IDataFilterSyntax = interface
    ['{EEDE65E5-581B-4D88-B0F2-E56B52553A31}']
    function Parse(const DataFilter: IDataFilter): string;
  end;

  TDataFilterSyntax = class sealed(TInterfacedObject, IDataFilterSyntax)
  strict private
    _ValueSyntax: IValueSyntax;
    _DataFilterTemplate: IDataFilterTemplate;
  private
    function ParseJoinMode(const JoinMode: TDataFilterJoinMode): string;
    function BuildValueList(const DataField: IDataField; const ValueList: IValueList): string;
    function BuildValueArray(const DataField: IDataField; const ValueList: IValueList): TFormatValues;
  public
    function Parse(const DataFilter: IDataFilter): string;
    constructor Create(const ValueSyntax: IValueSyntax; const DataFilterTemplate: IDataFilterTemplate);
    class function New(const ValueSyntax: IValueSyntax; const DataFilterTemplate: IDataFilterTemplate)
      : IDataFilterSyntax;
  end;

implementation

function TDataFilterSyntax.ParseJoinMode(const JoinMode: TDataFilterJoinMode): string;
begin
  case JoinMode of
    None_:
      Result := EmptyStr;
    And_:
      Result := ' AND ';
    Or_:
      Result := ' OR ';
    AndNot_:
      Result := ' AND NOT ';
    OrNot_:
      Result := ' OR NOT ';
  end;
end;

function TDataFilterSyntax.BuildValueList(const DataField: IDataField; const ValueList: IValueList): string;
var
  Value: IValue;
begin
  Result := EmptyStr;
  for Value in ValueList do
    Result := Result + _ValueSyntax.Parse(DataField, Value) + ',';
  if Length(Result) > 0 then
    Result := Copy(Result, 1, Pred(Length(Result)));
end;

function TDataFilterSyntax.BuildValueArray(const DataField: IDataField; const ValueList: IValueList): TFormatValues;
var
  Value: IValue;
  Index: smallint;
begin
  Index := 0;
  if (Length(DataField.Name) > 0) and not Supports(DataField, ICalculatedDataField) then
  begin
    SetLength(Result, Succ(Index));
    Result[Index].VType := vtWideString;
    Result[Index].VWideString := nil;
    WideString(Result[Index].VWideString) := WideString(DataField.Name);
    Inc(Index);
  end;
  SetLength(Result, Length(Result) + NativeInt(ValueList.Count));
  for Value in ValueList do
  begin
    Result[Index].VType := vtWideString;
    Result[Index].VWideString := nil;
    WideString(Result[Index].VWideString) := WideString(_ValueSyntax.Parse(DataField, Value));
    Inc(Index);
  end;
end;

function TDataFilterSyntax.Parse(const DataFilter: IDataFilter): string;
var
  Template: string;
begin
  Result := ParseJoinMode(DataFilter.JoinMode);
  Template := _DataFilterTemplate.Template(DataFilter);
  if DataFilter.CompareOperator in [IsNull_, IsNotNull_] then
    Result := Result + Format(Template, [DataFilter.DataField.Name])
  else if DataFilter.CompareOperator = In_ then
    Result := Result + Format(Template, [DataFilter.DataField.Name, BuildValueList(DataFilter.DataField,
      DataFilter.ValueList)])
  else
    Result := Result + Format(Template, BuildValueArray(DataFilter.DataField, DataFilter.ValueList));
end;

constructor TDataFilterSyntax.Create(const ValueSyntax: IValueSyntax; const DataFilterTemplate: IDataFilterTemplate);
begin
  _ValueSyntax := ValueSyntax;
  _DataFilterTemplate := DataFilterTemplate;
end;

class function TDataFilterSyntax.New(const ValueSyntax: IValueSyntax; const DataFilterTemplate: IDataFilterTemplate)
  : IDataFilterSyntax;
begin
  Result := Create(ValueSyntax, DataFilterTemplate);
end;

end.
