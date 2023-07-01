unit EntityCachedService;

interface

uses
  SysUtils,
  ObjectId,
  EntityCached,
  Entity, EntityService;

type
  TEntityCachedService<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityService<I, IL>)
  strict private
    _Service: IEntityService<I, IL>;
    _CachedList: IEntityCachedList<I>;
    _Queries: IEntityQueryCachedList<IL>;
  private
    function EntityComparator(const Code: WideString; const Entity: I): Boolean;
  protected
    function CachedList: IEntityCachedList<I>;
    function Queries: IEntityQueryCachedList<IL>;
    function Service: IEntityService<I, IL>;
    procedure CopyList(const Source, Destination: IL);
  public
    function GetOne(const ID: IObjectId): I;
    function GetMany(const List: IL): Boolean;
    function Exists(const Entity: I): Boolean;
    function Remove(const Entity: I): Boolean;
    function Update(const Entity: I): Boolean;
    function Insert(const Entity: I): Boolean;
    function Save(const Entity: I): Boolean;
    constructor Create(const Service: IEntityService<I, IL>; const SecondsToExpire: NativeUInt); virtual;
    class function New(const Service: IEntityService<I, IL>;
      const SecondsToExpire: NativeUInt = TCacheExpireLevel.A_DAY): IEntityService<I, IL>;
  end;

implementation

function TEntityCachedService<I, IL>.GetOne(const ID: IObjectId): I;
begin
  Result := I(_CachedList.ItemByCode(IntToStr(ID.Value)));
  if not Assigned(Result) then
  begin
    Result := I(_Service.GetOne(ID));
    if Assigned(Result) then
      _CachedList.Add(Result);
  end;
end;

function TEntityCachedService<I, IL>.CachedList: IEntityCachedList<I>;
begin
  Result := _CachedList;
end;

function TEntityCachedService<I, IL>.Queries: IEntityQueryCachedList<IL>;
begin
  Result := _Queries;
end;

procedure TEntityCachedService<I, IL>.CopyList(const Source, Destination: IL);
var
  I: Integer;
begin
  Destination.Clear;
  for I := 0 to Pred(Source.Count) do
    Destination.Add(Source.Items[I]);
end;

function TEntityCachedService<I, IL>.GetMany(const List: IL): Boolean;
var
  CachedList: IL;
begin
  CachedList := _Queries.ItemByFilter(EmptyWideStr);
  if Assigned(CachedList) then
    CopyList(CachedList, List)
  else
  begin
    _Service.GetMany(List);
    if List.Count > 0 then
    begin
      CachedList := IL(TEntityList<I>.New);
      CopyList(List, CachedList);
      _Queries.Add(EmptyWideStr, CachedList);
    end;
  end;
  Result := List.Count > 0;
end;

function TEntityCachedService<I, IL>.Exists(const Entity: I): Boolean;
begin
  Result := _Service.Exists(Entity);
end;

function TEntityCachedService<I, IL>.Remove(const Entity: I): Boolean;
begin
  Result := _Service.Remove(Entity);
  _CachedList.Remove(IntToStr(Entity.ID.Value));
end;

function TEntityCachedService<I, IL>.Update(const Entity: I): Boolean;
begin
  Result := _Service.Update(Entity);
end;

function TEntityCachedService<I, IL>.Insert(const Entity: I): Boolean;
begin
  Result := _Service.Insert(Entity);
end;

function TEntityCachedService<I, IL>.Save(const Entity: I): Boolean;
begin
end;

function TEntityCachedService<I, IL>.Service: IEntityService<I, IL>;
begin
  Result := _Service;
end;

function TEntityCachedService<I, IL>.EntityComparator(const Code: WideString; const Entity: I): Boolean;
begin
  Result := SameText(Code, IntToStr(Entity.ID.Value));
end;

constructor TEntityCachedService<I, IL>.Create(const Service: IEntityService<I, IL>; const SecondsToExpire: NativeUInt);
begin
  _Service := Service;
  _CachedList := TEntityCachedList<I>.New(EntityComparator, SecondsToExpire);
  _Queries := TEntityQueryCachedList<IL>.New(SecondsToExpire);
end;

class function TEntityCachedService<I, IL>.New(const Service: IEntityService<I, IL>;
  const SecondsToExpire: NativeUInt = TCacheExpireLevel.A_DAY): IEntityService<I, IL>;
begin
  Result := Create(Service, SecondsToExpire);
end;

end.
