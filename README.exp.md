# Readme for 'exp' branch

## Directive classes & watchers

* TODO:
    * generalize the installation and destructions of watchers better
    * it should be easier to add a new watcher on top of those inherited

## Markdown extensions

* see ~/markdown_extensions.md for a description of intended extensions

* TODO:
    * Implement some notion of TOC
        * this requires analysis of the article
        * or perhaps only add to TOC the titles that are tagged

* TODO:
    * Implement `#` links

* TODO:
    * Support for
        * Angular.js expressions (some conversions needed?)
        * ids and anchors, and global fresh id when no id is provided

* TODO:
    * Do not compile the extension when they are in a <code> bracket
    * This requires using postConversions hook, and keeping track of <code> state

## URL language

* Link to a region of a file
    * /test/a:20-30    {lines 20-30}
    * /test/a:rid      {region 'rid'}

## Design decisions

* Glossary
    * Important terms (resource Vs data, url Vs path)
    * Make sure the code is consistent

* Markdown extension syntax
    * Simple to revert to basic markdown
    * Easy to write in text editor

## Directives

* Directives should have multiple states
    * Loading: waiting for resource
    * Display

## Functionalities

* Push to server on edit

## Error handling

* Warn of errors


