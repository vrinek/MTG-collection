# MTG collection

A script to manage Magic the Gathering cards in a collection file for book keeping reasons. The aim is to be able to quickly add a lot of cards and help in deck-building.

This script is mostly targeted at developers and other people that feel comfortable with the command line.

## Dependencies

This script is developed with Ruby 2.0 in mind.

Its dependencies are:

* awesome_print
* nokogiri

## Usage

`git clone` or download the code and `cd` to that directory.

`bundle install` to install its dependencies.

`bundle exec ruby mtg.rb` to start the program. This should behave like a shell, you type in commands, press enter and stuff happens. Type "?" to get some help.

The prompt looks like this:

    set: Dragon's Maze >

### Sample usage

    $ ruby mtg.rb
    set: NONE > dgm 12
    # adds "Hidden Strings" to your collection
    set: Dragon's Maze > 14 2
    # adds 2 "Mindstatic" to your collection
    set: Dragon's Maze > 19
    # adds "Uncovered Clues" to your collection
    set: Dragon's Maze > 25 4
    # adds 4 "Hired Torturer" to your collection
    set: Dragon's Maze > tr
    # switches to "Torment"
    set: Torment > 4
    # adds "Equal Treatment" to your collection
    set: Torment > 14f
    # adds a foil "Reborn Hero" to your collection
    set: Torment > cards
    # displays your collection so far
    Current collection:
    Dragon's Maze
       8 Common
    Torment
       1 Uncommon
    foils
       1 Rare
    set: Torment >

For more sample usage, see: doc/Sample_Workflows.md

## Current features

* Supports core sets up to "Magic 2013"
* Supports expansions up to "Dragon's Maze"
* Add cards by number to collection
* Persist cards collection to a JSON file
* Remove cards from collection
* Display cards for import in deckbox.org
* Keep time of when a card was added to the collection
* Export CSV for better import into deckbox.org

## Future features

* Support more card atributes (language, promo, signed, textless, condition)
* Card prices
* Statistics on collection
* Gather cards in groups/decks
* Full text search on cards

## Features that will probably not happen

* Native UI (even if I try, I will spend too much time and produce crappy results)
* Playtesting/Drafting (this is only for book keeping)

## Nice to have features

### Web interface

I am a web developer and having sortable and filterable tables of my cards sounds like a better idea that simply a command line interface. This does not mean that I intend to abandon the CLI but having a web interface and your collection on the cloud means that you don't need your laptop wherever you are. I will also try and make this fault tolerant to server outages (in other words, have your collection both at your hard drive and the cloud).

### Friends & alerts

You have a bunch of friends and you want a few rare cards. Add your friends and alerts for your cards and when your friends add those cards to their collections, you receive a notification so you can trade as soon as possible.

### Mobile version

This will probably branch out into a couple of apps for iOS/Android (and maybe Windows Mobile as well). I feel that it is very helpful to have your whole collection in your hands at any time.

### Pattern recognition for cards input

I want to be able to snap a photo of a bunch of cards on a table and the program to automatically recognize them and add them to my collection. Simple scenario: open a booster pack, arrange the cards on the table, snap a photo (within the mobile app), get a list of the cards to add to your collection.

## Wanna help?

Fork, edit, make a pull request.

This project is still quite young but for the future keep in mind the following:

* Ruby is the language
* YARD is/will be the documentation syntax
* JSON is the file format

All of the above are subject to change and I will gladly accept ideas about alternative solutions.
