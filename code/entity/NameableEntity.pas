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

  TNameableEntity = class(TEntity, INameableEntity)
  strict private
    _Name: IObjectName;
  public
    function Name: IObjectName;
    constructor Create(const ID: IObjectId; const Name: IObjectName); reintroduce; virtual;
    class function New<T: INameableEntity>(const ID: IObjectId; const Name: IObjectName): T; overload;
    class function New(const ID: IObjectId; const Name: IObjectName): INameableEntity; overload;
    class function NewWithOutID<T: INameableEntity>(const Name: IObjectName): T; overload;
    class function NewWithOutID(const Name: IObjectName): INameableEntity; overload;
    class function NewByCode<T: INameableEntity>(const Code: Integer): T; overload;
    class function NewByCode(const Code: Integer): INameableEntity; overload;
  end;

  INameableEntityList<T: INameableEntity> = interface(IEntityList<T>)
    ['{0959711E-9426-416E-9C98-4E4A3F9BC876}']
  end;

  TNameableEntityList<T: INameableEntity> = class(TEntityList<T>, INameableEntityList<T>)
  public
    class function New: INameableEntityList<T>;
  end;

implementation

function TNameableEntity.Name: IObjectName;
begin
  Result := _Name;
end;

constructor TNameableEntity.Create(const ID: IObjectId; const Name: IObjectName);
begin
  inherited Create(ID);
  _Name := Name;
end;

class function TNameableEntity.New<T>(const ID: IObjectId; const Name: IObjectName): T;
var
  NameableEntity: INameableEntity;
begin
  NameableEntity := Create(ID, Name);
  Result := T(NameableEntity);
end;

class function TNameableEntity.New(const ID: IObjectId; const Name: IObjectName): INameableEntity;
begin
  Result := Create(ID, Name);
end;

class function TNameableEntity.NewByCode(const Code: Integer): INameableEntity;
begin
  Result := New(TObjectID.New(Code), nil);
end;

class function TNameableEntity.NewByCode<T>(const Code: Integer): T;
begin
  Result := New<T>(TObjectID.New(Code), TObjectName.NewEmpty);
end;

class function TNameableEntity.NewWithOutID(const Name: IObjectName): INameableEntity;
begin
  Result := New(nil, Name);
end;

class function TNameableEntity.NewWithOutID<T>(const Name: IObjectName): T;
begin
  Result := New<T>(nil, Name);
end;

{ TNameableEntityList<T> }

class function TNameableEntityList<T>.New: INameableEntityList<T>;
begin
  Result := Create;
end;

end.
