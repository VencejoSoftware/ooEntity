unit EntityService;

interface

uses
  Entity, ObjectId,
  EntityRepository;

type
  IEntityService<I: IEntity; IL: IEntityList<I> { } > = interface
    ['{A3F1B3F3-3F2D-4C36-A343-E4A1DEE11CA4}']
    function GetOne(const ID: IObjectId): I;
    function GetMany(const List: IL): Boolean;
    function Exists(const Entity: I): Boolean;
    function ExistsById(const ID: IObjectId): Boolean;
    function Remove(const Entity: I): Boolean;
    function Update(const Entity: I): I;
    function Insert(const Entity: I): I;
    function Save(const Entity: I): I;
    function InsertMany(const List: IL): Boolean;
    function UpdateMany(const List: IL): Boolean;
    function SaveMany(const List: IL): Boolean;
  end;

  TEntityService<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityService<I, IL>)
  strict private
    _Repository: IEntityRepository<I, IL>;
  protected
    function Repository: IEntityRepository<I, IL>; virtual;
  public
    function GetOne(const ID: IObjectId): I;
    function GetMany(const List: IL): Boolean;
    function Exists(const Entity: I): Boolean;
    function ExistsById(const ID: IObjectId): Boolean;
    function Remove(const Entity: I): Boolean;
    function Update(const Entity: I): I;
    function Insert(const Entity: I): I;
    function Save(const Entity: I): I;
    function InsertMany(const List: IL): Boolean;
    function UpdateMany(const List: IL): Boolean;
    function SaveMany(const List: IL): Boolean;
    constructor Create(const Repository: IEntityRepository<I, IL>); virtual;
    class function New(const Repository: IEntityRepository<I, IL>): IEntityService<I, IL>;
  end;

implementation

function TEntityService<I, IL>.GetOne(const ID: IObjectId): I;
begin
  Result := _Repository.SelectOne(ID);
end;

function TEntityService<I, IL>.GetMany(const List: IL): Boolean;
begin
  Result := _Repository.SelectMany(List);
end;

function TEntityService<I, IL>.Exists(const Entity: I): Boolean;
begin
  Result := _Repository.Exists(Entity);
end;

function TEntityService<I, IL>.ExistsById(const ID: IObjectId): Boolean;
begin
  Result := _Repository.ExistsById(ID);
end;

function TEntityService<I, IL>.Remove(const Entity: I): Boolean;
begin
  Result := _Repository.Delete(Entity.ID);
end;

function TEntityService<I, IL>.Repository: IEntityRepository<I, IL>;
begin
  Result := _Repository;
end;

function TEntityService<I, IL>.Update(const Entity: I): I;
begin
  Result := _Repository.Update(Entity);
end;

function TEntityService<I, IL>.Insert(const Entity: I): I;
begin
  Result := _Repository.Insert(Entity);
end;

function TEntityService<I, IL>.Save(const Entity: I): I;
begin
  Result := _Repository.Upsert(Entity);
end;

function TEntityService<I, IL>.InsertMany(const List: IL): Boolean;
begin
  Result := _Repository.InsertMany(List);
end;

function TEntityService<I, IL>.UpdateMany(const List: IL): Boolean;
begin
  Result := _Repository.UpdateMany(List);
end;

function TEntityService<I, IL>.SaveMany(const List: IL): Boolean;
begin
  Result := _Repository.UpsertMany(List);
end;

constructor TEntityService<I, IL>.Create(const Repository: IEntityRepository<I, IL>);
begin
  _Repository := Repository;
end;

class function TEntityService<I, IL>.New(const Repository: IEntityRepository<I, IL>): IEntityService<I, IL>;
begin
  Result := TEntityService<I, IL>.Create(Repository);
end;

end.
