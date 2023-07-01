unit GenericNameableEntityFactory;

interface

uses
  DB,
  Entity, GenericEntityFactory, EntityFactory,
  ObjectName, ObjectNameFactory,
  NameableEntity;

type
  IGenericNameableEntityFactory<I: INameableEntity; IL: INameableEntityList<I> { } > = interface
    (IGenericEntityFactory<I, IL>)
    ['{5B36923E-D3BB-4585-9308-A1443BA53FFF}']
  end;

  TGenericNameableEntityFactory<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TInterfacedObject,
    IGenericNameableEntityFactory<I, IL>)
  strict private
    _ObjectNameFactory: IObjectNameFactory;
    _EntityFactory: IEntityFactory;
  protected
    function EntityFactory: IEntityFactory;
  public
    function Build(const Dataset: TDataSet): I;
    function BuildList(const Dataset: TDataSet; const List: IL): Boolean;
    function DoBuildList<T: IEntity>(const Dataset: TDataSet; const List: IEntityList<T>;
      const Callback: TBuildEntityCallback<T>): Boolean;
    constructor Create(const ObjectNameFactory: IObjectNameFactory);
    class function New(const ObjectNameFactory: IObjectNameFactory): IGenericNameableEntityFactory<I, IL>;
    class function NewDefault: IGenericNameableEntityFactory<I, IL>;
  end;

implementation

function TGenericNameableEntityFactory<I, IL>.Build(const Dataset: TDataSet): I;
var
  Entity: IEntity;
  Name: IObjectName;
begin
  Entity := _EntityFactory.Build(Dataset);
  Name := _ObjectNameFactory.Build(Dataset);
  Result := I(TNameableEntity.New(Entity, Name));
end;

function TGenericNameableEntityFactory<I, IL>.BuildList(const Dataset: TDataSet; const List: IL): Boolean;
begin
  Result := TEntityFactory(_EntityFactory).DoBuildList<I>(Dataset, List, Build);
end;

constructor TGenericNameableEntityFactory<I, IL>.Create(const ObjectNameFactory: IObjectNameFactory);
begin
  _EntityFactory := TEntityFactory.New;
  _ObjectNameFactory := ObjectNameFactory;
end;

function TGenericNameableEntityFactory<I, IL>.DoBuildList<T>(const Dataset: TDataSet; const List: IEntityList<T>;
  const Callback: TBuildEntityCallback<T>): Boolean;
begin
  Result := TEntityFactory(_EntityFactory).DoBuildList<T>(Dataset, List, Callback);
end;

function TGenericNameableEntityFactory<I, IL>.EntityFactory: IEntityFactory;
begin
  Result := _EntityFactory;
end;

class function TGenericNameableEntityFactory<I, IL>.New(const ObjectNameFactory: IObjectNameFactory)
  : IGenericNameableEntityFactory<I, IL>;
begin
  Result := Create(ObjectNameFactory);
end;

class function TGenericNameableEntityFactory<I, IL>.NewDefault: IGenericNameableEntityFactory<I, IL>;
begin
  Result := Create(TObjectNameFactory.New);
end;

end.
