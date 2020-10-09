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
unit objects.greasebag;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, objects.common, sqlite3.schema, sqlite3.result, sqlite3.result_row,
  container.arraylist, utils.functor, objects.greasebundle;

type
  TGreaseBag = class(TCommonObject)
  private
    const
      GREASE_BAG_TABLE_NAME = 'greasebag';
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
    procedure Append (AGreaseBundle : TGreaseBundle);

    { Remove grease bundle from current bag. }
    procedure Remove (AGreaseBundle : TGreaseBundle);
  public
    type
      TGreaseBundleCompareFunctor = class
        (specialize TBinaryFunctor<TGreaseBundle, Integer>)
      public
        function Call (AValue1, AValue2 : TGreaseBundle) : Integer; override;
      end;

      TGreaseBundleList = class
        (specialize TArrayList<TGreaseBundle, TGreaseBundleCompareFunctor>);  
  public
    { Get enumerator for in operator. }
    function GetEnumerator : TGreaseBundleList.TIterator;
  private
    FObject : PCommonObject;
    FGreaseBundleList : TGreaseBundleList;
  public
    property Entity : PCommonObject read FObject write FObject;
  end;

implementation

{ TGreaseBag.TGreaseBundleCompareFunctor }

function TGreaseBag.TGreaseBundleCompareFunctor.Call (AValue1, AValue2 :
  TGreaseBundle) : Integer;
begin
  if AValue1.ID < AValue2.ID then
    Result := -1
  else if AValue2.ID < AValue1.ID then
    Result := 1
  else
    Result := 0;
end;

{ TGreaseBag }

constructor TGreaseBag.Create (AID : Int64);
begin
  inherited Create (AID);
  FObject := nil;
  FGreaseBundleList := TGreaseBundleList.Create;
end;

destructor TGreaseBag.Destroy;
begin
  FreeAndNil(FGreaseBundleList);
  inherited Destroy;
end;

function TGreaseBag.CheckSchema : Boolean;
var
  Schema : TSQLite3Schema;
  GreaseBundle : TGreaseBundle;
begin
  Schema := TSQLite3Schema.Create;
  GreaseBundle := TGreaseBundle.Create(-1);
  
  Schema
    .Id
    .Integer('greasebundle_id')
    .Integer('object_id');

  if not FTable.Exists then
    FTable.New(Schema);

  Result := FTable.CheckSchema(Schema) and GreaseBundle.CheckSchema;  

  FreeAndNil(GreaseBundle);
  FreeAndNil(Schema);
end;

function TGreaseBag.Table : String;
begin
  Result := GREASE_BAG_TABLE_NAME;
end;

function TGreaseBag.Load : Boolean;
var
  result_rows : TSQLite3Result;
  row : TSQLite3ResultRow;
  GreaseBundle : TGreaseBundle;
begin
  if (FObject = nil) or (FObject^.ID = -1) then
    Exit(False);

  result_rows := FTable.Select.All.Where('object_id', FObject^.ID).Get;
  FGreaseBundleList.Clear;

  for row in result_rows do
  begin
    GreaseBundle := 
      TGreaseBundle.Create(row.GetIntegerValue('greasebundle_id'));

    if GreaseBundle.Load then
      FGreaseBundleList.Append(GreaseBundle);
  end;

  Result := True;
end;

function TGreaseBag.Save : Boolean;
var
  GreaseBundle : TGreaseBundle;
  updated_rows : Integer;
begin
  if FObject = nil then
    Exit(False);

  if FObject^.ID = -1 then
    FObject^.Save;

  if not FGreaseBundleList.FirstEntry.HasValue then
    Exit(False);

  for GreaseBundle in FGreaseBundleList do
  begin
    if not GreaseBundle.Save then
      continue;
    {
    updated_rows := UpdateRow.Update('greasebundle_id', GreaseBundle.ID)
      .Where('object_id', FObject^.ID).Get;

    if updated_rows > 0 then
      continue;
    }
    InsertRow.Value('greasebundle_id', GreaseBundle.ID)
      .Value('object_id', FObject^.ID).Get;
    UpdateObjectID;
  end;

  Result := True;
end;

procedure TGreaseBag.Append (AGreaseBundle : TGreaseBundle);
var
  updated_rows : Integer;
begin
  FGreaseBundleList.Append(AGreaseBundle);

  if (FObject <> nil) and (FObject^.ID <> -1) then
  begin
    updated_rows := UpdateRow.Update('greasebundle_id', AGreaseBundle.ID)
      .Where('object_id', FObject^.ID).Get;

    if updated_rows > 0 then
      Exit;

    InsertRow.Value('greasebundle_id', AGreaseBundle.ID)
      .Value('object_id', FObject^.ID).Get;
  end;
end;

procedure TGreaseBag.Remove (AGreaseBundle : TGreaseBundle);
var
  Index : Integer;
begin
  Index := FGreaseBundleList.IndexOf(AGreaseBundle);

  if Index <> -1 then
  begin
    FGreaseBundleList.Remove(Index);
    
    if (FObject <> nil) and (FObject^.ID <> -1) then
    begin
      FTable.Delete.Where('greasebundle_id', AGreaseBundle.ID)
        .Where('object_id', FObject^.ID).Get;
    end;
  end;
end;

function TGreaseBag.GetEnumerator : TGreaseBundleList.TIterator;
begin
  Result := FGreaseBundleList.GetEnumerator;
end;

end.