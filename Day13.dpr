program Day13;

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
  MinTime: Integer;
  StartTime: Integer;
  EarliestBus: Integer;
begin
  Total := 0;
  EarliestBus := 0;

  var ADataArray := AData.Split([#13#10]);
  StartTime := ADataArray[0].ToInteger;
  MinTime := Integer.MaxValue;
  for var Tmp in ADataArray[1].split([',']) do
  begin
    if Tmp <> 'x' then
    begin
      var Bus := StrToInt(Tmp);
      var TmpTime := ((StartTime div Bus) + 1) * Bus;
      if TmpTime < MinTime then
      begin
        EarliestBus := Bus;
        MinTime := TmpTime;
      end;
    end;
  end;

  Total := (MinTime-StartTime) * EarliestBus ;
  Result := Total.ToString;
end;

function greatestCommonDivisor(a, b: Int64): Int64;
var
  temp: Int64;
begin
  while b <> 0 do
  begin
    temp := b;
    b := a mod b;
    a := temp
  end;
  result := a
end;

function leastCommonMultiple(a, b: Int64): Int64;
begin
  result := b * (a div greatestCommonDivisor(a, b));
end;

function PartB(AData : string): string;
var
  Total: Int64;
  MinTime: Int64;
  StartTime: Int64;
  EarliestBus: Int64;

  BusList: TList<TPair<Int64, Int64>>;
begin
  Total := 0;
  EarliestBus := 0;

  var ADataArray := AData.Split([#13#10]);
  MinTime := Int64.MaxValue;
  var I := 0;

  BusList := TList<TPair<Int64, Int64>>.Create;
  try
    for var Tmp in ADataArray[1].split([',']) do
    begin
      if Tmp <> 'x' then
      begin
        var BusNumber := StrToInt64(Tmp);
        BusList.Add(TPair<Int64, Int64>.Create(BusNumber, I));
      end;
     Inc(I);
    end;

    StartTime := 0;
    var Interval := BusList.First.Key;
    var RightTime := False;
    while not RightTime do
    begin
      for var Bus in BusList do
      begin
        while True do
        begin
          if (StartTime + Bus.Value) mod Bus.Key = 0 then
          begin
            Interval := leastCommonMultiple(Interval, Bus.Key);
            break;
          end;

          Inc(StartTime, Interval);
        end;
        var Delay := (StartTime + Bus.Value) mod Bus.Key;
        if Delay <> 0 then
        begin
          RightTime := False;
          Break;
        end else begin
          RightTime := True;
        end;
      end;
    end;
  finally
    BusList.Free;
  end;

  Total := StartTime;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day13Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day13.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day13Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day13.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
