(******************************************************************************)
(*                               SheduledRepair                               *)
(*                                                                            *)
(* This is a software for creating schedules  for repair work, accounting and *)
(* monitoring  their  implementation, accounting for the  necessary materials *)
(* and spare parts.                                                           *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/SheduledRepair              ivan@semenkov.pro *)
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
unit objects.grade;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, objects.namedobject, sqlite3.schema;

type
  TGrade = class(TNamedObject)
  private
    const
      GRADE_TABLE_NAME = 'grade';
  public
    { Get object database table name. }
    function Table : String; override;

    { Object deep copy. }
    procedure Assign (AGrade : TGrade);
  protected
    { Prepare current object database table scheme. }
    procedure PrepareSchema (var ASchema : TSQLite3Schema); override;

    { Load current object form database. }
    function LoadCurrentObject : Boolean; override;

    { Store current object to database. }
    procedure SaveCurrentObject; override;
  end;

implementation

{ TCommonObject }

procedure TGrade.PrepareSchema (var ASchema : TSQLite3Schema);
begin
  ASchema
    .Id
    .Text('name').NotNull;
end;

function TGrade.Table : String;
begin
  Result := GRADE_TABLE_NAME;
end;

function TGrade.LoadCurrentObject : Boolean;
begin
  Result := inherited LoadCurrentObject;
  FName := GetStringProperty('name');
end;

procedure TGrade.SaveCurrentObject;
begin
  SetStringProperty('name', FName);
end;

procedure TGrade.Assign (AGrade : TGrade);
begin
  Name := AGrade.Name;
end;

end.
