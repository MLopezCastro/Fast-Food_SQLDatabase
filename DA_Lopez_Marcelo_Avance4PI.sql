/*Pregunta 1:
Listar todos los productos y sus categor�as
�C�mo puedo obtener una lista de todos los productos junto con sus categor�as?*/

SELECT * FROM Productos
SELECT * FROM Categorias

SELECT P.Nombre Producto, C.Nombre Categoria
FROM Productos P
INNER JOIN Categorias C
ON (C.CategoriaID = P.CategoriaID);

/*Pregunta 2:
Obtener empleados y su sucursal asignada
�C�mo puedo saber a qu� sucursal est� asignado cada empleado?*/

SELECT * FROM Empleados
SELECT * FROM Sucursales

SELECT E.Nombre Empleado, S.Nombre Sucursal
FROM Empleados E
LEFT JOIN 
Sucursales S ON (E.SucursalID = S.SucursalID);

/*Pregunta 3:
Identificar productos sin categor�a asignada
�Existen productos que no tienen una categor�a asignada?*/

SELECT * FROM Productos
SELECT * FROM Categorias

SELECT P.ProductoID, P.Nombre, C.CategoriaID, C.Nombre FROM Productos P 
LEFT JOIN
Categorias C ON (P.CategoriaID = C.CategoriaID)
WHERE C.CategoriaID IS NULL;

/*Pregunta 4: Detalle completo de �rdenes
�C�mo puedo obtener un detalle completo de las �rdenes, incluyendo cliente, 
empleado que tom� la orden, y el mensajero que la entreg�?*/

SELECT * FROM Ordenes
SELECT * FROM Clientes
SELECT * FROM Empleados
SELECT * FROM Mensajeros

SELECT O.OrdenID, C.Nombre AS Cliente, E.Nombre AS Empleado, M.Nombre AS Mensajero
FROM Ordenes O
LEFT JOIN Clientes C ON (C.ClienteID = O.ClienteID)
LEFT JOIN Empleados E ON (E.EmpleadoID = O.EmpleadoID)
LEFT JOIN Mensajeros M ON (M.MensajeroID = O.MensajeroID);

/*Pregunta 5: Productos vendidos por sucursal
�Cu�ntos productos de cada tipo se han vendido en cada sucursal?*/

SELECT * FROM DetalleOrdenes
SELECT * FROM Ordenes
SELECT * FROM Sucursales
SELECT * FROM Productos

SELECT S.Nombre Sucursal, P.Nombre Producto, SUM(DO.Cantidad) ProductosVendidos
FROM Ordenes O 
INNER JOIN DetalleOrdenes DO ON (DO.OrdenID = O.OrdenID)
INNER JOIN Productos P ON (P.ProductoID = DO.ProductoID) 
INNER JOIN Sucursales S ON (S.SucursalID = O.SucursalID)
GROUP BY S.Nombre, P.Nombre
ORDER BY ProductosVendidos DESC;


/*Pregunta 1: Eficiencia de los mensajeros: �Cu�l es el tiempo promedio desde el despacho hasta la entrega de los 
pedidos por los mensajeros?*/

SELECT * FROM Ordenes

SELECT AVG(DATEDIFF(MINUTE,FechaDespacho, FechaEntrega)) AS TiempoPromedioEntrega FROM Ordenes
WHERE MensajeroID IS NOT NULL;

/*Pregunta 2: An�lisis de Ventas por Origen de Orden: �Qu� canal de ventas genera m�s ingresos?*/

SELECT * FROM OrigenesOrden --OrigenID
SELECT * FROM Ordenes --OrigenID --TotalCompra

SELECT TOP 1 OO.Descripcion CanalVentas, SUM(O.TotalCompra) TotalVentas
FROM Ordenes O
INNER JOIN OrigenesOrden OO
ON (OO.OrigenID = O.OrigenID)
GROUP BY OO.Descripcion
ORDER BY TotalVentas DESC;

