// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract TryInlineAssembly {
    constructor() {}

    function useStorage2() public returns (uint256 v1, uint256 v2, uint256 v3){
        assembly {
            sstore(0x0, 100)
            v1 := sload(0x0)
            // non-zero to non-zero
            sstore(0x0, 10)
            v2 := sload(0x0)
            // non-zero to non-zero
            sstore(0x0, 200)
            v3 := sload(0x0)
        }
    }
    function useStorage1() public returns (uint256 v1, uint256 v2, uint256 v3){
        assembly {
            sstore(0x0, 100)
            v1 := sload(0x0)
            // non-zero to zero
            sstore(0x0, 0)
            v2 := sload(0x0)
            // zero to non-zero
            sstore(0x0, 200)
            v3 := sload(0x0)
        }
    }

    function useMemory(uint a) public pure returns (uint256){
        uint[] memory array_num1 = new uint[](a);
        uint res = 0;

        assembly {
            // next free memory pointer
            res := mload(0x40)
        }

        // The bigger the value of a, the bigger the value of res
        return res;
    }

    function addition(uint x, uint y) public pure returns (uint256){
        assembly {
            let result := add(x, y)
            mstore(0x0, result)
            return (0x0, 32)
        }
    }
}
