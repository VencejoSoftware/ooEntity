unit EntityStage;

interface

uses
  SysUtils,
  IterableList,
  ObjectId, Entity;

type
  TEntityStageStatus = (None, Modified, Deleted, Inserted);

  IEntityStage<T: IEntity> = interface
    ['{0C7BBD9A-1D76-43DB-A029-99A2B78A9DC9}']
    function Content: T;
    function Status: TEntityStageStatus;
    procedure ChangeContent(const Content: T);
    procedure ChangeStatus(const Status: TEntityStageStatus);
  end;

  TEntityStage<T: IEntity> = class(TInterfacedObject, IEntityStage<T>)
  var
    _Content: T;
    _Status: TEntityStageStatus;
  public
    function Content: T;
    function Status: TEntityStageStatus;
    procedure ChangeContent(const Content: T); virtual;
    procedure ChangeStatus(const Status: TEntityStageStatus);
    constructor Create(const Content: T; const Status: TEntityStageStatus);
    class function New(const Content: T; const Status: TEntityStageStatus = TEntityStageStatus.None): IEntityStage<T>;
  end;

  IEntityStageList<T: IEntity> = interface(IIterableList < IEntityStage < T >> )
    ['{B7FDB9E8-284D-4090-9240-E94E541F2E5B}']
    procedure LoadFromList(const List: IIterableList<T>);
  end;

  TEntityStageList<T: IEntity> = class(TIterableList<IEntityStage<T>>, IEntityStageList<T>)
  public
    procedure LoadFromList(const List: IIterableList<T>); virtual;
    class function New: IEntityStageList<T>;
  end;

implementation

{ TEntityStage<T> }

function TEntityStage<T>.Content: T;
begin
  Result := _Content;
end;

function TEntityStage<T>.Status: TEntityStageStatus;
begin
  Result := _Status;
end;

procedure TEntityStage<T>.ChangeContent(const Content: T);
var
  Id: IObjectID;
begin
  if Assigned(_Content) then
    Id := _Content.Id;
  _Content := Content;
  if Assigned(Id) then
    _Content.UpdateId(Id);
  ChangeStatus(TEntityStageStatus.Modified);
end;

procedure TEntityStage<T>.ChangeStatus(const Status: TEntityStageStatus);
begin
  _Status := Status;
end;

constructor TEntityStage<T>.Create(const Content: T; const Status: TEntityStageStatus);
begin
  _Content := Content;
  _Status := Status;
end;

class function TEntityStage<T>.New(const Content: T; const Status: TEntityStageStatus): IEntityStage<T>;
begin
  Result := TEntityStage<T>.Create(Content, Status);
end;

{ TEntityStageList<T> }

procedure TEntityStageList<T>.LoadFromList(const List: IIterableList<T>);
var
  Item: T;
begin
  Clear;
  for Item in List do
    Add(TEntityStage<T>.New(Item));
end;

class function TEntityStageList<T>.New: IEntityStageList<T>;
begin
  Result := Create;
end;

end.
