unit LoggableGenericNameableRepository;

interface

uses
  SysUtils,
  AppLog,
  NameableEntity,
  NameableRepository;

// type
// TLoggableGenericNameableRepository<I: INameableEntity; LI: INameableEntityList<I> //
// > = class(TGenericNameableRepository<I, LI>, IGenericNameableRepository<I, LI>)
// strict private
// _Repository: IGenericNameableRepository<I, LI>;
// _AppLog: IAppLog;
// public
// function GetOne(const ID: Integer): I; override;
// function GetList: LI; override;
// function Exists(const ID: Integer): Boolean; override;
// constructor Create(const Repository: IGenericNameableRepository<I, LI>; const AppLog: IAppLog);
// class function New(const Repository: IGenericNameableRepository<I, LI>; const AppLog: IAppLog)
// : IGenericNameableRepository<I, LI>;
// end;

implementation

// function TLoggableGenericNameableRepository<I, LI>.GetOne(const ID: Integer): I;
// begin
// try
// _AppLog.WriteDebug(Format('Getting one for id "%d"', [ID]), ClassName + 'GetOne');
// Result := _Repository.GetOne(ID);
// _AppLog.WriteDebug(Format('Getted one: id="%d", name="%s"', [Result.ID.Value, Result.Name.Text]),
// ClassName + 'GetOne');
// except
// on Error: Exception do
// _AppLog.ErrorByException(ClassName + 'GetOne', Error);
// end;
// end;
//
// function TLoggableGenericNameableRepository<I, LI>.GetList: LI;
// begin
// try
// _AppLog.WriteDebug('Getting list', ClassName + 'GetList');
// Result := _Repository.GetList;
// _AppLog.WriteDebug(Format('Getted list: count="%d""', [Result.Count]), ClassName + 'GetList');
// except
// on Error: Exception do
// _AppLog.ErrorByException(ClassName + 'GetOne', Error);
// end;
// end;
//
// function TLoggableGenericNameableRepository<I, LI>.Exists(const ID: Integer): Boolean;
// begin
// try
// _AppLog.WriteDebug(Format('Checking existence for id "%d"', [ID]), ClassName + 'Exists');
// Result := _Repository.Exists(ID);
// _AppLog.WriteDebug(Format('Checking existence for id "%d" return "%s"', [ID, BoolToStr(Result, True)]),
// ClassName + 'Exists');
// except
// on Error: Exception do
// _AppLog.ErrorByException(ClassName + 'Exists', Error);
// end;
// end;
//
// constructor TLoggableGenericNameableRepository<I, LI>.Create(const Repository: IGenericNameableRepository<I, LI>;
// const AppLog: IAppLog);
// begin
// _Repository := Repository;
// _AppLog := AppLog;
// end;
//
// class function TLoggableGenericNameableRepository<I, LI>.New(const Repository: IGenericNameableRepository<I, LI>;
// const AppLog: IAppLog): IGenericNameableRepository<I, LI>;
// begin
// Result := Create(Repository, AppLog);
// end;

end.
