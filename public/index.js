const express = require('express');
const router = express.Router();

router.get('/', function(req, res, next) {
  res.render('index', { title: 'Interact with Metamask in Your Web Application' });
});

module.exports = router;

// Initialize the page elements for interaction
const connectButton = document.querySelector('.connectButton');
const displayUser = document.querySelector('.displayUser');
const displayNetwork = document.querySelector('.displayNetwork');

// Initialize the active user and network
let activeUser;
let activeNetwork;

// Update the user and network when user clicks on the button
connectButton.addEventListener('click', () => {
  fetchUserData();
  fetchNetwork();
});

// Fetch the user account using MetaMask
async function fetchUserData() {
  const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  if (accounts.length === 0) {
    console.log('Please connect to MetaMask.');
  } else if (accounts[0] !== activeUser) {
    activeUser = accounts[0];
  }
  displayUser.innerHTML = activeUser;
}

// Fetch the connected network ID
async function fetchNetwork() {
  activeNetwork = await ethereum.request({ method: 'eth_chainId' });
  displayNetwork.innerHTML = activeNetwork;
}

// Update the selected user and network ID on change
ethereum.on('accountsChanged', fetchUserData);
ethereum.on('chainChanged', fetchNetwork);
