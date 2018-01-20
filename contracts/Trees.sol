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
  // What address has what trees
  mapping(address => Tree[]) public treeBalances;
  // Who owns that tree ID
  mapping(uint256 => address) public treeOwner;

  struct Tree {
    uint256 ID;
    address owner;
    uint256 treeValue;
    uint256 treePower; // How much ether that tree is generating from 0 to 100 where 100 is the total power combined of all the trees
    bool onSale;
  }

  uint256[] public trees;
  uint256[] public treesOnSale;
  uint256 public lastTreeId;
  address public defaultTreesOwner = owner;
  uint256 public defaultTreesValue = 1; // 1 ether is the default value
  uint256 public defaultTreesPower = 10; // 10% of the total power

  // To get the tree information of a specific tree ID
  function getTreeById(uint256 _id) public returns(Tree) {
    return treeBalances[treeOwner[_id]][_id];
  }

  function getTreesByAddress(address _user) public returns(Tree[]) {
    return treeBalances[_user];
  }

  // To get all the tree IDs of one user
  function getTreeIds(address _account) public returns(Tree[]) {
    if(_account != address(0)) return treeBalances[_account];
    else return treeBalances[msg.sender];
  }

  // This will be called automatically by the server
  // The contract itself will hold the initial trees
  function generateTree() public onlyAdmin {
    uint256 newTreeId = lastTreeId + 1;
    lastTreeId += 1;
    Tree memory newTree = Tree(newTreeId, defaultTreesOwner, defaultTreesValue, defaultTreesPower, true);

    // Update the treeBalances and treeOwner mappings
    // We add the tree to the same array position to find it easier
    treeOwner[newTreeId] = defaultTreesOwner;
    treeBalances[defaultTreesOwner][newTreeId] = newTree;
  }

  // This is payable, the user will send the payment here
  // We delete the tree from the owner first and we add that to the receiver
  // When you sell you're actually putting the tree on the market, not losing it yet
  function putTreeOnSale(uint256 _treeNumber, address _receiver) public payable {
    require(treesOnSale[_treeNumber] != 0);
    treesOnSale[_treeNumber] = _treeNumber;
    treeBalances[_receiver][_treeNumber].onSale = true;
  }

  function buyTree(uint256 _treeNumber, address _originalOwner) public payable {
    require(treesOnSale[_treeNumber] != 0);
    address newOwner = msg.sender;
    uint256 treeValueCopy = treeBalances[_originalOwner][_treeNumber].treeValue;
    uint256 treePowerCopy = treeBalances[_originalOwner][_treeNumber].treePower;
    Tree memory treeCopy = Tree(_treeNumber, _originalOwner, treeValueCopy, treePowerCopy, false);

    delete treeBalances[_originalOwner][_treeNumber];

    // Updated the 2 mappings
    treeBalances[newOwner][_treeNumber] = treeCopy;
    treeOwner[_treeNumber] = newOwner;
  }
}
