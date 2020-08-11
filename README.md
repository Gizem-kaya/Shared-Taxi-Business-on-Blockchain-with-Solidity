# Shared Taxi Business on Block-chain with Solidity

---

   ![nyc_yellow_taxi_in_times_square_hero](https://user-images.githubusercontent.com/32525636/89931335-b3aae700-dc14-11ea-88b9-4653ccb697a0.jpg)

---


## A Smart Contract Application


- **Constructor**: Called by owner of the contract and sets the manager and other initial values for state variables 
 
####- **Join function:** Public, Called by participants, Participants needs to pay the participation fee set in the contract to be a member in the taxi investment 
 
- **SetCarDealer:**
  Only Manager can call this function, Sets the CarDealer’s address 
 
- **CarProposeToBusiness:**
  Only CarDealer can call this, sets Proposed Car values, such as CarID, price, offer valid time and approval state (to 0) 
 
- **ApprovePurchaseCar:**
  Participants can call this function, approves the Proposed Purchase with incrementing the approval state. Each participant can increment once. 
 
- **PurchaseCar:**
  Only Manager can call this function, sends the CarDealer the price of the proposed car if the offer valid time is not passed yet and approval state is approved by more than half of the participants. 
 
- **RepurchaseCarPropose:**
  Only CarDealer can call this, sets Proposed Purchase values, such as CarID, price, offer valid time and approval state (to 0) 
 
- **ApproveSellProposal:**
  Participants can call this function, approves the Proposed Sell with incrementing the approval state. Each participant can increment once. 
 
- **Repurchasecar:**
  Only CarDealer can call this function, sends the proposed car price to contract if the offer valid time is not passed yet and approval state is approved by more than half of the participants.  
 
- **ProposeDriver:**
  Only Manager can call this function, sets driver address, and salary. 
 
- **ApproveDriver:**
  Participants can call this function, approves the Proposed Driver with incrementing the approval state. Each participant can increment once.  
 
- **SetDriver:**
  Only Manager can call this function, sets the Driver info if approval state is approved by more than half of the participants. Assume there is only 1 driver.  
 
- **FireDriver:**
  Only Manager can call this function, gives the full month of salary to current driver’s account and fires the driver by changing the address.     
 
- **GetCharge:**
    Public, customers who use the taxi pays their ticket through this function. Charge is sent to contract. Takes no parameter. See slides 5 deposit () function example. 
 
- **ReleaseSalary:**
  Only Manager can call this function, releases the salary of the Driver to his/her account monthly. Make sure Manager is not calling this function more than once in a month.  
 
- **GetSalary:**
  Only Driver can call this function, if there is any money in Driver’s account, it will be sent to his/her address, avoiding recursive calls. 
 
- **CarExpenses:**
  Only Manager can call this function, sends the CarDealer the price of the expenses every 6 month avoiding recursive calls. Make sure. Manager is not calling this function more than once in the last 6 months.  
 
- **PayDividend:**
  Only Manager can call this function, calculates the total profit after expenses and Driver salaries, calculates the profit per participant and releases this amount to participants in every 6 month. Make sure Manager is not calling this function more than once in the last 6 months. 
 
- **GetDividend:**
  Only Participants can call this function, if there is any money in participants’ account, it will be send to his/her address avoiding recursive calls. 
