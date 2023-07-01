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
  public
    function Build(const Dataset: TDataset): IObjectName;
    class function New: IObjectNameFactory;
  end;

implementation

function TObjectNameFactory.Build(const Dataset: TDataset): IObjectName;
begin
  Result := TObjectName.New(Dataset.FieldByName('NAME').AsString);
end;

class function TObjectNameFactory.New: IObjectNameFactory;
begin
  Result := TObjectNameFactory.Create;
end;

end.
