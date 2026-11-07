-- ===== RestMan: tạo CSDL MySQL 8 =====
DROP DATABASE IF EXISTS restman;
CREATE DATABASE restman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman;

CREATE TABLE tblMember (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userName VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255),
  phoneNumber VARCHAR(255),
  password VARCHAR(255) NOT NULL,
  fullName VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  dob DATE
);

-- Nhân viên (Staff6): có dòng ở đây thì là nhân viên, không có thì là khách hàng
CREATE TABLE tblStaff (
  tblMemberId INT PRIMARY KEY,
  position VARCHAR(255) NOT NULL,           -- MANAGER / WAITSTAFF / WAREHOUSESTAFF
  FOREIGN KEY (tblMemberId) REFERENCES tblMember(id)
);

CREATE TABLE tblSupplier (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phoneNumber VARCHAR(255),
  email VARCHAR(255),
  address VARCHAR(255)
);

CREATE TABLE tblIngredient (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  unit VARCHAR(50),
  quantityInStock INT NOT NULL DEFAULT 0
);

CREATE TABLE tblCatergory (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE tblMenuItem (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tblCatergoryId INT,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(19,0) NOT NULL,
  image VARCHAR(255),                       -- tên file ảnh trong thư mục WEB-INF/images
  description VARCHAR(1000),                -- bổ sung theo lớp thực thể MenuItem6
  status VARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
  FOREIGN KEY (tblCatergoryId) REFERENCES tblCatergory(id)
);

CREATE TABLE tblCombo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  sellingPrice DECIMAL(19,0) NOT NULL,      -- giá gốc
  salePrice DECIMAL(19,0) NOT NULL,         -- giá bán
  duration VARCHAR(255),                    -- thời gian áp dụng
  image VARCHAR(255)
);

CREATE TABLE tblComboDetail (
  tblMenuItemId INT NOT NULL,
  tblComboId INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (tblMenuItemId, tblComboId),
  FOREIGN KEY (tblMenuItemId) REFERENCES tblMenuItem(id),
  FOREIGN KEY (tblComboId) REFERENCES tblCombo(id)
);

CREATE TABLE tblTable (
  id INT AUTO_INCREMENT PRIMARY KEY,
  `number` INT NOT NULL,
  capacity INT NOT NULL,
  status VARCHAR(255) NOT NULL DEFAULT 'FREE'
);

CREATE TABLE tblOrder (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tblCustomerId INT NOT NULL,
  waitStaffId INT,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  totalAmount DECIMAL(19,0) NOT NULL DEFAULT 0,
  status VARCHAR(50),
  FOREIGN KEY (tblCustomerId) REFERENCES tblMember(id),
  FOREIGN KEY (waitStaffId) REFERENCES tblStaff(tblMemberId)
);

CREATE TABLE tblOnlineOrder (
  tblOrderId INT PRIMARY KEY,
  addressNote VARCHAR(255),
  FOREIGN KEY (tblOrderId) REFERENCES tblOrder(id)
);

CREATE TABLE tblOnlineTableReservation (
  tblOrderId INT PRIMARY KEY,
  tblCustomerId INT NOT NULL,
  tblTableId INT NOT NULL,
  arrivalTime TIMESTAMP NOT NULL,
  quantityCustomer INT NOT NULL,
  FOREIGN KEY (tblOrderId) REFERENCES tblOrder(id),
  FOREIGN KEY (tblCustomerId) REFERENCES tblMember(id),
  FOREIGN KEY (tblTableId) REFERENCES tblTable(id)
);

CREATE TABLE tblInvoice (
  id INT AUTO_INCREMENT PRIMARY KEY,
  orderId INT,
  customerId INT,
  waitStaffId INT,
  tableId INT,
  purchasedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  totalAmount DECIMAL(19,0) NOT NULL,
  purchaseMethod VARCHAR(255),
  FOREIGN KEY (orderId) REFERENCES tblOrder(id),
  FOREIGN KEY (customerId) REFERENCES tblMember(id),
  FOREIGN KEY (waitStaffId) REFERENCES tblStaff(tblMemberId),
  FOREIGN KEY (tableId) REFERENCES tblTable(id)
);

