# ranDOOM
a lua library for generating numbers with DOOM-style table algorithm

## Explanation

In original DOOM games the game uses interesting randomizing algorithm:

```C
unsigned char rndtable[256] = {
    0,   8, 109, 220, 222, 241, 149, 107,  75, 248, 254, 140,  16,  66 ,
    74,  21, 211,  47,  80, 242, 154,  27, 205, 128, 161,  89,  77,  36 ,
    ...  
    84, 118, 222, 187, 136 ,120, 163, 236, 249
};

int	rndindex = 0;

int M_Random (void)
{
    rndindex = (rndindex+1)&0xff;
    return rndtable[rndindex];
}
```

In this small snipet randomizer selects the returning value from an array of 
preset values by iterating. It's a very basic algorithm, that is good for high performance on really
weak systems. That is not the problem for modern system however.

## Why?
The downside of the algorithm is it's predictability - knowing last returned value allows user to know
what number comes next. However, it's not the problem in game design. Sometimes you need the predictability. 
At certain point in the game it would be highly likely to allow player to see and predict some situations
giving them more opportunities to use game mechanics to thier advantage instead of feeling upset about another
random encounter. RanDoom allows to control randomness in your game by creating and editing the table of numbers.
```Lua
    local t = rDm.genTable(4)
    rDm.saveTable(t, "MyRNG.lua")
```
Then by using function makeRand you can get new random function for your usage
```Lua
    local myrand = rDm.makeRand(t, 3)
```
This function will return any values from 1 to 4 in an order described by the table
```Lua
    local n = myrand()
```

RanDoom also provides an ability to create some unique abstractions
For example, in a card game called Fool you can easily store the whole deck in such an array:
```Lua
    local deck = rDm.genTable(36) -- creating a deck of card
    local spades, hearts, clubs, diamonds = 0, 1, 2, 3
```
Now comparing the value of each card would be a simple number comparison:
```Lua
    if (card1-1)//9 > (card2 - 1)//9 then
        print"Player_1 beats Player_2's card!!"
    else
        print"Player_1 takes Player_2's card!!"
end
```
The same also could be done to get suit of a card:
```Lua
    if (card-1)//9 == 1 then
        print"this card is of the hearts suit"
    end
```
We even can shuffle the deck
```Lua
    rDm.ShuffleTable(deck) -- doing some shuffling of cards
```
Additionally you can use your own rand function to shuffle
```Lua
    rDm.ShuffleTable(deck, myrand)
```
Or shuffle with deck's own rand function
```Lua
    local deckrnd = rDm.makeRand(deck, 2)
    rDm.ShuffleTable(deck, deckrnd)
```
This all creates a variety of situations for possible use. You can even manage AI
with a state machine, but from now on it's up to you!

