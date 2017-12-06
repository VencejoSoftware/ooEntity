{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooTextKey;

interface

uses
  SysUtils,
  ooText.RandomFixed,
  ooKey.Intf;

type
  TTextKey = class sealed(TInterfacedObject, IKey)
  strict private
    _Value: String;
  private
    function CreateUnique: String;
    function IsEmptyKey(const Value: String): Boolean;
  public
    function AsString: String;
    constructor Create(const Value: String);
    class function New(const Value: String): IKey; overload;
    class function New: IKey; overload;
  end;

implementation

function TTextKey.AsString: String;
begin
  Result := _Value;
end;

function TTextKey.CreateUnique: String;
begin
  Result := TRandomTextFixed.New.Value;
end;

function TTextKey.IsEmptyKey(const Value: String): Boolean;
begin
  Result := (Length(Value) = 0);
end;

constructor TTextKey.Create(const Value: String);
begin
  if IsEmptyKey(Value) then
    _Value := CreateUnique
  else
    _Value := Value;
end;

class function TTextKey.New(const Value: String): IKey;
begin
  Result := TTextKey.Create(Value);
end;

class function TTextKey.New: IKey;
begin
  Result := TTextKey.New(EmptyStr);
end;

end.
