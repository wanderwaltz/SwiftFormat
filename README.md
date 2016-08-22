[![Build Status](https://travis-ci.org/nicklockwood/SwiftFormat.svg)](https://travis-ci.org/nicklockwood/SwiftFormat)


What is this?
----------------

SwiftFormat is a code library and command line tool for reformatting swift code.

It applies a set of rules to the whitespace around the code, while leaving the meaning intact.


Why would I want to do that?
-----------------------------

Many programmers have a preferred style for formatting their code, and other programmers seems to be entirely blind to the existing formatting conventions of a project (to the enragement of their colleagues).

When collaborating on a project, it can be helpful to agree on a common coding style, but enforcing that manually is tedious and error-prone, and can lead to bad feeling if some developers take it more seriously than others.

Having a tool to automatically enforce a common style eliminates those issues, and lets you focus on the operation of the code, not its presentation.


How do I install it?
---------------------

1. The latest binary version of the `swiftformat` command-line tool is included in the `CommandLineTool` folder. You can either use that, or build it yourself from source. To build it yourself, open `SwiftFormat.xcodeproj` and build the `SwiftFormat (Application)` scheme.

2. Drag the `swiftformat` binary into `/usr/local/bin/` (this is a hidden folder, but you can use the Finder's `Go > Go to Folder...` menu to open it).

3. Open `~/.bash_profile` in your favorite text editor (this is a hidden file, but you can type `open ~/.bash_profile` in the terminal to open it).

4. Add the following line to the file: `alias swiftformat="/usr/local/bin/swiftformat -i 4"` (you can omit the `-i 4`, or replace it with something else - run `swiftformat --help` to see the available options).

5. Save the `.bash_profile` file. You will need to open a new Terminal window for the changes to take effect.


How do I use it?
----------------

If you followed the installation instructions above, you can now just type `swiftformat .` (that's a space and then a period after the command) in the terminal to format any swift files in the current directory.

**WARNING:** `swiftformat .` will overwrite any swift files it finds in the current directory or any subfolders therein. If you run it from your home directory, it will probably reformat every swift file on your hard drive.

To use it safely, do the following:

1. Choose a file or directory that you want to apply the changes to.

2. Make sure that you have committed all your changes to that code safely in git (or whatever source control system you use. If you don't use source control, rethink your life choices).

3. In Terminal, type `swiftformat /path/to/your/code/` (the path can either be absolute, or relative to the current directory)

4. Use your source control system to check the changes, and verify that no undesirable changes have been introduced (if they have, file a bug)

5. Commit the changes

This *should* ensure that you avoid catastrophic data loss, but in the unlikely event that it wipes your hard drive, please note that I accept no responsibility.


That seems like an awkward process - can I automate it?
---------------------------------------------------------

Yes. Once you are confident that SwiftFormat isn't going to wreck your code, you might want to add it as a build phase to your Xcode project, so  it will run each time you press Cmd-R or Cmd-B.

Do that as follows:

1. Add the `swiftformat` binary to your project directory (this is better than referencing your local copy because it ensures that everyone who checks out the project will be using the same version).

2. In the Build Phases section of your project target, add a new Run Script phase before the Compile Sources step. The script should be `${SRCROOT}/path/to/swiftformat -f /path/to/your/swift/code/`

**Note:** This will slightly increase your build time, but shouldn't impact it too much, as swiftformat is quite fast compared to compilation. If you find that it has a noticeable impact, file a bug report and I'll try to diagnose why it's running so slowly.


So what does it actually do?
------------------------------

Here are all the rules that SwiftFormat currently applies:

*spaceAroundParens* - contextually adjusts the space around ( ). For example:

    init (foo) --> init(foo)

    switch(x){ --> switch (x) {
    
*spaceInsideParens* - removes the space inside ( ). For example:

	( a, b ) --> (a, b)
	
*spaceAroundBrackets* - contextually adjusts the space around [ ]. For example:

	foo as[String] --> foo as [String]
	
	foo = bar [5] --> foo = bar[5]

*spaceInsideBrackets* - removes the space inside [ ]. For example:

	[ 1, 2, 3 ] --> [1, 2, 3]

*spaceAroundBraces* - contextually removes the space around { }. For example:

	foo.filter{ return true }.map{ $0 } --> foo.filter { return true }.map { $0 }
	
	foo({}) --> foo({})

*spaceInsideBraces* - adds space inside { }. For example:

	foo.filter {return true} --> foo.filter { return true }

*spaceAroundGenerics* - removes the space around < >. For example:

	Foo <Bar> () --> Foo<Bar>()

*spaceInsideGenerics* - removes the space inside < >. For example:

	Foo< Bar, Baz > --> Foo<Bar, Baz>

*spaceAroundOperators* - contextually adjusts the space around infix operators:

	foo . bar() --> foo.bar()
	
	a+b+c --> a + b + c

*noConsecutiveSpaces* - reduces a sequence of spaces to a single space:

    let  foo =  5 --> let foo = 5

*noTrailingWhitespace* - removes the whitespace at the end of a line

*noConsecutiveBlankLines* - reduces multiple sequential blank lines to a single blank line

*linebreakAtEndOfFile* - ensures that the last line of the file is empty

*indent* - adjusts leading whitespace based on scope and line wrapping:

    if x {           if x {
     //foo               //foo
    } else {   -->   } else {
        //bar            //bar
       }             }
       
    foo = [            foo = [
           foo,            foo,
          bar,  -->        bar,
         baz               baz
         ]             ]

*knrBraces* - implements K&R style braces, where the opening brace is on the same line as related code:

    if x              if x {
    {                     //foo
        //foo   -->   } 
    }    	          else {
    else                  //bar
    {                 }
    	//bar
    }

*elseOnSameLine* - ensures the else following an if statement appears on the same line as the closing }

    if x {            if x {
        //foo             //foo
    }           -->   } else {
    else {                //bar
        //bar         }
    }

*trailingCommas* - adds a trailing , to the last line in a multiline array or dictionary literal:

    foo = [         foo = [
        foo,            foo,
        bar,  -->       bar,
        baz             baz,
    ]               ]


FAQ
-----

This is the first release so there aren't any frequent questions yet, but here's what I imagine you might ask:


*Q. Does SwiftFormat support Swift 3?*

> A. Probably. I've only tested it with Swift 2.3 code, but the differences from a formatting perspective should be minimal. 


*Q. Can I compile it with Swift 3?*

> A. Hahahahahahahahahahahahahahahahahahahaha no. 


*Q. Can I run it as a git commit hook instead of a build step?*

> A. Almost certainly. If you figure out how, please create a pull request with the instructions.


*Q. I don't like how SwiftFormat formatted my code*

> A. That's not a question (but see below).


*Q. How can I modify the formatting rules?*

> A. With the exception of indenting, everything is hard-coded right now. If you look in `Formatter.swift` you will find a list of all the rules that are applied by default. You can easily remove rules you don't want and build a new version of the command line tool.

> With a bit more effort, you can also edit the existing rules or create new ones. If you think your changes might be generally useful, make a pull request.


*Q. Why did you write *yet another* Swift formatting tool?*

> A. Surprisingly, there really aren't that many other options out there, and none of them currently support all the rules I wanted. The only other comparable ones I'm aware of are Realm's [SwiftLint](https://github.com/realm/SwiftLint) and Jintin's [Swimat](https://github.com/Jintin/Swimat) - you might want to try those if SwiftFormat doesn't meet your requirements.


*Q. Does it use SourceKit?*

> A. No.


*Q. Why would you write a parser from scratch instead of just using SourceKit?*

> A. The fact that there aren't already dozens of full-featured Swift formatters using SourceKit would suggest that the "just" isn't warranted.


*Q. You wrote a Swift parser from scratch!? Are you a wizard?*

> A. Yes. Yes I am.


*Q. How does it work?*

> A. First it loops through the source file character-by-character and breaks it into tokens, such as `Number`, `Identifier`, `Whitespace`, etc. That's handled by the functions in `Tokenizer.swift`.

> Next, it applies a series of formatting rules to the token array, such as "remove whitespace at the end of a line", or "ensure each opening { appears on the same line as the preceding non-whitespace token". Each rule is designed to be relatively independent of the others, so they can be enabled or disabled individually. The rules are all defined as floating functions in `Formatter.swift`.

> Finally, the modified token array is stitched back together to re-generate the source file.


*Q. Why aren't you using regular expressions?*

> A. See https://xkcd.com/1171/ for details.


*Q. Can I use the `SwiftFormat.framework` inside another app?*

> A. I only created the framework to facilitate testing, so to be honest I've no idea if it will work in an app, but you're welcome to try. If you need to make adjustments to the public/private flags or namespaces to get it working, put up a pull request.


Known issues
---------------

SwiftFormat currently reformats multiline comment blocks without regard for the original indenting. That means

    /* some documentation
    
        func codeExample() {
            print("Hello World")
        }
 
     */
     
Will become

	/* some documentation
    
     func codeExample() {
     print("Hello World")
     }
     
     */
     
To work around that, either use blocks of single-line comments...

    // some documentation
    //
    // func codeExample() {
    //     print("Hello World")
    // }
    //
    //
    
Or begin each line with a `*` (or any other non-whitespace character)

    /* some documentation
     *
     *    func codeExample() {
     *        print("Hello World")
     *    }
     *  
     */
     

What's next?
--------------

I imagine people will discover (and hopefully report) a lot of bugs in this first release, so the next step will be to fix all of those.

There are a bunch of additional rules I'd like to add, such as removing trailing semicolons, or correctly formatting headerdoc comments.

At some point I should probably add an intermediate parsing stage that identifies high-level constructs such as classes and functions and assembles them into a syntax tree. I did't bother doing this originally because I thought it would be easier to implement formatting at the token level, but in fact this just meant that the logic for distinguishing between syntax constructs had to be split between the tokenizer and the formatting rules, making both of them more complex than they aught to be.
     
     
Release notes
----------------

Version 0.2

- Fixed formatting of generic function types
- Fixed indenting of `if case` statements
- Changed `private(set)` indenting to match Apple standard
- Added swiftformat as a build phase to SwiftFormat, so I'm eating my own dogfood

Version 0.1

- First release
