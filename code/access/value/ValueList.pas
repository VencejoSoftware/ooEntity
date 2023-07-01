unit ValueList;

interface

uses
  SysUtils,
  Value,
  IterableList;

type
  IValueList = interface(IIterableList<IValue>)
    ['{43A983B8-4337-4788-98DE-9A83762B0A84}']
  end;

  TValueList = class sealed(TIterableList<IValue>, IValueList)
  public
    class function New: IValueList;
    class function NewByArray(const Values: array of TVarRec): IValueList;
  end;

implementation

class function TValueList.New: IValueList;
begin
  Result := TValueList.Create;
end;

class function TValueList.NewByArray(const Values: array of TVarRec): IValueList;
var
  Value: TVarRec;
begin
  Result := TValueList.New;
  for Value in Values do
    Result.Add(TValue.New(Value));
end;

end.
