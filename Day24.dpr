program Day24;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  Types,
  System.RegularExpressions,
  System.SysUtils;


function CalculateWay(Path: String): TPoint;
begin
  Result.X := 0;
  Result.Y := 0;
  while Path.Length > 0 do
  begin
    var Direction := '';
    if (Path[1] = 'w') or (Path[1] = 'e') then
    begin
      Direction := Path[1];
    end else
    begin
      Direction := Path.Substring(0, 2);
    end;
    Path := Path.Substring(Direction.Length);

    if Direction = 'e' then
    begin
      inc(Result.X, 2);
    end else if Direction = 'w' then
    begin
      inc(Result.X, -2);
    end else if Direction = 'nw' then
    begin
      inc(Result.X, -1);
      inc(Result.Y, 1);
    end else if Direction = 'ne' then
    begin
      inc(Result.X, 1);
      inc(Result.Y, 1);
    end else if Direction = 'sw' then
    begin
      inc(Result.X, -1);
      inc(Result.Y, -1);
    end else if Direction = 'se' then
    begin
      inc(Result.X, 1);
      inc(Result.Y, -1);
    end;
  end;

end;

function PartA(AData : string): string;
var
  Total : Integer;
  Grid: TDictionary<TPoint, Integer>;
begin
  Total := 0;
  Grid := TDictionary<TPoint, Integer>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      var Point := CalculateWay(DataArray[I]);
      if Grid.ContainsKey(Point) then
      begin
        Grid[Point] := 1-Grid[Point];
      end else
      begin
        Grid.Add(Point, 1);
      end;
    end;

    for var Value in Grid.Values do
    begin
      Inc(Total, Value);
    end;

  finally
    Grid.Free;
  end;
  Result := Total.ToString;
end;

function CountNeighbours(APoint: TPoint; AGrid: TDictionary<TPoint, Integer>): Integer;
begin
  Result := 0;

  for var Point in [
      TPoint.Create(APoint.X + 1, APoint.Y + 1),
      TPoint.Create(APoint.X + 1, APoint.Y - 1),
      TPoint.Create(APoint.X - 1, APoint.Y + 1),
      TPoint.Create(APoint.X - 1, APoint.Y - 1),
      TPoint.Create(APoint.X + 2, APoint.Y),
      TPoint.Create(APoint.X - 2, APoint.Y)] do begin
    if AGrid.ContainsKey(Point) then
    begin
      Inc(Result, AGrid[Point]);
    end;
  end;
end;

function PartB(AData : string): string;
var
  Total : Integer;
  Grid: TDictionary<TPoint, Integer>;
  NewGrid: TDictionary<TPoint, Integer>;
begin
  Total := 0;
  Grid := TDictionary<TPoint, Integer>.Create;
  NewGrid := TDictionary<TPoint, Integer>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) to High(DataArray) do
    begin
      var Point := CalculateWay(DataArray[I]);
      if Grid.ContainsKey(Point) then
      begin
        Grid[Point] := 1-Grid[Point];
      end else
      begin
        Grid.Add(Point, 1);
      end;
    end;

    var MaxX := 0;
    var MaxY := 0;
    var MinX := 0;
    var MinY := 0;
    for var Hex in Grid do
    begin
      if Hex.Value = 1 then
      begin
        MaxX := Max(MaxX, Hex.Key.X);
        MaxY := Max(MaxY, Hex.Key.Y);
        MinX := Min(MinX, Hex.Key.X);
        MinY := Min(MinY, Hex.Key.Y);
      end;
    end;

    for var I := 1 to 100 do
    begin
      NewGrid.Clear;
      for var Hex in Grid do
      begin
        NewGrid.Add(Hex.Key, Hex.Value);
      end;
      for var J := MinX-2 to MaxX+2 do
      begin
        for var K := MinY-2 to MaxY+2 do
        begin
          if (J + K) mod 2 = 0 then
          begin
            var Point := TPoint.Create(J, K);
            if not Grid.ContainsKey(Point) then
            begin
              Grid.Add(Point, 0);
              NewGrid.Add(Point, 0);
            end;
            var Neighbours := CountNeighbours(Point, Grid);
            if (Neighbours = 2) and (Grid[Point] = 0) then
            begin
              NewGrid[Point] := 1;
            end else if ((Neighbours > 2) or (Neighbours = 0)) and (Grid[Point] = 1) then
            begin
              NewGrid[Point] := 0;
            end;
            if NewGrid[Point] = 1 then
            begin
              MaxX := Max(MaxX, Point.X);
              MaxY := Max(MaxY, Point.Y);
              MinX := Min(MinX, Point.X);
              MinY := Min(MinY, Point.Y);
            end;

          end;
        end;
      end;

      Grid.Clear;
      for var Hex in NewGrid do
      begin
        Grid.Add(Hex.Key, Hex.Value);
      end;
    end;

    for var Value in Grid.Values do
    begin
      Inc(Total, Value);
    end;
  finally
    Grid.Free;
    NewGrid.Free;
  end;
  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day24Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day24.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day24Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day24.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
