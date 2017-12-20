{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooDataset.DataInput;

interface

uses
  SysUtils,
  DB,
  ooKey.Intf,
  ooDataInput.Intf;

type
  TDatasetDataInput = class sealed(TInterfacedObject, IDataInput)
  strict private
    _Dataset: TDataSet;
    _Section: String;
  public
    function IsNull(const Key: IKey): Boolean;
    function ReadInteger(const Key: IKey): Integer;
    function ReadBoolean(const Key: IKey): Boolean;
    function ReadFloat(const Key: IKey): Extended;
    function ReadString(const Key: IKey): String;
    function ReadDateTime(const Key: IKey): TDateTime;
    function ReadChar(const Key: IKey): Char;
    procedure EnterSection(const Key: IKey);
    procedure ExitSection(const Key: IKey);
    constructor Create(Dataset: TDataSet);
    class function New(Dataset: TDataSet): IDataInput;
  end;

implementation

function TDatasetDataInput.ReadBoolean(const Key: IKey): Boolean;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsInteger <> 0;
end;

function TDatasetDataInput.ReadChar(const Key: IKey): Char;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsString[1];
end;

function TDatasetDataInput.ReadDateTime(const Key: IKey): TDateTime;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsDateTime;
end;

function TDatasetDataInput.ReadFloat(const Key: IKey): Extended;
begin
{$IFDEF FPC}
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsFloat;
{$ELSE}
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsExtended;
{$ENDIF}
end;

function TDatasetDataInput.ReadInteger(const Key: IKey): Integer;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsInteger;
end;

function TDatasetDataInput.ReadString(const Key: IKey): String;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).AsString;
end;

function TDatasetDataInput.IsNull(const Key: IKey): Boolean;
begin
  Result := _Dataset.FieldByName(_Section + Key.AsString).IsNull;
end;

procedure TDatasetDataInput.EnterSection(const Key: IKey);
begin
  _Section := _Section + Key.AsString + '_';
end;

procedure TDatasetDataInput.ExitSection(const Key: IKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.AsString)));
end;

constructor TDatasetDataInput.Create(Dataset: TDataSet);
begin
  _Dataset := Dataset;
end;

class function TDatasetDataInput.New(Dataset: TDataSet): IDataInput;
begin
  Result := TDatasetDataInput.Create(Dataset);
end;

end.
