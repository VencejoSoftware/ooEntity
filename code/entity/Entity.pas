unit Entity;

interface

uses
  ObjectID,
  IterableList;

type
  IEntity = interface
    ['{B6F78DDD-A39F-4DB2-966E-FE3235DBCA00}']
    function Id: IObjectID;
    function HasId: Boolean;
    procedure UpdateId(const Id: IObjectID);
  end;

  TEntity = class(TInterfacedObject, IEntity)
  strict private
    _Id: IObjectID;
  public
    function Id: IObjectID;
    function HasId: Boolean;
    procedure UpdateId(const Id: IObjectID);
    constructor Create(const Id: IObjectID); virtual;
    class function New(const Id: IObjectID): IEntity;
    class function NewWithoutId: IEntity;
  end;

  IEntityList<T: IEntity> = interface(IIterableList<T>)
    ['{28FA04C4-948B-444A-A026-F81062A64F59}']
    function ItemByID(const Id: IObjectID): T;
  end;

  TEntityList<T: IEntity> = class(TIterableList<T>, IEntityList<T>)
  public
    function ItemByID(const Id: IObjectID): T;
    class function New: IEntityList<T>;
  end;

implementation

function TEntity.Id: IObjectID;
begin
  Result := _Id;
end;

function TEntity.HasId: Boolean;
begin
  Result := Assigned(_Id);
end;

procedure TEntity.UpdateId(const Id: IObjectID);
begin
  _Id := Id;
end;

constructor TEntity.Create(const Id: IObjectID);
begin
  _Id := Id;
end;

class function TEntity.New(const Id: IObjectID): IEntity;
begin
  Result := Create(Id);
end;

class function TEntity.NewWithoutId: IEntity;
begin
  Result := Create(nil);
end;

{ TEntityList<T> }

function TEntityList<T>.ItemByID(const Id: IObjectID): T;
var
  Item: T;
begin
  Result := nil;
  for Item in Self do
    if Item.Id.IsEqual(Id) then
      Exit(Item);
end;

class function TEntityList<T>.New: IEntityList<T>;
begin
  Result := Create;
end;

end.
