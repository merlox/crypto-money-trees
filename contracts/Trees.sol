pragma solidity ^0.4.18;

contract Admin {
  address public owner;
  mapping(address => bool) public isAdmin;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyAdmin() {
    require(isAdmin[msg.sender]);
    _;
  }

  function Admin() public {
    owner = msg.sender;
    addAdmin(owner);
  }

  function addAdmin(address _admin) public onlyOwner {
    isAdmin[_admin] = true;
  }

  function removeAdmin(address _admin) public onlyOwner {
    isAdmin[_admin] = false;
  }
}

// To add a tree do the following:
// - Create a new Tree with the ID, owner, treeValue and power to generate fruits
// - Update the treeBalances and treeOwner mappings
contract Trees is Admin {
  // Get the tree information given the id
  mapping(uint256 => Tree) public treeDetails;
  // A mapping with all the tree IDs of that owner
  mapping(address => uint256[]) public ownerTreesIds;

  struct Tree {
    uint256 ID;
    address owner;
    uint256 purchaseDate;
    uint256 treePower; // How much ether that tree is generating from 0 to 100 where 100 is the total power combined of all the trees
    bool onSale;
  }

  uint256[] public trees;
  uint256[] public treesOnSale;
  uint256 public lastTreeId;
  address public defaultTreesOwner = msg.sender;
  uint256 public defaultTreesPower = 10; // 10% of the total power

  // This will be called automatically by the server
  // The contract itself will hold the initial trees
  function generateTree() public onlyAdmin {
    uint256 newTreeId = lastTreeId + 1;
    lastTreeId += 1;
    Tree memory newTree = Tree(newTreeId, defaultTreesOwner, now, defaultTreesPower, true);

    // Update the treeBalances and treeOwner mappings
    // We add the tree to the same array position to find it easier
    ownerTreesIds[defaultTreesOwner].push(newTreeId);
    treeDetails[newTreeId] = newTree;
    treesOnSale.push(newTreeId);
  }

  // This is payable, the user will send the payment here
  // We delete the tree from the owner first and we add that to the receiver
  // When you sell you're actually putting the tree on the market, not losing it yet
  function putTreeOnSale(uint256 _treeNumber) public {
    require(msg.sender == treeDetails[_treeNumber].owner);
    require(!treeDetails[_treeNumber].onSale);

    treesOnSale.push(_treeNumber);
    treeDetails[_treeNumber].onSale = true;
  }

  function buyTree(uint256 _treeNumber, address _originalOwner) public payable {
    require(msg.sender != treeDetails[_treeNumber].owner);
    require(treeDetails[_treeNumber].onSale);

    address newOwner = msg.sender;

    // Move id from old to new owner
    // Find the tree of that user and delete it
    for(uint256 i = 0; i < ownerTreesIds[_originalOwner].length; i++) {
        uint256 treeId = ownerTreesIds[_originalOwner][i];
        if(treeId == _treeNumber) delete ownerTreesIds[_originalOwner][i];
    }

    ownerTreesIds[newOwner].push(_treeNumber);
    treeDetails[_treeNumber].owner = newOwner;
    treeDetails[_treeNumber].onSale = false;
  }

  // To get all the tree IDs of one user
  function getTreeIds(address _account) public constant returns(uint256[]) {
    if(_account != address(0)) return ownerTreesIds[_account];
    else return ownerTreesIds[msg.sender];
  }

  // To get all the trees on sale
  function getTreesOnSale() public constant returns(uint256[]) {
      return treesOnSale;
  }
}
