// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Immutable file drive
contract FileDrive {
    using Counters for Counters.Counter;
 
    Counters.Counter private s_documentIds;

    enum DocumentType {
        Word,
        SpeadSheets,
        PDF,
        Audio,
        Video,
        Animation
    }

    struct Document {
     string       name;
     DocumentType docType;
     string       overview;
     string       hashValue;
     address      owner;
    }
 
    mapping(uint256 => Document) private s_documents;
    mapping(address => Document[]) private s_userDocuments;
 
    event NewDocument(uint indexed documentId,string name, DocumentType docType);

    constructor() {
        // initialization
    }

    function createDocument(string memory name,DocumentType docType,string memory overview, string memory hashValue) public payable {
      
      s_documentIds.increment();
      uint256 newDocumentId = s_documentIds.current();
    
      Document memory newDoc = Document(name, docType, overview, hashValue, msg.sender);

      // Store it in the collection.
      s_documents[newDocumentId] = newDoc;

      // Store at user level. 
      Document[] storage userDocs = s_userDocuments[msg.sender];
      
      userDocs.push(newDoc);
       
      emit NewDocument(newDocumentId, name,docType);
    }

    function getMyDocument() public view returns(Document[] memory){
        return s_userDocuments[msg.sender];
    }

    function getUserDocuments(address userAddress) public view returns(Document[] memory){
       return s_userDocuments[userAddress];
    }
}