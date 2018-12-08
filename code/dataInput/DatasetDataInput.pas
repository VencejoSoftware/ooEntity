{$REGION 'documentation'}
{
  Copyright (c) 2018, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Data input deserializer based on dataset
  @created(15/11/2018)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit DatasetDataInput;

interface

uses
  SysUtils,
  DB,
  Key,
  DataInput;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IDataInput))
  Use dataset as data input
  @member(ExistKey @seealso(IDataInput.ExistKey))
  @member(IsNull @seealso(IDataInput.IsNull))
  @member(ReadInteger @seealso(IDataInput.ReadInteger))
  @member(ReadBoolean @seealso(IDataInput.ReadBoolean))
  @member(ReadFloat @seealso(IDataInput.ReadFloat))
  @member(ReadString @seealso(IDataInput.ReadString))
  @member(ReadDateTime @seealso(IDataInput.ReadDateTime))
  @member(ReadChar @seealso(IDataInput.ReadChar))
  @member(EnterSection @seealso(IDataInput.EnterSection))
  @member(ExitSection @seealso(IDataInput.ExitSection))
  @member(
    FieldByKey Find field in dataset by key
    @parm(Key @link(ITextKey Key) to find)
    @returns(TField object or exception)
  )
  @member(
    Create Object constructor
    @param(Dataset TDataset object)
  )
  @member(Destroy Object destructor to free parameter list)
  @member(
    New Create a new @classname as interface
    @param(Dataset TDataset object)
  )
}
{$ENDREGION}
  TDatasetDataInput = class sealed(TInterfacedObject, IDataInput)
  strict private
    _Dataset: TDataSet;
    _Section: String;
  private
    function FieldByKey(const Key: ITextKey): TField;
  public
    function ExistKey(const Key: ITextKey): Boolean;
    function IsNull(const Key: ITextKey): Boolean;
    function ReadInteger(const Key: ITextKey): Integer;
    function ReadBoolean(const Key: ITextKey): Boolean;
    function ReadFloat(const Key: ITextKey): Extended;
    function ReadString(const Key: ITextKey): String;
    function ReadDateTime(const Key: ITextKey): TDateTime;
    function ReadChar(const Key: ITextKey): Char;
    procedure EnterSection(const Key: ITextKey);
    procedure ExitSection(const Key: ITextKey);
    constructor Create(const Dataset: TDataSet);
    class function New(const Dataset: TDataSet): IDataInput;
  end;

implementation

function TDatasetDataInput.FieldByKey(const Key: ITextKey): TField;
begin
  Result := _Dataset.FieldByName(_Section + Key.Value)
end;

function TDatasetDataInput.ExistKey(const Key: ITextKey): Boolean;
begin
  Result := Assigned(_Dataset.FindField(_Section + Key.Value));
end;

function TDatasetDataInput.ReadBoolean(const Key: ITextKey): Boolean;
var
  Field: TField;
begin
  Field := FieldByKey(Key);
  if Field.DataType = ftBoolean then
    Result := FieldByKey(Key).AsBoolean
  else
    Result := FieldByKey(Key).AsInteger <> 0;
end;

function TDatasetDataInput.ReadChar(const Key: ITextKey): Char;
begin
  Result := FieldByKey(Key).AsString[1];
end;

function TDatasetDataInput.ReadDateTime(const Key: ITextKey): TDateTime;
begin
  Result := FieldByKey(Key).AsDateTime;
end;

function TDatasetDataInput.ReadFloat(const Key: ITextKey): Extended;
begin
{$IFDEF FPC}
  Result := FieldByKey(Key).AsFloat;
{$ELSE}
  Result := FieldByKey(Key).AsExtended;
{$ENDIF}
end;

function TDatasetDataInput.ReadInteger(const Key: ITextKey): Integer;
begin
  Result := FieldByKey(Key).AsInteger;
end;

function TDatasetDataInput.ReadString(const Key: ITextKey): String;
begin
  Result := FieldByKey(Key).Value;
end;

function TDatasetDataInput.IsNull(const Key: ITextKey): Boolean;
begin
  Result := FieldByKey(Key).IsNull;
end;

procedure TDatasetDataInput.EnterSection(const Key: ITextKey);
begin
  _Section := _Section + Key.Value + '_';
end;

procedure TDatasetDataInput.ExitSection(const Key: ITextKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.Value)));
end;

constructor TDatasetDataInput.Create(const Dataset: TDataSet);
begin
  _Dataset := Dataset;
end;

class function TDatasetDataInput.New(const Dataset: TDataSet): IDataInput;
begin
  Result := TDatasetDataInput.Create(Dataset);
end;

end.
