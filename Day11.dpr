program Day11;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  WGUtils,
  System.RegularExpressions,
  System.SysUtils;

function CountNeighboringSeats(ASeatsArray : TArray<Tarray<Char>>; X: Integer; Y: Integer): Integer;
begin
  Result := 0;
  var MaxX := Length(ASeatsArray) - 1;
  var MaxY := Length(ASeatsArray[0]) - 1;
  for var I := -1 to 1 do
  begin
    for var J := -1 to 1 do
    begin
      if ((X + I >= 0) and (Y + J >= 0))
         and ((X + I <= MaxX) and (Y + J <= MaxY))
         and ((I <> 0) or (J <> 0)) then
        if ASeatsArray[X+I][Y+J] = '#' then
          Inc(Result);
    end;
  end;
end;

function CalculateNewArray(ASeatsArray : TArray<Tarray<Char>>; out AIsChanged: Boolean) : TArray<Tarray<Char>>;
begin
  AIsChanged := False;
  SetLength(Result, Length(ASeatsArray));
  for var I := Low(ASeatsArray) to High(ASeatsArray) do
  begin
    SetLength(Result[I], Length(ASeatsArray[I]));
    for var J := Low(ASeatsArray[I]) to High(ASeatsArray[I]) do
    begin
      if ASeatsArray[I][J] = '.' then
      begin
        Result[I][J] := '.';
      end
      else
      begin
        var SeatsCount := CountNeighboringSeats(ASeatsArray, I, J);
        if (ASeatsArray[I][J] = 'L') and (SeatsCount = 0) then
        begin
          Result[I][J] := '#';
          AIsChanged := True;
        end else if (ASeatsArray[I][J] = '#') and (SeatsCount >= 4) then
        begin
          Result[I][J] := 'L';
          AIsChanged := True;
        end else
        begin
          Result[I][J] := ASeatsArray[I][J];
        end;
      end;
    end;
  end;
end;

function CountNeighboringSeatsPartB(ASeatsArray : TArray<Tarray<Char>>; X: Integer; Y: Integer): Integer;
begin
  Result := 0;
  var MaxX := Length(ASeatsArray) - 1;
  var MaxY := Length(ASeatsArray[0]) - 1;
  for var I := -1 to 1 do
  begin
    for var J := -1 to 1 do
    begin
      if ((I <> 0) or (J <> 0)) then
      begin
        var NewX := X + I;
        var NewY := Y + J;
        while
          ((NewX >= 0) and (NewY >= 0))
          and ((NewX <= MaxX) and (NewY <= MaxY)) do
        begin
          if ASeatsArray[NewX][NewY] <> '.' then
          begin
            if ASeatsArray[NewX][NewY] = '#' then
              Inc(Result);
            Break;
          end;

          NewX := NewX + I;
          NewY := NewY + J;
        end;
      end;
    end;
  end;
end;

function CalculateNewArrayPartB(ASeatsArray : TArray<Tarray<Char>>; out AIsChanged: Boolean) : TArray<Tarray<Char>>;
begin
  AIsChanged := False;
  SetLength(Result, Length(ASeatsArray));
  for var I := Low(ASeatsArray) to High(ASeatsArray) do
  begin
    SetLength(Result[I], Length(ASeatsArray[I]));
    for var J := Low(ASeatsArray[I]) to High(ASeatsArray[I]) do
    begin
      if ASeatsArray[I][J] = '.' then
      begin
        Result[I][J] := '.';
      end
      else
      begin
        var SeatsCount := CountNeighboringSeatsPartB(ASeatsArray, I, J);
        if (ASeatsArray[I][J] = 'L') and (SeatsCount = 0) then
        begin
          Result[I][J] := '#';
          AIsChanged := True;
        end else if (ASeatsArray[I][J] = '#') and (SeatsCount >= 5) then
        begin
          Result[I][J] := 'L';
          AIsChanged := True;
        end else
        begin
          Result[I][J] := ASeatsArray[I][J];
        end;
      end;
    end;
  end;
end;

function PartA(AData : string): string;
var
  Total: Integer;
  SeatsArray : TArray<Tarray<Char>>;
  IsChanged : Boolean;
begin
  var ADataArray := AData.Split([#13#10]);
  SetLength(SeatsArray, Length(ADataArray));
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    SetLength(SeatsArray[I], ADataArray[I].Length);
    for var J := 0 to ADataArray[I].Length - 1 do
    begin
      SeatsArray[I][J] := ADataArray[I][J+1];
    end;
  end;

  IsChanged := True;
  while IsChanged = True do
  begin
    SeatsArray := CalculateNewArray(SeatsArray, IsChanged);
  end;

  Total := 0;
  for var I := Low(SeatsArray) to High(SeatsArray) do
  begin
    for var J := Low(SeatsArray[I]) to High(SeatsArray[I]) do
    begin
      if SeatsArray[I][J] = '#' then begin
        Inc(Total);
      end;
    end;
  end;
  Result := Total.ToString;
end;

function PartB(AData : string): string;
var
  Total: Integer;
  SeatsArray : TArray<Tarray<Char>>;
  IsChanged : Boolean;
begin
  var ADataArray := AData.Split([#13#10]);
  SetLength(SeatsArray, Length(ADataArray));
  for var I := Low(ADataArray) to High(ADataArray) do
  begin
    SetLength(SeatsArray[I], ADataArray[I].Length);
    for var J := 0 to ADataArray[I].Length - 1 do
    begin
      SeatsArray[I][J] := ADataArray[I][J+1];
    end;
  end;

  IsChanged := True;
  Total := 0;
  while IsChanged = True do
  begin
    SeatsArray := CalculateNewArrayPartB(SeatsArray, IsChanged);
    Inc(Total);
  end;

  Total := 0;
  for var I := Low(SeatsArray) to High(SeatsArray) do
  begin
    for var J := Low(SeatsArray[I]) to High(SeatsArray[I]) do
    begin
      if SeatsArray[I][J] = '#' then begin
        Inc(Total);
      end;
    end;
  end;
  Result := Total.ToString;
end;


begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day11Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day11.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day11Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day11.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
