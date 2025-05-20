/* 1. Count the customer base based on customer type to identify current customer preferences and sort them in descending order.*/
Select count(*) as Customers_Count,C_type 
from customer 
group by C_type 
Order by Customers_Count desc;

/* 2. Count the customer base based on their status of payment in descending order.*/
Select count(*) as Customers_Count,Payment_Status 
from payment_details 
group by Payment_Status 
Order by Customers_Count desc;

/*3. Count the customer base based on their payment mode in descending order of count.*/
Select count(*) as Customers_Count,Payment_Mode 
from payment_details 
group by Payment_Mode 
Order by Customers_Count desc;

/*4. Count the customers as per shipment domain in descending order. */
Select count(*) as Customers_Count,SH_DOMAIN 
from shipment_details 
group by SH_DOMAIN 
Order by Customers_Count desc;

/*5. Count the customer according to service type in descending order of count.*/
Select count(*) as Customers_Count,SER_TYPE 
from shipment_details 
group by SER_TYPE 
Order by Customers_Count desc;

/*6. Explore employee count based on the designation-wise count of employees' IDs in descending order.*/
Select count(E_ID) as Employee_Count,E_DESIGNATION
from employee_details 
group by E_DESIGNATION 
Order by Employee_Count desc;

/*7. Branch-wise count of employees for efficiency of deliveries in descending order. */
Select count(*) as Employee_Count,E_BRANCH 
from employee_details 
group by E_BRANCH 
Order by Employee_Count desc;

/*8. Finding C_ID, M_ID, and tenure for those customers whose membership is over 10 years. */
SELECT c.C_ID,c.M_ID, TIMESTAMPDIFF(YEAR, m.start_date, IFNULL(m.end_date, CURDATE())) AS tenure_years 
FROM customer c JOIN membership m 
ON c.M_ID = m.M_ID 
WHERE TIMESTAMPDIFF(YEAR, m.start_date, IFNULL(m.end_date, CURDATE())) > 10;

/*9. Considering average payment amount based on customer type having payment mode as COD in descending order.*/
Select avg(p.Amount) as Average_Payment_Amount,c.C_Type
from payment_details p
join customer c
on p.C_ID = c.C_ID
where p.Payment_Mode='COD'
group by c.C_Type
order by avg(p.Amount) desc;

/*10. Calculate the average payment amount based on payment mode where the payment date is not null. */
Select avg(Amount) as Average_Payment_Amount,Payment_Mode
from payment_details p
where Payment_Mode is not null
group by Payment_Mode;

/*11. Calculate the average shipment weight based on payment_status where shipment content does not start with "H." */
Select p.Payment_Status,avg(s.SH_Weight) as Average_Shipment_Weight
from payment_details p
join shipment_details s 
on p.SH_ID = s.SH_ID
where s.SH_Content not like'H%'
group by p.Payment_Status;

/*12. Retrieve the names and designations of all employees in the 'NY' E_Branch.*/
Select E_Name,E_Designation
from employee_details 
where E_Branch='NY';

/*13. Calculate the total number of customers in each C_TYPE (Wholesale, Retail, Internal Goods).*/
Select C_Type,count(*) as Total_Customers
from customer 
group by C_Type;

/*14. Find the membership start and end dates for customers with 'Paid' payment status. */
SELECT c.C_ID,c.C_Name,m.Start_Date,m.End_Date
FROM Customer c
JOIN Payment_Details p ON c.C_ID = p.SH_ID
JOIN Membership m ON c.M_ID = m.M_ID
WHERE p.PAYMENT_STATUS = 'Paid';

/*15. List the clients who have made 'Card Payment' and have a 'Regular' service type. */
SELECT c.C_ID,c.C_Name, p.PAYMENT_MODE,s.SER_TYPE
FROM Customer c
JOIN Payment_Details p ON c.C_ID = c.C_ID
JOIN shipment_details s ON c.C_ID = s.C_ID
WHERE p.PAYMENT_Mode = 'Card Payment'
and s.SER_Type='Regular';

/*16. Calculate the average shipment weight for each shipment domain (International and Domestic). */
Select avg(SH_WEIGHT) as Average_Shipment_Weight,SH_DOMAIN
from shipment_details
group by SH_DOMAIN;

/*17. Identify the shipment with the highest charges and the corresponding client's name. */
Select s.SH_ID,c.C_Name,s.SH_CHARGES as Shipment_Charges
from customer c 
join shipment_details s 
on c.C_ID = s.C_ID
order by s.SH_CHARGES desc
Limit 1;


/*18. Retrieve the current status and delivery date of shipments managed by employees with the designation 'Delivery Boy'. */
SELECT s.CURRENT_Status,s.DELIVERY_DATE
FROM Employee_Details e
JOIN employee_manages_shipment ems on e.E_ID = ems.Employee_E_ID
JOIN "status" s ON ems.Status_SH_ID = s.SH_ID
WHERE e.Emp_DESIGNATION = 'Delivery Boy';

/*19. Find the membership start and end dates for customers whose 'Current Status' is 'Not Delivered'.*/
SELECT c.C_ID,c.C_Name,m.Start_Date,m.End_Date
FROM customer c
JOIN shipment_details s ON c.C_ID = s.C_ID
JOIN 'status' st ON s.SH_ID = st.SH_ID
JOIN membership m on c.M_ID = m.M_ID
WHERE st.Current_Status = 'Not Delivered';
