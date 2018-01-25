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
  event LogWaterTree(uint256 indexed treeId, address indexed owner, uint256 date);

  // Get the tree information given the id
  mapping(uint256 => Tree) public treeDetails;
  // A mapping with all the tree IDs of that owner
  mapping(address => uint256[]) public ownerTreesIds;

  struct Tree {
    uint256 ID;
    address owner;
    uint256 purchaseDate;
    uint256 treePower; // How much ether that tree is generating from 0 to 100 where 100 is the total power combined of all the trees
    uint256 salePrice;
    uint256 timesExchanged;
    uint256[] waterTreeDates;
    bool onSale;
  }

  uint256[] public trees;
  uint256[] public treesOnSale;
  uint256 public lastTreeId;
  address public defaultTreesOwner = msg.sender;
  uint256 public defaultTreesPower = 10; // 10% of the total power
  uint256 public defaultSalePrice = 1 ether;

  // This will be called automatically by the server
  // The contract itself will hold the initial trees
  function generateTree() public onlyAdmin {
    uint256 newTreeId = lastTreeId + 1;
    lastTreeId += 1;
    uint256[] memory emptyArray;
    Tree memory newTree = Tree(newTreeId, defaultTreesOwner, now, defaultTreesPower, defaultSalePrice, 0, emptyArray, true);

    // Update the treeBalances and treeOwner mappings
    // We add the tree to the same array position to find it easier
    ownerTreesIds[defaultTreesOwner].push(newTreeId);
    treeDetails[newTreeId] = newTree;
    treesOnSale.push(newTreeId);
  }

  // This is payable, the user will send the payment here
  // We delete the tree from the owner first and we add that to the receiver
  // When you sell you're actually putting the tree on the market, not losing it yet
  function putTreeOnSale(uint256 _treeNumber, uint256 _salePrice) public {
    require(msg.sender == treeDetails[_treeNumber].owner);
    require(!treeDetails[_treeNumber].onSale);
    require(_salePrice > 0);

    treesOnSale.push(_treeNumber);
    treeDetails[_treeNumber].salePrice = _salePrice;
    treeDetails[_treeNumber].onSale = true;
  }

  function buyTree(uint256 _treeNumber, address _originalOwner) public payable {
    require(msg.sender != treeDetails[_treeNumber].owner);
    require(treeDetails[_treeNumber].onSale);
    require(msg.value >= treeDetails[_treeNumber].salePrice);

    address newOwner = msg.sender;

    // Move id from old to new owner
    // Find the tree of that user and delete it
    for(uint256 i = 0; i < ownerTreesIds[_originalOwner].length; i++) {
        if(ownerTreesIds[_originalOwner][i] == _treeNumber) delete ownerTreesIds[_originalOwner][i];
    }

    // Remove the tree from the array of trees on sale
    for(uint256 a = 0; a < treesOnSale.length; a++) {
        if(treesOnSale[a] == _treeNumber) {
            delete treesOnSale[a];
            break;
        }
    }

    ownerTreesIds[newOwner].push(_treeNumber);
    treeDetails[_treeNumber].owner = newOwner;
    treeDetails[_treeNumber].onSale = false;

    if(treeDetails[_treeNumber].timesExchanged == 0) {
        // Reward the owner for the initial trees as a way of monetization. Keep half for the treasury
        owner.transfer(msg.value / 2);
    }

    treeDetails[_treeNumber].timesExchanged += 1;
  }

  function cancelTreeSell(uint256 _treeId) public {
    require(msg.sender == treeDetails[_treeId].owner);
    require(treeDetails[_treeId].onSale);

    // Remove the tree from the array of trees on sale
    for(uint256 a = 0; a < treesOnSale.length; a++) {
        if(treesOnSale[a] == _treeId) {
            delete treesOnSale[a];
            break;
        }
    }
    treeDetails[_treeId].onSale = false;
  }

  function waterTree(uint256 _treeId) public {
    require(_treeId > 0);

    treeDetails[_treeId].waterTreeDates.push(now);
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
