program Day23;

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
  TMyNode = class
    Value: Int64;
    Next: TMyNode;
    Prev: TMyNode;
    constructor Create(AValue: Int64);
  end;

  TMyList = class
    LastInserted: TMyNode;
    Count: Int64;
    function InsertValue(AValue: Int64; ANode: TMyNode): TMyNode;
    procedure InsertNode(ANode: TMyNode; APrevNode: TMyNode);
    procedure DeleteNode(ANode: TMyNode);
    constructor Create;
  end;

  function FindDestinationNode(ACups: TMyList; ACurrentCupNode: TMyNode; ARemovedNodes: TArray<TMyNode>;  ACupsDictionary: TDictionary<Int64, TMyNode>): TMyNode;
begin
  Result := nil;
  var CurrentCup := ACurrentCupNode.Value;
  while Result = nil do
  begin
    Dec(CurrentCup);
    if CurrentCup <= 0 then
      CurrentCup := ACups.Count+3;
    var IsRemoved := False;
    for var I := Low(ARemovedNodes) to High(ARemovedNodes) do
    begin
      if ARemovedNodes[I].Value = CurrentCup then
      begin
        IsRemoved := True;
      end;
    end;
    if not IsRemoved then
    begin
      Result := ACupsDictionary[CurrentCup]
    end;
  end;
end;

function PartB(AData : string; AMoves: Int64; NumberOfCups: Int64): string;
var
  Total: Int64;
  CupsOld: TList<Int64>;
  PickedCups: TList<Int64>;
  Cups: TMyList;
  CupsDictionary: TDictionary<Int64, TMyNode>;
begin
  Total := 0;
  CupsOld := TList<Int64>.Create;
  PickedCups := TList<Int64>.Create;
  CupsDictionary := TDictionary<Int64, TMyNode>.Create;
  Cups := TMyList.Create;
  try
    var Node : TMyNode;
    Node := nil;
    for var I := 1 to AData.Length do
    begin
      Node := Cups.InsertValue(StrToInt(AData[I]), Node);
    end;
    for var I := 10 to NumberOfCups do
    begin
      Node := Cups.InsertValue(I, Node);
    end;

    var CurrentCupNode := Cups.LastInserted.Next; //First inserted node
    Node := CurrentCupNode;
    for var I := 0 to Cups.Count -1  do
    begin
      CupsDictionary.Add(Node.Value, Node);
      Node := Node.Next;
    end;

    for var I := 0 to AMoves - 1 do
    begin
      var MyArray: TArray<TMyNode>;
      SetLength(MyArray, 3);
      for var J := 0 to 2 do
      begin
        var TmpNode := CurrentCupNode.Next;
        MyArray[J] := TmpNode;
        Cups.DeleteNode(TmpNode);
      end;
      var DestinationNode := FindDestinationNode(Cups, CurrentCupNode, MyArray, CupsDictionary);
      for var J := 2 downto 0 do
      begin
        Cups.InsertNode(MyArray[J], DestinationNode);
      end;
      CurrentCupNode := CurrentCupNode.Next;
    end;
    var MyNode := CupsDictionary[1];
    if NumberOfCups > 10 then
    begin
      Total := MyNode.Next.Value * MyNode.Next.Next.Value;
      Result := Total.ToString;
    end else
    begin
      Result := '';
      for var I := 0 to NumberOfCups - 2 do
      begin
        MyNode := MyNode.Next;
        Result := Result + MyNode.Value.ToString;
      end;
    end;
  finally
    CupsOld.Free;
    PickedCups.Free;
    Cups.Free;
    CupsDictionary.Free;
  end;
end;

{ TMyNode }

constructor TMyNode.Create(AValue: Int64);
begin
  Value := AValue;
end;

{ TCirularList }

constructor TMyList.Create;
begin
  Count := 0;
end;


procedure TMyList.DeleteNode(ANode: TMyNode);
begin
  ANode.Prev.Next := ANode.Next;
  ANode.Next.Prev := ANode.Prev;
  ANode.Prev := nil;
  ANode.Next := nil;
  Dec(Count);
end;

procedure TMyList.InsertNode(ANode: TMyNode; APrevNode: TMyNode);
begin
  var NextNode := APrevNode.Next;
  APrevNode.Next := ANode;
  ANode.Prev := APrevNode;
  ANode.Next := NextNode;
  NextNode.Prev := ANode;
  LastInserted := ANode;
  Inc(Count);
end;

function TMyList.InsertValue(AValue: Int64; ANode: TMyNode): TMyNode;
begin
  var Node := TMyNode.Create(AValue);
  if ANode = nil then
  begin
    Node.Next := Node;
    Node.Prev := Node;
    Count := 1;
  end else
  begin
    InsertNode(Node, ANode);
  end;
  Result := Node;
end;

begin
  try
    writeln(PartB('389125467', 10, 9));
    writeln(PartB('523764819', 100, 9));
    writeln(PartB('389125467', 10000000, 1000000));
    writeln(PartB('523764819', 10000000, 1000000));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
