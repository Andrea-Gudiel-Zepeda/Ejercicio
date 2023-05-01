// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Votacion {

    struct Votar {
        uint peso; 
        bool votado;  
        address delegado; 
        uint voto;  
    }

    struct Propuesta {
        bytes32 name;   
        uint votoCount; 
    }

    address public chairperson;

    mapping(address => Votar) public votantes;

    Propuesta[] public propuestas;

 
    constructor(bytes32[] memory propuestaNames) {
        chairperson = msg.sender;
        votantes[chairperson].peso = 1;

        for (uint i = 0; i < propuestaNames.length; i++) {
            propuestas.push(Propuesta({
                name: propuestaNames[i],
                votoCount: 0
            }));
        }
    }

    function giveRightToVoto(address votante) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !votantes[votante].votado,
            "The voter already voted."
        );
        require(votantes[votante].peso == 0);
        votantes[votante].peso = 1;
    }

 
    function delegate(address to) public {
        Votar storage sender = votantes[msg.sender];
        require(!sender.votado, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (votantes[to].delegado != address(0)) {
            to = votantes[to].delegado;

            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.votado = true;
        sender.delegado = to;
        Votar storage delegate_ = votantes[to];
        if (delegate_.votado) {
            // If the delegate already voted,
            // directly add to the number of votes
            propuestas[delegate_.voto].votoCount += sender.peso;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.peso += sender.peso;
        }
    }

 
    function vote(uint propuesta) public {
        Votar storage sender = votantes[msg.sender];
        require(sender.peso != 0, "Has no right to vote");
        require(!sender.votado, "Already voted.");
        sender.votado = true;
        sender.voto = propuesta;

        propuestas[propuesta].votoCount += sender.peso;
    }


    function winningPropuesta() public view
            returns (uint winningPropuesta_)
    {
        uint winningVotoCount = 0;
        for (uint p = 0; p < propuestas.length; p++) {
            if (propuestas[p].votoCount > winningVotoCount) {
                winningVotoCount = propuestas[p].votoCount;
                winningPropuesta_ = p;
            }
        }
    }

  
    function winnerNombre() public view
            returns (bytes32 winnerNombre_)
    {
        winnerNombre_ = propuestas[winningPropuesta()].name;
    }
}