(******************************************************************************)
(*                               SheduledRepair                               *)
(*                                                                            *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpassqlite                ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)
unit objects.nodebag;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, objects.common, sqlite3.schema, sqlite3.result, sqlite3.result_row,
  container.arraylist, utils.functor, objects.node;

type
  TNodeBag = class(TCommonObject)
  private
    const
      NODE_BAG_TABLE_NAME = 'nodebag';
  public
    constructor Create (AID : Int64); override;
    destructor Destroy; override;
    
    { Check database table scheme. }
    function CheckSchema : Boolean; override;

    { Get object database table name. }
    function Table : String; override;

    { Load object from database. }
    function Load : Boolean; override;

    { Save object to database. }
    function Save : Boolean; override;

    { Add new grease bundle to current bag. }
    procedure Append (ANode : TNode);

    { Remove grease bundle from current bag. }
    procedure Remove (ANode : TNode);
  public
    type
      TNodeCompareFunctor = class
        (specialize TBinaryFunctor<TNode, Integer>)
      public
        function Call (AValue1, AValue2 : TNode) : Integer; override;
      end;

      TNodeList = class
        (specialize TArrayList<TNode, TNodeCompareFunctor>);  
  public
    { Get enumerator for in operator. }
    function GetEnumerator : TNodeList.TIterator;
  private
    FObject : PCommonObject;
    FNodeList : TNodeList;
  public
    property Entity : PCommonObject read FObject write FObject;
  end;

implementation

{ TGreaseBag.TGreaseBundleCompareFunctor }

function TNodeBag.TNodeCompareFunctor.Call (AValue1, AValue2 : TNode) : Integer;
begin
  if AValue1.ID < AValue2.ID then
    Result := -1
  else if AValue2.ID < AValue1.ID then
    Result := 1
  else
    Result := 0;
end;

{ TNodeBag }

constructor TNodeBag.Create (AID : Int64);
begin
  inherited Create (AID);
  FObject := nil;
  FNodeList := TNodeList.Create;
end;

destructor TNodeBag.Destroy;
begin
  FreeAndNil(FNodeList);
  inherited Destroy;
end;

function TNodeBag.CheckSchema : Boolean;
var
  Schema : TSQLite3Schema;
  Node : TNode;
begin
  Schema := TSQLite3Schema.Create;
  Node := TNode.Create(-1);
  
  Schema
    .Id
    .Integer('node_id')
    .Integer('object_id');

  if not FTable.Exists then
    FTable.New(Schema);

  Result := FTable.CheckSchema(Schema) and Node.CheckSchema;  

  FreeAndNil(Node);
  FreeAndNil(Schema);
end;

function TNodeBag.Table : String;
begin
  Result := NODE_BAG_TABLE_NAME;
end;

function TNodeBag.Load : Boolean;
var
  result_rows : TSQLite3Result;
  row : TSQLite3ResultRow;
  node : TNode;
begin
  if (FObject = nil) or (FObject^.ID = -1) then
    Exit(False);

  result_rows := FTable.Select.All.Where('object_id', FObject^.ID).Get;
  FNodeList.Clear;

  for row in result_rows do
  begin
    node := TNode.Create(row.GetIntegerValue('node_id'));

    if node.Load then
      FNodeList.Append(node);
  end;

  Result := True;
end;

function TNodeBag.Save : Boolean;
var
  node : TNode;
  updated_rows : Integer;
begin
  if FObject = nil then
    Exit(False);

  if FObject^.ID = -1 then
    FObject^.Save;

  if not FNodeList.FirstEntry.HasValue then
    Exit(False);

  for node in FNodeList do
  begin
    if not node.Save then
      continue;
    {
    updated_rows := UpdateRow.Update('node_id', node.ID)
      .Where('object_id', FObject^.ID).Get;

    if updated_rows > 0 then
      continue;
    }
    InsertRow.Value('node_id', node.ID)
      .Value('object_id', FObject^.ID).Get;
    UpdateObjectID;
  end;

  Result := True;
end;

procedure TNodeBag.Append (ANode : TNode);
var
  updated_rows : Integer;
begin
  FNodeList.Append(ANode);

  if (FObject <> nil) and (FObject^.ID <> -1) then
  begin
    updated_rows := UpdateRow.Update('node_id', ANode.ID)
      .Where('object_id', FObject^.ID).Get;

    if updated_rows > 0 then
      Exit;

    InsertRow.Value('node_id', ANode.ID)
      .Value('object_id', FObject^.ID).Get;
  end;
end;

procedure TNodeBag.Remove (ANode : TNode);
var
  Index : Integer;
begin
  Index := FNodeList.IndexOf(ANode);

  if Index <> -1 then
  begin
    FNodeList.Remove(Index);
    
    if (FObject <> nil) and (FObject^.ID <> -1) then
    begin
      FTable.Delete.Where('node_id', ANode.ID)
        .Where('object_id', FObject^.ID).Get;
    end;
  end;
end;

function TNodeBag.GetEnumerator : TNodeList.TIterator;
begin
  Result := FNodeList.GetEnumerator;
end;

end.