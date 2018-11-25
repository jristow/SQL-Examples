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

Select BuildingID, Sum(MaterialCost + LaborCost + (UtilityRate * Usage)) As 
From Utilities As U Join OperatingCost As OC
ON U.BuildingID = OC.BuildingID 
Join WorkOrders As WO 
On OC.WorkOrderID = WO.WorkOrderID 
Group By BuildingID
