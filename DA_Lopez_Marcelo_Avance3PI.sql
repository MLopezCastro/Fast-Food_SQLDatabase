USE FastFoodDB

--Pregunta 1: ¿Cuál es el total de ventas (TotalCompra) a nivel global?

SELECT * FROM Ordenes;

SELECT SUM(TotalCompra) AS 'Ventas a nivel global' FROM Ordenes;

--Pregunta 2: ¿Cuál es el precio promedio de los productos dentro de cada categoría?

SELECT * FROM Productos;

SELECT CategoriaID, FORMAT (AVG(Precio), '0.00') PrecioPromedioCategoria 
FROM Productos
GROUP BY CategoriaID
ORDER BY CategoriaID;

SELECT CategoriaID, CAST (AVG(Precio) AS DECIMAL(10,2)) PrecioPromedioCategoria 
FROM Productos
GROUP BY CategoriaID
ORDER BY CategoriaID;

--Pregunta 3: ¿Cuál es el valor de la orden mínima y máxima por cada sucursal?

SELECT * FROM Ordenes;

SELECT SucursalID, MIN(TotalCompra) ValorMinimoOrden, MAX(TotalCompra) ValorMaximoOrden 
FROM Ordenes
GROUP BY SucursalID;

--Pregunta 4: ¿Cuál es el mayor número de kilómetros recorridos para una entrega?

SELECT * FROM Ordenes;

SELECT MAX(KilometrosRecorrer) 'Mayor Nro. Kilómetros'
FROM Ordenes;

--Pregunta 5: ¿Cuál es la cantidad promedio de productos por orden?

SELECT * FROM DetalleOrdenes;

SELECT OrdenID, AVG(Cantidad) AS CantidadPromedioProductosOrden
FROM DetalleOrdenes
GROUP BY OrdenID;

--Pregunta 6: ¿Cuál es el total de ventas por cada tipo de pago?

SELECT * FROM Ordenes;

SELECT TipoPagoID, SUM(TotalCompra) AS TotalVentas 
FROM Ordenes
GROUP BY TipoPagoID
ORDER BY TotalVentas DESC;

SELECT * FROM TiposPago;

--Pregunta 7: ¿Cuál sucursal tiene la venta promedio más alta?

SELECT * FROM Ordenes;

SELECT TOP 1 SucursalID, FORMAT (AVG(TotalCompra), '00.00') AS VentaPromedio 
FROM Ordenes
GROUP BY SucursalID
ORDER BY VentaPromedio DESC;

SELECT TOP 1 SucursalID, CAST (AVG(TotalCompra) AS DECIMAL(10,2)) AS VentaPromedio 
FROM Ordenes
GROUP BY SucursalID
ORDER BY VentaPromedio DESC;

--Pregunta 8: ¿Cuáles son las sucursales que han generado ventas por orden por encima de $50

SELECT * FROM Ordenes;

SELECT SucursalID, SUM(TotalCompra) TotalVentas, COUNT(OrdenID) NumeroOrdenes, 
CAST (SUM (TotalCompra)/COUNT(OrdenID) AS DECIMAL(10,2)) VentaXOrden
FROM Ordenes
GROUP BY SucursalID
HAVING SUM(TotalCompra) > 50
ORDER BY TotalVentas DESC;

--Pregunta 9: ¿Cómo se comparan las ventas promedio antes y después del 1 de julio de 2023?

SELECT * FROM Ordenes;

(SELECT 'Antes de 2023-07-01' AS Periodo, CAST (AVG(Totalcompra) AS DECIMAL (10,2)) AS VentasPromedio
FROM Ordenes
WHERE FechaOrdenTomada < '2023-07-01')
UNION
(SELECT 'Despues de 2023-07-01' AS Periodo, CAST (AVG(Totalcompra) AS DECIMAL (10,2)) AS VentasPromedio
FROM Ordenes
WHERE FechaOrdenTomada > '2023-07-01');

/*Pregunta 10: ¿Durante qué horario del día (mañana, tarde, noche) se registra la mayor cantidad de ventas, 
cuál es el valor promedio de estas ventas, y cuál ha sido la venta máxima alcanzada?*/

SELECT * FROM Ordenes;

SELECT TOP 1 HorarioVenta, COUNT(OrdenID) CantidadVentas,
SUM(TotalCompra) TotalVentas, MAX(TotalCompra) AS VentaMaxima, 
CAST (AVG(TotalCompra) AS DECIMAL (10,2)) VentaPromedio
FROM Ordenes
GROUP BY HorarioVenta
ORDER BY TotalVentas DESC;
































