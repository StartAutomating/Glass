# Glass

## A Module for Finding, Reading, and Writing Secret Messages

In October 2025, koi.ai documented a dangerous new malware worm they called [Glassworm](https://www.koi.ai/blog/glassworm-first-self-propagating-worm-using-invisible-code-hits-openvsx-marketplace).

The full workup is worth the read, and this glassworm is a pernicious parasite that is likely to continue to spread.

There are a lot of interesting attack vectors this shows are already in play, and this module is here to help everyone understand at least one of them:

## Glassware / Glass Malware

As a somewhat clever computing professional, I believe that Glassworm is not going to be the last bit of malware to use glass.

As such, I'm coining the use of the term `Glassware` to mean "Software designed to be invisible" (October 23rd, 2025)

This module exists to help people understand how glass works, and to help uncover glass within your code.

### How Glassware works

There are a lot of characters out there.

Specifically, there are 65535 different characters in a modern "wide" character string.

Some of these characters support variations in how other characters get displayed.

There are a few different variations throughout the standard, but there's one block of [Variation Selectors](https://en.wikipedia.org/wiki/Variation_Selectors_(Unicode_block)) that is particularly troublesome.

Why?

1. They're all invisible characters.
2. There are 16 of them (or, one byte)

This means that it's easy to smuggle in bytes of invisible information.  

Furthermore, it would be trivial to shift or encrypt this information to further obscure a payload.

It is my opinion that this is mostly a bad thing.

While I appreciate the need for secrets, secrets that are a little too easy to turn into binary payloads concern me.

So, what to do?

This djinn is out of the bottle.  This has already been seen in the wild.

In my opinion, the ethical thing to do is to these invisible characters easier to detect, encode, and decode.

## Using this Module 

This module is meant for educational purposes and to assist responsible professionals in the discovery of glassware.

### Get-Glass
The primary use case of this module is to detect glass within files and archives.

For example, to import glass and scan it for glass:

~~~PowerShell
Import-Module Glass -Force -PassThru |
    Get-Glass
~~~

To scan for all glass in a directory:

~~~PowerShell
Get-Item $pwd | Glass
~~~

The secondary purpose is to help people understand glass encoding.

To that end, this module includes two additional commands:

### ConvertTo-Glass

Convert a message to glass

~~~PowerShell
ConvertTo-Glass "Now You See Me"
~~~

### ConvertFrom-Glass

Convert a message from glass

~~~PowerShell
ConvertTo-Glass "Now You See Me"  |
    ConvertFrom-Glass
~~~

It should be noted that not all glass messages will be encoded in plaintext.

### Responsible Use

This module should be used to detect dangerous shards of glass in an organization.  

Any other use is prohibited by the code of conduct, 
and should be reported to this repository so that security researchers can understand new glassware attack vectors as they arise.

If you see this module in your organization, and you are not actively using it for security research, please report this to your network administrator and information security teams immediately.