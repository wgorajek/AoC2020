program Day20;

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


type
  TTile = class
    Fields: TArray<TArray<ShortString>>;
    Id: Integer;
    NumberOfMatches: Integer;
    constructor Create(AId: Integer);
    procedure Rotate;
    procedure Flip;
  end;

  TDirection = (Right = 0, Down = 1, Left = 2, Up = 3, None = 4);

function IsMatchDirection(ADirection: TDirection; AFirstTile: TTile; ASecondTile: TTile): Boolean;
begin
  var IsMatch := True;
  for var I := 0 to 9 do
  begin
    case ADirection of
      Left :
        begin
          if AFirstTile.Fields[I][0] <> ASecondTile.Fields[I][9] then
          begin
            IsMatch := False;
            break;
          end;
        end;
      Right :
        begin
          if AFirstTile.Fields[I][9] <> ASecondTile.Fields[I][0] then
          begin
            IsMatch := False;
            break;
          end;
        end;
      Up :
        begin
          if AFirstTile.Fields[0][I] <> ASecondTile.Fields[9][I] then
          begin
            IsMatch := False;
            break;
          end;
        end;
      Down :
        begin
          if AFirstTile.Fields[9][I] <> ASecondTile.Fields[0][I] then
          begin
            IsMatch := False;
            break;
          end;
        end;
    end;
  end;
  Result := IsMatch;
end;

function TryMatch2(AFirstTile: TTile; ASecondTile: TTile; ADirection : TDirection = TDirection.None): TDirection;
begin
  var Rotations := 0;
  var MatchingDirection := TDirection.None;
  while (Rotations <= 7) and (MatchingDirection = TDirection.None) do
  begin
    if ADirection = TDirection.None then
    begin    
      for var Direction in [Right, Down, Left, Up] do
      begin
        if IsMatchDirection(Direction, AFirstTile, ASecondTile) then
          MatchingDirection := Direction;
      end;
    end else 
    begin
      if IsMatchDirection(ADirection, AFirstTile, ASecondTile) then
        MatchingDirection := ADirection;    
    end;
    if MatchingDirection = TDirection.None then
    begin
      ASecondTile.Rotate;
      Inc(Rotations);
      if Rotations = 4 then
        ASecondTile.Flip;
    end;
  end;
  Result := MatchingDirection;
end;

procedure TryMatch(AFirstTile: TTile; ASecondTile: TTile);
begin
  var NumberOfRotations := 0;
  var IsMatch := False;
  while (NumberOfRotations <= 7) and (not IsMatch) do
  begin
    IsMatch := True;
    for var I := 0 to 9 do
    begin
      if AFirstTile.Fields[I][0] <> ASecondTile.Fields[I][9] then
      begin
        IsMatch := False;
        break;
      end;
    end;
    if IsMatch then break;

    IsMatch := True;
    for var I := 0 to 9 do
    begin
      if AFirstTile.Fields[I][9] <> ASecondTile.Fields[I][0] then
      begin
        IsMatch := False;
        break;
      end;
    end;
    if IsMatch then break;

    IsMatch := True;
    for var I := 0 to 9 do
    begin
      if AFirstTile.Fields[0][I] <> ASecondTile.Fields[9][I] then
      begin
        IsMatch := False;
        break;
      end;
    end;
    if IsMatch then break;

    IsMatch := True;
    for var I := 0 to 9 do
    begin
      if AFirstTile.Fields[9][I] <> ASecondTile.Fields[0][I] then
      begin
        IsMatch := False;
        break;
      end;
    end;
    if IsMatch then break;
    AFirstTile.Rotate;
    Inc(NumberOfRotations);
    if NumberOfRotations = 4 then
      AFirstTile.Flip;
  end;
  if IsMatch then
  begin
    Inc(AFirstTile.NumberOfMatches);
    Inc(ASecondTile.NumberOfMatches);
  end;
end;

procedure FindMatches(ATiles: TDictionary<Integer, TTile>; ATile: TTile);
begin
  for var Tile in ATiles do
  begin
    if Tile.Key <> ATile.Id then
    begin
      TryMatch(Tile.Value, ATile);
    end;
  end;
end;

function PartA(AData : string): string;
var
  Total: Int64;
  Tiles: TDictionary<Integer, TTile>;
begin
  Total := 0;
  Tiles := TDictionary<Integer, TTile>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    var NewTile: TTile;
    var IsNewTile := True;
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I] = '' then
      begin
        IsNewTile := True;
      end else if IsNewTile then
      begin
        IsNewTile := False;
        var Id := TRegEx.Match(DataArray[I], 'Tile (\d+):').Groups[1].Value.ToInteger;
        NewTile := TTile.Create(Id);
        for var J := 0 to 9 do
        begin
          for var K := 0 to 9 do
          begin
            NewTile.Fields[J][K] := ShortString(DataArray[I+J+1][K+1]);
          end;
        end;
        Tiles.Add(Id, NewTile);
      end;
    end;

    for var Tile in Tiles.Values do
    begin
      FindMatches(Tiles, Tile);
    end;
    Total := 1;
    for var Tile in Tiles.Values do
    begin
      if Tile.NumberOfMatches/2 = 2 then
      begin
        Total := Total*Tile.Id;
      end;
    end;
  finally
    Tiles.Free;
  end;
  Result := Total.ToString;
