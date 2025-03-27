unit EntityFactory;

interface

uses
  DB,
  ObjectId,
  GenericEntityFactory, Entity;

type
  TBuildEntityCallback<I: IEntity> = function(const Dataset: TDataSet): I of object;

  IEntityFactory = interface(IGenericEntityFactory<IEntity, IEntityList<IEntity> { } >)
    ['{27725449-89DE-4279-B4AE-0D2563D17B9E}']
  end;

  TEntityFactory = class sealed(TInterfacedObject, IEntityFactory)
  public
    function Build(const Dataset: TDataSet): IEntity;
    function BuildList(const Dataset: TDataSet; const List: IEntityList<IEntity>): Boolean;
    class function DoBuildList<T: IEntity>(const Dataset: TDataSet; const List: IEntityList<T>;
      const Callback: TBuildEntityCallback<T>): Boolean;
    class function New: IEntityFactory;
  end;

implementation

function TEntityFactory.Build(const Dataset: TDataSet): IEntity;
var
  ID: IObjectID;
begin
  ID := TObjectID.New(Dataset.FieldByName('ID').AsInteger);
  Result := TEntity.New(ID);
end;

function TEntityFactory.BuildList(const Dataset: TDataSet; const List: IEntityList<IEntity>): Boolean;
begin
  Result := DoBuildList<IEntity>(Dataset, List, Build);
end;

class function TEntityFactory.DoBuildList<T>(const Dataset: TDataSet; const List: IEntityList<T>;
  const Callback: TBuildEntityCallback<T>): Boolean;
begin
  List.Clear;
  Dataset.DisableControls;
  try
    Dataset.First;
    while not Dataset.Eof do
    begin
      List.Add(Callback(Dataset));
      Dataset.Next;
    end;
    Result := True;
  finally
    Dataset.EnableControls;
  end;
end;

class function TEntityFactory.New: IEntityFactory;
begin
  Result := Create;
end;

end.
