-- Created by Fred Yang 2015-11-01

-- Sports Shop Schema
DROP TABLE Transaction_Item;
DROP TABLE Delivery_Item;
DROP TABLE Return_Item;
DROP TABLE Item;
DROP TABLE Category;
DROP TABLE Return;
DROP TABLE Delivery;
DROP TABLE Transaction;
DROP TABLE Customer;
DROP TABLE Administrator;
DROP TABLE Employee;
DROP TABLE Store;

CREATE TABLE Store (
    storeNo     CHAR(5)     NOT NULL,
    address     VARCHAR(70) NOT NULL,
    phone       VARCHAR(10) NOT NULL,
    PRIMARY KEY (storeNo)
);

CREATE TABLE Customer (
    customerId  CHAR(8)     NOT NULL,
    firstName   VARCHAR(15) NOT NULL,
    lastName    VARCHAR(15) NOT NULL,
    dob         DATE,
    gender      CHAR(1),
    phone       VARCHAR(10) NOT NULL,
    email       VARCHAR(20) NOT NULL,
    address     VARCHAR(70) NOT NULL,
    points      INT,
    isVip       CHAR(1)     DEFAULT '0',
    isValid     CHAR(1)     DEFAULT '1',
    PRIMARY KEY (customerId)    
);

CREATE TABLE Employee (
    employeeNo  CHAR(5)     NOT NULL,
    firstName   VARCHAR(15) NOT NULL,
    lastName    VARCHAR(15) NOT NULL,
    dob         DATE,
    gender      CHAR(1),
    phone       VARCHAR(10) NOT NULL,
    email       VARCHAR(20) NOT NULL,
    address     VARCHAR(70) NOT NULL,
    sin         CHAR(9)     NOT NULL,
    lv          SMALLINT    DEFAULT 1 NOT NULL,
    position    VARCHAR(15) NOT NULL,
    education   VARCHAR(30),
    storeNo     CHAR(5),
    isValid     CHAR(1)     DEFAULT '1',
    PRIMARY KEY (employeeNo),
    FOREIGN KEY (storeNo) REFERENCES Store(storeNo)
        ON DELETE CASCADE
);

CREATE TABLE Administrator (
    employeeNo  CHAR(5)     NOT NULL,
    userName    VARCHAR(10) NOT NULL,
    passwd      VARCHAR(32) NOT NULL,
    isValid     CHAR(1)     DEFAULT '1',
    PRIMARY KEY (employeeNo),
    FOREIGN KEY (employeeNo) REFERENCES Employee(employeeNo)
        ON DELETE CASCADE
);

CREATE TABLE Category (
    catNo       CHAR(8)     NOT NULL,
    catName     VARCHAR(20) NOT NULL,
    stockNo     CHAR(3),
    PRIMARY KEY (catNo)
);

CREATE TABLE Item (
    itemNo      CHAR(8)     NOT NULL,
    catNo       CHAR(8)     NOT NULL,
    itemName    VARCHAR(50) NOT NULL,
    spec        VARCHAR(20),
    costPrice   DECIMAL(6,2),
    salePrice   DECIMAL(6,2),
    quantity    INT,
    producer    VARCHAR(30),
    entryDate   DATE,
    madeDate    DATE,
    expiryDate  DATE,
    PRIMARY KEY (itemNo),
    FOREIGN KEY (catNo) REFERENCES Category(catNo)
        ON DELETE CASCADE
);

CREATE TABLE Transaction (
    transactionId   CHAR(10)    NOT NULL,
    receiptNo       CHAR(10)    NOT NULL,
    paymentNo       VARCHAR(15) NOT NULL,
    customerId      CHAR(8),
    cashierNo       CHAR(5),
    transactionDate DATE        NOT NULL,
    succeed         CHAR(1),
    PRIMARY KEY (transactionId),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId)
        ON DELETE CASCADE,
    FOREIGN KEY (cashierNo) REFERENCES Employee(employeeNo)
        ON DELETE CASCADE
);

