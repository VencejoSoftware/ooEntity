unit DescriptableEntity;

interface

uses
  EntityFactory,
  ObjectID,
  Entity;

type
  IDescriptableEntity = interface(IEntity)
    ['{1C6EB6A9-0C69-4910-A916-046A98109F77}']
    function Title: String;
    function Description: String;
  end;

  TDescriptableEntity = class sealed(TInterfacedObject, IDescriptableEntity)
  strict private
    _Entity: IEntity;
    _Title, _Description: String;
  public
    function Id: IObjectID;
    procedure UpdateId(const Id: IObjectID);
    function Title: String;
    function Description: String;
    constructor Create(const Entity: IEntity; const Title, Description: String);
    class function New(const Entity: IEntity; const Title, Description: String): IDescriptableEntity;
    class function NewById(const Id: IObjectID; const Title, Description: String): IDescriptableEntity;
    class function NewWithOutID(const Title, Description: String): IDescriptableEntity;
  end;

  IDescriptableEntityList<T: IDescriptableEntity> = interface(IEntityList<T>)
    ['{5EBBAB03-028C-4B59-A057-FC975B514980}']
  end;

  TDescriptableEntityList<T: IDescriptableEntity> = class(TEntityList<T>, IDescriptableEntityList<T>)
  public
    class function New: IDescriptableEntityList<T>;
  end;

implementation

function TDescriptableEntity.Id: IObjectID;
begin
  Result := _Entity.Id;
end;

procedure TDescriptableEntity.UpdateId(const Id: IObjectID);
begin
  _Entity.UpdateId(Id);
end;

function TDescriptableEntity.Description: String;
begin
  Result := _Description;
end;

function TDescriptableEntity.Title: String;
begin
  Result := _Title;
end;

constructor TDescriptableEntity.Create(const Entity: IEntity; const Title, Description: String);
begin
  _Entity := Entity;
  _Title := Title;
  _Description := Description;
end;

class function TDescriptableEntity.New(const Entity: IEntity; const Title, Description: String): IDescriptableEntity;
begin
  Result := Create(Entity, Title, Description);
end;

class function TDescriptableEntity.NewById(const Id: IObjectID; const Title, Description: String): IDescriptableEntity;
begin
  Result := Create(TEntity.New(Id), Title, Description);
end;

class function TDescriptableEntity.NewWithOutID(const Title, Description: String): IDescriptableEntity;
begin
  Result := TDescriptableEntity.Create(TEntity.New(nil), Title, Description);
end;

{ TDescriptableEntityList<T> }

class function TDescriptableEntityList<T>.New: IDescriptableEntityList<T>;
begin
  Result := Create;
end;

end.
