unit Identificable;

interface

type
  TCode = NativeInt;

  IIdentificable = interface
    ['{128BFEEB-2CD6-40CE-B2C3-94EDE66A7EC7}']
    function Code: TCode;
    procedure UpdateCode(const Code: TCode);
  end;

  TIdentificable = class sealed(TInterfacedObject, IIdentificable)
  const
    NULL_CODE = - 1;
  strict private
    _Code: TCode;
  public
    function Code: TCode;
    procedure UpdateCode(const Code: TCode);
    constructor Create(const Code: TCode);
    class function New(const Code: TCode): IIdentificable;
    class function NewNulled: IIdentificable;
  end;

implementation

function TIdentificable.Code: TCode;
begin
  Result := _Code;
end;

procedure TIdentificable.UpdateCode(const Code: TCode);
begin
  _Code := Code;
end;

constructor TIdentificable.Create(const Code: TCode);
begin
  UpdateCode(Code);
end;

class function TIdentificable.New(const Code: TCode): IIdentificable;
begin
  Result := TIdentificable.Create(Code);
end;

class function TIdentificable.NewNulled: IIdentificable;
begin
  Result := TIdentificable.New(NULL_CODE);
end;

end.
