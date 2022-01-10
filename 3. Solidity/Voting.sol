// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

/*
Contrat Voting
@author malattiya
*/
contract Voting is Ownable{

    WorkflowStatus private _status;

    constructor () {
        _status = WorkflowStatus.RegisteringVoters;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    mapping(uint=>Proposal) _proposalList;
    //Proposal[] proposalsList;
    uint winningProposalId;


    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    mapping(address=> Voter) _voterlist;
    
    /*
        registerProposal enregistrement des propositions dans la liste des propositions
    */
    function registerProposal(string memory _desc) public {
        require(_voterlist[msg.sender].isRegistered, "Proposals are only accepted from voters !");
        require(_status==WorkflowStatus.ProposalsRegistrationStarted, "Proposals registration ended !");
        //proposalsList.push(Proposal(_desc, 0));
        //emit ProposalRegistered(proposalsList.length()+1);
        _proposalList[_proposalList.length()++]=Proposal(_desc,0);
        emit ProposalRegistered(_proposalList.length());
    }

    function voting(uint _proposalId) public {
        require(!(_voterlist[msg.sender]).isRegistred, "You are not allowed to vote !");
        require(_status==WorkflowStatus.VotingSessionStarted, "Voting session does not started yet !");
        require(!(_voterlist[msg.sender]).hasVoted, "Already voted !");
        //proposalsList[_proposalId-1].voteCount=proposalsList[_proposalId-1].voteCount++;
        _proposalsList[_proposalId-1].voteCount++;
        _voterlist[msg.sender]=Voter(true,true,_proposalId);
        emit Voted(msg.sender,_proposalId);
    }

    /*
        changeWorkflowStatus changement de statut du workflow
    */
    function changeWorkflowStatus (WorkflowStatus _wfStatus) public onlyOwner {
        if (_wfStatus==WorkflowStatus.ProposalsRegistrationStarted) {
            emit WorkflowStatusChange (_status, WorkflowStatus.ProposalsRegistrationStarted);
            _status = WorkflowStatus.ProposalsRegistrationStarted;
        } else if (_wfStatus==WorkflowStatus.ProposalsRegistrationEnded) {
            emit WorkflowStatusChange (_status, WorkflowStatus.ProposalsRegistrationEnded);
            _status = WorkflowStatus.ProposalsRegistrationEnded;
        } else if (_wfStatus==WorkflowStatus.VotingSessionEnded) {
            emit WorkflowStatusChange (_status, WorkflowStatus.VotingSessionEnded);
            _status = WorkflowStatus.VotingSessionEnded;
        } else if (_wfStatus==WorkflowStatus.VotesTallied) {
            emit WorkflowStatusChange (_status, WorkflowStatus.VotesTallied);
            _status = WorkflowStatus.VotesTallied;
        }
    }

    function getStatus () public view returns (WorkflowStatus){
        return _status;
    }

    function registerVoter() public {
        require (_status==WorkflowStatus.RegisteringVoters, "Registering voters is closed");
        require(!_voterlist[msg.sender], "This address is already in our voter list !");
        _voterlist[msg.sender] = true;
        emit VoterRegistered(msg.sender);
    }

    function getWinner() public view returns(uint){
        require(_status!=WorkflowStatus.VotesTallied, "Votes not tallied yet!");

        winningProposalId = -1;
        uint maxCount = 0;
        /*for (uint i=0; i++; proposalsList.length()-1) {
            if (maxCount<proposalsList[i].voteCount) {
                winningProposalId=i;
                maxCount=proposalsList[i].voteCount;
            }
        }*/
        for (uint i=0; i++; _proposalsList.length()-1) {
            if (maxCount<_proposalsList[i].voteCount) {
                winningProposalId=i;
                maxCount=_proposalsList[i].voteCount;
            }
        }
        return winningProposalId;
    }
}