/*Pregunta 3: Productividad de los Empleados: �Cu�l es el volumen de ventas promedio gestionado por empleado?*/

SELECT * FROM Ordenes
SELECT * FROM Empleados

SELECT E.Nombre, CAST(AVG(TotalCompra)AS DECIMAL(10,2)) PromedioVentas FROM Ordenes O
LEFT JOIN Empleados E ON (E.EmpleadoID = O.EmpleadoID)
GROUP BY E.Nombre
ORDER BY PromedioVentas DESC;

/*An�lisis de Demanda por Horario y D�a: �C�mo var�a la demanda de productos a lo largo del d�a? 
NOTA: Esta consulta no puede ser implementada sin una definici�n clara del horario (ma�ana, tarde, noche) 
en la base de datos existente. Asumiremos que HorarioVenta refleja esta informaci�n correctamente.*/

--Demanda por horario y por d�a = HorarioVenta

SELECT * FROM Ordenes
SELECT * FROM DetalleOrdenes
SELECT * FROM Productos

SELECT O.HorarioVenta Horario, P.Nombre Producto, SUM(DO.Cantidad) Demanda
FROM Ordenes O
INNER JOIN DetalleOrdenes DO ON (DO.OrdenID = O.OrdenID)
INNER JOIN Productos P ON (P.ProductoID = DO.ProductoID)
GROUP BY O.HorarioVenta, P.Nombre
ORDER BY SUM(DO.Cantidad) DESC, O.HorarioVenta;

/*Pregunta 5: Comparaci�n de Ventas Mensuales: �C�mo se comparan las ventas mensuales de este a�o con el a�o anterior?*/

SELECT SUM(TotalCompra), FechaOrdenTomada
FROM Ordenes
GROUP BY FechaOrdenTomada

SELECT YEAR(FechaOrdenTomada) A�o, MONTH(FechaOrdenTomada) Mes, SUM(TotalCompra) Ventas
FROM Ordenes
WHERE YEAR(FechaOrdenTomada) >= 2023 AND YEAR(FechaOrdenTomada) <= 2024
GROUP BY YEAR(FechaOrdenTomada), MONTH(FechaOrdenTomada);

--Respuesta obtenida con ayuda de ChatGPT:
SELECT
    MONTH(FechaOrdenTomada) AS Mes,
    SUM(CASE WHEN YEAR(FechaOrdenTomada) = YEAR(GETDATE()) THEN TotalCompra ELSE 0 END) AS Ventas_2024 ,
    SUM(CASE WHEN YEAR(FechaOrdenTomada) = YEAR(GETDATE()) - 1 THEN TotalCompra ELSE 0 END) AS Ventas_2023
FROM
    Ordenes
WHERE
    YEAR(FechaOrdenTomada) IN (YEAR(GETDATE()), YEAR(GETDATE()) - 1)
GROUP BY
    MONTH(FechaOrdenTomada)
ORDER BY
    MONTH(FechaOrdenTomada);

/*An�lisis de Fidelidad del Cliente: �Qu� porcentaje de clientes son recurrentes versus nuevos clientes cada mes? 
NOTA: La consulta se enfocar�a en la frecuencia de �rdenes por cliente para inferir la fidelidad.*/

SELECT * FROM Clientes
SELECT * FROM Ordenes

SELECT C.Nombre, COUNT(O.OrdenID) Ventas
FROM Ordenes O
INNER JOIN Clientes C ON (C.ClienteID = O.ClienteID)
GROUP BY C.Nombre;


--Creaci�n de una Vista:

CREATE VIEW Vista_Productos_Categorias AS
SELECT P.Nombre AS Producto, C.Nombre AS Categoria
FROM Productos P
INNER JOIN Categorias C ON C.CategoriaID = P.CategoriaID;

SELECT * FROM Vista_Productos_Categorias;















