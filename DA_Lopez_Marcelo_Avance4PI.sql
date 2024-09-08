/*Pregunta 1:
Listar todos los productos y sus categorías
¿Cómo puedo obtener una lista de todos los productos junto con sus categorías?*/

SELECT * FROM Productos
SELECT * FROM Categorias

SELECT P.Nombre Producto, C.Nombre Categoria
FROM Productos P
INNER JOIN Categorias C
ON (C.CategoriaID = P.CategoriaID);

/*Pregunta 2:
Obtener empleados y su sucursal asignada
¿Cómo puedo saber a qué sucursal está asignado cada empleado?*/

SELECT * FROM Empleados
SELECT * FROM Sucursales

SELECT E.Nombre Empleado, S.Nombre Sucursal
FROM Empleados E
LEFT JOIN 
Sucursales S ON (E.SucursalID = S.SucursalID);

/*Pregunta 3:
Identificar productos sin categoría asignada
¿Existen productos que no tienen una categoría asignada?*/

SELECT * FROM Productos
SELECT * FROM Categorias

SELECT P.ProductoID, P.Nombre, C.CategoriaID, C.Nombre FROM Productos P 
LEFT JOIN
Categorias C ON (P.CategoriaID = C.CategoriaID)
WHERE C.CategoriaID IS NULL;

/*Pregunta 4: Detalle completo de órdenes
¿Cómo puedo obtener un detalle completo de las órdenes, incluyendo cliente, 
empleado que tomó la orden, y el mensajero que la entregó?*/

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
¿Cuántos productos de cada tipo se han vendido en cada sucursal?*/

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


/*Pregunta 1: Eficiencia de los mensajeros: ¿Cuál es el tiempo promedio desde el despacho hasta la entrega de los 
pedidos por los mensajeros?*/

SELECT * FROM Ordenes

SELECT AVG(DATEDIFF(MINUTE,FechaDespacho, FechaEntrega)) AS TiempoPromedioEntrega FROM Ordenes
WHERE MensajeroID IS NOT NULL;

/*Pregunta 2: Análisis de Ventas por Origen de Orden: ¿Qué canal de ventas genera más ingresos?*/

SELECT * FROM OrigenesOrden --OrigenID
SELECT * FROM Ordenes --OrigenID --TotalCompra

SELECT TOP 1 OO.Descripcion CanalVentas, SUM(O.TotalCompra) TotalVentas
FROM Ordenes O
INNER JOIN OrigenesOrden OO
ON (OO.OrigenID = O.OrigenID)
GROUP BY OO.Descripcion
ORDER BY TotalVentas DESC;

/*Pregunta 3: Productividad de los Empleados: ¿Cuál es el volumen de ventas promedio gestionado por empleado?*/

SELECT * FROM Ordenes
SELECT * FROM Empleados

SELECT E.Nombre, CAST(AVG(TotalCompra)AS DECIMAL(10,2)) PromedioVentas FROM Ordenes O
LEFT JOIN Empleados E ON (E.EmpleadoID = O.EmpleadoID)
GROUP BY E.Nombre
ORDER BY PromedioVentas DESC;

/*Análisis de Demanda por Horario y Día: ¿Cómo varía la demanda de productos a lo largo del día? 
NOTA: Esta consulta no puede ser implementada sin una definición clara del horario (mañana, tarde, noche) 
en la base de datos existente. Asumiremos que HorarioVenta refleja esta información correctamente.*/

--Demanda por horario y por día = HorarioVenta

SELECT * FROM Ordenes
SELECT * FROM DetalleOrdenes
SELECT * FROM Productos

SELECT O.HorarioVenta Horario, P.Nombre Producto, SUM(DO.Cantidad) Demanda
FROM Ordenes O
INNER JOIN DetalleOrdenes DO ON (DO.OrdenID = O.OrdenID)
INNER JOIN Productos P ON (P.ProductoID = DO.ProductoID)
GROUP BY O.HorarioVenta, P.Nombre
ORDER BY SUM(DO.Cantidad) DESC, O.HorarioVenta;

/*Pregunta 5: Comparación de Ventas Mensuales: ¿Cómo se comparan las ventas mensuales de este año con el año anterior?*/

SELECT SUM(TotalCompra), FechaOrdenTomada
FROM Ordenes
GROUP BY FechaOrdenTomada

SELECT YEAR(FechaOrdenTomada) Año, MONTH(FechaOrdenTomada) Mes, SUM(TotalCompra) Ventas
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

/*Análisis de Fidelidad del Cliente: ¿Qué porcentaje de clientes son recurrentes versus nuevos clientes cada mes? 
NOTA: La consulta se enfocaría en la frecuencia de órdenes por cliente para inferir la fidelidad.*/

SELECT * FROM Clientes
SELECT * FROM Ordenes

SELECT C.Nombre, COUNT(O.OrdenID) Ventas
FROM Ordenes O
INNER JOIN Clientes C ON (C.ClienteID = O.ClienteID)
GROUP BY C.Nombre;


--Creación de una Vista:

CREATE VIEW Vista_Productos_Categorias AS
SELECT P.Nombre AS Producto, C.Nombre AS Categoria
FROM Productos P
INNER JOIN Categorias C ON C.CategoriaID = P.CategoriaID;

SELECT * FROM Vista_Productos_Categorias;















