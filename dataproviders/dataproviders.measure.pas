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
unit dataproviders.measure;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, dataproviders.common, objects.common, objects.measure;

type
  PMeasureDataProvider = ^TMeasureDataProvider;
  TMeasureDataProvider = class(specialize TCommonDataProvider<TMeasure>)
  public
    function Load : Boolean; override;
    
  protected
    function OpenEditor (AObject : TCommonObject) : Boolean; override;
  end;

implementation

{ TMeasureDataProvider }

function TMeasureDataProvider.Load : Boolean;
var
  MeasureItem : TMeasure;
begin
  MeasureItem := TMeasure.Create(-1);
  Result := LoadObjects(MeasureItem.Table);
  FreeAndNil(MeasureItem);
end;

function TMeasureDataProvider.OpenEditor (AObject : TCommonObject) :
  Boolean;
begin
  Result := False;
end;

end.