USE FastFoodDB

--Pregunta 1: �Cu�l es el total de ventas (TotalCompra) a nivel global?

SELECT * FROM Ordenes;

SELECT SUM(TotalCompra) AS 'Ventas a nivel global' FROM Ordenes;

--Pregunta 2: �Cu�l es el precio promedio de los productos dentro de cada categor�a?

SELECT * FROM Productos;

SELECT CategoriaID, FORMAT (AVG(Precio), '0.00') PrecioPromedioCategoria 
FROM Productos
GROUP BY CategoriaID
ORDER BY CategoriaID;

SELECT CategoriaID, CAST (AVG(Precio) AS DECIMAL(10,2)) PrecioPromedioCategoria 
FROM Productos
GROUP BY CategoriaID
ORDER BY CategoriaID;

--Pregunta 3: �Cu�l es el valor de la orden m�nima y m�xima por cada sucursal?

SELECT * FROM Ordenes;

SELECT SucursalID, MIN(TotalCompra) ValorMinimoOrden, MAX(TotalCompra) ValorMaximoOrden 
FROM Ordenes
GROUP BY SucursalID;

--Pregunta 4: �Cu�l es el mayor n�mero de kil�metros recorridos para una entrega?

SELECT * FROM Ordenes;

SELECT MAX(KilometrosRecorrer) 'Mayor Nro. Kil�metros'
FROM Ordenes;

--Pregunta 5: �Cu�l es la cantidad promedio de productos por orden?

SELECT * FROM DetalleOrdenes;

SELECT OrdenID, AVG(Cantidad) AS CantidadPromedioProductosOrden
FROM DetalleOrdenes
GROUP BY OrdenID;

--Pregunta 6: �Cu�l es el total de ventas por cada tipo de pago?

SELECT * FROM Ordenes;

SELECT TipoPagoID, SUM(TotalCompra) AS TotalVentas 
FROM Ordenes
GROUP BY TipoPagoID
ORDER BY TotalVentas DESC;

SELECT * FROM TiposPago;

--Pregunta 7: �Cu�l sucursal tiene la venta promedio m�s alta?

SELECT * FROM Ordenes;

SELECT TOP 1 SucursalID, FORMAT (AVG(TotalCompra), '00.00') AS VentaPromedio 
FROM Ordenes
GROUP BY SucursalID
ORDER BY VentaPromedio DESC;

SELECT TOP 1 SucursalID, CAST (AVG(TotalCompra) AS DECIMAL(10,2)) AS VentaPromedio 
FROM Ordenes
GROUP BY SucursalID
ORDER BY VentaPromedio DESC;

--Pregunta 8: �Cu�les son las sucursales que han generado ventas por orden por encima de $50

SELECT * FROM Ordenes;

SELECT SucursalID, SUM(TotalCompra) TotalVentas, COUNT(OrdenID) NumeroOrdenes, 
CAST (SUM (TotalCompra)/COUNT(OrdenID) AS DECIMAL(10,2)) VentaXOrden
FROM Ordenes
GROUP BY SucursalID
HAVING SUM(TotalCompra) > 50
ORDER BY TotalVentas DESC;

--Pregunta 9: �C�mo se comparan las ventas promedio antes y despu�s del 1 de julio de 2023?

SELECT * FROM Ordenes;

(SELECT 'Antes de 2023-07-01' AS Periodo, CAST (AVG(Totalcompra) AS DECIMAL (10,2)) AS VentasPromedio
FROM Ordenes
WHERE FechaOrdenTomada < '2023-07-01')
UNION
(SELECT 'Despues de 2023-07-01' AS Periodo, CAST (AVG(Totalcompra) AS DECIMAL (10,2)) AS VentasPromedio
FROM Ordenes
WHERE FechaOrdenTomada > '2023-07-01');

/*Pregunta 10: �Durante qu� horario del d�a (ma�ana, tarde, noche) se registra la mayor cantidad de ventas, 
cu�l es el valor promedio de estas ventas, y cu�l ha sido la venta m�xima alcanzada?*/

SELECT * FROM Ordenes;

SELECT TOP 1 HorarioVenta, COUNT(OrdenID) CantidadVentas,
SUM(TotalCompra) TotalVentas, MAX(TotalCompra) AS VentaMaxima, 
CAST (AVG(TotalCompra) AS DECIMAL (10,2)) VentaPromedio
FROM Ordenes
GROUP BY HorarioVenta
ORDER BY TotalVentas DESC;
