CREATE TABLE Delivery (
    deliveryId      CHAR(10)    NOT NULL,
    transactionId   CHAR(10)    NOT NULL,    
    shipper         CHAR(5)     NOT NULL,
    consignee       CHAR(8)     NOT NULL,
    deliveryDate    DATE,
    receiveDate     DATE,   
    PRIMARY KEY (deliveryId),
    FOREIGN KEY (transactionId) REFERENCES Transaction(transactionId)
        ON DELETE CASCADE,
    FOREIGN KEY (shipper) REFERENCES Employee(employeeNo)
        ON DELETE CASCADE,
    FOREIGN KEY (consignee) REFERENCES Customer(customerId)
        ON DELETE CASCADE
);

CREATE TABLE Return (
    returnId        CHAR(10)    NOT NULL,
    transactionId   CHAR(10)    NOT NULL,
    returnDate      DATE,
    reason          VARCHAR(70),
    PRIMARY KEY (returnId),
    FOREIGN KEY (transactionId) REFERENCES Transaction(transactionId)
        ON DELETE CASCADE
);

CREATE TABLE Transaction_Item (
    transactionId   CHAR(10)    NOT NULL,
    itemNo          CHAR(8)     NOT NULL,
    quantity        INT,
    PRIMARY KEY (transactionId, itemNo),
    FOREIGN KEY (transactionId) REFERENCES Transaction(transactionId)
        ON DELETE CASCADE,
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE
);

CREATE TABLE Delivery_Item (
    deliveryId      CHAR(10)    NOT NULL,
    itemNo          CHAR(8)     NOT NULL,
    quantity        INT,
    PRIMARY KEY (deliveryId, itemNo),
    FOREIGN KEY (deliveryId) REFERENCES Delivery(deliveryId)
        ON DELETE CASCADE,
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE
);

CREATE TABLE Return_Item (
    returnId        CHAR(10)    NOT NULL,
    itemNo          CHAR(8)     NOT NULL,
    quantity        INT,
    PRIMARY KEY (returnId, itemNo),
    FOREIGN KEY (returnId) REFERENCES Return(returnId)
        ON DELETE CASCADE,
    FOREIGN KEY (itemNo) REFERENCES Item(itemNo)
        ON DELETE CASCADE
);

-- Data
INSERT INTO Category VALUES('CA150001','Apparel', 'N01');
INSERT INTO Category VALUES('CA150002','Outwear', 'N01');
INSERT INTO Category VALUES('CA150003','Equipment', 'N02');
INSERT INTO Category VALUES('CA150004','Hockey', 'N02');
INSERT INTO Category VALUES('CA150005','Footwear', 'N03');