end;

function CheckMonster(FinalMap: TArray<TArray<ShortString>>; AI: Integer; AJ: Integer): Boolean;
begin
  Result := True;
  var MaxI := Length(FinalMap)-1;
  var MaxJ := MaxI;
  var Monster0 := '                  # ';
  var Monster1 := '#    ##    ##    ###';
  var Monster2 := ' #  #  #  #  #  #   ';
  if (AI + 2 <= MaxI) and (AJ + 19 <= MaxJ) then
  begin
    for var J := 0 to Monster0.Length - 1 do
    begin
      if (Monster0[J+1] = '#') and (FinalMap[AI][AJ+J] <> '#') then
      begin
        result := False;
        break;
      end;
      if (Monster1[J+1] = '#') and (FinalMap[AI+1][AJ+J] <> '#') then
      begin
        result := False;
        break;
      end;
      if (Monster2[J+1] = '#') and (FinalMap[AI+2][AJ+J] <> '#') then
      begin
        result := False;
        break;
      end;
    end;
  end else
  begin
    Result := False;
  end;
  if Result then
  begin
    for var J := 0 to Monster0.Length - 1 do
    begin

      if (Monster0[J+1] = '#') then
      begin
        FinalMap[AI][AJ+J] := 'O';
      end;
      if (Monster1[J+1] = '#')  then
      begin
        FinalMap[AI+1][AJ+J] := 'O';
      end;
      if (Monster2[J+1] = '#') then
      begin
        FinalMap[AI+2][AJ+J] := 'O';
      end;
    end;
  end;

end;


function FlipArray(AArray: TArray<TArray<ShortString>>): TArray<TArray<ShortString>>;
begin
  var NewArray: TArray<TArray<ShortString>>;
  SetLength(NewArray, Length(AArray));
  for var I := Low(NewArray) to High(NewArray) do
  begin
    SetLength(NewArray[I], Length(AArray));
  end;
  for var I := 0 to Length(AArray) - 1 do
  begin
    for var J := 0 to Length(AArray) - 1 do
    begin
      NewArray[I][J] := AArray[I][Length(AArray) - 1 -J];
    end;
  end;
  Result := NewArray;
end;

function RotateArray(AArray: TArray<TArray<ShortString>>): TArray<TArray<ShortString>>;
begin
  var NewArray: TArray<TArray<ShortString>>;
  SetLength(NewArray, Length(AArray));
  for var I := Low(NewArray) to High(NewArray) do
  begin
    SetLength(NewArray[I], Length(AArray));
  end;
  for var I := 0 to Length(AArray) - 1 do
  begin
    for var J := 0 to Length(AArray) - 1 do
    begin
      NewArray[I][J] := AArray[Length(AArray) - 1 -J][I];
    end;
  end;
  Result := NewArray;
end;

function PartB(AData : string): string;
var
  Total : Int64;
  Tiles: TDictionary<Integer, TTile>;  
