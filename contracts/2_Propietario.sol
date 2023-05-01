// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";


contract Propietario {

    address private propietario;

   
    event PropietarioSet(address indexed oldPropietario, address indexed newPropietario);

    
    modifier esPropietario() {
        
        require(msg.sender == propietario, "La persona que llama no es el propietario");
        _;
    }

  
    constructor() {
        console.log("Contrato de propietario desplegado por: ", msg.sender);
        propietario = msg.sender; 
        emit PropietarioSet(address(0), propietario);
    }

    
    function changePropietario(address newPropietario) public esPropietario {
        emit PropietarioSet(propietario, newPropietario);
        propietario = newPropietario;
    }


    function getPropietario() external view returns (address) {
        return propietario;
    }
} 