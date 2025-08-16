// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TestDao {
    address[] admins;
    address owner;

    enum Status {
        PENDING,
        PASSED,
        REJECTED
    }

    constructor() {
        owner = msg.sender;
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
        if (joinDAO[msg.sender] == false) {
            joinDAO[msg.sender] = true;
        }

        _;
    }

    modifier onlyOnwer() {
        require(owner == msg.sender, "YOU CANT ADD ADMIN");
        _;
    }

    function add_admin(address _admin) external onlyOnwer {
        admins.push(_admin);
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
