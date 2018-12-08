unit Nameable;

interface

uses
  Identificable;

type
  INameable = interface
    ['{6DFA468A-9C5F-400D-A412-0016329E6A85}']
    function ID: IIdentificable;
    function Name: String;
  end;

  TNameable = class sealed(TInterfacedObject, INameable)
  strict private
    _Identificable: IIdentificable;
    _Name: String;
  public
    function ID: IIdentificable;
    function Name: String;
    constructor Create(const Identificable: IIdentificable; const Name: String);
    class function New(const Identificable: IIdentificable; const Name: String): INameable;
    class function NewByCode(const Code: TCode; const Name: String = ''): INameable;
  end;

implementation

function TNameable.ID: IIdentificable;
begin
  Result := _Identificable;
end;

function TNameable.Name: String;
begin
  Result := _Name;
end;

constructor TNameable.Create(const Identificable: IIdentificable; const Name: String);
begin
  _Identificable := Identificable;
  _Name := Name;
end;

class function TNameable.New(const Identificable: IIdentificable; const Name: String): INameable;
begin
  Result := TNameable.Create(Identificable, Name);
end;

class function TNameable.NewByCode(const Code: TCode; const Name: String): INameable;
begin
  Result := TNameable.Create(TIdentificable.New(Code), Name);
end;

end.
