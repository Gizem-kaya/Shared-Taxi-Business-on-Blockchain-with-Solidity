/*

Gizem Kaya

Compiler version : 0.4.24+commit.e67f0147.Emscripten.clang

*/


pragma solidity >=0.4.0 <0.6.0;

contract TaxiBusiness{
    
    /* state variables */
    
    mapping(uint => Participants) participants;     // to access each participant with unique index number in an array
    address Manager;                                // to hold address of the contract's caller.
    address carDealer;
    uint contractBalance;
    uint fixedExpenses;
    uint public peopleCount;
    uint participationFee;
    int32 ownedCar;
    address this;             
    
    
    /* variables to make time comparisons more comprehensible */
                
    uint offersCurrentTime;
    uint purchaseCurrentTime;
    
    
    /* variables to make functions more readable */
    
    bool controlForDriver;
    uint timeForDriverSalary;
    uint charge;
    uint releasedSalaryOfDriver;
    uint timeForCarExpenses;
    uint sixMonthsForPaying;
    
    
    /* structs */

    struct Participants {
        uint Id;
        uint Balance;
        address Address;
        
    }

     struct TaxiDriver {                
        address TaxiDriverAddress;
        uint Salary;
     }
     TaxiDriver candidateDriver;
     TaxiDriver taxiDriver;
     
     
     
     struct ProposedCar {
        int32 CarID;
        uint Price;
        uint OfferValidTime;
        uint ApprovalState;
     }ProposedCar proposedCar;
     
     
     
     struct ProposedRepurchase {
        int32 CarID;
        uint Price;
        uint OfferValidTime;
        uint ApprovalState;
     }ProposedRepurchase proposedRepurchase;
     


 
    constructor () public {      // a simple constructor that assigns initial values for state variables.
    
        Manager = msg.sender;
        contractBalance = 0 ether;
        peopleCount = 0;
        participationFee = 100 ether;
        controlForDriver = false;
        charge = 50 ether;
        releasedSalaryOfDriver = 0;
        fixedExpenses = 10 ether;
        sixMonthsForPaying = now;
    }
    
    /* modifiers */
    
    modifier onlyParticipants {
        
        bool isParticipant = false;
        for(uint i = 0; i<= peopleCount; i++){
            if(msg.sender == participants[i].Address) 
                isParticipant == true;
        }  if(isParticipant == true) _;
     
    }
    
    modifier onlyCandidateParticipants {        // to control if the address is not in participants and 
                                                // participant count is not above 9.
        bool isParticipant = false;
        for(uint i = 0; i<= peopleCount; i++){
            if(msg.sender == participants[i].Address)
                isParticipant == true;
            
        } if( isParticipant == false && peopleCount < 10 ) _;   
    }
    
    modifier onlyManager {
        
        if( msg.sender == Manager ) _;        
        
    }
    
    modifier onlyCarDealer {
        
        if( msg.sender == carDealer ) _;
    }
    
    modifier onlyDriver {
        
        if(msg.sender == taxiDriver.TaxiDriverAddress) _;
    }
    
    
    
    /* functions */
    
    function Join() public payable onlyCandidateParticipants {
        
        if(msg.value >= participationFee){
            
            this.transfer(participationFee);
            contractBalance += participationFee;
            participants[peopleCount] = Participants(peopleCount, msg.value, msg.sender);
            peopleCount++;
        }
       
    }
    
    function SetCarDealer(address carDealersAddress) public onlyManager {
        
        carDealer = carDealersAddress;
       
        
    }
    
    function CarProposeToBusiness(int32 carID, uint price, uint offerValidTime) public onlyCarDealer {
        
        proposedCar.CarID = carID;
        proposedCar.Price = price;
        proposedCar.OfferValidTime = offerValidTime;
        proposedCar.ApprovalState = 0;
        offersCurrentTime = now;
        
    }
    
    address[] controlForDoubleVoteArrayToPurchaseCar;          // to control "each participant can increment once" rule.
    uint public votesForPurchaseCar = 0;                        // to hold the votes of the participants
    
    function ApprovePurchaseCar() public onlyParticipants returns(bool) {
        
        for(uint i = 0; i < controlForDoubleVoteArrayToPurchaseCar.length; i++){
            if(msg.sender == controlForDoubleVoteArrayToPurchaseCar[i]){
                
                return false;
            }
        }
        
        controlForDoubleVoteArrayToPurchaseCar.push(msg.sender);       
        votesForPurchaseCar += 1;

        return true;
        
    }


    function PurchaseCar() public payable onlyManager {
        
        if(offersCurrentTime + proposedCar.OfferValidTime >= now && (votesForPurchaseCar > (peopleCount/2)) ){
            contractBalance -= proposedCar.Price;
            carDealer.transfer(proposedCar.Price);
            for(uint i = 0; i <controlForDoubleVoteArrayToPurchaseCar.length; i++){
               delete controlForDoubleVoteArrayToPurchaseCar[i];
            }
            
            timeForCarExpenses = now;
            votesForPurchaseCar = 0;
        }
    }
    
    function RepurchaseCarPropose(int32 carID, uint price, uint offerValidTime) public onlyCarDealer {
        
        proposedRepurchase.CarID = carID;
        proposedRepurchase.Price = price;
        proposedRepurchase.OfferValidTime = offerValidTime;
        proposedRepurchase.ApprovalState = 0;
        purchaseCurrentTime = now;
  
    }
    
    address[] controlForDoubleVoteArrayToSellProposal;          // to control "each participant can increment once" rule.
    uint public votesForSellProposal = 0;                        // to hold the votes of the participants.
    
    function ApproveSellProposal() public onlyParticipants returns (bool){
    
        for(uint i = 0; i < controlForDoubleVoteArrayToSellProposal.length; i++){
            if(msg.sender == controlForDoubleVoteArrayToSellProposal[i]){
                
                return false;
            }
        }
        controlForDoubleVoteArrayToSellProposal.push(msg.sender);
        votesForSellProposal += 1;
        
        return true;
    }
    
    
    function Repurchasecar () public payable onlyCarDealer {
        
        if((votesForPurchaseCar > (peopleCount/2)) && (purchaseCurrentTime + proposedRepurchase.OfferValidTime) > now){
            
            contractBalance += proposedRepurchase.Price;
            this.transfer(proposedRepurchase.Price);
            controlForDoubleVoteArrayToSellProposal;
            
            for(uint i = 0; i <controlForDoubleVoteArrayToSellProposal.length; i++){
               delete controlForDoubleVoteArrayToSellProposal[i];
            }
               
            votesForSellProposal = 0;
            
        }
       
    }
    
    function ProposeDriver(address Address, uint salary) public onlyManager {
        
        candidateDriver.TaxiDriverAddress = Address;
        candidateDriver.Salary = salary;
        
    }
    
    
    address[] controlForDoubleVoteArrayToDriver;          // to control "each participant can increment once" rule.
    uint public votesForDriver = 0;                        // to hold the votes of the participants.
    
    function ApproveDriver() public onlyParticipants {
        
        for(uint i = 0; i < controlForDoubleVoteArrayToDriver.length; i++){
            if(msg.sender == controlForDoubleVoteArrayToDriver[i]){
                return;
            }
        }
        controlForDoubleVoteArrayToDriver.push(msg.sender);
        votesForDriver += 1;
        
        return;
        
    }
    

    function SetDriver() public onlyManager {
        
        if(votesForDriver > (peopleCount/2)) {
          
            taxiDriver.TaxiDriverAddress = candidateDriver.TaxiDriverAddress;
            taxiDriver.Salary = candidateDriver.Salary;
            for(uint i = 0; i <controlForDoubleVoteArrayToDriver.length; i++){
               delete controlForDoubleVoteArrayToDriver[i];
            }
            
            controlForDriver = true;
            votesForDriver = 0;
         
        }
        
    }
                
    function FireDriver() public payable onlyManager {
        
        if (controlForDriver == true){
            taxiDriver.TaxiDriverAddress.transfer(taxiDriver.Salary);
            taxiDriver.TaxiDriverAddress = 0;
            controlForDriver = false;
            timeForDriverSalary = now;
        }
        
     
    }

    function GetCharge() public payable {
        
        this.transfer(charge);
        contractBalance += charge;
        
    }
    
    function ReleaseSalary() public onlyManager {
        
        if(timeForDriverSalary + 2629746 < now){            // if at least 1 month is passed.
        
            contractBalance -= taxiDriver.Salary;
            releasedSalaryOfDriver = taxiDriver.Salary;
            timeForDriverSalary = now;
           
        }
        
    }
    
    function GetSalary() public payable onlyDriver {
        
        taxiDriver.TaxiDriverAddress.transfer(releasedSalaryOfDriver);
        releasedSalaryOfDriver = 0;
    }
    
    
    function CarExpenses() public payable onlyManager {  
      
        if( timeForCarExpenses + 15778476 < now){       // if at least 6 months are passed.
            carDealer.transfer(fixedExpenses);
            contractBalance -= fixedExpenses;
            timeForCarExpenses = now;
            
        }

    }
    
    uint [] dividendsList;                              // to hold dividend value of each participant.
    function PayDividend () public onlyManager {
        
        if( sixMonthsForPaying + 15778476 < now){
             
            uint div = contractBalance / peopleCount;
        
            for(uint i = 0; i< peopleCount; i++){
                dividendsList[i] += div;
            }
        
        sixMonthsForPaying = now;
        
        }
      
    }
    

    function GetDividend () public payable onlyParticipants{
        
        uint dividend = contractBalance / peopleCount;
        
        for(uint i = 0; i< peopleCount; i++){
            
            if(msg.sender == participants[i].Address){
                
                msg.sender.transfer(dividendsList[i]);
                participants[i].Balance += dividend; 
                dividendsList[i] = 0;
                
            }
        }
    }
   
    function () external {                                           // fallback function.
        
        revert();
    }
    
    
    
}