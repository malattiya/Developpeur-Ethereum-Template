// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

/*
Contrat Voting
@author malattiya
*/
contract Voting is Ownable{

    uint winningProposalId; //La proposition qui reçoit le plus de vote 
    uint private totalProposals; //Nbr total de propositions
    WorkflowStatus private _status; //Le statut du workflow

    //Structure qui aide à stocker l'état de vote sur les propsoitions
    struct Proposal {
        string description;
        uint voteCount;
    }

     //Structure qui aide à stocker l'état de chhaque votant
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    //mapping contenant la liste des votants et leurs états
    mapping(address=> Voter) _voterlist;
    //mapping contenant la liste des propositions
    mapping(uint=>Proposal) _proposalList;

    /*
        Le constructeur du SC qui sert à initialiser l'état
    */
    constructor () {
        changeWorkflowStatus(WorkflowStatus.RegisteringVoters);
        totalProposals = 0;
        winningProposalId = 0;
    }

    //Statuts du workflow
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
    
    /*
        registerProposal enregistrement des propositions dans la liste des propositions
    */
    function registerProposal(string memory _desc) public {
        require(_voterlist[msg.sender].isRegistered, "Proposals are only accepted from voters !");
        require(_status==WorkflowStatus.ProposalsRegistrationStarted, "Proposals registration ended !");
        _proposalList[totalProposals++]=Proposal(_desc,0);
        emit ProposalRegistered(totalProposals);
    }

    /*
        voting permet l'enregsitretment des votes sur les propositions
    */
    function voting(uint _proposalId) public {
        require(!(_voterlist[msg.sender]).isRegistered, "You are not allowed to vote !");
        require(_status==WorkflowStatus.VotingSessionStarted, "Voting session does not started yet !");
        require(!(_voterlist[msg.sender]).hasVoted, "Already voted !");
        //assert(_proposalList[totalProposals].voteCount++,"Proposal does not existe !");
        //On vérifie que le parametre est bien une propostion valide
        require(_proposalId>0 && _proposalId<=totalProposals,"Proposal does not existe !");
        _proposalList[totalProposals].voteCount++;
        _voterlist[msg.sender]=Voter(true,true,totalProposals);
        emit Voted(msg.sender,_proposalId);
    }

    /*
        changeWorkflowStatus changement de statut du workflow
    */
    function changeWorkflowStatus (WorkflowStatus _wfStatus) public onlyOwner returns (WorkflowStatus){
        if (_wfStatus==WorkflowStatus.RegisteringVoters) {
            emit WorkflowStatusChange (_status, WorkflowStatus.RegisteringVoters);
            _status = WorkflowStatus.RegisteringVoters;
        } else if (_wfStatus==WorkflowStatus.ProposalsRegistrationStarted) {
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
        return _status;
    }

    /*
        getStatus retourne le statut actuel du workflow
    */
    function getStatus () public view returns (WorkflowStatus){
        return _status;
    }

    /*
        registerVoter permet l'enregistrement des votants sur liste blanche
    */
    function registerVoter() public returns (bool){
        require (_status!=WorkflowStatus.RegisteringVoters, "Registering voters is closed");
        require(!_voterlist[msg.sender].isRegistered, "This address is already in our voter list !");
        _voterlist[msg.sender].hasVoted = true;
        emit VoterRegistered(msg.sender);
        return (true);
    }

    /*
        getWinner retourne la proposition gagnate
    */
    function getWinner() public returns(uint){
        require(_status!=WorkflowStatus.VotesTallied, "Votes not tallied yet!");

        uint maxCount = 0;
        for (uint i=1; i<=totalProposals; i++) {
            if (maxCount<_proposalList[i].voteCount) {
                winningProposalId=i;
                maxCount=_proposalList[i].voteCount;
            }
        }
        return winningProposalId;
    }
}