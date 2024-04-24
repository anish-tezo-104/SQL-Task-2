-- JOINS --

-- 1
SELECT DISTINCT Employee.FirstName, Employee.LastName
FROM Employee
JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
WHERE Orders.OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

-- 2
SELECT DISTINCT Orders.EmployeeID
FROM Orders
WHERE Orders.OrderDate < '1996-10-16';

--3
SELECT SUM(OrderDetails.Quantity) AS TotalOrderedProducts
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--4
SELECT COUNT(OrderDetails.ProductID)
FROM OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE Employee.FirstName = 'Anne'
AND Employee.LastName = 'Dodsworth'
AND Orders.OrderDate BETWEEN '1997-01-13' AND '1997-04-16';

--5
SELECT COUNT(*) FROM Orders
JOIN
Employee
ON Employee.EmployeeID = Orders.EmployeeID
WHERE Employee.FirstName = 'Robert' AND Employee.LastName = 'King';

--6
SELECT COUNT(OrderDetails.ProductID)
FROM OrderDetails
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE Employee.FirstName = 'Robert'
AND Employee.LastName = 'King'
AND Orders.OrderDate BETWEEN '1996-08-15' AND '1997-08-15';

--7
SELECT DISTINCT Employee.EmployeeID, 
       CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName, 
       Employee.HomePhone
FROM Orders
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE Orders.OrderDate BETWEEN '1997-01-13' AND '1997-04-16'
ORDER BY Employee.EmployeeID ASC;

--8
SELECT TOP 1 Products.ProductID, Products.ProductName, COUNT(*) AS NumberOfOrders
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.ProductID, Products.ProductName
ORDER BY COUNT(*) DESC;

--9
SELECT TOP 5 OrderDetails.ProductID, Products.ProductName, SUM(Quantity) AS TotalShipped
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY OrderDetails.ProductID, ProductName
ORDER BY TotalShipped ASC;

--10
SELECT SUM(DISTINCT(OrderDetails.UnitPrice * OrderDetails.Quantity) - (OrderDetails.UnitPrice * OrderDetails.Quantity * OrderDetails.Discount)) AS TotalPrice
FROM OrderDetails
JOIN
Orders ON Orders.OrderID = OrderDetails.OrderID
JOIN
Employee
ON Orders.EmployeeID = Employee.EmployeeID
WHERE Employee.FirstName = 'Laura' AND Employee.LastName = 'Callahan'
AND Orders.OrderDate = '1997-01-13';

--11
SELECT COUNT(DISTINCT Orders.EmployeeID) AS TotalCount
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName IN ('Gorgonzola Telino', 'Gnocchi di nonna Alice', 'Raclette Courdavault', 'Camembert Pierrot')
AND Orders.OrderDate BETWEEN '1997-01-01' AND '1997-01-31';

--12
SELECT DISTINCT CONCAT(Employee.FirstName, ' ', Employee.LastName) AS 'Employee Name', Products.ProductName
FROM Orders
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
WHERE Products.ProductName = 'Tofu'
AND Orders.OrderDate BETWEEN '1997-01-13' AND '1997-01-30';

--13
SELECT 
    Employee.EmployeeID,
    CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName,
    DATEDIFF(YEAR, Employee.BirthDate, Orders.OrderDate) AS AgeInYears,
    DATEDIFF(MONTH, Employee.BirthDate, Orders.OrderDate) % 12 AS AgeInMonths,
    DATEDIFF(DAY, Employee.BirthDate, Orders.OrderDate) % 30 AS AgeInDays
FROM 
    Orders
JOIN 
    Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE 
    MONTH(Orders.OrderDate) = 8;

--14
SELECT DISTINCT Shippers.CompanyName,  COUNT(Orders.OrderId) AS NumberOfOrdersShipped
FROM Shippers
LEFT JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
GROUP BY Shippers.CompanyName;

--15
SELECT Shippers.CompanyName, COUNT(OrderDetails.ProductID) AS TotalProductsShipped
FROM Shippers
LEFT JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
LEFT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Shippers.CompanyName;

--16
SELECT TOP 1
Shippers.ShipperID, Shippers.CompanyName,  COUNT(Orders.OrderId) AS NumberOfOrders
FROM Shippers
LEFT JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
GROUP BY Shippers.ShipperID, Shippers.CompanyName
ORDER BY NumberOfOrders DESC;

--17 
SELECT TOP 1 Shippers.CompanyName, SUM(OrderDetails.Quantity) AS TotalProductsSupplied
FROM Shippers
JOIN Orders ON Shippers.ShipperID = Orders.ShipperID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.OrderDate BETWEEN '1996-08-10' AND '1998-09-20'
GROUP BY Shippers.CompanyName
ORDER BY TotalProductsSupplied DESC;

--18
SELECT DISTINCT Employee.EmployeeID, Employee.FirstName, Employee.LastName
FROM Employee
LEFT JOIN Orders ON Employee.EmployeeID = Orders.EmployeeID
WHERE Orders.OrderDate <> '1997-04-04' OR Orders.OrderDate IS NULL;

