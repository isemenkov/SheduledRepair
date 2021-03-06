unit equipment_testcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, objects.equipment, objects.entity,
  dateutils;

type
  TEquipmentTestCase = class(TTestCase)
  published
    procedure Test_Equipment_CheckSchema;
    procedure Test_Equipment_SaveAndLoad;
    procedure Test_Equipment_Delete;
  end;

implementation

procedure TEquipmentTestCase.Test_Equipment_CheckSchema;
var
  equipment : TEquipment;
begin
  equipment := TEquipment.Create(-1);
  AssertTrue('Database table schema is not correct', equipment.CheckSchema);
  FreeAndNil(equipment);
end;

procedure TEquipmentTestCase.Test_Equipment_SaveAndLoad;
var
  equipment : TEquipment;
  entity : TEntity;
  id : Int64;
  counter : Integer;
begin
  equipment := TEquipment.Create(-1);
  AssertTrue('Database table schema is not correct', equipment.CheckSchema);

  equipment.Name := 'equipment';
  
  entity := TEntity.Create(-1);
  entity.Name := 'Entity 1';
  entity.Quantity.Measure.Name := 'pcs';
  entity.Quantity.Count := 2;
  entity.Period.Quantity.Measure.Name := 'weeks';
  entity.Period.Quantity.Count := 32;

  equipment.EntityBag.Append(entity);

  entity := TEntity.Create(-1);
  entity.Name := 'Entity 2';
  entity.Quantity.Measure.Name := 'pcs';
  entity.Quantity.Count := 1;
  entity.Period.Quantity.Measure.Name := 'weeks';
  entity.Period.Quantity.Count := 24;

  equipment.EntityBag.Append(entity);

  AssertTrue('Object save error', equipment.Save);

  id := equipment.ID;
  FreeAndNil(equipment);

  equipment := TEquipment.Create(id);
  AssertTrue('Equipment object load error', equipment.Load);
  AssertTrue('Equipment object ''ID'' is not correct error', equipment.ID = id);
  AssertTrue('Equipment object ''Name'' is not correct error', 
    equipment.Name = 'equipment');

  counter := 0;
  for entity in equipment.EntityBag do
  begin
    case counter of
    0 : begin
      AssertTrue('Equipment object ''Entity.Name'' is not correct error', 
        entity.Name = 'Entity 1');
      AssertTrue('Equipment object ''Entity.Quantity.Measure.Name'' is not correct error', 
        entity.Quantity.Measure.Name = 'pcs');
      AssertEquals('Equipment object ''Entity.Quantity.Count'' is not correct error', 
        entity.Quantity.Count, 2, 0.01);
      AssertTrue('Equipment object ''Entity.Period.Quantity.Measure.Name'' is not correct error', 
        entity.Period.Quantity.Measure.Name = 'weeks');
      AssertEquals('Equipment object ''Entity.Period.Quantity.Count'' is not correct error', 
        entity.Period.Quantity.Count, 32, 0.01);
    end;
    1 : begin
      AssertTrue('Equipment object ''Entity.Name'' is not correct error', 
        entity.Name = 'Entity 2');
      AssertTrue('Equipment object ''Entity.Quantity.Measure.Name'' is not correct error', 
        entity.Quantity.Measure.Name = 'pcs');
      AssertEquals('Equipment object ''Entity.Quantity.Count'' is not correct error', 
        entity.Quantity.Count, 1, 0.01);
      AssertTrue('Equipment object ''Entity.Period.Quantity.Measure.Name'' is not correct error', 
        entity.Period.Quantity.Measure.Name = 'weeks');
      AssertEquals('Equipment object ''Entity.Period.Quantity.Count'' is not correct error', 
        entity.Period.Quantity.Count, 24, 0.01);
    end;
    2 : begin
      Fail('Impossible Equipment.EntityBag item.');
    end;
  end;
  Inc(counter);
  end;

  AssertTrue('GreaseBag items count is not correct', counter = 2);

  FreeAndNil(equipment);
end;

procedure TEquipmentTestCase.Test_Equipment_Delete;
var
  equipment : TEquipment;
  entity : TEntity;
  id : Int64;
  counter : Integer;
begin
  equipment := TEquipment.Create(-1);
  AssertTrue('Database table schema is not correct', equipment.CheckSchema);

  equipment.Name := 'equipment';
  
  entity := TEntity.Create(-1);
  entity.Name := 'Entity 1';
  entity.Quantity.Measure.Name := 'pcs';
  entity.Quantity.Count := 2;
  entity.Period.Quantity.Measure.Name := 'weeks';
  entity.Period.Quantity.Count := 32;

  equipment.EntityBag.Append(entity);

  entity := TEntity.Create(-1);
  entity.Name := 'Entity 2';
  entity.Quantity.Measure.Name := 'pcs';
  entity.Quantity.Count := 1;
  entity.Period.Quantity.Measure.Name := 'weeks';
  entity.Period.Quantity.Count := 24;

  equipment.EntityBag.Append(entity);

  AssertTrue('Object save error', equipment.Save);

  id := equipment.ID;
  FreeAndNil(equipment);

  equipment := TEquipment.Create(id);
  AssertTrue('Equipment object load error', equipment.Load);
  AssertTrue('Equipment object ''ID'' is not correct error', equipment.ID = id);
  AssertTrue('Equipment object ''Name'' is not correct error', 
    equipment.Name = 'equipment');

  counter := 0;
  for entity in equipment.EntityBag do
  begin
    case counter of
    0 : begin
      AssertTrue('Equipment object ''Entity.Name'' is not correct error', 
        entity.Name = 'Entity 1');
      AssertTrue('Equipment object ''Entity.Quantity.Measure.Name'' is not correct error', 
        entity.Quantity.Measure.Name = 'pcs');
      AssertEquals('Equipment object ''Entity.Quantity.Count'' is not correct error', 
        entity.Quantity.Count, 2, 0.01);
      AssertTrue('Equipment object ''Entity.Period.Quantity.Measure.Name'' is not correct error', 
        entity.Period.Quantity.Measure.Name = 'weeks');
      AssertEquals('Equipment object ''Entity.Period.Quantity.Count'' is not correct error', 
        entity.Period.Quantity.Count, 32, 0.01);
    end;
    1 : begin
      AssertTrue('Equipment object ''Entity.Name'' is not correct error', 
        entity.Name = 'Entity 2');
      AssertTrue('Equipment object ''Entity.Quantity.Measure.Name'' is not correct error', 
        entity.Quantity.Measure.Name = 'pcs');
      AssertEquals('Equipment object ''Entity.Quantity.Count'' is not correct error', 
        entity.Quantity.Count, 1, 0.01);
      AssertTrue('Equipment object ''Entity.Period.Quantity.Measure.Name'' is not correct error', 
        entity.Period.Quantity.Measure.Name = 'weeks');
      AssertEquals('Equipment object ''Entity.Period.Quantity.Count'' is not correct error', 
        entity.Period.Quantity.Count, 24, 0.01);
    end;
    2 : begin
      Fail('Impossible Equipment.EntityBag item.');
    end;
  end;
  Inc(counter);
  end;

  AssertTrue('GreaseBag items count is not correct', counter = 2);

  AssertTrue('Equipment object delete error', equipment.Delete);
  AssertTrue('Equipment object impossible load', not equipment.Load);

  FreeAndNil(equipment);
end;

initialization
  RegisterTest(TEquipmentTestCase);
end.

