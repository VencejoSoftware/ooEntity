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
    function Remove(const Entity: I): Boolean;
    function Update(const Entity: I): Boolean;
    function Insert(const Entity: I): Boolean;
    function Save(const Entity: I): Boolean;
  end;

  TEntityService<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityService<I, IL>)
  strict private
    _Repository: IEntityRepository<I, IL>;
  protected
    function Repository: IEntityRepository<I, IL>;
  public
    function GetOne(const ID: IObjectId): I;
    function GetMany(const List: IL): Boolean;
    function Exists(const Entity: I): Boolean;
    function Remove(const Entity: I): Boolean;
    function Update(const Entity: I): Boolean;
    function Insert(const Entity: I): Boolean;
    function Save(const Entity: I): Boolean;
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

function TEntityService<I, IL>.Remove(const Entity: I): Boolean;
begin
  Result := _Repository.Delete(Entity.ID);
end;

function TEntityService<I, IL>.Repository: IEntityRepository<I, IL>;
begin
  Result := _Repository;
end;

function TEntityService<I, IL>.Update(const Entity: I): Boolean;
begin
  Result := _Repository.Update(Entity);
end;

function TEntityService<I, IL>.Insert(const Entity: I): Boolean;
begin
  Result := _Repository.Insert(Entity);
end;

function TEntityService<I, IL>.Save(const Entity: I): Boolean;
begin
  Result := _Repository.Upsert(Entity);
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
