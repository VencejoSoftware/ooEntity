unit ObjectNameFactory;

interface

uses
  DB,
  ObjectName;

type
  IObjectNameFactory = interface
    ['{740655DA-B3D8-4981-B072-A0B9918B52A9}']
    function Build(const Dataset: TDataset): IObjectName;
  end;

  TObjectNameFactory = class sealed(TInterfacedObject, IObjectNameFactory)
  strict private
    _FieldName: String;
  public
    function Build(const Dataset: TDataset): IObjectName;
    constructor Create(const FieldName: String);
    class function New(const FieldName: String = 'NAME'): IObjectNameFactory;
  end;

implementation

function TObjectNameFactory.Build(const Dataset: TDataset): IObjectName;
begin
  Result := TObjectName.New(Dataset.FieldByName(_FieldName).AsString);
end;

constructor TObjectNameFactory.Create(const FieldName: String);
begin
  _FieldName := FieldName;
end;

class function TObjectNameFactory.New(const FieldName: String): IObjectNameFactory;
begin
  Result := Create(FieldName);
end;

end.
