unit KeyValue;

interface

uses
  SysUtils, StrUtils,
  List, IterableList;

type
  IKeyValue = interface
    ['{11D46BED-C4B4-4D4F-BC44-177A54C9BFC0}']
    function Key: String;
    function Value: String;
    function AsString: String;
    procedure UpdateValue(const Value: String);
  end;

  TKeyValue = class sealed(TInterfacedObject, IKeyValue)
  const
    ASSIGNMENT_CHAR = '=';
  strict private
    _Key: String;
    _Value: String;
  public
    function Key: String;
    function Value: String;
    function AsString: String;
    procedure UpdateValue(const Value: String);
    constructor Create(const Key: String; const Value: String);
    class function New(const Key: String; const Value: String): IKeyValue;
    class function NewFromString(const Text: String; const AssignmentChar: String = ASSIGNMENT_CHAR): IKeyValue;
  end;

  IKeyValueList = interface(IIterableList<IKeyValue>)
    ['{563FD2B3-A8F3-4281-B0DF-1F41B81D8D15}']
    function ItemByKey(const Key: String): IKeyValue;
    function ExistsByKey(const Key: String): Boolean;
    procedure LoadFromString(const Text, Separator: String);
  end;

  TKeyValueList = class sealed(TIterableList<IKeyValue>, IKeyValueList)
  public
    function Add(const KeyValue: IKeyValue): TIntegerIndex; override;
    function ItemByKey(const Key: String): IKeyValue;
    function ExistsByKey(const Key: String): Boolean;
    function Exists(const KeyValue: IKeyValue): Boolean; override;
    procedure LoadFromString(const Text, Separator: String);
    class function New: IKeyValueList;
  end;

implementation

function TKeyValue.Key: String;
begin
  Result := _Key;
end;

function TKeyValue.Value: String;
begin
  Result := _Value;
end;

function TKeyValue.AsString: String;
begin
  Result := _Key + ASSIGNMENT_CHAR + _Value;
end;

procedure TKeyValue.UpdateValue(const Value: String);
begin
  _Value := Value;
end;

constructor TKeyValue.Create(const Key: String; const Value: String);
begin
  _Key := Key;
  _Value := Value;
end;

class function TKeyValue.New(const Key: String; const Value: String): IKeyValue;
begin
  Result := Create(Key, Value);
end;

class function TKeyValue.NewFromString(const Text: String; const AssignmentChar: String = ASSIGNMENT_CHAR): IKeyValue;
var
  Key, Value: String;
  PosAssign: Integer;
begin
  PosAssign := Pos(AssignmentChar, Text);
  if PosAssign > 0 then
  begin
    Key := Copy(Text, 1, Pred(PosAssign));
    Value := Copy(Text, Succ(PosAssign));
  end
  else
  begin
    Key := Text;
    Value := EmptyStr;
  end;
  Result := TKeyValue.New(Key, Value);
end;

{ TKeyValueList }

function TKeyValueList.Add(const KeyValue: IKeyValue): TIntegerIndex;
var
  KeyValueExistence: IKeyValue;
begin
  KeyValueExistence := ItemByKey(KeyValue.Key);
  if Assigned(KeyValueExistence) then
  begin
    KeyValueExistence.UpdateValue(KeyValue.Value);
    Result := IndexOf(KeyValueExistence);
  end
  else
    Result := inherited Add(KeyValue);
end;

function TKeyValueList.ItemByKey(const Key: String): IKeyValue;
var
  Item: IKeyValue;
begin
  Result := nil;
  for Item in Self do
    if Key = Item.Key then
      Exit(Item);
end;

function TKeyValueList.ExistsByKey(const Key: String): Boolean;
begin
  Result := Assigned(ItemByKey(Key));
end;

function TKeyValueList.Exists(const KeyValue: IKeyValue): Boolean;
var
  Item: IKeyValue;
begin
  Result := False;
  for Item in Self do
    if (KeyValue.Key = Item.Key) and (KeyValue.Value = Item.Value) then
      Exit(True);
end;

procedure TKeyValueList.LoadFromString(const Text, Separator: String);
var
  SeparatorSize, CurrentPos, NewPos: Integer;
begin
  Clear;
  if Length(Text) > 0 then
  begin
    SeparatorSize := Length(Separator);
    CurrentPos := 1;
    while CurrentPos > 0 do
    begin
      NewPos := PosEx(Separator, Text, CurrentPos);
      if NewPos > 0 then
      begin
        Add(TKeyValue.NewFromString(Copy(Text, CurrentPos, NewPos - CurrentPos)));
        CurrentPos := NewPos + SeparatorSize;
      end
      else
      begin
        Add(TKeyValue.NewFromString(Copy(Text, CurrentPos)));
        CurrentPos := 0;
      end;
    end;
  end;
end;

class function TKeyValueList.New: IKeyValueList;
begin
  Result := Create;
end;

end.
