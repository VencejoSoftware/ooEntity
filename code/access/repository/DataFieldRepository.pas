unit DataFieldRepository;

interface

uses
  DataField;

type
  IDataFieldRepository = interface
    ['{3A9E5862-A1F1-4703-AC96-D7EC1FE90CFA}']
    function GetFields(const DataObjectName: String): IDataFieldList;
  end;

implementation

end.
