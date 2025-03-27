unit ValueList;

interface

uses
  SysUtils,
  Value,
  IterableList;

type
  IValueList = interface(IIterableList<IValue>)
    ['{43A983B8-4337-4788-98DE-9A83762B0A84}']
    function Join(const Separator: String): String;
  end;

  TValueList = class sealed(TIterableList<IValue>, IValueList)
  public
    function Join(const Separator: String): String;
    class function New: IValueList;
    class function NewByArray(const Values: array of TVarRec): IValueList;
  end;

implementation

function TValueList.Join(const Separator: String): String;
var
  Item: IValue;
begin
  Result := EmptyStr;
  for Item in Self do
    if not Item.IsEmpty then
    begin
      if Result <> EmptyStr then
        Result := Result + Separator;
      Result := Result + Item.ToString + Separator;
    end;
end;

class function TValueList.New: IValueList;
begin
  Result := Create;
end;

class function TValueList.NewByArray(const Values: array of TVarRec): IValueList;
var
  Value: TVarRec;
begin
  Result := Create;
  for Value in Values do
    Result.Add(TValue.New(Value));
end;

end.
