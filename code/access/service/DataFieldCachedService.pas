unit DataFieldCachedService;

interface

uses
  Classes, SysUtils,
  EntityCached,
  DataField, DataFieldService;

type
  TDataFieldCachedService = class sealed(TInterfacedObject, IDataFieldService)
  strict private
    _Service: IDataFieldService;
    _Queries: IEntityQueryCachedList<IDataFieldList>;
  public
    function GetFields(const DataObjectName: String): IDataFieldList;
    constructor Create(const Service: IDataFieldService; const SecondsToExpire: NativeUInt);
    class function New(const Service: IDataFieldService; const SecondsToExpire: NativeUInt = TCacheExpireLevel.A_DAY)
      : IDataFieldService;
  end;

implementation

function TDataFieldCachedService.GetFields(const DataObjectName: String): IDataFieldList;
begin
  Result := _Queries.ItemByFilter(DataObjectName);
  if not Assigned(Result) then
  begin
    Result := _Service.GetFields(DataObjectName);
    if Result.Count > 0 then
      _Queries.Add(DataObjectName, Result);
  end;
end;

constructor TDataFieldCachedService.Create(const Service: IDataFieldService; const SecondsToExpire: NativeUInt);
begin
  _Service := Service;
  _Queries := TEntityQueryCachedList<IDataFieldList>.New(SecondsToExpire);
end;

class function TDataFieldCachedService.New(const Service: IDataFieldService; const SecondsToExpire: NativeUInt)
  : IDataFieldService;
begin
  Result := Create(Service, SecondsToExpire);
end;

end.