--19
SELECT COUNT(OrderDetails.ProductID) AS TotalProductsShipped
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE Employee.FirstName = 'Steven' AND Employee.LastName = 'Buchanan';

--20
SELECT COUNT(Orders.OrderID) AS TotalOrdersShipped
FROM Orders
JOIN Employee ON Orders.EmployeeID = Employee.EmployeeID
JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE Employee.FirstName = 'Michael' AND Employee.LastName = 'Suyama'
AND Shippers.CompanyName = 'Federal Shipping';

--21
SELECT COUNT(DISTINCT Orders.OrderID) AS TotalOrders
FROM Orders
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.Country IN ('UK', 'Germany');

--22
SELECT SUM(TotalPrice) AS TotalAmountReceived
FROM (
    SELECT DISTINCT OrderDetails.OrderID,
           SUM((OrderDetails.UnitPrice * OrderDetails.Quantity) - (OrderDetails.UnitPrice * OrderDetails.Quantity * OrderDetails.Discount)) AS TotalPrice
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
    WHERE Suppliers.CompanyName = 'Exotic Liquids'
    AND MONTH(Orders.OrderDate) = 1
    AND YEAR(Orders.OrderDate) = 1997
    GROUP BY OrderDetails.OrderID
) AS OrderTotals;

--23
SELECT DISTINCT OrderDate AS NoOrderDates from Orders
WHERE Orders.OrderDate >= '1997-01-01' AND Orders.OrderDate <= '1997-01-31'
AND Orders.OrderDate NOT IN (
select Orders.OrderDate from Orders
Inner JOIN OrderDetails on OrderDetails.OrderID = Orders.OrderID
Inner JOIN Products on Products.ProductID = OrderDetails.ProductID
Inner JOIN Suppliers s on s.SupplierID = Products.SupplierID
where s.CompanyName = 'Tokyo Traders');

--24
SELECT DISTINCT Employee.FirstName, Employee.LastName
FROM Employee
LEFT JOIN (
    SELECT Orders.EmployeeID
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
    WHERE MONTH(Orders.OrderDate) = 5
    AND Suppliers.CompanyName = 'Ma Maison'
) AS MaMaisonOrders ON Employee.EmployeeID = MaMaisonOrders.EmployeeID
WHERE MaMaisonOrders.EmployeeID IS NULL;


--25
SELECT TOP 1 ShipperID, CompanyName, SUM(Quantity) AS TotalQuantity
FROM (
    SELECT Orders.ShipperID, Shippers.CompanyName, OrderDetails.Quantity
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN Products ON OrderDetails.ProductID = Products.ProductID
    JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
    WHERE MONTH(Orders.OrderDate) IN (9, 10)
    AND YEAR(Orders.OrderDate) = 1997
) AS ShipperQuantities
GROUP BY ShipperID, CompanyName
ORDER BY TotalQuantity;


--26
SELECT DISTINCT Products.ProductID, Products.ProductName 
FROM Products
LEFT JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
LEFT JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE Orders.OrderID IS NULL OR MONTH(Orders.OrderDate) <> 8 OR YEAR(Orders.OrderDate) <> 1997;

--27
SELECT Employee.EmployeeID, CONCAT(Employee.FirstName, ' ', Employee.LastName) AS 'Employee Name', Products.ProductID, Products.ProductName
FROM Employee
CROSS JOIN Products
LEFT JOIN (
    SELECT DISTINCT Orders.EmployeeID, OrderDetails.ProductID
    FROM Orders
    JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
) AS OrderedProducts ON Employee.EmployeeID = OrderedProducts.EmployeeID AND Products.ProductID = OrderedProducts.ProductID
WHERE OrderedProducts.EmployeeID IS NULL
ORDER BY Employee.EmployeeID, Products.ProductID
;

--28
SELECT Orders.ShipperID, Shippers.CompanyName, COUNT(*) AS TotalShipments
FROM Orders
JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE MONTH(Orders.OrderDate) IN (4, 5, 6)
AND YEAR(Orders.OrderDate) IN (1996, 1997)
GROUP BY Orders.ShipperID, Shippers.CompanyName
ORDER BY TotalShipments DESC;

--29
SELECT TOP 1 Suppliers.Country AS Country, SUM(OrderDetails.Quantity) AS TotalProducts
FROM Suppliers
JOIN Products ON Suppliers.SupplierID = Products.SupplierID
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE YEAR(Orders.OrderDate) = 1997
GROUP BY Suppliers.Country
ORDER BY TotalProducts DESC;


--30
SELECT AVG(DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate)) AS AverageDaysToShip
FROM Orders;

--31
SELECT TOP 1 Shippers.ShipperID, Shippers.CompanyName, AVG(DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate)) AS AvgDaysToShip
FROM Orders
JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
GROUP BY Shippers.ShipperID, Shippers.CompanyName
ORDER BY AvgDaysToShip ASC;


--32
SELECT TOP 1 
    Orders.OrderID, 
    CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName, 
    COUNT(OrderDetails.ProductID) AS NumberOfProducts, 
    DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysToShip, 
    Shippers.CompanyName AS ShipperCompanyName
