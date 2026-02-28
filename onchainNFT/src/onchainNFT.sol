// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/utils/Base64.sol'; //used for encoding svg to base64
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract lymarhNFT is ERC721, Ownable {
using Strings for uint256;
uint256 private _tokenIdCounter;
error TokenNotFound();

constructor() ERC721('lymarhNFT', 'LFT') Ownable(msg.sender) {}

function tokenURI(uint256 tokenId) public view override returns (string memory) {
if (ownerOf(tokenId) == address(0)) revert TokenNotFound();
string memory name = string(abi.encodePacked('lymarhNFT #', tokenId.toString()));
string memory description = 'This is an on-chain NFT';
string memory image = generateBase64Image();
string memory json = string(
abi.encodePacked(
'{"name":"',
name,                                                             
'",',
'"description":"',
description,
'",',
'"image":"',
image,
'"}'
)
);
return string(abi.encodePacked('data:application/json;base64,', Base64.encode(bytes(json))));
}


function generateBase64Image() internal pure returns (string memory) {
string memory svg ='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">'
    '<defs>'
    '<linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">'
    '<stop offset="0%" stop-color="#1a2a6c"/>'
    '<stop offset="50%" stop-color="#b21f1f"/>'
    '<stop offset="100%" stop-color="#fdbb2d"/>'
    '</linearGradient>'
    '<filter id="glow" x="-20%" y="-20%" width="140%" height="140%">'
    '<feGaussianBlur stdDeviation="5" result="blur"/>'
    '<feComposite in="SourceGraphic" in2="blur" operator="over"/>'
    '</filter>'
    '</defs>'
    '<rect width="100%" height="100%" rx="15" ry="15" fill="url(#bgGradient)"/>'
    // Headwrap (Hijab) Base - Main Shape
    '<path d="M160 220 Q160 100 250 100 Q340 100 340 220 L340 400 Q250 460 160 400 Z" fill="#000000" stroke="#ffffff" stroke-width="2"/>'
    // Face
    '<ellipse cx="250" cy="240" rx="80" ry="100" fill="#FFDBAC" stroke="#000000" stroke-width="1"/>'
    // Glasses Frames
    '<g stroke="#000000" stroke-width="4" fill="none">'
    '<ellipse cx="215" cy="230" rx="30" ry="25" stroke="#ffffff" />'
    '<ellipse cx="285" cy="230" rx="30" ry="25" stroke="#ffffff" />'
    '<path d="M245 230 Q250 225 255 230" stroke="#ffffff" />'
    '</g>'
    // Eyes (Pupils)
    '<circle cx="215" cy="230" r="4" fill="#000000"/>'
    '<circle cx="285" cy="230" r="4" fill="#000000"/>'
    // Smile
    '<path d="M225 300 Q250 320 275 300" fill="none" stroke="#000000" stroke-width="2" stroke-linecap="round"/>'
    // Text Label
    '<text x="250" y="450" font-family="Impact, sans-serif" font-size="40" text-anchor="middle" fill="#ffffff" filter="url(#glow)">Lymarh</text>'
    // Decorative Corner Elements
    '<path d="M100 50 L120 70 L100 90 L80 70 Z" fill="#ffcc00" stroke="#ffffff" stroke-width="1"/>'
    '<path d="M400 50 L420 70 L400 90 L380 70 Z" fill="#ffcc00" stroke="#ffffff" stroke-width="1"/>'
    // Header Bar
    '<rect x="150" y="50" width="200" height="40" rx="10" ry="10" fill="rgba(255,255,255,0.2)" stroke="#ffffff" stroke-width="1"/>'
    '<text x="250" y="77" font-family="Arial, sans-serif" font-size="20" text-anchor="middle" fill="#ffffff">Lymarh</text>'
    '</svg>';
return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(svg))));
}

function mint() public {
_tokenIdCounter += 1;
_safeMint(msg.sender, _tokenIdCounter);
}

function burn(uint256 tokenId) public onlyOwner() {
_burn(tokenId);
}
}