begin
  Total := 0;
  Tiles := TDictionary<Integer, TTile>.Create;
  try
    var DataArray := AData.Split([#13#10]);
    var NewTile: TTile;
    var IsNewTile := True;
    for var I := Low(DataArray) to High(DataArray) do
    begin
      if DataArray[I] = '' then
      begin
        IsNewTile := True;
      end else if IsNewTile then
      begin
        IsNewTile := False;
        var Id := TRegEx.Match(DataArray[I], 'Tile (\d+):').Groups[1].Value.ToInteger;
        NewTile := TTile.Create(Id);
        for var J := 0 to 9 do
        begin
          for var K := 0 to 9 do
          begin
            NewTile.Fields[J][K] := ShortString(DataArray[I+J+1][K+1]);
          end;
        end;
        Tiles.Add(Id, NewTile);
      end;
    end;

    for var Tile in Tiles.Values do
    begin
      FindMatches(Tiles, Tile);
    end;
    var CornerTile: TTile;
    CornerTile := nil;
    for var Tile in Tiles.Values do
    begin
      if Tile.NumberOfMatches = 4 then
      begin
        CornerTile := Tile;
        break;
      end;
    end;
    Tiles.Remove(CornerTile.Id);

    var FinalTiles := TDictionary<TPoint, TTile>.Create;
      var MatchingTiles := TList<TPair<TTile, TDirection>>.Create;
    try
      try
        for var Tile in Tiles.Values do
        begin
          var Rotations := 0;
          var MatchingDirection := TDirection.None;
          while (Rotations <= 7) and (MatchingDirection = TDirection.None) do
          begin
            if IsMatchDirection(Right, CornerTile, Tile) then
              MatchingDirection := Right
            else if IsMatchDirection(Down, CornerTile, Tile) then
              MatchingDirection := Down
            else if IsMatchDirection(Left, CornerTile, Tile) then
              MatchingDirection := Left
            else if IsMatchDirection(Up, CornerTile, Tile) then
              MatchingDirection := Up;
            if MatchingDirection = TDirection.None then
            begin
              Tile.Rotate;
              Inc(Rotations);
              if Rotations = 4 then
                Tile.Flip;
            end else
            begin
              MatchingTiles.Add(TPair<TTile, TDirection>.create(Tile, MatchingDirection));
            end;
          end;
        end;

        var RightTile: TTile;
        var DownTile: TTile;
        if (Ord(MatchingTiles[0].Value) + 1) mod 4 = Ord(MatchingTiles[1].Value) then
        begin
          RightTile := MatchingTiles[0].Key;
          DownTile := MatchingTiles[1].Key;
          for var I := 1 to (4-Ord(MatchingTiles[0].Value)) mod 4 do
          begin
            RightTile.Rotate;
            DownTile.Rotate;
            CornerTile.Rotate;
          end;
        end else
        begin
          RightTile := MatchingTiles[1].Key;
          DownTile := MatchingTiles[0].Key;
          for var I := 1 to (4-Ord(MatchingTiles[1].Value)) mod 4 do
          begin
            RightTile.Rotate;
            DownTile.Rotate;
            CornerTile.Rotate;
          end;
        end;
        FinalTiles.Add(TPoint.Create(0,0), CornerTile);
        FinalTiles.Add(TPoint.Create(0,1), RightTile);        
        FinalTiles.Add(TPoint.Create(1,0), DownTile);        
                
        Tiles.Remove(DownTile.Id);
        Tiles.Remove(RightTile.Id);    
      finally
        MatchingTiles.Free;
      end;
      
      var SideSize := Round(Sqrt(Tiles.Count+3));
      for var I := 0 to SideSize-1 do
      begin
        for var J := 0 to SideSize-1 do
        begin
          var Point := TPoint.Create(I,J);
          if not FinalTiles.ContainsKey(Point) then
          begin
            if J > 0 then
            begin
              for var Tile in Tiles.Values do 
              begin  
                var IsMatch :=  TDirection.None <> TryMatch2(FinalTiles[TPoint.Create(I,J-1)], Tile, Right);
                if IsMatch then
                begin
                  Tiles.Remove(Tile.Id);
                  FinalTiles.Add(Point, Tile);
                  break;
                end;
              end;
            end else
            begin
              for var Tile in Tiles.Values do
              begin
                var IsMatch :=  TDirection.None <> TryMatch2(FinalTiles[TPoint.Create(I-1,J)], Tile, Down);
                if IsMatch then
                begin
                  Tiles.Remove(Tile.Id);
                  FinalTiles.Add(Point, Tile);
                  break;
                end;               
              end;            
            end;            
          end;
        end;
      end;

      var FinalMap: TArray<TArray<ShortString>>;
      SetLength(FinalMap, SideSize*8);
      for var I := 0 to SideSize*8-1 do
      begin
        SetLength(FinalMap[I], SideSize*8);
      end;
      for var I := 0 to SideSize-1 do
      begin
        for var J := 0 to SideSize-1 do
        begin
          var Point := TPoint.Create(I,J);
          var Tile := FinalTiles[Point];
          for var K := 1 to 8 do
          begin
            for var L := 1 to 8 do
            begin
              FinalMap[I*8+K-1][J*8+L-1] := Tile.Fields[K][L];
            end;
          end;
        end;
      end;

      var FoundMonsters := False;
      var Rotations := 0;
      while (Rotations <= 7) and not FoundMonsters  do
      begin
        for var I := 0 to SideSize*8-1 do
        begin
          for var J := 0 to SideSize*8-1 do
          begin
            FoundMonsters := CheckMonster(FinalMap, I, J) or FoundMonsters;
          end;
        end;
        if not FoundMonsters then
        begin
          Inc(Rotations);
          FinalMap := RotateArray(FinalMap);
          if Rotations mod 4 = 0 then
          begin
            FinalMap := FlipArray(FinalMap);
          end;
        end;
      end;

      Total :=0;
      for var I := 0 to SideSize*8-1 do
      begin
        for var J := 0 to SideSize*8-1 do
        begin
          if FinalMap[I][J] = '#' then
            Inc(Total);
        end;
      end;
    finally
      FinalTiles.Free;
    end;
  finally
    Tiles.Free;
  end;
  Result := Total.ToString;
end;


{ Tile }

constructor TTile.Create(AId: Integer);
begin
  Id := AId;
  NumberOfMatches := 0;
  SetLength(Fields, 10);
  for var I := Low(Fields) to High(Fields) do
  begin
    SetLength(Fields[I], 10);
  end;
end;

procedure TTile.Flip;
begin
  Fields := FlipArray(Fields);
end;

procedure TTile.Rotate;
begin
  Fields := RotateArray(Fields);
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day20Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day20.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day20Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day20.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
