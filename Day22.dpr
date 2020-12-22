program Day22;

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

function PartA(AData : string): string;
var
  Total: Int64;
  Deck1 : TQueue<Integer>;
  Deck2 : TQueue<Integer>;
begin
  Total := 0;

  Deck1 := TQueue<Integer>.Create;
  Deck2 := TQueue<Integer>.Create;
  try
    var IsPlayer2 := False;
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) + 1 to High(DataArray) do
    begin
      if DataArray[I] = 'Player 2:' then
      begin
        IsPlayer2 := True;
      end else
      if DataArray[I] <> '' then
      begin
        if IsPlayer2 then
        begin
          Deck2.Enqueue(DataArray[I].ToInteger);
        end else
        begin
          Deck1.Enqueue(DataArray[I].ToInteger);
        end;
      end;
    end;

    while (Deck1.Count > 0) and (Deck2.Count > 0) do
    begin
      var Card1 := Deck1.Dequeue;
      var Card2 := Deck2.Dequeue;
      if Card1 > Card2 then
      begin
        Deck1.Enqueue(Card1);
        Deck1.Enqueue(Card2);
      end else
      begin
        Deck2.Enqueue(Card2);
        Deck2.Enqueue(Card1);
      end;
    end;

    Var DeckWon : TQueue<Integer>;
    if Deck1.Count > 0 then
    begin
      DeckWon := Deck1;
    end else
    begin
      DeckWon := Deck2;
    end;

    while DeckWon.Count > 0 do
    begin
      Total := Total + (DeckWon.Count + 1) * DeckWon.Dequeue;
    end;

  finally
    Deck1.Free;
    Deck2.Free;
  end;

  Result := Total.ToString;
end;

function SubDeck(ADeck: TQueue<Integer>; ACard: Integer) : TQueue<Integer>;
begin
  Result := TQueue<Integer>.Create;
  for var Card in ADeck do
  begin
    Result.Enqueue(Card);
    Dec(ACard);
    if ACard = 0 then
    begin
      break;
    end;
  end;
end;

function DeckToStr(ADeck1: TQueue<Integer>): String;
begin
  Result := '';
  for var Card in ADeck1 do
  begin
    Result := Result + Card.ToString + ',';
  end;
end;

function RecursePlay(ADeck1: TQueue<Integer>; ADeck2: TQueue<Integer>): Integer;
var Memory : TList<String>;
begin
  Result := 1;

  Memory := TList<String>.create;
  try
  while (ADeck1.Count > 0) and (ADeck2.Count > 0) do
  begin
    var Situation := DeckToStr(ADeck1) + 'D2'+ DeckToStr(ADeck2);
    if Memory.Contains(Situation) then
    begin
      Result := 1;
      break;
    end else
    begin
      Memory.add(Situation);
    end;

    var Card1 := ADeck1.Dequeue;
    var Card2 := ADeck2.Dequeue;
    var playerRoundWon : Integer;
    if (Card1 <= ADeck1.Count) and (Card2 <= ADeck2.Count) then
    begin
      playerRoundWon := RecursePlay(SubDeck(ADeck1, Card1), SubDeck(ADeck2, Card2));
    end else
    begin
      if Card1 > Card2 then
      begin
        playerRoundWon := 1;
      end else
      begin
        playerRoundWon := 2;
      end;
    end;
    if playerRoundWon = 1 then
    begin
      ADeck1.Enqueue(Card1);
      ADeck1.Enqueue(Card2);
    end else
    begin
      ADeck2.Enqueue(Card2);
      ADeck2.Enqueue(Card1);
    end;
  end;
  if ADeck1.Count > 0 then
    Result := 1
  else
    Result := 2;
  finally
    Memory.Free;
    ADeck1.Free;
    ADeck2.Free;
  end;
end;

function PartB(AData : string): string;
var
  Total: Int64;
  Deck1 : TQueue<Integer>;
  Deck2 : TQueue<Integer>;
begin
  Total := 0;

  Deck1 := TQueue<Integer>.Create;
  Deck2 := TQueue<Integer>.Create;
  try
    var IsPlayer2 := False;
    var DataArray := AData.Split([#13#10]);
    for var I := Low(DataArray) + 1 to High(DataArray) do
    begin
      if DataArray[I] = 'Player 2:' then
      begin
        IsPlayer2 := True;
      end else
      if DataArray[I] <> '' then
      begin
        if IsPlayer2 then
        begin
          Deck2.Enqueue(DataArray[I].ToInteger);
        end else
        begin
          Deck1.Enqueue(DataArray[I].ToInteger);
        end;
      end;
    end;

    var Round := 1;
    while (Deck1.Count > 0) and (Deck2.Count > 0) do
    begin
      var Card1 := Deck1.Dequeue;
      var Card2 := Deck2.Dequeue;
      var playerRoundWon : Integer;
      if (Card1 <= Deck1.Count) and (Card2 <= Deck2.Count) then
      begin
        playerRoundWon := RecursePlay(SubDeck(Deck1, Card1), SubDeck(Deck2, Card2));
      end else
      begin
        if Card1 > Card2 then
        begin
          playerRoundWon := 1;
        end else
        begin
          playerRoundWon := 2;
        end;
      end;
      if playerRoundWon = 1 then
      begin
        Deck1.Enqueue(Card1);
        Deck1.Enqueue(Card2);
      end else
      begin
        Deck2.Enqueue(Card2);
        Deck2.Enqueue(Card1);
      end;

      Inc(Round);
    end;

    Var DeckWon : TQueue<Integer>;
    if Deck1.Count > 0 then
    begin
      DeckWon := Deck1;
    end else
    begin
      DeckWon := Deck2;
    end;

    while DeckWon.Count > 0 do
    begin
      Total := Total + (DeckWon.Count + 1) * DeckWon.Dequeue;
    end;

  finally
    Deck1.Free;
    Deck2.Free;
  end;

  Result := Total.ToString;
end;

begin
  try
    writeln(PartA(T_WGUtils.OpenFile('..\..\day22Test.txt')));
    writeln(PartA(T_WGUtils.OpenFile('..\..\day22.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day22Test.txt')));
    writeln(PartB(T_WGUtils.OpenFile('..\..\day22.txt')));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
