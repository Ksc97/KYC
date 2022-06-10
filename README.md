# KYC


Instructions to Start the BlockChain And Deploying the smart contract

    Open two sessions, one for Geth and another for truffle commands.
    On Geth session create a directory , and create a genesis.json file which will be our first block creation and run the following command : geth --datadir ./datadir init genesis.json

After successful the log looks like below

    Then we need to enter into into geth console with the below command geth --networkid 73829 --datadir datadir --http --http ports 30303 --allow-insecure-unlock console

After successful execution it looks as below

    We need to create the account with the following command personal.newAccount()

After successful execution it looks as below

    Unlock it with the password personal.unlockAccount(eth.accounts[0],"password")

After successful execution it looks as below

    Start the miner to have account balance miner.start(1)

After successful execution it looks as below

    After few blocks added and generated the ethash verification code, stop the mining miner.stop()

    Go to other session and create new folder as KYC-SC and execute ‘truffle init’ command. Which will create below set of folders and file. contracts migrations test truffle-config.js

    Copy KYC.sol file under contracts and proceed with next step.

    Execute the below command to compile contract truffle compile

After successful execution it looks as below

    To deploy deploy the contract on blockchain use the below command truffle migrate --network geth

After successful execution it looks as below on the current session.

    On Geth seesion after deploying the contract is as below. We can find the message as “Submitted contract creation”.

    Exit from the geth session by executing “exit” command


