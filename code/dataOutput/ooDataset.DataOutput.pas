{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooDataset.DataOutput;

interface

uses
  DB,
  ooKey.Intf,
  ooDataOutput.Intf;

type
  TDatasetDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TDataset;
  public
    procedure WriteNull(const Key: IKey);
    procedure WriteInteger(const Key: IKey; const Value: Integer);
    procedure WriteBoolean(const Key: IKey; const Value: Boolean);
    procedure WriteFloat(const Key: IKey; const Value: Extended);
    procedure WriteString(const Key: IKey; const Value: String);
    procedure WriteDateTime(const Key: IKey; const Value: TDateTime);
    procedure WriteChar(const Key: IKey; const Value: Char);

    constructor Create(const Destination: TDataset);
    class function New(const Destination: TDataset): IDataOutput;
  end;

implementation

procedure TDatasetDataOutput.WriteBoolean(const Key: IKey; const Value: Boolean);
begin
  _Destination.FieldByName(Key.AsString).AsBoolean := Value;
end;

procedure TDatasetDataOutput.WriteChar(const Key: IKey; const Value: Char);
begin
  _Destination.FieldByName(Key.AsString).AsString := Value;
end;

procedure TDatasetDataOutput.WriteDateTime(const Key: IKey; const Value: TDateTime);
begin
  _Destination.FieldByName(Key.AsString).AsDateTime := Value;
end;

procedure TDatasetDataOutput.WriteFloat(const Key: IKey; const Value: Extended);
begin
{$IFDEF FPC}
  _Destination.FieldByName(Key.AsString).AsFloat := Value;
{$ELSE}
  _Destination.FieldByName(Key.AsString).AsExtended := Value;
{$ENDIF}
end;

procedure TDatasetDataOutput.WriteInteger(const Key: IKey; const Value: Integer);
begin
  _Destination.FieldByName(Key.AsString).AsInteger := Value;
end;

procedure TDatasetDataOutput.WriteString(const Key: IKey; const Value: String);
begin
  _Destination.FieldByName(Key.AsString).AsString := Value;
end;

procedure TDatasetDataOutput.WriteNull(const Key: IKey);
begin
  _Destination.FieldByName(Key.AsString).Clear;
end;

constructor TDatasetDataOutput.Create(const Destination: TDataset);
begin
  _Destination := Destination;
end;

class function TDatasetDataOutput.New(const Destination: TDataset): IDataOutput;
begin
  Result := TDatasetDataOutput.Create(Destination);
end;

end.
