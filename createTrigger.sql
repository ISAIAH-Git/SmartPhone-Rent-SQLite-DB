/* Trigger Query which calculates the Rental cost after the dateBack is updated in the rentalContract table */
create trigger compute_rental_cost after update of dateBack on rentalContract
for each row
/* The trigger will only start if the dateBack is not null and the return date is after or the same as the rental date */
when new.dateBack is not null and julianday(new.dateBack)>=julianday(new.dateOut)
begin
	/* Updating the rental cost based on the baseCost and dailycost from the PhoneModel table */
    update rentalContract
	/* calculating the rentalCost based on the baseCost and dailyCost from the PhoneModel  table */
    set rentalCost=(select(baseCost+(dailyCost*(julianday(new.dateBack)-julianday(new.dateOut)))) from PhoneModel 
        /* Joining with the Phone Table to get the model details */
		join Phone on Phone.modelNumber=PhoneModel.modelNumber 
        where Phone.IMEI=new.IMEI)
	where IMEI=new.IMEI and dateOut=new.dateOut;
	
end; 
