# Markdown Syntax extensions

**Span form: general syntax**

    $[name arg](text1)(text2)...

* `arg`: optional directive argument, which is either
    * an unquoted string
        * Possibly interpreted as json data by the directive
* `text1`: first text argument
    * an unquoted string
        * Possibly interpreted as:
            * Markdown text to be compiled
            * Yaml data
* `text2`: second text argument
* ...: other text arguments

**Span form: examples**

    $[dir 'a','b','c'](Blah *blah*)

    $[dir id:'adsf', dd:'a']

    $[name oh oh](Blah **blah**)(More **blah**)

    $[name ./c/a](Blah **blah**)(More **blah**)

**Block form: general syntax**

    $ name arg
        text1

        text2

**Block form: examples**

    $ dir 'a','b','c'
        Blah *blah*

    $ dir id:'asdf', dd:'a'

    $ name oh oh
        Blah **blah**

        More **blah** **blah**

    $ name ./c/a
        Blah **blah**

        More **blah** **blah**


**Supported extensions**

* **comment**: simply a directive that does nothing
    * Span form

            $[comment id](Some **quick** comment)

    * Block form

            $ comment id
                A longer
                comment

                possibly with
                many paragraphs

* **inline**: interpreted as yaml (only in block form).
    The idea is to quickly write some .yaml content (could be copied as a separate file later).
    The `id` argument makes the .yaml content embedable from other files

        $ inline id
            directive: markdown
            vars:
                var01:
                    |
                        Pouet
            data:
                text:
                    |
                        this like embed, but
                        the yaml is directly in the file

        $ inline id
            directive: table
            data:
                - col:
                    |
                        Test
                - row:
                    |
                        Pouet

* **append**: insert link here, and content at the end of the article (or in a special *append* section)
    * Span form

            $[append src:'./c' target:'append-container'](Link **text**)

        or, possibly

            $[append ./c append-container](Link **text**)

        or with a default append container

            $[append ./c](Link **text**)

    * Block form

            $ append src:'./c', target:'append-container'
                Link **text**

    * Inline form if more practical

            $ inline
                - directive: append
                - data:
                    src: ./c
                    target: append-container

* **embed**: insert content directy here
    * Span form

            $[embed ./c]

    * Block form

            $ embed ./c

* **tag**: tags some content with an id
    * Span form

            $[tag id](Region text)

    * Block form

            $ tag id
                this
                is
                the
                region with id

    * For example, to give an id to a title

            $[tag my_title](# Title)

        or

            $ tag my_title
                # Title


* **var**: gives a value to a variable
    * Span form

            $[var varname](10)

    * Block form

            $ var varname
                10

    * Templating test: {{varname}}

* **repeat**: maps to ng-repeat
    * Span form

            $[repeat expr](Text to be repeated)

    * Block form

            $ repeat expr
                Text
                to
                be repeated {{item}}

* **if/else**: conditional. (the else case is optional)
    * Span form

        $[if expr] (if case)(else **case**)

    * Block form

        $ if expr
            if
            case

            else
            **case**

## Code

    <adf>
    <asdf>

## Block quote

>asdf
asdf asdf

<h2 id='templating'>Templating</h2>

<ul>
    <li ng-repeat="item in chiffres">{{item}}</li>
</ul>

NOTE: to make the above general, we need:

* Vars need to be inserted into the scope when loading a resource





