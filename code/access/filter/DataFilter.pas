unit DataFilter;

interface

uses
  SysUtils,
  Value, ValueList,
  DataField,
  IterableList;

type
  TDataFilterJoinMode = (None_, And_, Or_, AndNot_, OrNot_);
  TDataFilterCompareOperator = (IsNull_, IsNotNull_, Like_, Between_, In_, Equal_, NotEqual_, Greater_, Lesser_,
    GreaterOrEqual_, LesserOrEqual_, Template_);

  IDataFilter = interface
    ['{EA534227-F299-4F3A-9C48-CCA47CBE6894}']
    function JoinMode: TDataFilterJoinMode;
    function DataField: IDataField;
    function ValueList: IValueList;
    function CompareOperator: TDataFilterCompareOperator;
  end;

  TDataFilter = class sealed(TInterfacedObject, IDataFilter)
  strict private
    _JoinMode: TDataFilterJoinMode;
    _DataField: IDataField;
    _ValueList: IValueList;
    _CompareOperator: TDataFilterCompareOperator;
  public
    function JoinMode: TDataFilterJoinMode;
    function DataField: IDataField;
    function ValueList: IValueList;
    function CompareOperator: TDataFilterCompareOperator;
    constructor Create(const JoinMode: TDataFilterJoinMode; const DataField: IDataField; const ValueList: IValueList;
      const CompareOperator: TDataFilterCompareOperator);
    class function New(const JoinMode: TDataFilterJoinMode; const DataField: IDataField; const ValueList: IValueList;
      const CompareOperator: TDataFilterCompareOperator): IDataFilter;
    class function NewByValue(const JoinMode: TDataFilterJoinMode; const DataField: IDataField;
      const Values: array of TVarRec; const CompareOperator: TDataFilterCompareOperator): IDataFilter;
  end;

  IDataFilterList = interface(IIterableList<IDataFilter>)
    ['{1A314F3F-2DE1-4D7D-BF2E-362DD05BD3E0}']
    function ItemByFieldName(const Name: String): IDataFilter;
  end;

  TDataFilterList = class sealed(TIterableList<IDataFilter>, IDataFilterList)
  public
    function ItemByFieldName(const Name: String): IDataFilter;
    class function New: IDataFilterList;
  end;

implementation

function TDataFilter.JoinMode: TDataFilterJoinMode;
begin
  Result := _JoinMode;
end;

function TDataFilter.DataField: IDataField;
begin
  Result := _DataField;
end;

function TDataFilter.ValueList: IValueList;
begin
  Result := _ValueList;
end;

function TDataFilter.CompareOperator: TDataFilterCompareOperator;
begin
  Result := _CompareOperator;
end;

constructor TDataFilter.Create(const JoinMode: TDataFilterJoinMode; const DataField: IDataField;
  const ValueList: IValueList; const CompareOperator: TDataFilterCompareOperator);
begin
  _JoinMode := JoinMode;
  _DataField := DataField;
  _ValueList := ValueList;
  _CompareOperator := CompareOperator;
end;

class function TDataFilter.New(const JoinMode: TDataFilterJoinMode; const DataField: IDataField;
  const ValueList: IValueList; const CompareOperator: TDataFilterCompareOperator): IDataFilter;
begin
  Result := TDataFilter.Create(JoinMode, DataField, ValueList, CompareOperator);
end;

class function TDataFilter.NewByValue(const JoinMode: TDataFilterJoinMode; const DataField: IDataField;
  const Values: array of TVarRec; const CompareOperator: TDataFilterCompareOperator): IDataFilter;
begin
  Result := TDataFilter.Create(JoinMode, DataField, TValueList.NewByArray(Values), CompareOperator);
end;

{ TDataFilterList }

function TDataFilterList.ItemByFieldName(const Name: String): IDataFilter;
var
  Item: IDataFilter;
begin
  Result := nil;
  for Item in Self do
    if SameText(Name, Item.DataField.Name) then
      Exit(Item);
end;

class function TDataFilterList.New: IDataFilterList;
begin
  Result := TDataFilterList.Create;
end;

end.
