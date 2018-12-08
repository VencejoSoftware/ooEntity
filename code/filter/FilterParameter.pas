{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit FilterParameter;

interface

uses
  SysUtils,
  Nullable;

type
  EParameter = class(Exception)
  end;

  ICriteriaStatement = interface
    ['{84C9EBAF-BB41-4D3B-BF4F-8483ABAC434E}']
    function Name: String;
    function Expression: String;
    function IsReplaceable: Boolean;
    function IsEmpty: Boolean;
  end;


// TParameter<T> = class sealed(TInterfacedObject, IParameter<T>)
// strict private
// _Name: String;
// _Value: TNullable<T>;
// public
// function Name: String;
// function Value: T;
// function IsNull: Boolean;
// procedure Clear;
// constructor Create(const Name: String); overload; virtual;
// constructor Create(const Name: String; const Value: T); overload; virtual;
// class function New(const Name: String): IParameter<T>; overload;
// class function New(const Name: String; const Value: T): IParameter<T>; overload;
// end;

implementation

//
// function TParameter<T>.Name: String;
// begin
// Result := _Name;
// end;
//
// function TParameter<T>.Value: T;
// begin
// {$IFDEF FPC}
// Result := _Value.Value;
// {$ELSE}
// Result := _Value.ToType<T>;
// {$ENDIF}
// end;
//
// constructor TParameter<T>.Create(const Name: String);
// begin
// if Length(Name) < 1 then
// raise EParameter.Create('Parameter name not defined!');
// _Name := Name;
// end;
//
// procedure TParameter<T>.Clear;
// begin
// _Value.Clear;
// end;
//
// constructor TParameter<T>.Create(const Name: String; const Value: T);
// begin
// Create(Name);
// _Value := Value;
// end;
//
// function TParameter<T>.IsNull: Boolean;
// begin
// Result := _Value.IsEmpty;
// end;
//
// class function TParameter<T>.New(const Name: String): IParameter<T>;
// begin
// Result := Create(Name);
// end;
//
// class function TParameter<T>.New(const Name: String; const Value: T): IParameter<T>;
// begin
// Result := Create(Name, Value);
// end;

end.
