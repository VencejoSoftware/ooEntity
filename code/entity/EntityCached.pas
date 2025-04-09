unit EntityCached;

interface

uses
  SysUtils, DateUtils,
  System.RTTI,
  Generics.Collections;

type
  TCacheExpireLevel = record
  const
    TEN_SECONDS = 10;
    HALF_MINUTE = 30;
    A_MINUTE = 60;
    FIVE_MINUTES = 300;
    TEN_MINUTES = 600;
    HALF_AN_HOUR = 1800;
    AN_HOUR = 3600;
    HALF_DAY = 43200;
    A_DAY = 86400;
    A_WEEK = 604800;
    A_MONTH = 2.628E+6;
    A_YEAR = 3.154E+7;
  end;

  IEntityCached<T> = interface
    ['{8D535462-BFB1-4BCD-80E7-F2E91FE5B8C9}']
    function Entity: T;
    function IsExpired: Boolean;
  end;

  TEntityCached<T> = class sealed(TInterfacedObject, IEntityCached<T>)
  strict private
    _Entity: T;
    _ExpirationTime: TDateTime;
  public
    function Entity: T;
    function IsExpired: Boolean;
    constructor Create(const Entity: T; const SecondsToExpire: NativeUInt);
    class function New(const Entity: T; const SecondsToExpire: NativeUInt): IEntityCached<T>;
  end;

  IEntityCachedList<T> = interface
    ['{C48A4A43-799B-4972-A9B1-0FF706FC94DE}']
    function Add(const Entity: T): Integer;
    function ItemByCode(const Code: WideString): T;
    function Update(const Code: WideString; const Entity: T): Boolean;
    procedure Remove(const Code: WideString);
    procedure Invalidate;
  end;

  TEntityCachedList<T> = class(TInterfacedObject, IEntityCachedList<T>)
  type
    TEntityComparator = reference to function(const Code: WideString; const Entity: T): Boolean;
    TEntityList = TList<IEntityCached<T>>;
  strict private
    _Comparator: TEntityComparator;
    _SecondsToExpire: NativeUInt;
    _List: TEntityList;
    function EntityCachedByCode(const Code: WideString): IEntityCached<T>;
    function IsAssignedEntity(const Entity: T): Boolean;
  public
    function Add(const Entity: T): Integer;
    function ItemByCode(const Code: WideString): T;
    function Update(const Code: WideString; const Entity: T): Boolean;
    procedure Remove(const Code: WideString);
    procedure Invalidate;
    constructor Create(const Comparator: TEntityComparator; const SecondsToExpire: NativeUInt);
    destructor Destroy; override;
    class function New(const Comparator: TEntityComparator; const SecondsToExpire: NativeUInt): IEntityCachedList<T>;
  end;

  IEntityQueryCached<T> = interface
    ['{33EA76E8-AAEB-4C9E-A24D-FBF016068D65}']
    function Filter: WideString;
    function List: T;
    function IsExpired: Boolean;
  end;

  TEntityQueryCached<T> = class sealed(TInterfacedObject, IEntityQueryCached<T>)
  strict private
    _Filter: WideString;
    _List: T;
    _ExpirationTime: TDateTime;
  public
    function Filter: WideString;
    function List: T;
    function IsExpired: Boolean;
    constructor Create(const Filter: WideString; const List: T; const SecondsToExpire: NativeUInt);
    destructor Destroy; override;
    class function New(const Filter: WideString; const List: T; const SecondsToExpire: NativeUInt)
      : IEntityQueryCached<T>;
  end;

  IEntityQueryCachedList<T> = interface
    ['{BBB46A3D-2C4A-4395-BAD4-73238B55D0D4}']
    function Add(const Filter: WideString; const List: T): Integer;
    function ItemByFilter(const Filter: WideString): T;
    procedure Invalidate;
  end;

  TEntityQueryCachedList<T> = class(TInterfacedObject, IEntityQueryCachedList<T>)
  type
    TQueryList = TList<IEntityQueryCached<T>>;
  strict private
    _List: TQueryList;
    _SecondsToExpire: NativeUInt;
  public
    function Add(const Filter: WideString; const List: T): Integer;
    function ItemByFilter(const Filter: WideString): T;
    procedure Invalidate;
    constructor Create(const SecondsToExpire: NativeUInt);
    destructor Destroy; override;
    class function New(const SecondsToExpire: NativeUInt): IEntityQueryCachedList<T>;
  end;

implementation

{ TEntityCached<T> }

function TEntityCached<T>.Entity: T;
begin
  Result := _Entity;
end;

function TEntityCached<T>.IsExpired: Boolean;
begin
  Result := _ExpirationTime <= Now;
end;

constructor TEntityCached<T>.Create(const Entity: T; const SecondsToExpire: NativeUInt);
begin
  _Entity := Entity;
  _ExpirationTime := IncSecond(Now, SecondsToExpire);
end;

