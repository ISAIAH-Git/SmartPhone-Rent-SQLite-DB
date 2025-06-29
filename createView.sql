/* Creating a View called Customer Summary to provide a summarised view of the customer rentals */
/* Over here the view helps in getting the summary of rentals for the tax purposes */
create view CustomerSummary as
 select rentalContract.customerId, /* customer id from rental contract table */
 PhoneModel.modelName, /* Phone model name from the phonemodel table */
 /* Calculating the number of days the phone was rented */
 julianday(rentalContract.dateBack)-julianday(rentalContract.dateOut) as daysRented,
 
   /* Writing the Logic for determining the Tax Year based on the rental date */
   /* Over here the financial year starts from July to the June */
   /* If the rental date falls between january and june it would be considered that it belongs to  previous tax year */
   /* Contrarily if the rental rate is between july to december it is allocated to the current tax year */
   
   case
	when strftime('%m',rentalContract.dateOut) between '01' and '06' then  
		cast(strftime('%Y',rentalContract.dateOut)-1 as text)|| '/' ||substr(strftime('%Y',rentalContract.dateOut),3,2)
    else 
	strftime('%Y',rentalContract.dateOut) || '/' ||substr(cast(strftime('%Y',rentalContract.dateOut)+1 as text),3,2)
    end as taxYear,
	rentalContract.rentalCost /* Rental cost from the rentalcontract table */
from rentalContract
/* Joining with the phone table to get the phone details*/
join Phone  on rentalContract.IMEI=Phone.IMEI
/* joining with the phonemodel table to get the phone model details */
join PhoneModel on Phone.modelNumber=PhoneModel.modelNumber
/* The view will only include records where the dateback is not null and return date is after or the same as the rental date */
where rentalContract.dateBack is not null and julianday(rentalContract.dateBack)>=julianday(rentalContract.dateOut);