program Day12;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  Types,
  System.SysUtils;

function PartA(AData : string): string;
var
  Total: Integer;
  X, Y : Integer;
  Degrees: Integer;
begin
  Total := 0;
  var ADataArray := AData.Split([#13#10]);
  X := 0;
  Y := 0;
  Degrees := 90;
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var Instruction := ADataArray[I][1];
    var Value := ADataArray[I].Substring(1).ToInteger;
    if Instruction = 'F' then
    begin
      if Degrees = 0 then
        Instruction := 'N';
      if Degrees = 90 then
        Instruction := 'E';
      if Degrees = 180 then
        Instruction := 'S';
      if Degrees = 270 then
        Instruction := 'W';
    end;

    if Instruction = 'N' then
    begin
      Inc(Y, Value);
    end else if Instruction = 'S' then
    begin
      Inc(Y, -Value);
    end else if Instruction = 'E' then
    begin
      Inc(X, Value);
    end else if Instruction = 'W' then
    begin
      Inc(X, -Value);
    end else if Instruction = 'R' then
    begin
      Degrees := (Degrees + Value) mod 360;
    end else if Instruction = 'L' then
    begin
      Degrees := (Degrees + 360 - Value) mod 360;
    end;
  end;
  Total := Abs(X) + Abs(Y);
  Result := Total.ToString;
end;


function PartB(AData : string): string;
var
  Total: Integer;
  X, Y : Integer;
  Waypoint : TPoint;
  Degrees: Integer;
begin
  Total := 0;
  var ADataArray := AData.Split([#13#10]);
  X := 0;
  Y := 0;
  Degrees := 90;
  Waypoint.X := 10;
  Waypoint.Y := 1;

  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var Instruction := ADataArray[I][1];
    var Value := ADataArray[I].Substring(1).ToInteger;

    if Instruction = 'N' then
    begin
      Inc(Waypoint.Y, Value);
    end else if Instruction = 'S' then
    begin
      Inc(Waypoint.Y, -Value);
    end else if Instruction = 'E' then
    begin
      Inc(Waypoint.X, Value);
    end else if Instruction = 'W' then
    begin
      Inc(Waypoint.X, -Value);
    end else if Instruction = 'R' then
    begin
      while Value > 0 do
      begin
        var TmpX := Waypoint.X;
        Waypoint.X := Waypoint.Y;
        Waypoint.Y := -TmpX;
        Inc(Value, -90)
      end;
    end else if Instruction = 'L' then
    begin
      while Value > 0 do
      begin
        var TmpX := Waypoint.X;
        Waypoint.X := -Waypoint.Y;
        Waypoint.Y := TmpX;
        Inc(Value, -90)
      end;
    end else if Instruction = 'F' then
    begin
      Inc(X, Value*Waypoint.X);
      Inc(Y, Value*Waypoint.Y);
    end;
  end;
  Total := Abs(X) + Abs(Y);
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day12Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day12.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day12Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day12.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