class function TEntityCached<T>.New(const Entity: T; const SecondsToExpire: NativeUInt): IEntityCached<T>;
begin
  Result := TEntityCached<T>.Create(Entity, SecondsToExpire);
end;

{ TEntityCachedList<T> }

function TEntityCachedList<T>.Add(const Entity: T): Integer;
begin
  Result := _List.Add(TEntityCached<T>.New(Entity, _SecondsToExpire));
end;

function TEntityCachedList<T>.EntityCachedByCode(const Code: WideString): IEntityCached<T>;
var
  Item: IEntityCached<T>;
begin
  Result := nil;
  for Item in _List do
    if _Comparator(Code, Item.Entity) then
      if Item.IsExpired then
      begin
        _List.Remove(Item);
        Break;
      end
      else
        Exit(Item);
end;

function TEntityCachedList<T>.ItemByCode(const Code: WideString): T;
var
  Item: IEntityCached<T>;
begin
  Item := EntityCachedByCode(Code);
  if Assigned(Item) then
    Result := Item.Entity
  else
    Result := Default (T);
end;

function TEntityCachedList<T>.IsAssignedEntity(const Entity: T): Boolean;
var
  CastedObject: TValue;
begin
  Result := False;
  CastedObject := TValue.From<T>(Entity);
  if CastedObject.IsObject then
    Result := CastedObject.AsObject <> nil;
end;

function TEntityCachedList<T>.Update(const Code: WideString; const Entity: T): Boolean;
var
  Item: IEntityCached<T>;
begin
  Item := EntityCachedByCode(Code);
  if Assigned(Item) then
    _List.Remove(Item);
  if IsAssignedEntity(Entity) then
    Add(Entity);
end;

procedure TEntityCachedList<T>.Remove(const Code: WideString);
var
  Item: IEntityCached<T>;
begin
  Item := EntityCachedByCode(Code);
  if Assigned(Item) then
    _List.Remove(Item);
end;

procedure TEntityCachedList<T>.Invalidate;
begin
  _List.Clear;
end;

constructor TEntityCachedList<T>.Create(const Comparator: TEntityComparator; const SecondsToExpire: NativeUInt);
begin
  _Comparator := Comparator;
  _SecondsToExpire := SecondsToExpire;
  _List := TEntityList.Create;
end;

destructor TEntityCachedList<T>.Destroy;
begin
  _List.Free;
  inherited;
end;

class function TEntityCachedList<T>.New(const Comparator: TEntityComparator; const SecondsToExpire: NativeUInt)
  : IEntityCachedList<T>;
begin
  Result := Create(Comparator, SecondsToExpire);
end;

{ TEntityQueryCached }

function TEntityQueryCached<T>.Filter: WideString;
begin
  Result := _Filter;
end;

function TEntityQueryCached<T>.IsExpired: Boolean;
begin
  Result := _ExpirationTime <= Now;
end;

function TEntityQueryCached<T>.List: T;
begin
  Result := _List;
end;

constructor TEntityQueryCached<T>.Create(const Filter: WideString; const List: T; const SecondsToExpire: NativeUInt);
begin
  _Filter := Filter;
  _List := List;
  _ExpirationTime := IncSecond(Now, SecondsToExpire);
end;

destructor TEntityQueryCached<T>.Destroy;
var
  CastedObject: TValue;
begin
  CastedObject := TValue.From<T>(_List);
  if CastedObject.IsObject then
    CastedObject.AsObject.Free;
  inherited;
end;

class function TEntityQueryCached<T>.New(const Filter: WideString; const List: T; const SecondsToExpire: NativeUInt)
  : IEntityQueryCached<T>;
begin
  Result := TEntityQueryCached<T>.Create(Filter, List, SecondsToExpire);
end;

{ TEntityQueryCachedList }

function TEntityQueryCachedList<T>.Add(const Filter: WideString; const List: T): Integer;
begin
  Result := _List.Add(TEntityQueryCached<T>.New(Filter, List, _SecondsToExpire));
end;

function TEntityQueryCachedList<T>.ItemByFilter(const Filter: WideString): T;
var
  Item: IEntityQueryCached<T>;
begin
  Result := Default (T);
  for Item in _List do
    if SameText(Filter, Item.Filter) then
      if Item.IsExpired then
      begin
        _List.Remove(Item);
        Break;
      end
      else
        Exit(Item.List);
end;

procedure TEntityQueryCachedList<T>.Invalidate;
begin
  _List.Clear;
end;

constructor TEntityQueryCachedList<T>.Create(const SecondsToExpire: NativeUInt);
begin
  _List := TQueryList.Create;
  _SecondsToExpire := SecondsToExpire;
end;

destructor TEntityQueryCachedList<T>.Destroy;
begin
  _List.Free;
  inherited;
end;

class function TEntityQueryCachedList<T>.New(const SecondsToExpire: NativeUInt): IEntityQueryCachedList<T>;
begin
  Result := TEntityQueryCachedList<T>.Create(SecondsToExpire);
end;

end.
