program Day15;

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

function PartA(AData : string; ANumberOfTurns: Int64): string;
var
  Total: Int64;
  Memory: TDictionary<Int64, Int64>;
  Turn: Integer;
  LastNumber: Integer;
  LastSpoken, CurrentNumber: Integer;
begin
  Total := 0;
  CurrentNumber := 0;
  LastSpoken := 0;
  LastNumber := 0;

  Memory := TDictionary<Int64, Int64>.Create;
  try
    var DataArray := AData.Split([',']);
    Turn := 1;
    for var I := Low(DataArray) to High(DataArray) do
    begin
      Memory.AddOrSetValue(DataArray[I].ToInteger , Turn);
      Inc(Turn);
      LastNumber := DataArray[I].ToInteger;
      LastSpoken := 0;
    end;
    while Turn <= ANumberOfTurns do
    begin
      if LastSpoken = 0 then
      begin
        CurrentNumber := 0;
      end else
      begin
        CurrentNumber := Memory[LastNumber] - LastSpoken;
      end;
      if Memory.ContainsKey(CurrentNumber) then
      begin
        LastSpoken := Memory[CurrentNumber];
      end else
      begin
        LastSpoken := 0;
      end;
      Memory.AddOrSetValue(CurrentNumber, Turn);

      Inc(Turn);
      LastNumber := CurrentNumber;
    end;
    Total := CurrentNumber;
  finally
    Memory.Free;
  end;

  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day15Test.txt'), 2020));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day15.txt'), 2020));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day15Test.txt'), 30000000));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day15.txt'), 30000000));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
