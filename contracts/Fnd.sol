//SPDX-License-Identifier: MIT
pragma solidity >=0.4.0;

contract Fnd
{
    address admin;
    
    struct Validator
    {
        uint cred_score;
        int vote;
        bool hasVoted;
    }
    struct News
    {
        uint nid;
        uint weight_true;
        uint weight_false;
    }
    address auth;
    News[100] news;
    mapping(address => Validator) validators;
    uint  index=0; 
    
    
    modifier restricted()
    {
        require(msg.sender == admin);
        _;
    }
    
    constructor() public
    {
        admin = msg.sender;
        auth = msg.sender;
        
    }
     function createPost() public {
        news[index]=News(index,0,0);
        index+=1;
        
    }
    function register(address toValidator) restricted public {
        if (msg.sender != auth || validators[toValidator].hasVoted) return;
        
        validators[toValidator].hasVoted = false;
    }
     modifier alreadyVoted()
    {
         Validator storage sender = validators[msg.sender];
         require(sender.hasVoted==false);
        _;
    }
    
     function vote(address voter,uint trueorfalse, uint id) alreadyVoted public returns(string memory) {
         news[id].weight_true = 0;
         news[id].weight_false = 0;
         Validator storage sender = validators[voter];
        sender.hasVoted = true;
        if(id<news.length){
         if(trueorfalse == 1)
         {
             news[id].weight_true += 1;
             return("Successfully voted");
         }
         else
         {
             news[id].weight_false += 1;
             return("Successfully voted");
         }
        }
        else{
            return "Voting failed!!! Invalid Id";
        }
        
        
    }
    function NewsResult(uint id) public view returns (string memory){
        if(news[id].weight_true > news[id].weight_false)
        {
            return "Real news";
        }
        else
        {
            return "Fake news";
        }
    }
}