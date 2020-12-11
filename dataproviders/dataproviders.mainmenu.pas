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
  SysUtils, dataproviders.common, objects.common, objects.mainmenu.item;

type
  TMainMenuDataProvider = class(TCommonDataProvider)
  public
    function Load : Boolean; override;
  protected
    { Get current loaded objects table name. }
    function LoadObjectsTableName : String; override;

    { Load concrete object. }
    function LoadConcreteObject ({%H-}AID : Int64) : TCommonObject; override;
  private
    procedure JobSelectedEvent ({%H-}AMainMenuItem : TMainMenuItem);
    procedure JobAttachMenuEvent ({%H-}AMainMenuItem : TMainMenuItem);
    procedure JobDetachMenuEvent ({%H-}AMainMenuItem : TMainMenuItem);

    procedure EquipmentSelectedEvent ({%H-}AMainMenuItem : TMainMenuItem);
    procedure EquipmentUnselectEvent ({%H-}AMainMenuItem : TMainMenuItem);
  end;

  TMenuSubitemJobDataProvider = class(TCommonDataProvider)
  public
    function Load : Boolean; override;
  protected
    { Get current loaded objects table name. }
    function LoadObjectsTableName : String; override;

    { Load concrete object. }
    function LoadConcreteObject ({%H-}AID : Int64) : TCommonObject; override;
  private
    
  end;

implementation

uses
  dataprovider, datahandlers, mainmenuprovider, profilesprovider.mainmenu;

{ TMainMenuDataProvider }

function TMainMenuDataProvider.Load : Boolean;
begin
  Clear;
  
  Append(TMainMenuItem.Create(TMainMenu.MAIN_MENU_ITEM_LOGO, 
    MENU_ITEM_TYPE_LOGO, 'SheduledRepair'));
  Append(TMainMenuItem.Create(TMainMenu.MAIN_MENU_ITEM_JOB, 
    MENU_ITEM_TYPE_ITEM, 'Job', @JobSelectedEvent, nil, @JobAttachMenuEvent,
    @JobDetachMenuEvent));
  Append(TMainMenuItem.Create(TMainMenu.MAIN_MENU_ITEM_EQUIPMENT, 
    MENU_ITEM_TYPE_ITEM, 'Equipment', @EquipmentSelectedEvent, 
    @EquipmentUnselectEvent));
  
  Result := True;
end;

function TMainMenuDataProvider.LoadObjectsTableName : String;
begin
  Result := '';
end;

function TMainMenuDataProvider.LoadConcreteObject (AID : Int64) : TCommonObject;
begin
  Result := nil;
end;

procedure TMainMenuDataProvider.JobSelectedEvent (AMainMenuItem :
  TMainMenuItem);
begin
  Provider.ChangeData(TJobDataHandler.Create);
end;

procedure TMainMenuDataProvider.JobAttachMenuEvent (AMainMenuItem :
  TMainMenuItem);
begin
  MainMenu.AttachDynamicMenu(TMainMenu.MAIN_MENU_ITEM_JOB,
    TMenuSubitemJobDataProvider.Create, TMenuSubitemJobProfilesProvider.Create);
end;

procedure TMainMenuDataProvider.JobDetachMenuEvent (AMainMenuItem :
  TMainMenuItem);
begin
  MainMenu.DetachAllDynamicMenus(TMainMenu.MAIN_MENU_ITEM_JOB);
end;

procedure TMainMenuDataProvider.EquipmentSelectedEvent (AMainMenuItem :
  TMainMenuItem);
begin
  Provider.ChangeData(TEquipmentDataHandler.Create);
end;

procedure TMainMenuDataProvider.EquipmentUnselectEvent (AMainMenuItem :
  TMainMenuItem);
begin
  MainMenu.DetachObject(TMainMenu.MAIN_MENU_ITEM_EQUIPMENT);
end;

{ TMenuSubitemJobDataProvider }

function TMenuSubitemJobDataProvider.Load : Boolean;
begin
  Clear;
  
  Append(TMainMenuItem.Create(-1, MENU_ITEM_TYPE_SUBITEM, 'Create'));
  Append(TMainMenuItem.Create(-1, MENU_ITEM_TYPE_SUBITEM, 'Edit'));
  
  Result := True;
end;

function TMenuSubitemJobDataProvider.LoadObjectsTableName : String;
begin
  Result := '';
end;

function TMenuSubitemJobDataProvider.LoadConcreteObject (AID : Int64) : 
  TCommonObject;
begin
  Result := nil;
end;

end.
