// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "../contracts/3_Votacion.sol";

contract BallotTest {

    bytes32[] propuestaNames;

    Votacion votacionToTest;
    function beforeAll () public {
        propuestaNames.push(bytes32("candidate1"));
        votacionToTest = new Votacion(propuestaNames);
    }

    function checkWinningPropuesta () public {
        console.log("Running checkWinningProposal");
        votacionToTest.vote(0);
        Assert.equal(votacionToTest.winningPropuesta(), uint(0), "proposal at index 0 should be the winning proposal");
        Assert.equal(votacionToTest.winnerNombre(), bytes32("candidate1"), "candidate1 should be the winner name");
    }

    function checkWinninPropuestaWithReturnValue () public view returns (bool) {
        return votacionToTest.winningPropuesta() == 0;
    }
}