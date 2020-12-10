program Day10;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

function PartA(AData : string): string;
var Total : Integer;
begin
  var CountDiff1 := 0;
  var CountDiff3 := 0;
  var DataArray := AData.Split([#13#10]);
  var AdapterList := TList<Integer>.Create;
  try
    for var I := Low(DataArray) to High(DataArray) do
    begin
      AdapterList.Add(DataArray[I].ToInteger);
    end;
    AdapterList.Add(0);
    AdapterList.Sort;
    AdapterList.Add(AdapterList.Last + 3);
    for var I := 1 to AdapterList.Count - 1 do
    begin
      var Diffrence := AdapterList[I] - Adapterlist[I-1];
      if Diffrence = 3 then
      begin
        inc(CountDiff3);
      end else if Diffrence = 1 then
      begin
        inc(CountDiff1);
      end else if Diffrence > 3 then
      begin
        break;
      end;
    end;
  finally
    AdapterList.Free;
  end;

  Total := CountDiff1 * CountDiff3;
  Result := Total.ToString;
end;

function CountPossibleConnections(ACountDiff1: Integer): Integer;
begin
  if ACountDiff1 = 0 then
  begin
    Result := 0;
  end else if ACountDiff1 <= 2 then
  begin
    Result := 1;
  end else
  begin
    Result := CountPossibleConnections(ACountDiff1 - 3) + CountPossibleConnections(ACountDiff1 - 2) + CountPossibleConnections(ACountDiff1 - 1);
  end;
end;

function PartB(AData : string): string;
var Total : Int64;
begin
  Total := 1;
  var DataArray := AData.Split([#13#10]);
  var AdapterList := TList<Integer>.Create;
  try
    for var I := Low(DataArray) to High(DataArray) do
    begin
      AdapterList.Add(DataArray[I].ToInteger);
    end;
    AdapterList.Add(0);
    AdapterList.Sort;
    AdapterList.Add(AdapterList.Last + 3);
    var I := 0;
    while I < AdapterList.Count - 1 do
    begin
      var CountDiff1 := 0;
      while (AdapterList[I+1] - AdapterList[I] = 1) do
      begin
        Inc(CountDiff1);
        Inc(I);
      end;
      Total := Total * CountPossibleConnections(CountDiff1+1);
      Inc(I);
    end;

  finally
    AdapterList.Free;
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day10Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day10.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day10Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day10.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