-- Lớp cha Detail6: dùng chung cho chi tiết hóa đơn / chi tiết đơn đặt
CREATE TABLE tblDetail (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sellingPrice DECIMAL(19,0) NOT NULL,
  quantity INT NOT NULL,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE tblInvoiceDetailMenuItem (
  tblInvoiceId INT NOT NULL,
  tblMenuItemId INT NOT NULL,
  tblDetailId INT NOT NULL UNIQUE,
  PRIMARY KEY (tblInvoiceId, tblMenuItemId),
  FOREIGN KEY (tblInvoiceId) REFERENCES tblInvoice(id),
  FOREIGN KEY (tblMenuItemId) REFERENCES tblMenuItem(id),
  FOREIGN KEY (tblDetailId) REFERENCES tblDetail(id)
);

CREATE TABLE tblInvoiceDetailCombo (
  tblInvoiceId INT NOT NULL,
  tblComboId INT NOT NULL,
  tblDetailId INT NOT NULL UNIQUE,
  salePrice DECIMAL(19,0) NOT NULL,
  PRIMARY KEY (tblInvoiceId, tblComboId),
  FOREIGN KEY (tblInvoiceId) REFERENCES tblInvoice(id),
  FOREIGN KEY (tblComboId) REFERENCES tblCombo(id),
  FOREIGN KEY (tblDetailId) REFERENCES tblDetail(id)
);

CREATE TABLE tblOrderDetailMenuItem (
  tblOnlineOrderId INT NOT NULL,
  tblMenuItemId INT NOT NULL,
  tblDetailId INT NOT NULL UNIQUE,
  PRIMARY KEY (tblOnlineOrderId, tblMenuItemId),
  FOREIGN KEY (tblOnlineOrderId) REFERENCES tblOnlineOrder(tblOrderId),
  FOREIGN KEY (tblMenuItemId) REFERENCES tblMenuItem(id),
  FOREIGN KEY (tblDetailId) REFERENCES tblDetail(id)
);

CREATE TABLE tblOrderDetailCombo (
  tblOnlineOrderId INT NOT NULL,
  tblComboId INT NOT NULL,
  tblDetailId INT NOT NULL UNIQUE,
  salePrice DECIMAL(19,0) NOT NULL,
  PRIMARY KEY (tblOnlineOrderId, tblComboId),
  FOREIGN KEY (tblOnlineOrderId) REFERENCES tblOnlineOrder(tblOrderId),
  FOREIGN KEY (tblComboId) REFERENCES tblCombo(id),
  FOREIGN KEY (tblDetailId) REFERENCES tblDetail(id)
);

CREATE TABLE tblIngredientReceipt (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tblSupplierId INT NOT NULL,
  warehouseStaffId INT NOT NULL,
  purchasedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  totalAmount DECIMAL(19,0) NOT NULL DEFAULT 0,
  purchaseMethod VARCHAR(255),
  FOREIGN KEY (tblSupplierId) REFERENCES tblSupplier(id),
  FOREIGN KEY (warehouseStaffId) REFERENCES tblStaff(tblMemberId)
);

CREATE TABLE tblIngredientReceiptDetail (
  tblIngredientReceiptId INT NOT NULL,
  tblIngredientId INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(19,0) NOT NULL,
  PRIMARY KEY (tblIngredientReceiptId, tblIngredientId),
  FOREIGN KEY (tblIngredientReceiptId) REFERENCES tblIngredientReceipt(id),
  FOREIGN KEY (tblIngredientId) REFERENCES tblIngredient(id)
);

-- ===== Dữ liệu mẫu =====
INSERT INTO tblMember (id,userName,email,phoneNumber,password,fullName,address,dob) VALUES
 (1,'manager','quan.nguyen@restman.vn','0900000001','123456','Nguyễn Minh Quân','Hà Nội','1985-01-01'),
 (2,'waiter','huong.tran@restman.vn','0900000002','123456','Trần Thu Hương','Hà Nội','1995-02-02'),
 (3,'kho','nam.le@restman.vn','0900000003','123456','Lê Hoàng Nam','Hà Nội','1993-03-03'),
 (4,'khach1','ducanh.pham@gmail.com','0911111111','123456','Phạm Đức Anh','Hà Nội','1990-04-04'),
 (5,'khach2','lan.hoang@gmail.com','0922222222','123456','Hoàng Thị Lan','Hải Phòng','1992-05-05'),
 (6,'khach3','hailong.vu@gmail.com','0933333333','123456','Vũ Hải Long','Nam Định','1998-06-06');
INSERT INTO tblStaff VALUES (1,'MANAGER'),(2,'WAITSTAFF'),(3,'WAREHOUSESTAFF');

INSERT INTO tblCatergory (id,name,status) VALUES
 (1,'Gà rán','ACTIVE'),(2,'Burger','ACTIVE'),(3,'Mì Ý','ACTIVE'),(4,'Cơm','ACTIVE'),
 (5,'Khoai & món phụ','ACTIVE'),(6,'Đồ uống','ACTIVE'),(7,'Tráng miệng','ACTIVE');
INSERT INTO tblMenuItem (id,tblCatergoryId,name,price,image,description,status) VALUES
 (1,1,'Gà giòn vui vẻ (1 miếng)',39000,'ga-gion-vui-ve.svg','Gà rán giòn tan, tẩm ướp đậm vị',  'ACTIVE'),
 (2,1,'Gà sốt cay (1 miếng)',42000,'ga-sot-cay.svg','Gà rán phủ sốt cay đậm đà','ACTIVE'),
 (3,1,'Gà viên (6 miếng)',35000,'ga-vien.svg','Gà viên chiên vàng, ăn kèm sốt chua ngọt','ACTIVE'),
 (4,2,'Burger bò phô mai',49000,'burger-bo-pho-mai.svg','Bánh burger bò nướng, phô mai tan chảy','ACTIVE'),
 (5,2,'Burger gà giòn',45000,'burger-ga-gion.svg','Burger với miếng gà phi lê chiên giòn','ACTIVE'),
 (6,2,'Burger tôm',52000,'burger-tom.svg','Burger nhân tôm chiên xù, sốt mayonnaise','ACTIVE'),
 (7,3,'Mì Ý sốt bò bằm',38000,'mi-y-sot-bo-bam.svg','Mì Ý sốt cà chua bò bằm, rắc phô mai','ACTIVE'),
 (8,4,'Cơm gà giòn',55000,'com-ga-gion.svg','Cơm trắng ăn kèm gà giòn và sốt đặc biệt','ACTIVE'),
 (9,5,'Khoai tây chiên (vừa)',25000,'khoai-tay-chien.svg','Khoai tây chiên vàng giòn','ACTIVE'),
 (10,5,'Salad bắp cải',15000,'salad-bap-cai.svg','Salad bắp cải trộn sốt kem','ACTIVE'),
 (11,6,'Pepsi (ly vừa)',15000,'pepsi.svg','Nước ngọt có ga mát lạnh','ACTIVE'),
 (12,6,'Trà đào',25000,'tra-dao.svg','Trà đào cam sả giải nhiệt','ACTIVE'),
 (13,7,'Kem sundae',20000,'kem-sundae.svg','Kem vani rưới sốt socola','ACTIVE'),
 (14,7,'Bánh xoài',18000,'banh-xoai.svg','Bánh chiên nhân xoài thơm ngọt','ACTIVE');
INSERT INTO tblCombo (id,name,sellingPrice,salePrice,duration,image) VALUES
 (1,'Combo 1 Gà giòn + Khoai tây + Pepsi',79000,69000,'01/01/2026 - 31/12/2026','combo-1.svg'),
 (2,'Combo 2 Gà giòn + Mì Ý + Pepsi',92000,79000,'01/01/2026 - 31/12/2026','combo-2.svg'),
 (3,'Combo Burger bò phô mai + Khoai tây + Pepsi',89000,75000,'01/01/2026 - 31/12/2026','combo-3.svg'),
 (4,'Combo Bạn bè 3 Gà giòn + 2 Khoai tây + 3 Pepsi',212000,179000,'01/01/2026 - 31/12/2026','combo-ban-be.svg'),
 (5,'Combo Gia đình 6 Gà giòn + 3 Khoai tây + 4 Pepsi + 2 Kem',409000,349000,'01/01/2026 - 31/12/2026','combo-gia-dinh.svg');
-- (món, combo, số lượng)
INSERT INTO tblComboDetail VALUES
 (1,1,1),(9,1,1),(11,1,1),
 (1,2,1),(7,2,1),(11,2,1),
 (4,3,1),(9,3,1),(11,3,1),
 (1,4,3),(9,4,2),(11,4,3),
 (1,5,6),(9,5,3),(11,5,4),(13,5,2);
INSERT INTO tblTable (id,`number`,capacity,status) VALUES (1,1,4,'FREE'),(2,2,6,'FREE');

INSERT INTO tblOrder (id,tblCustomerId,waitStaffId,createdAt,totalAmount,status) VALUES
 (1,4,2,'2026-09-05 19:00:00',108000,'PAID'),(2,4,2,'2026-10-10 12:00:00',69000,'PAID'),
 (3,5,2,'2026-10-12 18:30:00',172000,'PAID'),(4,6,2,'2026-10-20 20:00:00',158000,'PAID');
INSERT INTO tblInvoice (id,orderId,customerId,waitStaffId,tableId,purchasedAt,totalAmount,purchaseMethod) VALUES
 (1,1,4,2,1,'2026-09-05 20:30:00',108000,'CASH'),(2,2,4,2,2,'2026-10-10 13:15:00',69000,'CARD'),
 (3,3,5,2,1,'2026-10-12 19:45:00',172000,'CASH'),(4,4,6,2,2,'2026-10-20 21:00:00',158000,'TRANSFER');
INSERT INTO tblDetail (id,sellingPrice,quantity,name) VALUES
 (1,39000,2,'Gà giòn vui vẻ (1 miếng)'),(2,15000,2,'Pepsi (ly vừa)'),
 (3,69000,1,'Combo 1 Gà giòn + Khoai tây + Pepsi'),
 (4,49000,3,'Burger bò phô mai'),(5,25000,1,'Khoai tây chiên (vừa)'),
 (6,79000,2,'Combo 2 Gà giòn + Mì Ý + Pepsi');
INSERT INTO tblInvoiceDetailMenuItem VALUES (1,1,1),(1,11,2),(3,4,4),(3,9,5);
INSERT INTO tblInvoiceDetailCombo VALUES (2,1,3,69000),(4,2,6,79000);
