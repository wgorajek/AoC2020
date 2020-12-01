unit WGUtils;

interface

uses
    SysUtils
  ;

type

  T_WGUtils = class
    class function OpenFile(ASciezka: String): String;
  end;

implementation

uses
  StrUtils,
  Classes;

class function T_WGUtils.OpenFile(ASciezka: String): String;
var
  LPlik : TextFile;
  LBuffer : String;
begin
  Result := '';
  AssignFile(LPlik, ASciezka);
  Reset(LPlik);

  while not EOF(LPlik) do
  begin
    Readln(LPlik, LBuffer);
    Result := Result + IfThen(Result <> '', #13#10) + LBuffer;
  end;
  CloseFile(LPlik);
end;

end.
