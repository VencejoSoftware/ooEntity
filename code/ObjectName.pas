unit ObjectName;

interface

uses
  SysUtils;

type
  IObjectName = interface
    ['{38C59B6F-99FF-488E-9E38-618DE0CD4EA2}']
    function Text: WideString;
  end;

  TObjectName = class sealed(TInterfacedObject, IObjectName)
  strict private
    _Text: WideString;
  public
    function Text: WideString;
    constructor Create(const Text: WideString);
    class function New(const Text: WideString): IObjectName;
    class function NewEmpty: IObjectName;
  end;

implementation

function TObjectName.Text: WideString;
begin
  Result := _Text;
end;

constructor TObjectName.Create(const Text: WideString);
begin
  _Text := Text;
end;

class function TObjectName.New(const Text: WideString): IObjectName;
begin
  Result := Create(Text);
end;

class function TObjectName.NewEmpty: IObjectName;
begin
  Result := Create(EmptyStr);
end;

end.