INSERT INTO Item VALUES('IT150001', 'CA150001','Columbia Hanath Mens Half-zip Top','premium',
    15.15,23.99,50,'Hanath',SYSDATE,to_date('20150118','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150002', 'CA150002','Giro Bevel White Helmet','senior',
    45.20,53.99,50,'Giro',SYSDATE,to_date('20150118','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150003', 'CA150003','Nordica Nadvo Binding','junior',
    200.50,220.99,25,'Nordica',SYSDATE,to_date('20150201','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150004', 'CA150004','Bauer Supreme Stick','flex75',
    38.99,43.99,10,'Bauer',SYSDATE,to_date('20150315','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150005', 'CA150005','Reebok Realflex Womens Boots','size#9',
    91.45,105.99,8,'Reebok',SYSDATE,to_date('20150902','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150006', 'CA150003','Wilson NFL Official Game Football','senior',
    100.50,119.99,20,'Wilson',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);    
INSERT INTO Item VALUES('IT150007', 'CA150003','Wilson NFL Official Football','senior',
    90.50,109.99,20,'Wilson',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150008', 'CA150003','Wilson TDJ Composite Football','junior',
    27.99,34.99,30,'Wilson',SYSDATE,to_date('20150308','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150009', 'CA150003','Wilson LFL Ultimat Football','premium',
    28.69,37.99,15,'Wilson',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150010', 'CA150003','Wilson NFL Competition Football','premium',
    20.99,29.99,20,'Wilson',SYSDATE,to_date('20150215','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150011', 'CA150004','Bauer Vapor X40 Hockey Skates','senior',
    58.50,69.99,20,'Bauer',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);    
INSERT INTO Item VALUES('IT150012', 'CA150004','Reebok Ribcor SC87 Hockey Skates','senior',
    100.50,129.99,10,'Reebok',SYSDATE,to_date('20150113','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150013', 'CA150004','Easton V9E Hockey Stick','flex85',
    100.50,119.99,20,'Easton',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150014', 'CA150004','CCM Ultra Tacks Shoulder Pads',NULL,
    158.50,189.99,10,'CCM',SYSDATE,to_date('20150511','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150015', 'CA150004','Easton Stealth CX Hockey Gloves',NULL,
    158.50,179.99,20,'Easton',SYSDATE,to_date('20150218','YYYYMMDD'),NULL);    
INSERT INTO Item VALUES('IT150016', 'CA150005','Mizuno Wave Mens Indoor Shoes','size#9',
    59.50,79.99,30,'Mizuno',SYSDATE,to_date('20150108','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150017', 'CA150005','Mizuno Wave Mens Indoor Shoes','size#10',
    59.99,81.99,10,'Mizuno',SYSDATE,to_date('20150108','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150018', 'CA150005','Mizuno Wave Mens Indoor Shoes','size#11',
    59.99,82.99,30,'Mizuno',SYSDATE,to_date('20150108','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150019', 'CA150005','Asics Gel Rocket Womens Indoor Shoes','size#8',
    49.50,69.99,10,'Asics',SYSDATE,to_date('20150105','YYYYMMDD'),NULL);
INSERT INTO Item VALUES('IT150020', 'CA150005','Asics Gel Rocket Womens Indoor Shoes','size#9',
    54.50,79.99,20,'Asics',SYSDATE,to_date('20150105','YYYYMMDD'),NULL);  
    
INSERT INTO Store VALUES('SC-01','2929 Barnet Highway #1400, Coquitlam, BC V3B 5R9','6044645110');
INSERT INTO Store VALUES('SC-02','4700 Kingsway, Burnaby, BC V5H 4M1','6044645112');
INSERT INTO Store VALUES('SC-03','18 West Broadway, Vancouver, BC V5Y 1P2','6044645113');
INSERT INTO Store VALUES('SC-04','8125 Ontario Street, Vancouver, BC V5X 0A7','6044645114');
INSERT INTO Store VALUES('SC-05','Unit 600 5771 Marine Way, Burnaby, BC V5J 0A6','6044645115');

INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150001','Homer','Simpson',to_date('19900901','YYYYMMDD'),'1','6045561234','hsimpson@gmail.com',
    '515 Ontario Street, Vancouver, BC V4X 1A7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150002','Tina','Smith',to_date('19800102','YYYYMMDD'),'0','7785580230','tsmith@gmail.com',
    '21 Maroal Dr., Richmond, BC V1N 3Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150003','Alex','Spotter',to_date('19700202','YYYYMMDD'),'1','6041561234','aspotter@hotmail.com',
    '4147 Chatham st., Vancouver, BC V3E 5Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150004','Mara','Harper',to_date('19620910','YYYYMMDD'),'0','6047761234','mharper@netmail.com',
    '777 Johns cr., Surrey, BC V1B 2H4');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150005','Ken','Dope',to_date('19591005','YYYYMMDD'),'1','6048880234','kdope@gmail.com',
    '332 Chequeen st., Coquitlam, BC V3E 0B9');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150006','Dick','Johnson',to_date('19790920','YYYYMMDD'),'1','7781561234','djohnson@gmail.com',
    '1515 Barcode Street, Langley, BC V1T 2G5');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150007','Honna','Wong',to_date('19850502','YYYYMMDD'),'0','7785580114','hwong@net.com',
    '215 Capital Dr., Delta, BC V5N 5Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150008','Alex','Clark',to_date('19550712','YYYYMMDD'),'1','6048881234','aclark@hotmail.com',
    '308-411 Zoob road, Vancouver, BC V3P 9U7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150009','Lana','Moore',to_date('19630910','YYYYMMDD'),'0','6040331234','lmoore@netmail.com',
    '132 Hall st., New Westminster, BC V2C 2H9');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150010','Job','Allen',to_date('19691130','YYYYMMDD'),'1','6049100234','jallen@gmail.com',
    '111-3321 Chequeen Street, Coquitlam, BC V3E 0B9');    
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150011','Pijon','White',to_date('19460901','YYYYMMDD'),'1','6048021234','pwhite@gmail.com',
    '120-5151 Ontario Street, Maple Ridge, BC V5T 3A7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150012','Jonisa','Davis',to_date('19611102','YYYYMMDD'),'0','7781180230','jdavis@gmail.com',
    '2102 Mars Dr., Richmond, BC V2N 3Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150013','Pipo','Baker',to_date('19470101','YYYYMMDD'),'1','6044561234','pbaker@hotmail.com',
    '147 Boomboo road, Vancouver, BC V7E 5Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150014','Alisa','Green',to_date('19920912','YYYYMMDD'),'0','6041761234','agreen@netmail.com',
    '77 Marphoon Hwy., Surrey, BC V2B 2H4');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150015','Jet','King',to_date('19581005','YYYYMMDD'),'1','6043670234','jking@gmail.com',
    '300-133 Douglas Street, Coquitlam, BC V5E 0B9');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150016','Wakon','Lewis',to_date('19890902','YYYYMMDD'),'1','6045541234','wlewis@gmail.com',
    '501 Peter Street, Vancouver, BC V8X 5A7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150017','Joanne','Wright',to_date('19700122','YYYYMMDD'),'0','7782580230','jwright@gmail.com',
    '211 Darma Dr., New Westminister, BC V4N 3Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150018','Phoon','Wood',to_date('19400222','YYYYMMDD'),'1','6049041234','pwood@hotmail.com',
    '4455 Qius st., Port Coquitlam, BC V6E 5Y7');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150019','Kitty','Woo',to_date('19520910','YYYYMMDD'),'0','6045761234','kwoo@netmail.com',
    '711 Times Cr., Delta, BC V4B 2H4');
INSERT INTO Customer(customerId, firstName, lastName, dob, gender, phone, email, address)
VALUES('CU150020','Kenny','Martin',to_date('19561105','YYYYMMDD'),'1','6048180234','kmartin@gmail.com',
    '532 Murrey Road, North Vancouver, BC V2E 2B9');
UPDATE CUSTOMER SET POINTS = 100 WHERE CUSTOMERID IN ('CU150001','CU150002','CU150003', 'CU150004','CU150005');
    
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00001','Kim','Bell', to_date('19780910','YYYYMMDD'),'1','6047771234','kbell@gmail.com','110 Dupeen Dr. Coquitlam, BC V3E 0B2',
        '777123456',3,'Store Manager', 'MBA', 'SC-01');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00002','Anna','Johns', to_date('19750108','YYYYMMDD'),'0','6047761238','ajohns@sports.com','3135 Silver St. Burnaby, BC V1X 7G1',
        '701123455',2,'Store Manager', 'MBA', 'SC-02');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00003','Tony','Chueng', to_date('19710210','YYYYMMDD'),'1','7787751234','tchueng@gmail.com','666 Kimpon Cr. Landley, BC V9Y 3H1',
        '713123450',2,'Administrator', 'Electronic Engineer', 'SC-01');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00004','Benedict','Singh', to_date('19890120','YYYYMMDD'),'1','6057799234','bsingh@netmail.com','445 Jump Road. Richmond, BC V7Y 3U3',
        '775023456',2,'Administrator', 'CST', 'SC-02');        
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00005','Gordon','Broinne', to_date('19890304','YYYYMMDD'),'1','6047771200','gbroinne@gmail.com','900 Victory Road. Vancouver, BC V1E 2B2',
        '773993456',1,'Administrator', 'High School', 'SC-05');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00006','Benney','Collins', to_date('19771010','YYYYMMDD'),'1','6047741234','bcollins@gmail.com','210-110 Dupa Dr. Coquitlam, BC V3E 0B2',
        '772128456',3,'Store Manager', 'MBA', 'SC-03');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00007','Manina','James', to_date('19740208','YYYYMMDD'),'0','6057761238','mjames@sports.com','135 Navigator St. Burnaby, BC V2X 7G1',
        '711123455',2,'Store Manager', 'MBA', 'SC-04');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00008','Tony','Nelson', to_date('19610213','YYYYMMDD'),'1','7781751234','tnelson@gmail.com','666 Park Cr. Landley, BC V2Y 3H1',
        '714123452',2,'Store Manager', 'Electronic Engineer', 'SC-05');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00009','Bars','Proter', to_date('19691120','YYYYMMDD'),'1','6055799234','bproter@netmail.com','145 Kooner Road. Surrey, BC V5Y 3U3',
        '702023456',1,'Cashier', 'High School', 'SC-01');        
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00010','Gordon','Nekon', to_date('19870304','YYYYMMDD'),'1','6041271200','gnekon@gmail.com','2900 Success Road. Delta, BC V8E 2B2',
        '714993456',1,'Cashier', 'High School', 'SC-01');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00011','Jomo','Bella', to_date('19580910','YYYYMMDD'),'1','6047971234','jbella@gmail.com','550-110 Dupeek road. Coquitlam, BC V6E 0B2',
        '777553456',1,'Cashier', 'Middle School', 'SC-02');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00012','Anna','Koop', to_date('19850108','YYYYMMDD'),'0','6047861235','akoop@sports.com','135 Silver road. Burnaby, BC V2X 7G1',
        '716123455',1,'Cashier', 'High School', 'SC-02');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00013','Tonney','Elliott', to_date('19770410','YYYYMMDD'),'1','7786651234','telliott@gmail.com','66 Zoopic Cr. Landley, BC V5Y 3H1',
        '743123450',1,'Cashier', 'High School', 'SC-03');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00014','Benot','Hudson', to_date('19811020','YYYYMMDD'),'1','6056789234','bhudson@netmail.com','4645 Kly Road. Port Coquitlam, BC V5Y 3O3',
        '722023456',1,'Cashier', 'Middle School', 'SC-03');        
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00015','Gord','Franklin', to_date('19861204','YYYYMMDD'),'1','6047581200','gfranklin@gmail.com','900 Maudrin Road. Langley, BC V1E 2B3',
        '751893456',1,'Cashier', 'High School', 'SC-04');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00016','Duke','England', to_date('19881212','YYYYMMDD'),'1','6047881234','dengland@gmail.com','550-1102 Simpson Dr. West Vancouver, BC V5E 2B2',
        '786123456',1,'Cashier', 'Douglas College', 'SC-04');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00017','Ampoa','Cobb', to_date('19740104','YYYYMMDD'),'0','6044761238','acobb@sports.com','235 Zeek St. Burnaby, BC V2X 7G1',
        '737123455',1,'Cashier', 'High School', 'SC-05');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00018','Kiki','Wilcox', to_date('19710228','YYYYMMDD'),'1','7787774234','kwilcox@gmail.com','440-666 Tommy Cr. Landley, BC V9Y 3H1',
        '712323450',1,'Clerk', 'Electronic Engineer', 'SC-01');
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00019','Cook','Harvey', to_date('19791120','YYYYMMDD'),'1','6056699234','charvey@netmail.com','65 Andrew Road. Richmond, BC V7Y 3U9',
        '718023456',1,'Clerk', 'CST', 'SC-02');        
