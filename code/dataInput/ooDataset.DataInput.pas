{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooDataset.DataInput;

interface

uses
  DB,
  ooKey.Intf,
  ooDataInput.Intf;

type
  TDatasetDataInput = class sealed(TInterfacedObject, IDataInput)
  strict private
    _Dataset: TDataSet;
  public
    function IsNull(const Key: IKey): Boolean;
    function ReadInteger(const Key: IKey): Integer;
    function ReadBoolean(const Key: IKey): Boolean;
    function ReadFloat(const Key: IKey): Extended;
    function ReadString(const Key: IKey): String;
    function ReadDateTime(const Key: IKey): TDateTime;
    function ReadChar(const Key: IKey): Char;

    constructor Create(Dataset: TDataSet);

    class function New(Dataset: TDataSet): IDataInput;
  end;

implementation

function TDatasetDataInput.ReadBoolean(const Key: IKey): Boolean;
begin
  Result := _Dataset.FieldByName(Key.AsString).AsInteger <> 0;
end;

function TDatasetDataInput.ReadChar(const Key: IKey): Char;
begin
  Result := _Dataset.FieldByName(Key.AsString).AsString[1];
end;

function TDatasetDataInput.ReadDateTime(const Key: IKey): TDateTime;
begin
  Result := _Dataset.FieldByName(Key.AsString).AsDateTime;
end;

function TDatasetDataInput.ReadFloat(const Key: IKey): Extended;
begin
{$IFDEF FPC}
  Result := _Dataset.FieldByName(Key.AsString).AsFloat;
{$ELSE}
  Result := _Dataset.FieldByName(Key.AsString).AsExtended;
{$ENDIF}
end;

function TDatasetDataInput.ReadInteger(const Key: IKey): Integer;
begin
  Result := _Dataset.FieldByName(Key.AsString).AsInteger;
end;

function TDatasetDataInput.ReadString(const Key: IKey): String;
begin
  Result := _Dataset.FieldByName(Key.AsString).AsString;
end;

constructor TDatasetDataInput.Create(Dataset: TDataSet);
begin
  _Dataset := Dataset;
end;

function TDatasetDataInput.IsNull(const Key: IKey): Boolean;
begin
  Result := _Dataset.FieldByName(Key.AsString).IsNull;
end;

class function TDatasetDataInput.New(Dataset: TDataSet): IDataInput;
begin
  Result := TDatasetDataInput.Create(Dataset);
end;

end.
