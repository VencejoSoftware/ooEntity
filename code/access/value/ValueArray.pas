unit ValueArray;

interface

uses
  SysUtils,
  Value, ValueList;

type
  IValueArray = interface(IValue)
    ['{A67A61C8-9ACB-46AB-B373-FA3CD039D632}']
    function ValueList: IValueList;
    function Concatenator: String;
  end;

  TValueArray = class sealed(TInterfacedObject, IValueArray)
  strict private
    _ValueList: IValueList;
    _Concatenator: String;
  public
    function Content: TVarRec;
    function ToString: string; reintroduce;
    function IsEmpty: Boolean;
    function ValueList: IValueList;
    function Concatenator: String;
    constructor Create(const Values: array of IValue; const Concatenator: String);
    class function New(const Values: array of IValue; const Concatenator: String = ','): IValueArray;
  end;

implementation

function TValueArray.Content: TVarRec;
begin
end;

function TValueArray.ToString: string;
var
  Value: IValue;
begin
  Result := EmptyStr;
  for Value in _ValueList do
  begin
    if Result <> EmptyStr then
      Result := Result + _Concatenator;
    Result := Result + Value.ToString;
  end;
end;

function TValueArray.IsEmpty: Boolean;
begin
  Result := _ValueList.IsEmpty;
end;

function TValueArray.ValueList: IValueList;
begin
  Result := _ValueList;
end;

function TValueArray.Concatenator: String;
begin
  Result := _Concatenator;
end;

constructor TValueArray.Create(const Values: array of IValue; const Concatenator: String);
var
  Item: IValue;
begin
  _ValueList := TValueList.New;
  for Item in Values do
    _ValueList.Add(Item);
  _Concatenator := Concatenator;
end;

class function TValueArray.New(const Values: array of IValue; const Concatenator: String): IValueArray;
begin
  Result := TValueArray.Create(Values, Concatenator);
end;

end.