INSERT INTO Employee(employeeNo, firstName, lastName, dob, gender, phone, email, address, sin, lv, position, education, storeNo)
VALUES('00020','Tim','Bowen', to_date('19871204','YYYYMMDD'),'1','6047151200','tbowen@gmail.com','280 Victory Cr. Delta, BC V1D 2B2',
        '733593456',1,'Store Person', 'High School', 'SC-03');        
        
-- INSERT INTO Administrator(employeeNo, userName, passwd)
-- VALUES('00003','scadmin',MD5('123'));
INSERT INTO Administrator(employeeNo, userName, passwd)
VALUES('00003','admin','202cb962ac59075b964b07152d234b70');
INSERT INTO Administrator(adminId, employeeNo, userName, passwd)
VALUES('00004','scadmin','202cb962ac59075b964b07152d234b70');
INSERT INTO Administrator(adminId, employeeNo, userName, passwd)
VALUES('00005','scadmin1','202cb962ac59075b964b07152d234b70');

INSERT INTO Transaction VALUES('TP11500001','SC11512345','VISA-7289011123','CU150001','00009',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500002','SC11512346','MAST-1179011124',NULL,'00010',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500003','SC11512347','MAST-3459011123','CU150003','00011',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500004','SC11512348','VISA-7287011181','CU150004',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500005','SC11512349','VISA-3389011177','CU150005',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500006','SC11512350','VISA-7389014121','CU150006','00012',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500007','SC11512351','MAST-1279011151',NULL,'00012',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500008','SC11512352','MAST-3154011123','CU150007','00013',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500009','SC11512353','VISA-1286011182','CU150008',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500010','SC11512354','VISA-3389013175','CU150008',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500011','SC11512355','VISA-7289014122','CU150009','00014',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500012','SC11512356','MAST-1179011125',NULL,'00015',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500013','SC11512357','MAST-3415011123','CU150010','00015',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500014','SC11512358','VISA-0287011151','CU150011',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500015','SC11512359','VISA-3189011117','CU150012',NULL,SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500016','SC11512360','VISA-5286011123','CU150013','00015',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500017','SC11512361','MAST-1579011324',NULL,'00016',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500018','SC11512362','MAST-3155011123','CU150015','00017',SYSDATE,1);
INSERT INTO Transaction VALUES('TP11500019','SC11512363','VISA-9287011188','CU150016',NULL,SYSDATE,0);
INSERT INTO Transaction VALUES('TP11500020','SC11512364','VISA-0389011170','CU150018',NULL,SYSDATE,0);

INSERT INTO Delivery VALUES('DP01500001','TP11500004','00018','CU150004',SYSDATE,SYSDATE+3);
INSERT INTO Delivery VALUES('DP01500002','TP11500005','00018','CU150005',SYSDATE,SYSDATE+3);
INSERT INTO Delivery VALUES('DP01500003','TP11500009','00018','CU150008',SYSDATE,SYSDATE+4);
INSERT INTO Delivery VALUES('DP01500004','TP11500010','00018','CU150008',SYSDATE,SYSDATE+5);
INSERT INTO Delivery VALUES('DP01500005','TP11500014','00018','CU150011',SYSDATE,NULL);
INSERT INTO Delivery VALUES('DP01500006','TP11500015','00018','CU150012',SYSDATE,NULL);

INSERT INTO Return VALUES('RT01500001','TP11500016',SYSDATE,'Size not correct.');
INSERT INTO Return VALUES('RT01500002','TP11500017',SYSDATE,'Price not correct. Sale price higher than the price displayed on tag.');
INSERT INTO Return VALUES('RT01500003','TP11500018',SYSDATE,'Product did not match description on website.');

INSERT INTO Transaction_Item VALUES('TP11500001','IT150001',2);
INSERT INTO Transaction_Item VALUES('TP11500002','IT150003',1);
INSERT INTO Transaction_Item VALUES('TP11500003','IT150005',2);
INSERT INTO Transaction_Item VALUES('TP11500004','IT150004',3);
INSERT INTO Transaction_Item VALUES('TP11500005','IT150002',4);
INSERT INTO Transaction_Item VALUES('TP11500006','IT150008',2);
INSERT INTO Transaction_Item VALUES('TP11500007','IT150007',1);
INSERT INTO Transaction_Item VALUES('TP11500008','IT150006',2);
INSERT INTO Transaction_Item VALUES('TP11500009','IT150009',2);
INSERT INTO Transaction_Item VALUES('TP11500010','IT150010',5);
INSERT INTO Transaction_Item VALUES('TP11500011','IT150020',2);
INSERT INTO Transaction_Item VALUES('TP11500012','IT150019',3);
INSERT INTO Transaction_Item VALUES('TP11500013','IT150016',2);
INSERT INTO Transaction_Item VALUES('TP11500014','IT150015',1);
INSERT INTO Transaction_Item VALUES('TP11500015','IT150017',2);

INSERT INTO Delivery_Item VALUES('DP01500001','IT150004',3);
INSERT INTO Delivery_Item VALUES('DP01500002','IT150005',2);
INSERT INTO Delivery_Item VALUES('DP01500003','IT150011',3);
INSERT INTO Delivery_Item VALUES('DP01500004','IT150015',1);
INSERT INTO Delivery_Item VALUES('DP01500005','IT150017',1);
INSERT INTO Delivery_Item VALUES('DP01500006','IT150020',2);

INSERT INTO Return_Item VALUES('RT01500001','IT150001',3);
INSERT INTO Return_Item VALUES('RT01500002','IT150008',1);
INSERT INTO Return_Item VALUES('RT01500003','IT150015',2);

-- SELECT * FROM Customer;
-- SELECT * FROM Employee;
-- SELECT * FROM Administrator;
-- SELECT * FROM Store;
-- SELECT * FROM Category;
-- SELECT * FROM Item;
-- SELECT * FROM Transaction;
-- SELECT * FROM Delivery;
-- SELECT * FROM Return;
-- SELECT * FROM Transaction_Item;
-- SELECT * FROM Delivery_Item;
-- SELECT * FROM Return_Item;







