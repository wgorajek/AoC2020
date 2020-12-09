program Day9;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;


function CheckIfSumExists(AXmas: TList<Int64>; AIndex: Integer): Boolean;
begin
  Result := False;
  for var I := 1 to 24 do
  begin
    for var J := I+1 to 25 do
    begin
      if AXmas[AIndex-I] + AXmas[AIndex-J] = AXmas[AIndex] then
      begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function PartA(AData : string): string;
var
  Total: Int64;
begin
  Total := 0;
  var ADataArray := AData.Split([#13#10]);
  var Xmas := TList<Int64>.Create;
  try
    for var I := Low(ADataArray) to High(ADataArray) do
    begin
      XMas.Add(ADataArray[I].ToInt64);
    end;
    for var I := 25 to XMas.Count -1 do
    begin
      if not CheckIfSumExists(Xmas, I) then
      begin
        Total := Xmas[I];
        break;
      end;
    end;

  finally
    Xmas.Free;
  end;
  Result := Total.ToString;
end;

function PartB(AData : string): string;
var
  Total: Int64;
begin
  Total := 0;
  var ADataArray := AData.Split([#13#10]);
  var Xmas := TList<Int64>.Create;
  try
    for var I := Low(ADataArray) to High(ADataArray) do
    begin
      XMas.Add(ADataArray[I].ToInt64);
    end;

    Var LookingFor := PartA(AData).ToInt64;
    for var I := 0 to Xmas.Count - 1 do
    begin
      var ASum :Int64;
      Asum := LookingFor;
      var J := 0;
      var MinNumber : Int64;
      var MaxNumber : Int64;
      MinNumber := LookingFor;
      MaxNumber := 0;
      while ASum > 0 do begin
        ASum := ASum - Xmas[I+J];
        MinNumber := Min(MinNumber, Xmas[I+J]);
        MaxNumber := Max(MaxNumber, Xmas[I+J]);
        Inc(J);
      end;
      if ASum = 0 then
      begin
        Total := MinNumber + MaxNumber;
        break;
      end;
    end;
  finally
    Xmas.Free;
  end;
  Result := Total.ToString;
end;


begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day9.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day9.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
