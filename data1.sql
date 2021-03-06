

use quanlyquancafe1
go

-- Các bảng gồm: Account, FoodCategory, Food, TableFood, Bill, BillInfo

create table Account(
	id int identity primary key,
	UserName nvarchar(100) not null,
	DisplayName nvarchar(100) not null,
	PassWord nvarchar(100) not null,
	Type int not null default 0 -- 1:Admin or 0:Staff
)
go

create table FoodCategory(
	id int identity primary key,
	name nvarchar(100) not null,
)
go

create table Food(
	id int identity primary key,
	name nvarchar(100) not null,
	idCategory int not null,
	price float not null default 0,
	foreign key (idCategory) references FoodCategory(id)
)
go

create table TableFood(
	id int identity primary key,
	name nvarchar(100) not null,
	status nvarchar(100) not null default N'Trống' --Trống or Có người 
)
go

create table Bill(
	id int identity primary key,
	DateCheckIn date not null default getdate(),
	DateCheckOut date,
	idTable int not null,
	status int not null default 0, --1 or 0
	discount int default 0,
	totalPrice float default 0,
	foreign key (idTable) references TableFood(id)
)
go


create table BillInfo(
	id int identity primary key,
	idBill int not null,
	idFood int not null,
	count int not null default 0,
	foreign key (idBill) references Bill(id),
	foreign key (idFood) references Food(id)
)
go


--Thêm dữ liệu vào bảng Account
insert into Account(UserName,DisplayName,PassWord,Type) values (N'admin',N'Chủ quán',N'admin',1)
insert into Account(UserName,DisplayName,PassWord,Type) values (N'luong',N'Lê Thanh Lương',N'dong',0)
insert into Account(UserName,DisplayName,PassWord,Type) values (N'Dat',N'Trần Sĩ Đạt',N'dat',0)
go


--Thêm dữ liệu vào bảng TableFood
insert into TableFood(name) values (N'Bàn 1')
insert into TableFood(name) values (N'Bàn 2')
insert into TableFood(name) values (N'Bàn 3')
insert into TableFood(name) values (N'Bàn 4')
insert into TableFood(name) values (N'Bàn 5')
insert into TableFood(name) values (N'Bàn 6')
insert into TableFood(name) values (N'Bàn 7')
insert into TableFood(name) values (N'Bàn 8')
insert into TableFood(name) values (N'Bàn 9')
insert into TableFood(name) values (N'Bàn 10')
insert into TableFood(name) values (N'Bàn 11')
insert into TableFood(name) values (N'Bàn 12')
insert into TableFood(name) values (N'Bàn 13')
insert into TableFood(name) values (N'Bàn 14')
insert into TableFood(name) values (N'Bàn 15')
go

--Thêm dữ liệ vào bảng FoodCategory
insert into FoodCategory(name) values (N'Món chính')
insert into FoodCategory(name) values (N'Món tráng miệng')
insert into FoodCategory(name) values (N'Đồ uống')
go

--Thêm dữ liệu vào bảng Food
insert into Food(name,idCategory,price) values (N'Gà hấp lá chanh',1,80000)
insert into Food(name,idCategory,price) values (N'Bò xào mướp đắng',1,70000)
insert into Food(name,idCategory,price) values (N'Cơm xào hải sản',1,120000)
insert into Food(name,idCategory,price) values (N'Lẩu gà lá é',1,90000)
insert into Food(name,idCategory,price) values (N'Dú dê nướng',1,20000)
insert into Food(name,idCategory,price) values (N'Tôm hấp bia',1,15000)
insert into Food(name,idCategory,price) values (N'Kem tươi',2,30000)
insert into Food(name,idCategory,price) values (N'Rau câu dừa',2,15000)
insert into Food(name,idCategory,price) values (N'Đá me',3,18000)
insert into Food(name,idCategory,price) values (N'Đá chanh',3,18000)
insert into Food(name,idCategory,price) values (N'Cà phê',3,18000)
insert into Food(name,idCategory,price) values (N'Cà phê sữa',3,23000)
insert into Food(name,idCategory,price) values (N'Lipton',3,18000)
insert into Food(name,idCategory,price) values (N'Dừa tươi',3,23000)
insert into Food(name,idCategory,price) values (N'Chanh muối',3,18000)
insert into Food(name,idCategory,price) values (N'Trà ôlong',3,8000)
go

--Thêm dữ liệu vào bảng Bill
insert into Bill(DateCheckIn,DateCheckOut,idTable,status) values (GETDATE(),null,1,0)
insert into Bill(DateCheckIn,DateCheckOut,idTable,status) values (GETDATE(),GETDATE(),3,1)
go
--Thêm dữ liệu vào bảng BillInfo
insert into BillInfo(idBill,idFood,count) values (1,2,2)
insert into BillInfo(idBill,idFood,count) values (1,3,1)
insert into BillInfo(idBill,idFood,count) values (1,10,5)
insert into BillInfo(idBill,idFood,count) values (2,3,1)
insert into BillInfo(idBill,idFood,count) values (2,5,2)
go


create proc GetAccountByUsername @username nvarchar(100)
as
begin
	select * from Account where username=@username
end
go

create proc Login @username nvarchar(100), @password nvarchar(100)
as
begin
	select * from Account where username=@username and password=@password
