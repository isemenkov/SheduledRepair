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
unit renderer.common.stringgrid;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, Classes, StdCtrls, Controls, Graphics, Types, Math, Grids,
  renderer.objects.common;

type
  PCustomStringGrid = ^TCustomStringGrid;  

  TCommonStringGridRenderer = class
  public
    constructor Create (AStringGrid : PCustomStringGrid; ARenderer :
      PObjectCommonRenderer);

  private
    FStringGrid : PCustomStringGrid;
    FRenderer : PObjectCommonRenderer;    
  protected
    property StringGrid : PCustomStringGrid read FStringGrid;
    property Renderer : PObjectCommonRenderer read FRenderer;
  end;

implementation

{ TCommonStringGridRenderer }

constructor TCommonStringGridRenderer.Create (AStringGrid : PCustomStringGrid;
  ARenderer : PObjectCommonRenderer);
begin
  FStringGrid := AStringGrid;
  FRenderer := ARenderer;

  with FStringGrid^ do
  begin
    DefaultDrawing := False;
    ExtendedSelect := False;
    FixedCols := 0;
    FixedRows := 0;
    Options := [goSmoothScroll];
  end;
end;


end.
