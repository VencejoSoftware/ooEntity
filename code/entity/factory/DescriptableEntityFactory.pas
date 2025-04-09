unit DescriptableEntityFactory;

interface

uses
  SysUtils,
  DB,
  Entity, GenericEntityFactory, EntityFactory,
  DescriptableEntity;

type
  IDescriptableEntityFactory = interface(IGenericEntityFactory<IDescriptableEntity,
    IDescriptableEntityList<IDescriptableEntity> { } >)
    ['{D5277A39-8BC6-4943-8B48-CD2BD35738FB}']
  end;

  TDescriptableEntityFactory = class sealed(TInterfacedObject, IDescriptableEntityFactory)
  strict private
    _EntityFactory: IEntityFactory;
  public
    function Build(const Dataset: TDataSet): IDescriptableEntity;
    function BuildList(const Dataset: TDataSet; const List: IDescriptableEntityList<IDescriptableEntity>): Boolean;
    constructor Create;
    class function New: IDescriptableEntityFactory;
  end;

implementation

function TDescriptableEntityFactory.Build(const Dataset: TDataSet): IDescriptableEntity;
var
  Entity: IEntity;
  Title, Description: String;
begin
  Entity := _EntityFactory.Build(Dataset);
  Title := Dataset.FieldByName('TITLE').AsString;
  Description := Dataset.FieldByName('DESCRIPTION').AsString;
  Result := TDescriptableEntity.New(Entity, Title, Description);
end;

function TDescriptableEntityFactory.BuildList(const Dataset: TDataSet;
  const List: IDescriptableEntityList<IDescriptableEntity>): Boolean;
begin
  Result := TEntityFactory(_EntityFactory).DoBuildList<IDescriptableEntity>(Dataset, List, Build);
end;

constructor TDescriptableEntityFactory.Create;
begin
  _EntityFactory := TEntityFactory.New;
end;

class function TDescriptableEntityFactory.New: IDescriptableEntityFactory;
begin
  Result := Create;
end;

end.
