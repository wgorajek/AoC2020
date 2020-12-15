program Day14;

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

function ApplyMask(AValue: Int64; Mask: String): Int64;
begin
  var MaxMask := Round(Power(2, Mask.Length)) - 1;
  for var I := 1 to Mask.Length do
  begin
    if Mask[I] = '1' then
    begin
      AValue := AValue or Round(Power(2, Mask.Length-I));
    end else if Mask[I] = '0' then
    begin
      AValue := AValue and (MaxMask - Round(Power(2, Mask.Length-I)));
    end;
  end;
  Result := AValue;
end;

function PartA(AData : string): string;
var
  Total: Int64;
  Mask : String;
  Memory: TDictionary<Int64, Int64>;
begin
  Total := 0;

  Memory := TDictionary<Int64, Int64>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I].Remove(4) = 'mask' then
      begin
        Mask := DataArray[I].Substring(7);
      end else
      begin
        var Index := TRegEx.Match(DataArray[I], '.*\[(.*)\].*').Groups[1].Value.ToInteger;
        var Value := TRegEx.Match(DataArray[I], '.* = (.*)').Groups[1].Value.ToInteger;

        Memory.AddOrSetValue(Index, ApplyMask(Value, Mask));
      end;
    end;
    for var MemValue in Memory.Values  do
    begin
      Inc(Total, MemValue);
    end;
  finally
    Memory.Free;
  end;

  Result := Total.ToString;
end;

function GetAdressList(AIndex: Int64; Mask: String): TList<Int64>;
var TmpList: TList<Int64>;
begin
  Result := TList<Int64>.Create;
  TmpList := TList<Int64>.Create;
  try
    Result.Add(AIndex);
    var MaxMask := Round(Power(2, Mask.Length)) - 1;
    for var I := 1 to Mask.Length do
    begin
      for var Index in Result do
      begin
        if Mask[I] = '1' then
        begin
          var TmpIndex := Index or Round(Power(2, Mask.Length-I));
          if not TmpList.Contains(TmpIndex) then
            TmpList.Add(TmpIndex);
        end else if Mask[I] = '0' then
        begin
          if not TmpList.Contains(Index) then
            TmpList.Add(Index);
        end else
        begin
          var TmpIndex := Index or Round(Power(2, Mask.Length-I));
          if not TmpList.Contains(TmpIndex) then
            TmpList.Add(TmpIndex);
          TmpIndex := Index and (MaxMask - Round(Power(2, Mask.Length-I)));
          if not TmpList.Contains(TmpIndex) then
            TmpList.Add(TmpIndex);
        end;
      end;
      Result.Clear;
      Result.AddRange(TmpList);
      TmpList.Clear;
    end;
  finally
    tmpList.Free;
  end;
end;

function PartB(AData : string): string;
var
  Total: Int64;
  Mask : String;
  Memory: TDictionary<Int64, Int64>;
begin
  Total := 0;

  Memory := TDictionary<Int64, Int64>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I].Remove(4) = 'mask' then
      begin
        Mask := DataArray[I].Substring(7);
      end else
      begin
        var Index := TRegEx.Match(DataArray[I], '.*\[(.*)\].*').Groups[1].Value.ToInteger;
        var Value := TRegEx.Match(DataArray[I], '.* = (.*)').Groups[1].Value.ToInteger;

        var TmpList := GetAdressList(Index, Mask);
        for var TmpIndex in TmpList do
        begin
          Memory.AddOrSetValue(TmpIndex, Value);
        end;
        TmpList.Free;
      end;
    end;
    for var MemValue in Memory.Values  do
    begin
      Inc(Total, MemValue);
    end;
  finally
    Memory.Free;
  end;

  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day14Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day14.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day14Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day14.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
