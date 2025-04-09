unit DataSortSyntax;

interface

uses
  SysUtils,
  DataSort, DataSortTemplate;

type
  IDataSortSyntax = interface
    ['{E552B2B0-C629-4E0A-B02F-8423A96B503F}']
    function Parse(const DataSort: IDataSort): string;
  end;

  TDataSortSyntax = class sealed(TInterfacedObject, IDataSortSyntax)
  strict private
    _DataSortTemplate: IDataSortTemplate;
  public
    function Parse(const DataSort: IDataSort): string;
    constructor Create(const DataSortTemplate: IDataSortTemplate);
    class function New(const DataSortTemplate: IDataSortTemplate): IDataSortSyntax;
  end;

implementation

function TDataSortSyntax.Parse(const DataSort: IDataSort): string;
var
  Template: string;
begin
  Template := _DataSortTemplate.Template(DataSort);
  Result := Format(Template, [DataSort.Field.Name]);
end;

constructor TDataSortSyntax.Create(const DataSortTemplate: IDataSortTemplate);
begin
  _DataSortTemplate := DataSortTemplate;
end;

class function TDataSortSyntax.New(const DataSortTemplate: IDataSortTemplate): IDataSortSyntax;
begin
  Result := Create(DataSortTemplate);
end;

end.
