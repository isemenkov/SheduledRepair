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
unit eventproviders.mainmenu.item.entity;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, eventproviders.common, objects.common;

type
  TMainMenuItemEntityEventProvider = class(TCommonEventProvider)
  public
    constructor Create; override;
  private
    function EntitySelectEvent ({%H-}AObject : TCommonObject) : Boolean;
    function EntityClickEvent ({%H-}AObject : TCommonObject) : Boolean;
    function EntityAttachDynamicMenuEvent ({%H-}AObject : TCommonObject) : 
      Boolean;
    function EntityDetachDynamicMenuEvent ({%H-}AObject : TCommonObject) : 
      Boolean;
  end;

implementation

uses
  dataprovider, mainmenuprovider, profilesprovider.mainmenu,
  dataproviders.mainmenu;

{ TMainMenuItemEntityEventProvider }

constructor TMainMenuItemEntityEventProvider.Create;
begin
  inherited Create;
  
  Register(EVENT_OBJECT_SELECT, @EntitySelectEvent);
  Register(EVENT_OBJECT_CLICK, @EntityClickEvent);
  Register(EVENT_OBJECT_ATTACH_DYNAMIC_MENU, @EntityAttachDynamicMenuEvent);
  Register(EVENT_OBJECT_DETACH_DYNAMIC_MENU, @EntityDetachDynamicMenuEvent);
end;

function TMainMenuItemEntityEventProvider.EntitySelectEvent (AObject : 
  TCommonObject) : Boolean;
begin
  Result := True;
end;

function TMainMenuItemEntityEventProvider.EntityClickEvent (AObject : 
  TCommonObject) : Boolean;
begin
  {
  Provider.ChangeData(TJobDataHandler.Create);
  MainMenu.DetachObject(TMainMenu.MAIN_MENU_ITEM_JOB);
  MainMenu.DetachObject(TMainMenu.MAIN_MENU_ITEM_EQUIPMENT);
  MainMenu.DetachAllDynamicMenus(TMainMenu.MAIN_MENU_ITEM_EQUIPMENT);
  }
  Result := True;
end;

function TMainMenuItemEntityEventProvider.EntityAttachDynamicMenuEvent 
  (AObject : TCommonObject) : Boolean;
begin
  MainMenu.AttachDynamicMenu(TMainMenu.MAIN_MENU_ITEM_ENTITY,
    TMenuSubitemEntityCreateDataProvider.Create,
    TMainMenuSubitemProfilesProvider.Create);
  
  Result := True;
end;

function TMainMenuItemEntityEventProvider.EntityDetachDynamicMenuEvent 
  (AObject : TCommonObject) : Boolean;
begin
  MainMenu.DetachAllDynamicMenus(TMainMenu.MAIN_MENU_ITEM_ENTITY);
  
  Result := True;
end;

end.
