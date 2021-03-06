unit supplier_testcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, objects.supplier;

type
  TSupplierTestCase = class(TTestCase)
  published
    procedure Test_Supplier_CheckSchema;
    procedure Test_Supplier_SaveAndLoad;
    procedure Test_Supplier_Delete;
  end;

implementation

procedure TSupplierTestCase.Test_Supplier_CheckSchema;
var
  supplier : TSupplier;
begin
  supplier := TSupplier.Create(-1);
  AssertTrue('Database table schema is not correct', supplier.CheckSchema);
  FreeAndNil(supplier);
end;

procedure TSupplierTestCase.Test_Supplier_SaveAndLoad;
var
  supplier : TSupplier;
  id : Int64;
begin
  supplier := TSupplier.Create(-1);
  AssertTrue('Database table schema is not correct', supplier.CheckSchema);

  supplier.Name := 'ECO';
  AssertTrue('Object save error', supplier.Save);
  
  id := supplier.ID;
  FreeAndNil(supplier);

  supplier := TSupplier.Create(id);
  AssertTrue('Supplier object load error', supplier.Load);
  AssertTrue('Supplier object ''ID'' is not correct error', supplier.ID = id);
  AssertTrue('Supplier object ''Name'' is not correct', supplier.Name = 'ECO');

  FreeAndNil(supplier);
end;

procedure TSupplierTestCase.Test_Supplier_Delete;
var
  supplier : TSupplier;
  id : Int64;
begin
  supplier := TSupplier.Create(-1);
  AssertTrue('Database table schema is not correct', supplier.CheckSchema);

  supplier.Name := 'ECO';
  AssertTrue('Object save error', supplier.Save);
  
  id := supplier.ID;
  FreeAndNil(supplier);

  supplier := TSupplier.Create(id);
  AssertTrue('Supplier object load error', supplier.Load);
  AssertTrue('Supplier object ''ID'' is not correct error', supplier.ID = id);
  AssertTrue('Supplier object ''Name'' is not correct', supplier.Name = 'ECO');

  AssertTrue('Supplier object delete error', supplier.Delete);
  AssertTrue('Supplier object impossible load', not supplier.Load);

  FreeAndNil(supplier);
end;

initialization
  RegisterTest(TSupplierTestCase);
end.

