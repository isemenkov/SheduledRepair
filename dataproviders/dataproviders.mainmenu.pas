(******************************************************************************)
(*                               SheduledRepair                               *)
(*                                                                            *)
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
unit dataproviders.mainmenu;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, Graphics, dataproviders.common, objects.common,
  objects.mainmenu.item, renderer.profile.objectprofile,
  renderer.profile.profileitem;

type
  TMainMenuDataProvider = class(TCommonDataProvider)
  public
    function Load : Boolean; override;
  protected
    { Set default object renderer profile. }
    function DefaultObjectProfile :  TRendererObjectProfile; override;

    { Get current loaded objects table name. }
    function LoadObjectsTableName : String; override;

    { Load concrete object. }
    function LoadConcreteObject (AID : Int64) : TCommonObject; override;
  end;

implementation

{ TMainMenuDataProvider }

function TMainMenuDataProvider.Load : Boolean;
var
  MenuItem : TMainMenuItem;
begin
  MenuItem := TMainMenuItem.Create(0, MENU_ITEM_LOGO, '');
  Append(MenuItem);

  MenuItem := TMainMenuItem.Create(1, MENU_ITEM, 'Equipment');
  Append(MenuItem);

  Result := True;
end;

function TMainMenuDataProvider.DefaultObjectProfile :  TRendererObjectProfile;
begin
  Result := TRendererObjectProfile.Create(-1);

  { Set default profile items. }
  Result.DefaultProfile.Background := clWhite;
  Result.DefaultProfile.Items['Icon'] := TRendererProfileItem.Create(-1);
  Result.DefaultProfile.Items['Title'] := TRendererProfileItem.Create(-1);

  { Set selected profile items. }
  Result.SelectedProfile.Background := clYellow;
  Result.SelectedProfile.Items['Icon'] := TRendererProfileItem.Create(-1);
  Result.SelectedProfile.Items['Title'] := TRendererProfileItem.Create(-1);

  { Set hover profile items. }
  Result.HoverProfile.Background := clSilver;
  Result.HoverProfile.Items['Icon'] := TRendererProfileItem.Create(-1);
  Result.HoverProfile.Items['Title'] := TRendererProfileItem.Create(-1);
end;

function TMainMenuDataProvider.LoadObjectsTableName : String;
begin
  Result := '';
end;

function TMainMenuDataProvider.LoadConcreteObject (AID : Int64) : TCommonObject;
begin
  Result := nil;
end;

end.