FROM 
    Orders
JOIN 
    Employee ON Orders.EmployeeID = Employee.EmployeeID
JOIN 
    OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN 
    Shippers ON Orders.ShipperID = Shippers.ShipperID
WHERE Orders.ShippedDate IS NOT NULL
GROUP BY 
    Orders.OrderID, 
    CONCAT(Employee.FirstName, ' ', Employee.LastName), 
    DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate), 
    Shippers.CompanyName
ORDER BY 
    DaysToShip ASC;



-- UNIONS --

-- 1
WITH MinShippingDays AS (
    SELECT TOP 1
        Orders.OrderID, 
        CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName, 
        DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysToShip, 
        Shippers.CompanyName AS ShipperCompanyName
    FROM 
        Orders
    JOIN 
        Employee ON Orders.EmployeeID = Employee.EmployeeID
    JOIN 
        Shippers ON Orders.ShipperID = Shippers.ShipperID
	WHERE Orders.ShippedDate IS NOT NULL
    ORDER BY 
        DaysToShip ASC
),
MaxShippingDays AS (
    SELECT TOP 1
        Orders.OrderID, 
        CONCAT(Employee.FirstName, ' ', Employee.LastName) AS FullName, 
        DATEDIFF(day, Orders.OrderDate, Orders.ShippedDate) AS DaysToShip, 
        Shippers.CompanyName AS ShipperCompanyName
    FROM 
        Orders
    JOIN 
        Employee ON Orders.EmployeeID = Employee.EmployeeID
    JOIN 
        Shippers ON Orders.ShipperID = Shippers.ShipperID
    ORDER BY 
        DaysToShip DESC
)
SELECT 
    '1' AS OrderType,
    OrderID, 
    FullName, 
    DaysToShip, 
    ShipperCompanyName
FROM 
    MinShippingDays

UNION ALL

SELECT 
    '2' AS OrderType,
    OrderID, 
    FullName, 
    DaysToShip, 
    ShipperCompanyName
FROM 
    MaxShippingDays;

--2

WITH CheapestProduct AS (
    SELECT TOP 1
        Products.ProductID, 
		Products.ProductName,
		Products.UnitPrice
    FROM 
        Orders
	JOIN
		OrderDetails ON OrderDetails.OrderID = Orders.OrderID
	JOIN 
		Products ON OrderDetails.ProductID = Products.ProductID
	WHERE
		Orders.OrderDate >= '1997-10-07' AND Orders.OrderDate <= '1997-10-13'
	ORDER BY Products.UnitPrice ASC
),
CostliestProduct AS (
    SELECT TOP 1
        Products.ProductID, 
		Products.ProductName,
		Products.UnitPrice
    FROM 
        Orders
	JOIN
		OrderDetails ON OrderDetails.OrderID = Orders.OrderID
	JOIN 
		Products ON OrderDetails.ProductID = Products.ProductID
	WHERE
		Orders.OrderDate >= '1997-10-07' AND Orders.OrderDate <= '1997-10-13'
	ORDER BY Products.UnitPrice DESC
)
SELECT 
    '1' AS ProductType,
    ProductID,
    ProductName,
    UnitPrice
FROM 
    CheapestProduct

UNION ALL

SELECT 
    '2' AS ProductType,
    ProductID,
    ProductName,
    UnitPrice
FROM 
    CostliestProduct;


-- OR --

WITH ProductsByWeek AS (
    SELECT 
        OrderDetails.ProductID,
        Products.ProductName,
        Products.UnitPrice,
        DENSE_RANK() OVER (ORDER BY Products.UnitPrice ASC) AS CheapestRank,
        DENSE_RANK() OVER (ORDER BY Products.UnitPrice DESC) AS CostliestRank
    FROM 
        Orders
    JOIN 
        OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    JOIN 
        Products ON OrderDetails.ProductID = Products.ProductID
    WHERE 
        Orders.OrderDate >= '1997-10-07' AND Orders.OrderDate <= '1997-10-13'
)
SELECT DISTINCT
    '1' AS ProductType,
    ProductID,
    ProductName,
    UnitPrice
FROM 
    ProductsByWeek
WHERE 
    CheapestRank = 1

UNION ALL

SELECT DISTINCT
    '2' AS ProductType,
    ProductID,
    ProductName,
    UnitPrice
FROM 
    ProductsByWeek
WHERE 
    CostliestRank = 1;


-- CASE --

SELECT DISTINCT 
Employee.EmployeeId, Shippers.ShipperID,
    CASE 
        WHEN Shippers.ShipperID = 1 THEN 'Shipping Federal'
        WHEN Shippers.ShipperID = 2 THEN 'Express Speedy'
        WHEN Shippers.ShipperID = 3 THEN 'United Package'
        ELSE Shippers.CompanyName
    END AS ShipperName
FROM 
    Shippers
INNER JOIN
	Orders ON Shippers.ShipperId = Orders.ShipperId
INNER JOIN 
    Employee ON Orders.EmployeeID = Employee.EmployeeID
WHERE 
    Employee.EmployeeID IN (1, 3, 5, 7);
