unit ObjectName;

interface

uses
  SysUtils;

type
  IObjectName = interface
    ['{38C59B6F-99FF-488E-9E38-618DE0CD4EA2}']
    function Text: string;
  end;

  TObjectName = class sealed(TInterfacedObject, IObjectName)
  strict private
    _Text: string;
  public
    function Text: string;
    constructor Create(const Text: string);
    class function New(const Text: string): IObjectName;
    class function NewEmpty: IObjectName;
  end;

implementation

function TObjectName.Text: string;
begin
  Result := _Text;
end;

constructor TObjectName.Create(const Text: string);
begin
  _Text := Text;
end;

class function TObjectName.New(const Text: string): IObjectName;
begin
  Result := TObjectName.Create(Text);
end;

class function TObjectName.NewEmpty: IObjectName;
begin
  Result := TObjectName.Create(EmptyStr);
end;

end.
