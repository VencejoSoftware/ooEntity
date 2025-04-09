unit DataSort;

interface

uses
  Field,
  IterableList;

type
  TDataSortOrder = (Natural, Ascending, Descending);

  IDataSort = interface
    ['{B262B96A-4B50-400D-AD67-9C8397E6CEFC}']
    function Field: IField;
    function Order: TDataSortOrder;
  end;

  TDataSort = class sealed(TInterfacedObject, IDataSort)
  strict private
    _Field: IField;
    _Order: TDataSortOrder;
  public
    function Field: IField;
    function Order: TDataSortOrder;
    constructor Create(const Field: IField; const Order: TDataSortOrder);
    class function New(const Field: IField; const Order: TDataSortOrder): IDataSort;
  end;

  IDataSortList = interface(IIterableList<IDataSort>)
    ['{2E28FB64-6755-480A-9E74-0085A2D0959C}']
  end;

  TDataSortList = class sealed(TIterableList<IDataSort>, IDataSortList)
  public
    class function New: IDataSortList;
  end;

implementation

{ TDataSort }

function TDataSort.Field: IField;
begin
  Result := _Field;
end;

function TDataSort.Order: TDataSortOrder;
begin
  Result := _Order;
end;

constructor TDataSort.Create(const Field: IField; const Order: TDataSortOrder);
begin
  _Field := Field;
  _Order := Order;
end;

class function TDataSort.New(const Field: IField; const Order: TDataSortOrder): IDataSort;
begin
  Result := Create(Field, Order);
end;

{ TDataSortList }

class function TDataSortList.New: IDataSortList;
begin
  Result := Create;
end;

end.
