Title: Strange things of Javascript
Date: 2019-11-17 13:13
Tags: dev
Slug: strange things of javascript
Author: Feng Xia

<figure class="col l6 m6 s12">
  <img src="images/wise%20doctor.jpg"/>
</figure>

God, isn't Angular confusing! and I really think it is because of its
shaky underline language &mdash; Javascript, is itself,
confusing. Well, even by just looking at its name, how many people
have thought that it is a _script_ derived from Java!? Oh well well,
here are some notes I take while studying Angular(JS, sometimes), and
`.js`. Btw, there is another article about all the confusion of [`ES<a
number>` denotation][1] that can clarify those naming/version hell.

# scope

Scope is always the most fundamental concept I read of a language, and
for all I know, I'm expecting something like a `global` and a `local`,
that a local is always _private_ to its enclosed curly brackets or any
nearest declaration _chunk_ &mdash; if it is declared in a function, it
is available in a function, not outside; if it is declared in a `for`
loop, well, it is only useful inside the `for` loop, not outside.

But there comes this country boy Javascript, and for the first time I
realized there are actually 3 scopes: global, function, and
**block**. It turned out that **anything declared w/ a `var xyz` can not
have a block scope**! What does this mean,

```js
var x = 10;
// Here x is 10
{
  var x = 2;
  // Here x is 2
}
// Here x is 2
```

So the 2nd declaration of `var x=2` is not creating a new _private_
variable that is only useful inside the curly bracket[^1]. On the
contrary, it **re**declare the former `var x=10`, but now overwriting
its (I guess the reference) w/ a value of 2. 

Isn't this strange! So it turned out that

> Before ES2015 JavaScript did not have Block Scope. [ref][2]

Well well well, so before the year of 2015, how many poor javascript
coders have tripped on this!? and how many poor written code has been
generated? and why the hell it sets such a trap to begin w/!?

So the correct way is: 

```js
var x = 10;
// Here x is 10
{
  let x = 2; <== using the `let`
  // Here x is 2
}
// Here x is 10
```

This doesn't seem very bad if you are enclosing a lot of them into
functions. But still, try this (really, this is a nasty bug!):

```js
var i = 5;
for (var i = 0; i < 10; i++) {
  // some statements
}
// Here i is 10
```

Things like this, makes it very difficult for me to like Javascript.

# hoisting

WTF. After being in the trade for 20+ years, this is the very first
time I heard something like this:

> Hoisting is JavaScript's default behavior of moving declarations to
> the top. [ref][3]

This seems quite fine since it's trying to be smart. But then, here
comes the rub: **JavaScript only hoists declarations, not
initializations.** What that means? Two examples below:

Example 1:
```js
var x = 5; // Initialize x
var y = 7; // Initialize y

console.log("x is " + x + " and y is " + y); 
```

Example 2:
```js
var x = 5; // Initialize x

console.log("x is " + x + " and y is " + y); 

var y = 7; // Initialize y
```

Two logs generate different results:
- example 1: `x` is 5 and `y` is 7
- example 2: `x` is 5 and `y` is **undefined**

As a matter of fact, example 2 is equivalent to this:

```js
var x = 5; // Initialize x
var y; // declaration

console.log("x is " + x + " and y is " + y); 

var y = 7; // Initialize y
```

I think the problem of this confusion roots in the decision that JS
allows the use of `y` even before it has been declared (as seen in the
original example 2 code above)! In any other language, it will do one
of the two things:

1. variable will be declared **implicitly** and given a value of
   null/undefined, sth like that &larr; this is **always a bad idea**
   on the coder's part[^2].
2. compiler will just balk w/ an error &larr; preferred.

Btw, the new `let` and `const` are not hoisted. Thus, if you just
declare a `let feng;`, too bad, it stays where it is in its line
number.

[1]: {filename}/dev/ecmascript.md
[2]: https://www.w3schools.com/js/js_let.asp
[3]: https://www.w3schools.com/js/js_hoisting.asp

[^1]: But if you define the curly as a function, the `var` inside will
    have a _function scope_, and it is only visible to the function
    itself, not outside the function.

[^2]: We do use this a lot in python in which we don't have to
   _declare_ a variable explicitly. But then, it is a solid decision
   in Python, and I don't recall ever need to be aware a _trap_ like
   what this hoisting idea is producing.
