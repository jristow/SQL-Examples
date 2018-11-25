Use master;
GO

Create Database FacilityInfo;
GO

Use FacilityInfo

Create Table Buildings
(
    BuildingID INT Not Null Primary Key,
    SquareFootage Int Not Null,
    ReplacementCost Money Not Null,
    BuildingCondition Int Null
);

Create Table EquipmentItems
(
    EquipID Int Not Null Primary Key,
    Condition Int Null,
    BuildingID Int Not Null References Buildings(BuildingID)
);

Create Table WorkOrders
(
    WorkOrderID Int Not Null Primary Key,
    MaterialCost Money Null,
    LaborCost Varchar(20) Null,
    EquipID Int Not Null References EquipmentItems(EquipID)
);

Create Table Utilities
(
    MeterID Int Not Null Primary Key,
    Usage varchar(20) Null,
    UtilityRate money Null,
    BuildingID Int Not Null References Buildings(BuildingID)
);

Create Table OperatingCost
(
    BuildingID Int Not Null References Buildings(BuildingID),
    WorkOrderID Int Not Null References WorkOrders(WorkOrderID),
    EquipID Int Not Null References EquipmentItems(EquipID)
);
GO

Insert Into Buildings
    (BuildingID, SquareFootage, ReplacementCost, BuildingCondition)
VALUES
    (1, 10000, 1000000, 68),
    (2, 30000, 2500000, 80),
    (3, 5000, 15000000, 97),
    (4, 2500, 750000, 50),
    (5, 6000, 4000000, 76);

Insert Into EquipmentItems
    (EquipID, Condition, BuildingID)
VALUES
    (1, 50, 1),
    (2, 75, 1),
    (3, 70, 1),
    (4, 90, 2),
    (5, 80, 2),
    (6, 70, 2),
    (7, 97, 3),
    (8, 50, 4),
    (9, 50, 4),
    (10, 76, 5);

Insert Into WorkOrders
    (WorkOrderID, MaterialCost, LaborCost, EquipID)
VALUES
    (1, Null, 100, 1),
    (2, 1000, 300, 2),
    (3, 300, 1000, 3),
    (4, Null, 500, 5),
    (5, 5000, 2000, 10);

Insert Into Utilities
    (MeterID, Usage, UtilityRate, BuildingID)
VALUES
    (1, 100, 2.50, 5),
    (2, 50, 2.50, 4),
    (3, 200, 2.50, 3),
    (4, 1000, 1.25, 2),
    (5, 500, 2.00, 1);


/* Creating views for each table */

Create View BuildingCondition AS
    Select BuildingID, BuildingCondition
    From Buildings;
    GO

Create View EquipmentCondition AS
    Select EquipID, Condition
    From EquipmentItems;
    GO

Create View WorkOrderInfo AS
    Select MaterialCost, LaborCost, WorkOrderID
    From WorkOrders;
    GO

Create View UtilityCost AS
    Select MeterID, UtilityRate, Usage 
    From Utilities;
    GO

/* Creating a view using columns from two related tables */

Create View BuildingExpense AS
    Select BuildingID, WorkOrderID, MaterialCost, LaborCost
    From WorkOrders As WO Join EquipmentItems As E
    On WO.EquipID = E.EquipID 
    Join Buildings As B
    On E.BuildingID = B.BuildingID;
    GO

/* Creating some queries */

Select BuildingID, Sum(MaterialCost + LaborCost + (UtilityRate * Usage)) As OperatingExpense
From Utilities As U Join OperatingCost As OC
ON U.BuildingID = OC.BuildingID 
Join WorkOrders As WO 
On OC.WorkOrderID = WO.WorkOrderID 
Group By BuildingID
