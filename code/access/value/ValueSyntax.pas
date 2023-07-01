unit ValueSyntax;

interface

uses
  SysUtils,
  IterableList,
  Token,
  Value,
  ValueFormat,
  DataField, AutoIncrementDataField;

type
  IValueFormatDataKindLink = interface
    ['{6BB45BF2-1F44-47E7-8950-5379D582F79B}']
    function DataFieldKind: TDataFieldKind;
    function ValueFormat: IValueFormat;
  end;

  TValueFormatDataKindLink = class sealed(TInterfacedObject, IValueFormatDataKindLink)
  strict private
    _DataFieldKind: TDataFieldKind;
    _ValueFormat: IValueFormat;
  public
    function DataFieldKind: TDataFieldKind;
    function ValueFormat: IValueFormat;
    constructor Create(const DataFieldKind: TDataFieldKind; const ValueFormat: IValueFormat);
    class function New(const DataFieldKind: TDataFieldKind; const ValueFormat: IValueFormat): IValueFormatDataKindLink;
  end;

  IValueFormatDataKindLinkList = interface(IIterableList<IValueFormatDataKindLink>)
    ['{843434DD-9CD9-4CC9-B9A5-C929BDC48CC0}']
    function ItemByDataKind(const DataFieldKind: TDataFieldKind): IValueFormat;
  end;

  TValueFormatDataKindLinkList = class sealed(TIterableList<IValueFormatDataKindLink>, IValueFormatDataKindLinkList)
  public
    function ItemByDataKind(const DataFieldKind: TDataFieldKind): IValueFormat;
    class function NewFromDefaults: IValueFormatDataKindLinkList;
    class function New: IValueFormatDataKindLinkList;
  end;

  IValueSyntax = interface
    ['{0A838B48-F066-4839-A281-E3BD4C93D26A}']
    function Parse(const DataField: IDataField; const Value: IValue): string;
  end;

  TValueSyntax = class sealed(TInterfacedObject, IValueSyntax)
  strict private
    _ValueFormatDataKindLinkList: IValueFormatDataKindLinkList;
  public
    function Parse(const DataField: IDataField; const Value: IValue): string;
    constructor Create(const ValueFormatDataKindLinkList: IValueFormatDataKindLinkList);
    class function New(const ValueFormatDataKindLinkList: IValueFormatDataKindLinkList = nil): IValueSyntax;
  end;

implementation

{ TValueFormatDataKindLink }

function TValueFormatDataKindLink.DataFieldKind: TDataFieldKind;
begin
  Result := _DataFieldKind;
end;

function TValueFormatDataKindLink.ValueFormat: IValueFormat;
begin
  Result := _ValueFormat;
end;

constructor TValueFormatDataKindLink.Create(const DataFieldKind: TDataFieldKind; const ValueFormat: IValueFormat);
begin
  _DataFieldKind := DataFieldKind;
  _ValueFormat := ValueFormat;
end;

class function TValueFormatDataKindLink.New(const DataFieldKind: TDataFieldKind; const ValueFormat: IValueFormat)
  : IValueFormatDataKindLink;
begin
  Result := TValueFormatDataKindLink.Create(DataFieldKind, ValueFormat);
end;

{ TValueFormatDataKindLinkList }

function TValueFormatDataKindLinkList.ItemByDataKind(const DataFieldKind: TDataFieldKind): IValueFormat;
var
  Item: IValueFormatDataKindLink;
begin
  Result := nil;
  for Item in Self do
    if Item.DataFieldKind = DataFieldKind then
      Exit(Item.ValueFormat);
end;

class function TValueFormatDataKindLinkList.New: IValueFormatDataKindLinkList;
begin
  Result := TValueFormatDataKindLinkList.Create;
end;

class function TValueFormatDataKindLinkList.NewFromDefaults: IValueFormatDataKindLinkList;
begin
  Result := TValueFormatDataKindLinkList.New;
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Unknown, TUnknownValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Text, TTextValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Numeric, TNumericValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Float, TFloatValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Date, TDateValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Time, TTimeValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.DateTime, TDateTimeValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.Logic, TLogicValueFormat.New));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.List, TListValueFormat.New(nil)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.TextList, TListValueFormat.New(TTextValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.NumericList, TListValueFormat.New(TNumericValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.FloatList, TListValueFormat.New(TFloatValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.DateList, TListValueFormat.New(TDateValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.TimeList, TListValueFormat.New(TTimeValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.DateTimeList, TListValueFormat.New(TDateTimeValueFormat.New)));
  Result.Add(TValueFormatDataKindLink.New(TDataFieldKind.LogicList, TListValueFormat.New(TLogicValueFormat.New)));
end;

{ TValueSyntax }

function TValueSyntax.Parse(const DataField: IDataField; const Value: IValue): string;
var
  ValueFormat: IValueFormat;
begin
  if not Assigned(DataField) or not Assigned(Value) then
    if Supports(DataField, IAutoIncrementDataField) then
      Result := IntToStr((DataField as IAutoIncrementDataField).AutoIncrementFactory.Next)
    else
      Result := 'NULL'
  else
  begin
    if TToken.IsToken(Value.ToString) then
      Result := Value.ToString
    else
    begin
      ValueFormat := _ValueFormatDataKindLinkList.ItemByDataKind(DataField.Kind);
      Result := ValueFormat.Parse(Value);
    end;
  end;
end;

constructor TValueSyntax.Create(const ValueFormatDataKindLinkList: IValueFormatDataKindLinkList);
begin
  if not Assigned(ValueFormatDataKindLinkList) then
    _ValueFormatDataKindLinkList := TValueFormatDataKindLinkList.NewFromDefaults
  else
    _ValueFormatDataKindLinkList := ValueFormatDataKindLinkList;
end;

class function TValueSyntax.New(const ValueFormatDataKindLinkList: IValueFormatDataKindLinkList): IValueSyntax;
begin
  Result := TValueSyntax.Create(ValueFormatDataKindLinkList);
end;

end.
