unit DataRow;

interface

uses
  SysUtils,
  DataField,
  DataValue,
  IterableList;

type
  IDataRow = interface
    ['{9FB810F5-4322-4F66-8F7B-D04340769A58}']
    function DataFieldList: IDataFieldList;
    function DataValueList: IDataValueList;
  end;

  TDataRow = class sealed(TInterfacedObject, IDataRow)
  strict private
    _DataValueList: IDataValueList;
  private
  public
    function DataFieldList: IDataFieldList;
    function DataValueList: IDataValueList;
    constructor Create(const DataValueList: IDataValueList);
    class function New(const DataValueList: IDataValueList): IDataRow;
  end;

  IDataRowList = interface(IIterableList<IDataRow>)
    ['{93BF3389-85B9-4C48-B487-053FBB9A0C02}']
  end;

  TDataRowList = class sealed(TIterableList<IDataRow>, IDataRowList)
  public
    class function New: IDataRowList;
  end;

implementation

function TDataRow.DataValueList: IDataValueList;
begin
  Result := _DataValueList;
end;

function TDataRow.DataFieldList: IDataFieldList;
var
  Item: IDataValue;
begin
  Result := TDataFieldList.New;
  for Item in _DataValueList do
    if Assigned(Item.DataField) then
      Result.Add(Item.DataField);
end;

constructor TDataRow.Create(const DataValueList: IDataValueList);
begin
  _DataValueList := DataValueList;
end;

class function TDataRow.New(const DataValueList: IDataValueList): IDataRow;
begin
  Result := Create(DataValueList);
end;

{ TDataRowList }

class function TDataRowList.New: IDataRowList;
begin
  Result := Create;
end;

end.
