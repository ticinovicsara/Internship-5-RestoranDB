--1.
SELECT * FROM Menus WHERE price < 15;

--2.
SELECT * FROM Orders
WHERE TimeOfOrder BETWEEN '2023-01-01' AND '2023-12-31' AND TotalAmount > 50;

--3. 
SELECT s.id, s.name, COUNT(d.id) AS completed_deliveries
FROM Staff s
JOIN Delivery d ON s.id = d.staffid
WHERE s.role = 'delivery man'
AND d.status = 'completed'
GROUP BY s.id, s.name
HAVING COUNT(d.id) > 100;

--4.
SELECT Staff.name, Staff.role
FROM Staff
JOIN Restaurants ON Staff.restaurantid = Restaurants.id
WHERE Restaurants.city = 'Zagreb' AND Staff.role = 'chef';

--5.
SELECT r.name, COUNT(Orders.id) AS order_count
FROM Orders
JOIN Restaurants r ON Orders.restaurantid = r.id
WHERE r.city = 'Split' 
AND EXTRACT(YEAR FROM Orders.timeoforder) = 2023
GROUP BY r.name;

--6.
SELECT m.title, SUM(od.amount) AS times_ordered
FROM Menus m
JOIN OrderDetails od ON m.id = od.menuid
JOIN Orders o ON od.orderid = o.id
WHERE m.category = 'dessert'
AND o.timeoforder >= '2023-12-01'
AND o.timeoforder < '2024-01-01'
GROUP BY m.title
HAVING SUM(od.amount) > 10;

--7.
SELECT Customers.surname, COUNT(orders.id) AS number_of_orders
FROM Customers
JOIN Orders ON Customers.id = Orders.customerid
WHERE Customers.surname LIKE 'M%'
GROUP BY Customers.surname;

--8.
SELECT AVG(Reviews.review) AS average_rating
FROM Restaurants
JOIN Reviews ON Restaurants.id = Reviews.restaurantid
WHERE Restaurants.city = 'Rijeka';

--9.
SELECT name, tablecapacity, delivery
FROM Restaurants
WHERE tablecapacity > 30
AND delivery = TRUE;

--10.
DELETE FROM LoyaltyCards
WHERE customerid IN (
    SELECT Orders.customerid
    FROM Orders
    WHERE Orders.timeoforder < CURRENT_DATE - INTERVAL '1 year'
    OR Orders.id IS NULL
    GROUP BY Orders.customerid
);
