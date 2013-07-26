# Sample Workflows

## Entering a whole collection

After you enter a card, it displays the next 10 cards (number and name).
This makes it easy to enter cards in card number order order.
In case you have changed the default verbosity, type in "verbose" to reset it.

First enter the code of the set (type "sets" to see all codes).
Then start entering the card numbers followed by the amount you have (default is 1).
Optionally, follow the amount with an "f" to indicate that the card is foil.

    $ bundler exec ruby mtg.rb
    set: NONE > m14
    set: Magic 2014 Core Set > 7
    {
           :number => 7,
             :name => "Banisher Priest",
             :type => "Creature — Human Cleric 2/2",
        :mana_cost => "1WW",
           :rarity => "Uncommon",
           :artist => "Willian Murai",
             :sets => " Magic 2014 Core Set",
             :side => nil
    }
      8 - Blessing
      9 - Bonescythe Sliver
     10 - Brave the Elements
     11 - Capashen Knight
     12 - Celestial Flare
     13 - Charging Griffin
     14 - Congregate
     15 - Dawnstrike Paladin
     16 - Devout Invocation
     17 - Divine Favor
    set: Magic 2014 Core Set > 12
    {
           :number => 12,
             :name => "Celestial Flare",
             :type => "Instant",
        :mana_cost => "WW",
           :rarity => "Common",
           :artist => "Clint Cearley",
             :sets => " Magic 2014 Core Set",
             :side => nil
    }
     13 - Charging Griffin
     14 - Congregate
     15 - Dawnstrike Paladin
     16 - Devout Invocation
     17 - Divine Favor
     18 - Fiendslayer Paladin
     19 - Fortify
     20 - Griffin Sentinel
     21 - Hive Stirrings
     22 - Imposing Sovereign
    set: Magic 2014 Core Set >
    # keep entering card numbers

## Entering booster packs

This workflow is a little noisy because of the "10 next card display" feature.
To eliminate the noise, turn verbosity to "quiet" by typing it as a command.

Follow the same procedure as for entering a collection.
The only difference here is that you will not need to enter amounts and will not need to change the set.

    $ bundler exec ruby mtg.rb
    set: NONE > quiet
    set: NONE > m14
    Verbosity is: quiet
    set: Magic 2014 Core Set > 56
    Magic 2014 Core Set - Frost Breath (Common)
    set: Magic 2014 Core Set > 12
    Magic 2014 Core Set - Celestial Flare (Common)
    set: Magic 2014 Core Set > 125
    Magic 2014 Core Set - Act of Treason (Common)
    # enter more cards
    set: Magic 2014 Core Set > 204
    Magic 2014 Core Set - Accorder's Shield (Uncommon)
    set: Magic 2014 Core Set > 8
    Magic 2014 Core Set - Blessing (Uncommon)
    set: Magic 2014 Core Set > 185
    Magic 2014 Core Set - Megantic Sliver (Rare)
    set: Magic 2014 Core Set > cards m14
    # displays all cards entered in M14 set

## Entering decks

You can enter cards with their set code.

This is useful for entering random cards or decks.
As with the booster entry, this is also noisy and the "quiet" command is recommended.

NOTE: as of now there is no functionality to group the cards into a deck. Therefor, the entered cards will just become part of the collection.

    $ bundler exec ruby mtg.rb
    set: NONE > quiet
    Verbosity is: quiet
    set: NONE > m14 56
    Magic 2014 Core Set - Frost Breath (Common)
    set: Magic 2014 Core Set > dgm 21 3
    Dragon's Maze - Bane Alley Blackguard (Common)
    set: Dragon's Maze > rtr 25 2
    Return to Ravnica - Sunspire Griffin (Common)
    # keep entering cards
