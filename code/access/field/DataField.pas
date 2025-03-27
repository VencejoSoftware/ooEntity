unit DataField;

interface

uses
  SysUtils,
  Field,
  FieldNameFormat,
  IterableList;

type
  TDataFieldKind = (Unknown, Text, Numeric, Float, Date, Time, DateTime, Logic, List, TextList, NumericList, FloatList,
    DateList, TimeList, DateTimeList, LogicList);
  TDataFieldConstraint = (PrimaryKey, ForeignKey, Unique);
  TDataFieldConstraintSet = set of TDataFieldConstraint;

  IDataField = interface(IField)
    ['{5C251238-E374-4FD1-B832-AEDF91863A50}']
    function Kind: TDataFieldKind;
    function Constraints: TDataFieldConstraintSet;
    function IsRequired: Boolean;
  end;

  TDataField = class sealed(TInterfacedObject, IDataField)
  strict private
    _Field: IField;
    _Kind: TDataFieldKind;
    _Constraints: TDataFieldConstraintSet;
    _Required: Boolean;
  public
    function Name: String;
    function Kind: TDataFieldKind;
    function Constraints: TDataFieldConstraintSet;
    function IsRequired: Boolean;
    constructor Create(const Field: IField; const Kind: TDataFieldKind; const Constraints: TDataFieldConstraintSet;
      const Required: Boolean);
    class function New(const Field: IField; const Kind: TDataFieldKind; const Constraints: TDataFieldConstraintSet = [];
      const Required: Boolean = False): IDataField;
  end;

  IDataFieldList = interface(IIterableList<IDataField>)
    ['{D9D96C67-D023-4035-B51F-9C1EB628F2BF}']
    function ItemByName(const Name: String): IDataField;
    function FilterByConstraint(const Constraint: TDataFieldConstraint): IDataFieldList;
    function ToString(const FieldNameFormat: IFieldNameFormat): String;
  end;

  TDataFieldList = class sealed(TIterableList<IDataField>, IDataFieldList)
  public
    function ItemByName(const Name: String): IDataField;
    function FilterByConstraint(const Constraint: TDataFieldConstraint): IDataFieldList;
    function ToString(const FieldNameFormat: IFieldNameFormat): String; reintroduce;
    class function New: IDataFieldList;
  end;

implementation

function TDataField.Name: String;
begin
  Result := _Field.Name;
end;

function TDataField.Kind: TDataFieldKind;
begin
  Result := _Kind;
end;

function TDataField.Constraints: TDataFieldConstraintSet;
begin
  Result := _Constraints;
end;

function TDataField.IsRequired: Boolean;
begin
  Result := _Required;
end;

constructor TDataField.Create(const Field: IField; const Kind: TDataFieldKind;
  const Constraints: TDataFieldConstraintSet; const Required: Boolean);
begin
  _Field := Field;
  _Kind := Kind;
  _Constraints := Constraints;
  _Required := Required;
end;

class function TDataField.New(const Field: IField; const Kind: TDataFieldKind;
  const Constraints: TDataFieldConstraintSet; const Required: Boolean): IDataField;
begin
  Result := Create(Field, Kind, Constraints, Required);
end;

{ TDataFieldList }

function TDataFieldList.FilterByConstraint(const Constraint: TDataFieldConstraint): IDataFieldList;
var
  Item: IDataField;
begin
  Result := TDataFieldList.New;
  for Item in Self do
    if Constraint in Item.Constraints then
      Result.Add(Item);
end;

function TDataFieldList.ToString(const FieldNameFormat: IFieldNameFormat): String;
var
  Item: IDataField;
begin
  Result := EmptyStr;
  for Item in Self do
    if Length(Result) < 1 then
      Result := FieldNameFormat.GetName(Item.Name)
    else
      Result := Result + ',' + FieldNameFormat.GetName(Item.Name);
end;

function TDataFieldList.ItemByName(const Name: String): IDataField;
var
  Item: IDataField;
begin
  Result := nil;
  for Item in Self do
    if SameText(Name, Item.Name) then
      Exit(Item);
end;

class function TDataFieldList.New: IDataFieldList;
begin
  Result := Create;
end;

end.
