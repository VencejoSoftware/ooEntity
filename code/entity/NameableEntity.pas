unit NameableEntity;

interface

uses
  Entity,
  ObjectID, ObjectName;

type
  INameableEntity = interface(IEntity)
    ['{FCB4E73D-590C-47C9-A7B5-70763D5FD277}']
    function Name: IObjectName;
  end;

  TNameableEntity = class(TInterfacedObject, INameableEntity)
  strict private
    _Entity: IEntity;
    _Name: IObjectName;
  public
    function Id: IObjectID;
    procedure UpdateId(const Id: IObjectID);
    function Name: IObjectName;
    constructor Create(const Entity: IEntity; const Name: IObjectName);
    class function New(const Entity: IEntity; const Name: IObjectName): INameableEntity; overload;
    class function NewByCode(const Code: Integer): INameableEntity; overload;
    class function NewWithOutID(const Name: IObjectName): INameableEntity; overload;
  end;

  INameableEntityList<T: INameableEntity> = interface(IEntityList<T>)
    ['{0959711E-9426-416E-9C98-4E4A3F9BC876}']
  end;

  TNameableEntityList<T: INameableEntity> = class(TEntityList<T>, INameableEntityList<T>)
  public
    class function New: INameableEntityList<T>; overload;
    class function New<I: IInterface>: I; overload;
  end;

implementation

function TNameableEntity.Id: IObjectID;
begin
  Result := _Entity.Id;
end;

procedure TNameableEntity.UpdateId(const Id: IObjectID);
begin
  _Entity.UpdateId(Id);
end;

function TNameableEntity.Name: IObjectName;
begin
  Result := _Name;
end;

constructor TNameableEntity.Create(const Entity: IEntity; const Name: IObjectName);
begin
  _Entity := Entity;
  _Name := Name;
end;

class function TNameableEntity.New(const Entity: IEntity; const Name: IObjectName): INameableEntity;
begin
  Result := Create(Entity, Name);
end;

class function TNameableEntity.NewByCode(const Code: Integer): INameableEntity;
begin
  Result := TNameableEntity.New(TEntity.New(TObjectID.New(Code)), TObjectName.NewEmpty);
end;

class function TNameableEntity.NewWithOutID(const Name: IObjectName): INameableEntity;
begin
  Result := TNameableEntity.Create(nil, Name);
end;

{ TNameableEntityList<T> }

class function TNameableEntityList<T>.New: INameableEntityList<T>;
begin
  Result := Create;
end;

class function TNameableEntityList<T>.New<I>: I;
begin
  Result := I(TNameableEntityList<T>.New);
end;

end.
