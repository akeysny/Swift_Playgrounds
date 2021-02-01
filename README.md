# Swift_Playgrounds

Here is where we will review blockchain using Swift

- [x] We had generated keys for blocks
- [x] Initialized blockchain


We have to find this magic hash, that's our goal, so we will write proof of work algorithm

App Walkthrough GIF

<img src="http://g.recordit.co/orHmHCBJKd.gif" width=250><br>

If we attempted to find a hash let say that starts with 6-7 zeros, it may have taken us a very, very long time

<img src="http://g.recordit.co/TXm3LFkDfK.gif" width=250><br>

Now, we have to do the search to create a normal block and the other one to create a genesis block. We create a hash that consists of two 0s. 

Above the line calculations are done for the genesis block and notice that the last one contains of 2 0s, meaning it was able to create a hash and return it to you.

Calculations that are done below the horizontal line are for the block #1 that contains all the transactions, and you will see at the end it was able to create that particular hash that begins with 2 0s. The genesis block is the index 0 block and it is created by the block chain itself and it consists of the rewards, bitcoins.

This is the overview of how the blockchain actually works.

<img src="http://g.recordit.co/234lJbcbz0.gif" width=250><br>

Implementing Smart Contracts

<img src="http://g.recordit.co/FfFND3VEPL.gif" width=250><br>

