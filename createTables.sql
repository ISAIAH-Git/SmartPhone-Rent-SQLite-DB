/* Creating the PhoneModel Table: */
create table PhoneModel(modelNumber  text primary key not null, /* Adding Primary Key for the PhoneModel Table */
modelName text not null,/* Making Model name not null */
storage real not null check(storage>0) /* Ensuring the storage value always is going to be positive */,
colour text not null, /* Ensuring the colour should be not null*/
baseCost real not null check (baseCost>=0), /* Base cost must be positive*/
dailyCost real not null check(dailyCost>=0)/* Daily Cost must be positive */);

/* Creating the Phone Table to store individual phones  and their attributes: */
create table Phone(modelNumber text not null, /* Model Number shoulbe text and not null */
 modelName text not null, /* Model Name should be text and not null */
 IMEI text primary key,/* Making IMEI as the primary Key */
 foreign key(modelNumber) references PhoneModel(modelNumber),/* Foreign key constraint referencing the PhoneModel TABLE */
 /* IMEI validation using the Luhn Algorithm */
    check(length(IMEI)=15 and (substr(IMEI,1,1)+substr(IMEI,3,1)+substr(IMEI,5,1)+substr(IMEI,7,1)+substr(IMEI,9,1)+substr(IMEI,11,1)+substr(IMEI,13,1)+substr(IMEI,15,1)+
           case when substr(IMEI,2,1)*2>9 then substr(IMEI,2,1)*2-9 else substr(IMEI,2,1)*2 end+
           case when substr(IMEI,4,1)*2>9 then substr(IMEI,4,1)*2-9 else substr(IMEI,4,1)*2 end+
           case when substr(IMEI,6,1)*2>9 then substr(IMEI,6,1)*2-9 else substr(IMEI,6,1)*2 end+
           case when substr(IMEI,8,1)*2>9 then substr(IMEI,8,1)*2-9 else substr(IMEI,8,1)*2 end+
           case when substr(IMEI,10,1)*2>9 then substr(IMEI,10,1)*2-9 else substr(IMEI,10,1)*2 end+
           case when substr(IMEI,12,1)*2>9 then substr(IMEI,12,1)*2-9 else substr(IMEI,12,1)*2 end+
           case when substr(IMEI,14,1)*2>9 then substr(IMEI,14,1)*2-9 else substr(IMEI,14,1)*2 end)%10=0));


/* Creating the Customer Table to store customer details*/
create table Customer(customerId integer primary key autoincrement, /* Making CustomerId as Primary Key which auto increments to identify the unique customer */
 customerName text not null, /* Customer can't be null */
 customerEmail text unique not null); /* Email must be unique at all times */

/* Creating the Rental Contract Table: */
create table rentalContract(customerId integer not null, /* Customer Id identifier linking to the customer table */
IMEI text not null,/* Using IMEI identifier to link the phone Table */
dateOut date not null, /* Date Out when the phone was rented out */
dateBack date, /* Date when the phone was returned */
rentalCost real, /* Total rental cost for the duration */
/* Foreign key Constraints the Phone and Customer Tables */
foreign KEY(IMEI) references Phone(IMEI) on delete set null,/* foreign key constraint if phone table is deleted IMEI in rental Contract will be set to  */
foreign key(customerId) references Customer(customerId) on delete restrict, /* Restricting deletion in the customer table to maintain referencing integrity*/
PRIMARY KEY(customerId, IMEI,dateOut) /* Composite primary Key */
check (julianday(dateBack)>=julianday(dateOut) or dateBack is null)); /* Ensuring the returned date is after the rental date or is null */

/* Creating an Index on the IMEI column of the Phone table for faster lookups */
create Index idx_imei on Phone(IMEI);

/* Creating an Index on the modelNumber column of the Phone Model for faster lookups */
create Index idx_modelNumber on PhoneModel(modelNumber); 

