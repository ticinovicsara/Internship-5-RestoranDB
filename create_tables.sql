CREATE TABLE Restaurants(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	City VARCHAR(50) NOT NULL,
	TableCapacity INT NOT NULL CHECK(TableCapacity > 0),
	WorkingHours VARCHAR(50) NOT NULL,
	GeoLocation POINT,
	Delivery BOOLEAN DEFAULT FALSE
);

CREATE TABLE Menus(
	Id SERIAL PRIMARY KEY,
	RestaurantId INT NOT NULL REFERENCES Restaurants(Id),
	Title VARCHAR(100) NOT NULL,
	Category VARCHAR(20) NOT NULL CHECK(Category IN ('appetizer', 'main course', 'dessert')),
	Price DECIMAL(10, 2) NOT NULL CHECK(Price > 0),
	Calories INT NOT NULL CHECK(Calories > 0),
	Available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Customers(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	LoyaltyCard BOOLEAN DEFAULT FALSE
	NumberOfOrders INT,
	Surname VARCHAR(30)
);


CREATE TABLE Orders(
	Id SERIAL PRIMARY KEY,
	CustomerId INT NOT NULL REFERENCES Customers(Id),
	RestaurantId INT NOT NULL REFERENCES Restaurants(Id),
	Type VARCHAR(20) NOT NULL CHECK(Type IN ('delivery', 'in restaurant')),
	DeliveryAdress VARCHAR(150),
	TotalAmount DECIMAL(10, 2) NOT NULL CHECK(TotalAmount > 0),
	TimeOfOrder TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE OrderDetails(
	Id SERIAL PRIMARY KEY,
	OrderId INT NOT NULL REFERENCES Orders(Id),
	MenuId INT NOT NULL REFERENCES Menus(Id),
	Amount INT NOT NULL CHECK(Amount > 0)
);

CREATE TABLE Staff(
	Id SERIAL PRIMARY KEY,
	RestaurantId INT NOT NULL REFERENCES Restaurants(Id),
	Name VARCHAR(50) NOT NULL,
	Role VARCHAR(20) NOT NULL CHECK(Role IN ('chef', 'waiter', 'delivery man')),
	Age INT CHECK((Role = 'chef' OR Role = 'delivery man') AND Age >= 18),
	DriversLicence BOOLEAN CHECK(Role != 'delivery man' OR DriversLicence = TRUE)
);

CREATE TABLE EmployeeWorkPeriods(
	Id SERIAL PRIMARY KEY,
    StaffId INT NOT NULL REFERENCES Staff(Id),
    RestaurantId INT NOT NULL REFERENCES Restaurants(Id),
    StartDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndDate TIMESTAMP,
    UNIQUE (StaffId, RestaurantId, StartDate) 
);

CREATE TABLE Reviews(
	id SERIAL PRIMARY KEY,
    CustomerId INT NOT NULL REFERENCES Customers(Id),
    MenuId INT REFERENCES Menus(Id),
    OrderId INT REFERENCES Orders(Id),
   	Review INT NOT NULL CHECK (Review BETWEEN 1 AND 5),
    Comment TEXT,
	RestaurantId INT REFERENCES Restaurants(id);
);

CREATE TABLE Delivery(
    Id SERIAL PRIMARY KEY,
    OrderId INT NOT NULL REFERENCES Orders(Id),
    TimeofDelivery TIMESTAMP NOT NULL,
    Note TEXT,
	RestaurantId INT,
	Status TEXT
);

ALTER TABLE Delivery
ADD CONSTRAINT ForeignStaffId FOREIGN KEY(StaffId) REFERENCES Staff(Id);


CREATE TABLE LoyaltyCards(
    CustomerId INT PRIMARY KEY REFERENCES Customers(Id),
    TimeOfCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
