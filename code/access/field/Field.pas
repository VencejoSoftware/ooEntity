unit Field;

interface

uses
  SysUtils,
  IterableList;

type
  IField = interface
    ['{E8249B81-A82E-4CF1-A87D-6F6F2B0D549E}']
    function Name: String;
  end;

  TField = class sealed(TInterfacedObject, IField)
  strict private
    _Name: String;
  public
    function Name: String;
    constructor Create(const Name: String);
    class function New(const Name: String): IField;
  end;

  IFieldList = interface(IIterableList<IField>)
    ['{FF89B064-974E-4C6A-A017-437F4A581504}']
    function ItemByName(const Name: String): IField;
  end;

  TFieldList = class sealed(TIterableList<IField>, IFieldList)
  public
    function ItemByName(const Name: String): IField;
    class function New: IFieldList;
  end;

implementation

function TField.Name: String;
begin
  Result := _Name;
end;

constructor TField.Create(const Name: String);
begin
  _Name := Name;
end;

class function TField.New(const Name: String): IField;
begin
  Result := Create(Name);
end;

{ TFieldList }

function TFieldList.ItemByName(const Name: String): IField;
var
  Item: IField;
begin
  Result := nil;
  for Item in Self do
    if SameText(Name, Item.Name) then
      Exit(Item);
end;

class function TFieldList.New: IFieldList;
begin
  Result := Create;
end;

end.
