program Day17;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

type
  TPoint3D = record
    X: Integer;
    Y: Integer;
    Z: Integer;
    constructor Create(AX, AY, AZ: Integer);
  end;

  TPoint4D = record
    X: Integer;
    Y: Integer;
    Z: Integer;
    W: Integer;
    constructor Create(AX, AY, AZ, AW: Integer);
  end;

function CalculateNext(ACubes: TDictionary<TPoint3D, Byte>; APoint: TPoint3D): Integer;
begin
  if ACubes.ContainsKey(APoint) then
    Result := ACubes[APoint]
  else
    Result := 0;
  var Neighbours := 0;
  for var I := -1 to 1 do
  begin
    for var J := -1 to 1 do
    begin
      for var K := -1 to 1 do
      begin
        If (I <> 0) or (J <> 0) or (K <> 0) then
        begin
          var Point := TPoint3D.Create(APoint.X + I, APoint.Y + J, APoint.Z + K);
          if ACubes.ContainsKey(Point) then
          begin
            Inc(Neighbours, ACubes[Point]);
          end;
        end;
      end;
    end;
  end;
  if ((Neighbours <> 3) and (Neighbours <> 2)) then
  begin
    Result := 0;
  end;
  if (Neighbours = 3) then
  begin
    Result := 1;
  end;
end;

function PartA(AData : string): string;
var
  Total : Integer;
  Cubes: TDictionary<TPoint3D, Byte>;
  NewCubes: TDictionary<TPoint3D, Byte>;
begin
  Total := 0;
  var DataArray := AData.Split([#13#10]);
  Cubes := TDictionary<TPoint3D, Byte>.Create;
  NewCubes := TDictionary<TPoint3D, Byte>.Create;
  try
    for var I := Low(DataArray) to High(DataArray) do
    begin
      for var J := 0 to  DataArray[I].Length - 1 do
      begin
        if DataArray[I][J+1] = '#' then
        begin
          Cubes.Add(TPoint3D.Create(I, J, 0), 1);
        end;
      end;
    end;
    for var Turn := 1 to 6 do
    begin
      for var I := -8 to 14 do
      begin
        for var J := -8 to 14 do
        begin
          for var K := -7 to 7 do
          begin
            var Point := TPoint3D.Create(I,J,K);
            NewCubes.Add(Point, CalculateNext(Cubes, Point));
          end;
        end;
      end;
      Cubes.Clear;
      for var Point in NewCubes.Keys do
      begin
        Cubes.Add(Point, NewCubes[Point]);
      end;
      NewCubes.Clear;
    end;

    for var Value in Cubes.Values do
    begin
      Inc(Total, Value);
    end;
  finally
    Cubes.Free;
    NewCubes.Free;
  end;

  Result := Total.ToString;
end;

function CalculateNext4D(ACubes: TDictionary<TPoint4D, Byte>; APoint: TPoint4D): Integer;
begin
  if ACubes.ContainsKey(APoint) then
    Result := ACubes[APoint]
  else
    Result := 0;
  var Neighbours := 0;
  for var I := -1 to 1 do
  begin
    for var J := -1 to 1 do
    begin
      for var K := -1 to 1 do
      begin
        for var L := -1 to 1 do
        begin
          If (I <> 0) or (J <> 0) or (K <> 0) or (L <> 0) then
          begin
            var Point := TPoint4D.Create(APoint.X + I, APoint.Y + J, APoint.Z + K, APoint.W + L);
            if ACubes.ContainsKey(Point) then
            begin
              Inc(Neighbours, ACubes[Point]);
            end;
          end;
        end;
      end;
    end;
  end;
  if ((Neighbours <> 3) and (Neighbours <> 2)) then
  begin
    Result := 0;
  end;
  if (Neighbours = 3) then
  begin
    Result := 1;
  end;
end;

function PartB(AData : string): string;
var
  Total : Integer;
  NextCubes: TArray<TArray<TArray<Byte>>>;
  Cubes: TDictionary<TPoint4D, Byte>;
  NewCubes: TDictionary<TPoint4D, Byte>;
  MinX, MaxX, MinY, MaxY, MinZ, MaxZ, MinW, MaxW: Integer;
begin
  Total := 0;
  var DataArray := AData.Split([#13#10]);
  Cubes := TDictionary<TPoint4D, Byte>.Create;
  NewCubes := TDictionary<TPoint4D, Byte>.Create;
  try
    for var I := Low(DataArray) to High(DataArray) do
    begin
      for var J := 0 to  DataArray[I].Length - 1 do
      begin
        if DataArray[I][J+1] = '#' then
        begin
          Cubes.Add(TPoint4D.Create(I, J, 0, 0), 1);
        end;
      end;
    end;
    MinX := 0;
    MaxX := 8;
    MinY := 0;
    MaxY := 8;
    MinZ := 0;
    MaxZ := 0;
    MinW := 0;
    MaxW := 0;
    for var Turn := 1 to 6 do
    begin

      for var I := MinX - 1 to MaxX + 1 do
      begin
        for var J := MinY - 1 to MaxY + 1 do
        begin
          for var K := MinZ - 1 to MaxZ + 1 do
          begin
            for var L := MinW - 1 to MaxW + 1 do
            begin
              var Point := TPoint4D.Create(I, J, K, L);
              NewCubes.Add(Point, CalculateNext4D(Cubes, Point));
            end;
          end;
        end;
      end;
      Cubes.Clear;
      for var Point in NewCubes.Keys do
      begin
        Cubes.Add(Point, NewCubes[Point]);
        if Cubes[Point] = 1 then
        begin
          MaxX := Max(MaxX, Point.X);
          MaxY := Max(MaxY, Point.Y);
          MaxZ := Max(MaxZ, Point.Z);
          MaxW := Max(MaxW, Point.W);
          MinX := Min(MinX, Point.X);
          MinY := Min(MinY, Point.Y);
          MinZ := Min(MinZ, Point.Z);
          MinW := Min(MinW, Point.W);
        end;
      end;
      NewCubes.Clear;
    end;

    for var Value in Cubes.Values do
    begin
      Inc(Total, Value);
    end;
  finally
    Cubes.Free;
    NewCubes.Free;
  end;

  Result := Total.ToString;
end;

{ TPoint3D }

constructor TPoint3D.Create(AX, AY, AZ: Integer);
begin
  X := AX;
  Y := AY;
  Z := AZ;
end;

{ TPoint4D }

constructor TPoint4D.Create(AX, AY, AZ, AW: Integer);
begin
  X := AX;
  Y := AY;
  Z := AZ;
  W := AW;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day17Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day17.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day17Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day17.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
