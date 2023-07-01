unit DataFieldFactory;

interface

uses
  SysUtils, DB,
  AutoIncrementFactory,
  TextToArray,
  Field, DataField, AutoIncrementDataField;

type
  EDataFieldFactory = class sealed(Exception)
  end;

  IDataFieldFactory = interface
    ['{46073D8B-EE8E-4F09-8AB2-B90A17D09210}']
    function BuildDataField(const Dataset: TDataSet): IDataField;
    function BuildDataFieldList(const Dataset: TDataSet; const AutoIncrementFactory: IAutoIncrementFactory)
      : IDataFieldList;
  end;

  TDataFieldFactory = class sealed(TInterfacedObject, IDataFieldFactory)
  private
    function TextToConstraints(const Text: String): TDataFieldConstraintSet;
  public
    function BuildDataField(const Dataset: TDataSet): IDataField;
    function BuildDataFieldList(const Dataset: TDataSet; const AutoIncrementFactory: IAutoIncrementFactory)
      : IDataFieldList;
    class function New: IDataFieldFactory;
  end;

implementation

function TDataFieldFactory.TextToConstraints(const Text: String): TDataFieldConstraintSet;
var
  TextToArray: ITextToArray;
  ArrayText: TArrayText;
  Item: String;
  Constraint: TDataFieldConstraint;
begin
  Result := [];
  TextToArray := TTextToArray.New;
  ArrayText := TextToArray.Split(Text, ',');
  for Item in ArrayText do
    if Item <> EmptyStr then
    begin
      Constraint := TDataFieldConstraint(StrToInt(Item));
      Include(Result, Constraint);
    end;
end;

function TDataFieldFactory.BuildDataField(const Dataset: TDataSet): IDataField;
var
  Field: IField;
  Kind: TDataFieldKind;
  Constraints: TDataFieldConstraintSet;
  Required: Boolean;
begin
  Field := TField.New(Dataset.FieldByName('FIELD_NAME').AsString);
  Kind := TDataFieldKind(Dataset.FieldByName('FIELD_DATA_TYPE').AsInteger);
  Constraints := TextToConstraints(Dataset.FieldByName('FIELD_CONSTRAINT').AsString);
  Required := Dataset.FieldByName('FIELD_REQUIRED').AsInteger <> 0;
  Result := TDataField.New(Field, Kind, Constraints, Required);
end;

function TDataFieldFactory.BuildDataFieldList(const Dataset: TDataSet;
  const AutoIncrementFactory: IAutoIncrementFactory): IDataFieldList;
var
  DataField: IDataField;
begin
  Result := TDataFieldList.New;
  Dataset.DisableControls;
  try
    Dataset.First;
    while not Dataset.Eof do
    begin
      DataField := BuildDataField(Dataset);
      if Assigned(AutoIncrementFactory) then
        Result.Add(TAutoIncrementDataField.New(DataField, AutoIncrementFactory))
      else
        Result.Add(DataField);
      Dataset.Next;
    end;
  finally
    Dataset.EnableControls;
  end;
end;

class function TDataFieldFactory.New: IDataFieldFactory;
begin
  Result := TDataFieldFactory.Create;
end;

end.
