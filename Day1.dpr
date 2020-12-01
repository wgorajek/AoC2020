program Day1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.SysUtils;


function FindTwo(AExpenses: TList<Integer>; ATotal : Integer): Integer;
var
  Total : Integer;
begin
  Total := 0;
    AExpenses.Sort;
    var I := 0;
    var J := AExpenses.Count - 1;
    while I < J do
    begin
      If AExpenses[I] + AExpenses[J] = ATotal then
      begin
        Total := (AExpenses[I] * AExpenses[J]);
        Break;
      end else if AExpenses[I] + AExpenses[J] < ATotal then
      begin
        Inc(I);
      end else
      begin
        Dec(J);
      end;
    end;
  Result := Total;
end;

function PartA(AData : string): string;
var
  Total : Integer;
  Expenses: TList<Integer>;
begin
  Total := 0;
  Expenses := TList<Integer>.Create;
  try

    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      Expenses.add(StrToInt(Trim(DataArray[I])));
    end;

    Total := FindTwo(Expenses, 2020);
  finally
    Expenses.Free
  end;
  Result := Total.ToString;
end;


function PartB(AData : string): string;
var
  Total : Integer;
  Expenses: TList<Integer>;
begin
  Total := 0;
  Expenses := TList<Integer>.Create;
  try

    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      Expenses.add(StrToInt(Trim(DataArray[I])));
    end;

    Expenses.Sort;

    var K := 0;
    while K < Expenses.Count - 1 do
    begin
      Total := FindTwo(Expenses, 2020- Expenses[K]);
      if Total > 0 then
      begin
        Total := Total * Expenses[K];
        break;
      end;

      Inc(K);
    end;
  finally
    Expenses.Free
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day1Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day1.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day1Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day1.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
