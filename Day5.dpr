program Day5;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

function DecodeSeat(ASeat: String): Extended;
begin
  Result := 0;
  for var I := 1 to 10 do
  begin
    if (ASeat[I] = 'B') or (ASeat[I] = 'R') then
    begin
      var LSeatValue := Power(2, 10-I);
      Result := Result + LSeatValue;
    end;
  end;

end;

function PartA(AData : string): string;
var
  HighestId: Extended;
begin
  HighestId := 0;
  var ADataArray := Adata.Split([#13#10]);
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    var SeatId := DecodeSeat(ADataArray[I]);
    HighestId := Max(HighestId, SeatId);

  end;
  Result := HighestId.ToString;
end;


function PartB(AData : string): string;
var
  HighestId: Extended;
  AList: TList<Extended>;
begin

  HighestId := 0;
  AList := TList<Extended>.Create;
  try
    var ADataArray := Adata.Split([#13#10]);
    for var I := Low(ADataArray) to High(ADataArray) do
    begin
      var SeatId := DecodeSeat(ADataArray[I]);
      AList.Add(SeatId);
    end;
    AList.Sort;
    for var I := 0 to AList.Count - 2 do
    begin
      if AList[I] + 2 = AList[I+1] then
      begin
        HighestId := (AList[I] + 1);
      end;
    end;
  finally
    AList.Free;
  end;
  Result := HighestId.ToString;end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day5Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day5.txt')));
//    writeln(PartB(T_WGUtils.OpenFile('..\..\day5Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day5.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
