unit GenericNameableEntityFactory;

interface

uses
  DB,
  ObjectId,
  Entity, GenericEntityFactory, EntityFactory,
  ObjectName, ObjectNameFactory,
  NameableEntity;

type
  IGenericNameableEntityFactory<I: INameableEntity; IL: INameableEntityList<I> { } > = interface
    (IGenericEntityFactory<I, IL>)
    ['{21E3D795-3038-4A1F-A56D-012A7D44C65C}']
  end;

  TGenericNameableEntityFactory<I: INameableEntity; IL: INameableEntityList<I> { } > = class(TInterfacedObject,
    IGenericNameableEntityFactory<I, IL>)
  strict private
    _ObjectNameFactory: IObjectNameFactory;
  protected
    function ObjectNameFactory: IObjectNameFactory;
  public
    function Build(const Dataset: TDataSet): I; virtual;
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
  ID: IObjectID;
  Name: IObjectName;
begin
  ID := TObjectID.New(Dataset.FieldByName('ID').AsInteger);
  Name := _ObjectNameFactory.Build(Dataset);
  Result := TNameableEntity.New<I>(ID, Name);
end;

function TGenericNameableEntityFactory<I, IL>.BuildList(const Dataset: TDataSet; const List: IL): Boolean;
begin
  Result := DoBuildList<I>(Dataset, List, Build);
end;

constructor TGenericNameableEntityFactory<I, IL>.Create(const ObjectNameFactory: IObjectNameFactory);
begin
  _ObjectNameFactory := ObjectNameFactory;
end;

function TGenericNameableEntityFactory<I, IL>.DoBuildList<T>(const Dataset: TDataSet; const List: IEntityList<T>;
  const Callback: TBuildEntityCallback<T>): Boolean;
begin
  Result := TEntityFactory.DoBuildList<T>(Dataset, List, Callback);
end;

function TGenericNameableEntityFactory<I, IL>.ObjectNameFactory: IObjectNameFactory;
begin
  Result := _ObjectNameFactory;
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
