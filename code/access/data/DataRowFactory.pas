unit DataRowFactory;

interface

uses
  SysUtils,
  DB,
  Field, DataField, Value, DataValue,
  DataRow;

type
  IDataRowFactory = interface
    ['{319B6C99-530F-49B9-A897-01135126EA54}']
    function BuildByDataset(const Dataset: TDataset): IDataRow;
    function BuildListByDataset(const Dataset: TDataset): IDataRowList;
  end;

  TDataRowFactory = class sealed(TInterfacedObject, IDataRowFactory)
  private
    function FieldTypeToDataKind(const FieldType: TFieldType): TDataFieldKind;
    function BuildDataValue(const DataField: IDataField; const Field: DB.TField): IDataValue;
  public
    function BuildByDataset(const Dataset: TDataset): IDataRow;
    function BuildListByDataset(const Dataset: TDataset): IDataRowList;
    class function New: IDataRowFactory;
  end;

implementation

function TDataRowFactory.FieldTypeToDataKind(const FieldType: TFieldType): TDataFieldKind;
begin
  case FieldType of
    ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftFixedWideChar, ftWideMemo:
      Result := DataField.Text;
    ftSmallint, ftInteger, ftWord, ftLargeint, ftBytes:
      Result := DataField.Numeric;
    ftBoolean:
      Result := DataField.Logic;
    ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended:
      Result := DataField.Float;
    ftDate:
      Result := DataField.Date;
    ftTime:
      Result := DataField.Time;
    ftDateTime, ftTimeStamp:
      Result := DataField.DateTime;
  else
    Result := DataField.Unknown;
  end;
end;

function TDataRowFactory.BuildDataValue(const DataField: IDataField; const Field: DB.TField): IDataValue;
var
  Value: IValue;
begin
  if Field.IsNull then
    Value := nil
  else
    case DataField.Kind of
      Text:
        Value := TValue.NewByString(Field.AsString);
      Numeric:
        Value := TValue.NewByInt(Field.AsInteger);
      Float:
        Value := TValue.NewByFloat(Field.AsExtended);
      Date, Time, DateTime:
        Value := TValue.NewByFloat(Field.AsDateTime);
      Logic:
        Value := TValue.NewByBoolean(Field.AsInteger <> 0);
    else
      Value := TValue.NewByVariant(Field.AsVariant);
    end;
  Result := TDataValue.New(DataField, Value);
end;

function TDataRowFactory.BuildByDataset(const Dataset: TDataset): IDataRow;
var
  i: Word;
  DataField: IDataField;
  DataValueList: IDataValueList;
begin
  DataValueList := TDataValueList.New;
  if not Dataset.IsEmpty then
    for i := 0 to Pred(Dataset.Fields.Count) do
    begin
      DataField := TDataField.New(TField.New(Dataset.Fields[i].FieldName),
        FieldTypeToDataKind(Dataset.Fields[i].DataType), [], False);
      DataValueList.Add(BuildDataValue(DataField, Dataset.Fields[i]));
    end;
  Result := TDataRow.New(DataValueList);
end;

function TDataRowFactory.BuildListByDataset(const Dataset: TDataset): IDataRowList;
var
  BookMark: TBookmark;
  i: Word;
  DataFieldList: IDataFieldList;
  DataValueList: IDataValueList;
begin
  Result := TDataRowList.New;
  if not Dataset.IsEmpty then
  begin
    DataFieldList := TDataFieldList.New;
    for i := 0 to Pred(Dataset.Fields.Count) do
      DataFieldList.Add(TDataField.New(TField.New(Dataset.Fields[i].FieldName),
        FieldTypeToDataKind(Dataset.Fields[i].DataType), [], False));
    Dataset.DisableControls;
    try
      BookMark := Dataset.GetBookmark;
      try
        Dataset.First;
        while not Dataset.Eof do
        begin
          DataValueList := TDataValueList.New;
          for i := 0 to Pred(Dataset.Fields.Count) do
            DataValueList.Add(BuildDataValue(DataFieldList.ItemByIndex(i), Dataset.Fields[i]));
          Result.Add(TDataRow.New(DataValueList));
          Dataset.Next;
        end;
      finally
        if Dataset.BookmarkValid(BookMark) then
          Dataset.GotoBookmark(BookMark);
        Dataset.FreeBookmark(BookMark);
      end;
    finally
      Dataset.EnableControls;
    end;
  end;
end;

class function TDataRowFactory.New: IDataRowFactory;
begin
  Result := TDataRowFactory.Create;
end;

end.
