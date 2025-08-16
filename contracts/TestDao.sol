// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TestDao {
    address[] admins;

    enum Status {
        PENDING,
        PASSED,
        REJECTED
    }

    mapping(address => bool) approvals;
    address[] approvalsPassedAddress;
    address[] approvalsFailedAddress;
    mapping(address => bool) joinDAO;

    struct Proposal {
        uint256 id;
        string name;
        string details;
        Status status;
    }

    Proposal[] allProposals;
    Proposal[] passedProposal;
    Proposal[] failedProposal;

    function create_proposal(uint256 _id, string memory _name, string memory _details) external hasJoinedDAO {
        Proposal memory new_proposal_ = Proposal(_id, _name, _details, Status.PENDING);
        allProposals.push(new_proposal_);
    }

    function join_dao() external hasJoinedDAO {
        joinDAO[msg.sender] = true;
    }

    modifier hasJoinedDAO() {
        require(joinDAO[msg.sender] == true, "You need to join the DAO first");

        _;
    }

    function approveProposal() external {
        if (allProposals.length <= 0) {
            revert("YOU NEED TO ADD A PROPOSAL");
        }

        for (uint256 i; i < admins.length; i++) {
            if (admins[i] == msg.sender) {
                approvals[msg.sender] = true;
                approvalsPassedAddress.push(msg.sender);
            }
        }
    }

    function dismissProposal() external {
        if (allProposals.length <= 0) {
            revert("YOU NEED TO ADD A PROPOSAL");
        }
        for (uint256 i; i < admins.length; i++) {
            if (admins[i] == msg.sender) {
                approvals[msg.sender] = false;
                approvalsFailedAddress.push(msg.sender);
            }
        }
    }

    function checkProposalStatus(uint256 _index) external returns (string memory _proposalStatus) {
        for (uint256 i; i < admins.length; i++) {
            if (approvals[msg.sender] == true) {
                if (approvalsPassedAddress.length >= 2) {
                    allProposals[_index].status = Status.PASSED;
                }

                _proposalStatus = "PASSED";
            }

            if (approvals[msg.sender] == false) {
                if (approvalsFailedAddress.length >= 2) {
                    allProposals[_index].status = Status.REJECTED;
                }

                _proposalStatus = "FAILED";
            }
        }
    }
}
