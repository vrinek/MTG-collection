# Sample Workflows

## Entering a whole collection

After you enter a card, it displays the next 10 cards (number and name). This makes it easy to enter cards in card number order order.

    $ bundler exec ruby mtg.rb
    set: NONE > m14
    set: Magic 2014 Core Set > 7
    set: Magic 2014 Core Set > 12
    set: Magic 2014 Core Set > 15 3
    set: Magic 2014 Core Set > 20 f
    # enter more card numbers
    set: Magic 2014 Core Set > 185 2
    set: Magic 2014 Core Set > 191
    set: Magic 2014 Core Set > 192 3
    set: Magic 2014 Core Set > cards m14
    # displays all cards entered in M14 set

## Entering booster packs

This workflow is a little noisy because of the "10 next card display" feature.

    $ bundler exec ruby mtg.rb
    set: NONE > m14
    set: Magic 2014 Core Set > 56
    set: Magic 2014 Core Set > 12
    set: Magic 2014 Core Set > 204
    # enter more card numbers
    set: Magic 2014 Core Set > 185
    set: Magic 2014 Core Set > 125
    set: Magic 2014 Core Set > 8
    set: Magic 2014 Core Set > cards m14
    # displays all cards entered in M14 set

## Entering decks

You can enter cards with their set code. This is useful for entering random cards or decks. As with the booster entry, this is also noisy.

NOTE: as of now there is no functionality to group the cards into a deck. Therefor, the entered cards will just become part of the collection.

    $ bundler exec ruby mtg.rb
    set: NONE > m14 56
    set: Magic 2014 Core Set > dgm 21 3
    set: Dragon's Maze > rtr 25 2
    # enter more cards
