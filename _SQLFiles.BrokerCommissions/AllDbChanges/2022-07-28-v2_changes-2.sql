use Broker_Commission;
go


alter table Statement_Details
	add constraint Statement_Details_Broker_Master__fk
		foreign key (BROKER_ID) references Broker_Master (ID)
go

