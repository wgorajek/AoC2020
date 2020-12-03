program Day3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.SysUtils;


function NumberOfTrees(AX: Integer; AY: Integer; ADataArray: TArray<String>): Integer;
begin
  Result := 0;
  var MaxLength := ADataArray[0].Length;
  var MaxHeight := Length(ADataArray)-1;
  var J := 0;
  var I := 0;
  while I < MaxHeight do
  begin
    Inc(I, AY);
    Inc(J, AX);
    J := J mod MaxLength;
    if ADataArray[I][J+1] = '#' then
    begin
      inc(Result);
    end;
  end;
end;

function PartA(AData : string): string;
var
  Total : Integer;
begin
  var DataArray := AData.Split([#13#10]);
  Total := NumberOfTrees(3, 1, DataArray);
  Result := Total.ToString;
end;


function PartB(AData : string): string;
var
  Total : Integer;
begin
  Total := 1;
  var DataArray := AData.Split([#13#10]);
  Total := Total * NumberOfTrees(1, 1, DataArray);
  Total := Total * NumberOfTrees(3, 1, DataArray);
  Total := Total * NumberOfTrees(5, 1, DataArray);
  Total := Total * NumberOfTrees(7, 1, DataArray);
  Total := Total * NumberOfTrees(1, 2, DataArray);
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day3Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day3.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day3Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day3.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