end
go

select f.name, bi.count, f.price, f.price*bi.count as totalPrice from BillInfo as bi, Bill as b, Food as f
where bi.idBill = b.id and bi.idFood = f.id and b.idTable = 3

create proc GetTableList
as select * from TableFood
go

create proc InsertBill @idTable int
as
begin
	insert Bill(DateCheckIn, DateCheckOut, idTable, status, discount)
	values (GETDATE(), null, @idTable, 0, 0)
end
go

create proc InsertBillInfo @idBill int, @idFood int, @count int
as
begin
	declare @isExistBillInfo int
	declare @foodCount int = 1
	select @isExistBillInfo = id , @foodCount = count FROM BillInfo WHERE idBill = @idBill and idFood = @idFood
	if(@isExistBillInfo > 0)
		begin
			declare @newCount int = @foodCount + @count
			if(@newCount > 0)
				update BillInfo set count = @newCount where idFood = @idFood
			else
				delete BillInfo where idBill = @idBill and idFood = @idFood
		end
	else
		begin
			insert into BillInfo(idBill,idFood,count) values (@idBill,@idFood,@count)
		end
end
go

create trigger UpdateBillInfo
on BillInfo for insert, update
as
begin
	declare @idBill int
	select @idBill = idBill from Inserted
	declare @idTable int
	select @idTable = idTable from Bill where id = @idBill and status = 0
	declare @count int
	select @count = count(*) from BillInfo where idBill = @idBill
	if(@count > 0)
		update TableFood set status = N'Có người' where id = @idTable
	else 
		update TableFood set status = N'Trống' where id = @idTable
end
go

create trigger UpdateBill
on Bill for update
as
begin
	declare @idBill int
	select @idBill = id from Inserted
	declare @idTable int
	select @idTable = idTable from Bill where id = @idBill
	declare @count int = 0
	select @count = count(*) from Bill where idTable = @idTable and status = 0;
	if(@count = 0)
		update TableFood set status = N'Trống' where id = @idTable;
end
go

create trigger DeleteBillInfo
on BillInfo for delete
as
begin
	declare @idBillInfo int
	declare @idBill int
	select @idBillInfo = id, @idBill = Deleted.idBill from Deleted

	declare @idTable int
	select @idTable = idTable from Bill where id = @idBill

	declare @count int = 0
	select @count = count(*) from BillInfo a, Bill b where b.id = a.idBill and b.id = @idBill and b.status = 0

	if(@count = 0)
		update TableFood set status = N'Trống' where id = @idTable
end
go

create proc SwitchTable @idTable1 int, @idTable2 int 
as
begin
	declare @idFirstBill int
	declare @idSecondBill int

	declare @isFirstTableEmty int = 1
	declare @isSecondTableEmty int = 1

	SELECT @idFirstBill = id FROM Bill WHERE idTable = @idTable1 AND status = 0
	SELECT @idSecondBill = id FROM Bill WHERE idTable = @idTable2 AND status = 0
	if(@idFirstBill is null)
		begin
			insert into Bill(DateCheckIn,DateCheckOut,idTable,status) values (GETDATE(),null,@idTable1,0)
			select @idFirstBill = max(id) from Bill where idTable = @idTable1 and status = 0
		end

	select @isFirstTableEmty = count(*) from BillInfo where idBill = @idFirstBill

	if(@idSecondBill is null)
		begin
			insert into Bill(DateCheckIn,DateCheckOut,idTable,status) values (GETDATE(),null,@idTable2,0)
			select @idSecondBill = max(id) from Bill where idTable = @idTable2 and status = 0
		end

	select @isSecondTableEmty = count(*) from BillInfo where idBill = @idSecondBill

	select id into IDBillIntoTable from BillInfo where idBill = @idSecondBill
	update BillInfo set idBill = @idSecondBill where idBill = @idFirstBill
	update BillInfo set idBill = @idFirstBill where id in (select * from IDBillIntoTable)
	drop table IDBillIntoTable

	if(@isFirstTableEmty = 0)
		update TableFood set status = N'Trống' where id = @idTable2

	if(@isSecondTableEmty = 0)
		update TableFood set status = N'Trống' where id = @idTable1
end
go

---------------------------------------------------------------------




create proc GetListBillDate @dateCheckIn date, @dateCheckOut date
as
begin
	select b.name as [Tên bàn], a.totalPrice as [Tổng tiền], a.DateCheckIn as [Ngày vào], a.DateCheckOut as [Ngày ra], a.discount as [Giảm giá (%)] 
	from Bill a, TableFood b 
	where a.idTable = b.id and a.DateCheckIn >= @dateCheckIn and a.DateCheckOut <= @dateCheckOut and a.status = 1
end
go


create proc UpdateAccount @userName nvarchar(100), @displayName nvarchar(100), @passWord nvarchar(100), @newPassWord nvarchar(100)
as
begin
	declare @isRightPass int = 0
	select @isRightPass = count(*) from Account where UserName = @userName and PassWord = @passWord
	if(@isRightPass = 1)
	begin
		if(@newPassWord = null or @newPassWord = '')
		begin
			update Account set DisplayName = @displayName where UserName = @userName
		end
		else
			update Account set DisplayName = @displayName, PassWord = @newPassWord where UserName = @userName
	end
end
go

