unit EntityCachedService;

interface

uses
  SysUtils,
  ObjectId,
  EntityCached,
  Entity, EntityService;

type
  IEntityCachedService<I: IEntity; IL: IEntityList<I> { } > = interface(IEntityService<I, IL>)
    ['{85EC1F7F-825A-45AA-825E-8C25FA1B0882}']
    procedure Invalidate;
  end;

  TEntityCachedService<I: IEntity; IL: IEntityList<I> { } > = class(TInterfacedObject, IEntityService<I, IL>)
  strict private
  type
    TCacheUpdateState = (Created, Updated, Deleted);
  strict private
    _Service: IEntityService<I, IL>;
    _CachedList: IEntityCachedList<I>;
    _Queries: IEntityQueryCachedList<IL>;
  private
    function EntityComparator(const Code: WideString; const Entity: I): Boolean;
    procedure UpdateCachedQueryList(const Entity: I; const UpdateState: TCacheUpdateState);
  protected
    function CachedList: IEntityCachedList<I>;
    function Queries: IEntityQueryCachedList<IL>;
    function Service: IEntityService<I, IL>;
    function SanitizeCacheKey(const CacheKey: String): String;
    procedure CopyList(const Source, Destination: IL);
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
    procedure Invalidate;
    constructor Create(const Service: IEntityService<I, IL>; const SecondsToExpire: NativeUInt); virtual;
    class function New(const Service: IEntityService<I, IL>;
      const SecondsToExpire: NativeUInt = TCacheExpireLevel.A_DAY): IEntityService<I, IL>;
  end;

implementation

function TEntityCachedService<I, IL>.SanitizeCacheKey(const CacheKey: String): String;
begin
  Result := StringReplace(CacheKey, ' ', EmptyStr, [rfReplaceAll]);
end;

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

procedure TEntityCachedService<I, IL>.UpdateCachedQueryList(const Entity: I; const UpdateState: TCacheUpdateState);
var
  CachedList: IL;
  ExistingItem: I;
  ItemIndex: NativeUInt;
begin
  CachedList := _Queries.ItemByFilter(EmptyWideStr);
  if Assigned(CachedList) then
    case UpdateState of
      TCacheUpdateState.Created:
        CachedList.Add(Entity);
      TCacheUpdateState.Updated:
        begin
          ExistingItem := CachedList.ItemById(Entity.ID);
          ItemIndex := CachedList.IndexOf(ExistingItem);
          CachedList.ChangeItemByIndex(ItemIndex, Entity);
        end;
      TCacheUpdateState.Deleted:
        begin
          ExistingItem := CachedList.ItemById(Entity.ID);
          if Assigned(ExistingItem) then
            CachedList.Remove(ExistingItem);
        end;
    end;
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

function TEntityCachedService<I, IL>.ExistsById(const ID: IObjectId): Boolean;
begin
  Result := _Service.ExistsById(ID);
end;

function TEntityCachedService<I, IL>.Remove(const Entity: I): Boolean;
begin
  Result := _Service.Remove(Entity);
  _CachedList.Remove(IntToStr(Entity.ID.Value));
  UpdateCachedQueryList(Entity, TCacheUpdateState.Deleted);
end;

function TEntityCachedService<I, IL>.Update(const Entity: I): I;
begin
  Result := _Service.Update(Entity);
  _CachedList.Remove(IntToStr(Entity.ID.Value));
  _CachedList.Add(Result);
  UpdateCachedQueryList(Result, TCacheUpdateState.Updated);
end;

function TEntityCachedService<I, IL>.Insert(const Entity: I): I;
begin
  Result := _Service.Insert(Entity);
  _CachedList.Add(Result);
  UpdateCachedQueryList(Result, TCacheUpdateState.Created);
end;

function TEntityCachedService<I, IL>.Save(const Entity: I): I;
begin
  Result := _Service.Save(Entity);
  _CachedList.Remove(IntToStr(Entity.ID.Value));
  _CachedList.Add(Result);
  UpdateCachedQueryList(Result, TCacheUpdateState.Updated);
end;

function TEntityCachedService<I, IL>.InsertMany(const List: IL): Boolean;
begin
  Result := _Service.InsertMany(List);
  // TODO: Implement
end;

function TEntityCachedService<I, IL>.UpdateMany(const List: IL): Boolean;
begin
  Result := _Service.UpdateMany(List);
  // TODO: Implement
end;

function TEntityCachedService<I, IL>.SaveMany(const List: IL): Boolean;
begin
  Result := _Service.SaveMany(List);
  // TODO: Implement
end;

function TEntityCachedService<I, IL>.Service: IEntityService<I, IL>;
begin
  Result := _Service;
end;

function TEntityCachedService<I, IL>.EntityComparator(const Code: WideString; const Entity: I): Boolean;
begin
  Result := SameText(Code, IntToStr(Entity.ID.Value));
end;

procedure TEntityCachedService<I, IL>.Invalidate;
begin
  _CachedList.Invalidate;
  _Queries.Invalidate;
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
