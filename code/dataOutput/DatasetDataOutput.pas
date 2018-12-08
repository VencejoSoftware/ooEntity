{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit DatasetDataOutput;

interface

uses
  SysUtils,
  DB,
  Key,
  DataOutput;

type
  TDatasetDataOutput = class sealed(TInterfacedObject, IDataOutput)
  strict private
    _Destination: TDataset;
    _Section: String;
  public
    procedure WriteNull(const Key: ITextKey);
    procedure WriteInteger(const Key: ITextKey; const Value: Integer);
    procedure WriteBoolean(const Key: ITextKey; const Value: Boolean);
    procedure WriteFloat(const Key: ITextKey; const Value: Extended);
    procedure WriteString(const Key: ITextKey; const Value: String);
    procedure WriteDateTime(const Key: ITextKey; const Value: TDateTime);
    procedure WriteChar(const Key: ITextKey; const Value: Char);
    procedure EnterSection(const Key: ITextKey);
    procedure ExitSection(const Key: ITextKey);
    constructor Create(const Destination: TDataset);
    class function New(const Destination: TDataset): IDataOutput;
  end;

implementation

procedure TDatasetDataOutput.WriteBoolean(const Key: ITextKey; const Value: Boolean);
begin
  _Destination.FieldByName(_Section + Key.Value).AsBoolean := Value;
end;

procedure TDatasetDataOutput.WriteChar(const Key: ITextKey; const Value: Char);
begin
  _Destination.FieldByName(_Section + Key.Value).Value := Value;
end;

procedure TDatasetDataOutput.WriteDateTime(const Key: ITextKey; const Value: TDateTime);
begin
  _Destination.FieldByName(_Section + Key.Value).AsDateTime := Value;
end;

procedure TDatasetDataOutput.WriteFloat(const Key: ITextKey; const Value: Extended);
begin
{$IFDEF FPC}
  _Destination.FieldByName(_Section + Key.Value).AsFloat := Value;
{$ELSE}
  _Destination.FieldByName(_Section + Key.Value).AsExtended := Value;
{$ENDIF}
end;

procedure TDatasetDataOutput.WriteInteger(const Key: ITextKey; const Value: Integer);
begin
  _Destination.FieldByName(_Section + Key.Value).AsInteger := Value;
end;

procedure TDatasetDataOutput.WriteString(const Key: ITextKey; const Value: String);
begin
  _Destination.FieldByName(_Section + Key.Value).Value := Value;
end;

procedure TDatasetDataOutput.WriteNull(const Key: ITextKey);
begin
  _Destination.FieldByName(_Section + Key.Value).Clear;
end;

procedure TDatasetDataOutput.EnterSection(const Key: ITextKey);
begin
  _Section := _Section + Key.Value + '_';
end;

procedure TDatasetDataOutput.ExitSection(const Key: ITextKey);
begin
  _Section := Copy(_Section, 1, Pred(Length(_Section) - Length(Key.Value)));
end;

constructor TDatasetDataOutput.Create(const Destination: TDataset);
begin
  _Destination := Destination;
  _Section := EmptyStr;
end;

class function TDatasetDataOutput.New(const Destination: TDataset): IDataOutput;
begin
  Result := TDatasetDataOutput.Create(Destination);
end;

end.
