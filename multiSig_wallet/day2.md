### Assignment 1

## Where are your structs, mappings and arrays stored?
In Solidity, the storage location for structs, mappings, and arrays depends on how and where they are declared and used, primarily falling into storage, memory, or calldata.

## struct (Structures) 
# How it's stored: 
- A struct is a template for a custom data type. When a state variable of a struct type is created, its members are stored sequentially in storage, in the order they are defined . 

- Packing for Efficiency: The EVM will try to pack multiple struct members into a single 32-byte storage slot if they are small enough . For example, a struct with two uint128 numbers will store both in one slot. This is a key gas optimization technique!

## mapping
# How it's stored: 
- Mappings are designed for efficiency. The mapping itself only occupies a single, empty storage slot (at position p) to mark its existence .

- Where's the data? The actual key-value pairs are scattered throughout storage. The storage slot for a specific key k is calculated using the keccak256 hash function: keccak256(h(k) . p) . This hashing ensures that keys are spread out randomly, avoiding collisions and allowing for constant-time lookups.

## array
- Arrays are stored differently based on whether they have a fixed or dynamic size .

- Fixed-Size Arrays: Elements are stored contiguously (one right after the other) starting from the array's assigned storage slot . A uint[3] array at slot 0 will have its elements in slots 0, 1, and 2.

- Dynamic Arrays (uint[] x): These work in two parts :

The Array's Slot (at position p): This slot stores the length of the array.
The Data: The actual array elements start at a storage location computed as keccak256(p). They are then stored contiguously from that point onward, just like a fixed-size array.

## Q2. How they behave when executed or called.
When a Solidity function is executed or called, structs, arrays, and mappings behave differently based on where they live and how they are referenced. The key idea to keep in mind is that Solidity separates persistent blockchain state from temporary execution data. Only data stored in storage survives after a function call finishes; everything else is discarded.

- Structs behave like records that can either be referenced directly or copied. If a struct is a state variable, it lives in storage, so when a function accesses it using a storage reference, any modification is written directly to the blockchain and remains after the transaction completes. This is how contracts update state. If, instead, the struct is copied into memory, Solidity creates a temporary version of the struct for the duration of the function call. Changes made to this memory copy do not affect the original stored struct and are lost as soon as execution ends. Memory structs are useful for reading, processing, or returning data, but not for persisting changes.

- Arrays follow a similar pattern but with additional cost considerations. A state array exists in storage, so operations like indexing, push, or pop directly modify on-chain data and permanently change the contract’s state, which costs gas proportional to the work done. When an array is placed in memory, Solidity copies the entire array from storage into a temporary area. This copy can be expensive for large arrays, but modifications to it are cheap and temporary. Arrays passed in calldata are even cheaper because they are read directly from the transaction input without copying, but they are read-only and disappear after the function call.

- Mappings are special in how they behave during execution. A mapping always lives in storage and cannot exist in memory or calldata. When a function reads or writes to a mapping, Solidity computes a storage slot using the key and accesses that location directly. There is no copying, no iteration, and no concept of length. If a value is written to a mapping during execution, the change persists on-chain; if not, the mapping remains unchanged.

During the lifecycle of a function call, Solidity loads function inputs into calldata, allocates temporary variables in memory, and resolves references to storage. The function executes its logic, and if it completes successfully, any writes to storage are committed to the blockchain. Once execution finishes, memory and calldata are wiped, leaving only the updated storage state. This is why understanding data location is critical: it determines whether your changes are permanent or temporary.

## Q3.
## Why don't you need to specify memory or storage with mappings?
mappings are permanently tied to storage because of how they're implemented at the EVM level, so the location is implicit and doesn't need to be specified!


