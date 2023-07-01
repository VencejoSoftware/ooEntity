unit DataFieldService;

interface

uses
  DataField, DataFieldRepository;

type
  IDataFieldService = interface
    ['{AED350C7-50FB-4C4C-85F0-F87995B492D4}']
    function GetFields(const DataObjectName: String): IDataFieldList;
  end;

  TDataFieldService = class sealed(TInterfacedObject, IDataFieldService)
  strict private
    _Repository: IDataFieldRepository;
  public
    function GetFields(const DataObjectName: String): IDataFieldList;
    constructor Create(const Repository: IDataFieldRepository);
    class function New(const Repository: IDataFieldRepository): IDataFieldService;
  end;

implementation

function TDataFieldService.GetFields(const DataObjectName: String): IDataFieldList;
begin
  Result := _Repository.GetFields(DataObjectName);
end;

constructor TDataFieldService.Create(const Repository: IDataFieldRepository);
begin
  _Repository := Repository;
end;

class function TDataFieldService.New(const Repository: IDataFieldRepository): IDataFieldService;
begin
  Result := TDataFieldService.Create(Repository);
end;

end.
