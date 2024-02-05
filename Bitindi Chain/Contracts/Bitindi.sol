//SPDX-License-Identifier: Unlicense
pragma solidity = 0.8.9;

/*
⠀⢴⣶⡶⣶⢶⣶⢶⡶⣶⡶⣶⢶⣶⢶⡶⣶⡶⣶⢶⣶⢶⡶⣶⢶⡶⣶⣦⣠⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠈⠙⠛⠋⠿⢾⡿⣽⡷⣟⣯⣿⢾⣻⣽⡷⣟⣯⣿⢾⣻⣽⣿⡿⣿⣗⣻⠿⢯⣿⢷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⢽⣾⣟⣯⡷⣿⣻⣽⢾⣟⣯⣷⢯⣿⡽⣯⣟⣿⣲⣬⡙⠾⣟⣷⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠚⢯⣿⢷⣻⣽⢿⣞⡿⣞⣿⣳⡿⣯⣟⣾⣽⢾⣻⣦⡈⠻⣽⣷⡀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣯⣟⡿⣾⣻⣟⡷⣿⡽⣷⣻⣽⡾⣟⣯⣷⢿⣆⠙⣾⢷⡄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣻⣧⣿⣻⢿⣧⡿⣟⣿⣼⣻⡿⣧⣟⣿⣟⡇⠸⣿⢧⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣯⣟⡿⣾⣽⣟⡷⣯⡿⣽⣷⣻⢷⣯⣿⡄⢻⡿⡇⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢾⣟⡷⣟⣾⢿⣽⣻⢷⣯⣟⡿⣞⣷⣧⢸⣿⢷⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣟⣯⣟⡿⣞⣿⣻⡾⣽⣻⣯⡷⣿⣼⣿⣻⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣾⣟⣿⣳⡿⣽⣟⡷⣯⣟⣿⣿⣞⡿⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠺⣷⢿⡽⣟⣾⢿⡽⣯⣿⣟⣾⠃⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣯⣟⣯⣿⣻⣽⣾⠃⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠿⢷⣯⣇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⢀⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢆⠀⠀⠀⠀⠀⣠⣶⡿⣿⣻⢷⣻⡾⣟⣿⣟⣯⣷⣻⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡆⠀⠀⠀⠀⠀⠀⠀⠸⣟⣿⣆⠀⠀⢠⣾⡿⣽⣻⢷⣟⡿⣯⣟⣿⣳⢿⡿⣳⣟⣧
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠾⠀⣴⡿⣯⢿⣽⢯⣿⢾⡿⣽⡾⣷⣻⣯⡗⢿⣯⣷
⠀⠀⠀⠀⠀⠀⣀⣤⡾⣿⡽⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⢿⣽⣻⣯⣟⣯⣟⣯⡿⣯⣟⣷⣟⡷⡏⢸⣷⣻
⠀⠀⣠⣴⣶⣿⣻⣽⣻⢷⣟⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⣽⣻⡾⣷⣻⣾⣻⢾⣯⣟⣷⢿⣽⢾⣻⠇⣾⣯⢿
⠀⣸⣟⣷⣻⡾⣽⣳⣿⣻⢾⣻⣇⡀⠀⠀⠀⠀⠀⠀⣼⡿⣽⣻⢷⡿⣽⡷⣯⣟⡿⣾⣽⡾⣟⣾⣟⡿⢠⣿⡽⡟
⠀⣿⢻⣾⣽⢻⣽⡟⣾⣽⡟⣯⣿⣽⣷⣤⣤⣤⣤⣾⣿⣽⢻⣽⣯⣿⣷⡟⣯⣿⣽⣷⣯⡟⣿⢳⣿⠁⣾⣷⣿⠃
⢠⣿⢯⡿⣽⣻⢯⣟⣯⣷⢿⣻⢷⣯⡷⣟⣯⣟⡿⣽⣾⣻⢯⣿⡽⣾⣳⡿⣯⣷⣟⣷⣻⣽⣯⣿⢃⣾⣟⡷⡏⠀
⠰⣟⣿⡽⣿⡽⣟⣯⢿⣞⡿⣯⣿⣞⡿⣯⣟⣾⣟⡿⣾⡽⣟⣷⢿⣯⡷⣿⣻⢾⣽⡾⣯⣷⢟⣡⣿⣳⣯⠏⠀⠀
⢸⣟⡷⣿⢯⣟⡿⣽⣯⢿⣽⣷⣻⢾⡿⣽⣻⡾⣽⣻⢷⣿⣻⡽⣟⣾⣽⡷⣿⢯⣷⣟⣯⣴⣟⣯⣷⠟⠁⠀⠀⠀
⠈⣿⣽⢯⡿⣯⣟⡿⣾⣻⢷⣯⣟⣯⡿⣯⣷⢿⣻⣽⢿⡾⣽⣻⣯⣟⣾⣽⡿⣿⢿⣻⣽⡾⡽⠟⠁⠀⠀⠀⠀⠀
⠀⠙⠯⠿⠻⠷⠻⠟⠷⠿⠻⠾⠽⠳⠿⠽⠾⠟⠿⠾⠻⠽⠟⠷⠻⠾⠻⠾⠽⠿⠋⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/// @title Bitindi Chain
contract Bitindi is ERC20Burnable {

    constructor () ERC20("Bitindi Chain", "BNI") {
        _mint(msg.sender, 50_000_000 * (10 ** decimals()));
    }
}