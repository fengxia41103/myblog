Title: ECMAScript
Date: 2019-07-03 14:15
Tags: thoughts
Slug: ecmascript
Author: Feng Xia

Isn't this confusing &mdash; [ECMAScript][1], [ES2015][2], ES6, Javascript,
[JScript][3], [CoffeeScript][4], [TypeScript][5]... what the heck!?

<figure class="col s12">
  <img src="/images/ecmascript%20relationship.png"/>
  <figcaption>Feng's view of how these confusing Javascript words are
  linked together</figcaption>
</figure>

# spec

The mother of all is the [ECMAScript][1], which is the spec. It has
some wild release notion and cycles. The important one for me is the
[ES2015][2], and I think starting from that release, the schedule
becomes annual, thus we have `ECMAScript 2016` and so on. Since the
2015 release is the **6th** revision of the spec, thus also created
the notion `ES6` (`ES2015` ==  `ES6`).

# spec implementation

Javascript, together with [JScript][3], [ActionScript][6], are
implementation of this spec, and of course, by different
companies. The problem is, each implements some subset of the spec,
thus there are overlaps as well as incompatibilities. Sucks!
Therefore, when reading some Javascript articles, there is always
reference to `ES6` compatible or a feature, which means whether the
Javascript implementation is up to that spec's release, or not.

# javascript engine and compatibility

Ok. Here comes the giant twist &mdash; starting when the spec
committee decides that before I put feature into writing, there needs
to at least two implementations &rarr; browser's Javacript engines
(and dont' get confused w/ [browser engine][8], which itself is
includes an Javascript engine, but do other things such as rendering
HTML), that can make this feature work. So some engine implements a
feature that will be added into ES6, for example, while others then
have to play the catch up game once the spec is out, and even when a
_feature_ is usable in a browser, it doesn't necessarily in the spec
yet &rarr; isn't this logic circular!? Anway. So this leads the
browser's [compatibility hell][9], check it out.

# superset & transpiler

Then, nobody likes coding in plain Javascript (why!?), so there comes
the **supersets** &mdash; [CoffeeScript][4], [TypeScript][5]... and
then, Angular decides to use `typescript` to write itself. How
wonderful! The reason they call themselves superset is that any plain
Javascript is legitimate superset codes, but not the other way around
&mdash; it's like you can write assembly in C code, but can't add a C
function in assembly. 

Oh well, so enters the compilers (and the Javascript world must give
it a new name, `transpiler`, hell) &mdash; they covert these superset
code into, plain javascripts.. .well, you can translate many
programming languages into many others (see [the list][10]). So it's
really in your development pipeline to use some tooling to make this
compilation so **at the end of the day, you are getting
javascript**. But wait, there is more.

Not only they translate superset into javascript, it can **downgrade**
your code from ES15 to some really basics. An example in [this
article][23] which I'm showing below:

```javascript
"use strict";

class Planet {

  constructor (mass, moons) {
    this.mass  = mass;
    this.moons = moons || 0;
  }

  reportMoons () {
    console.log(`I have ${this.moons} moons.`)
  }

}

// Yeah, Jupiter really does have (at least) 67 moons.
const jupiter = new Planet('Pretty Big', 67);
jupiter.reportMoons();
```

will be translated to:

```javascript
// Everything below is Babel's output.
'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var Planet = function () {
  function Planet(mass, moons) {
    _classCallCheck(this, Planet);

    this.mass = mass;
    this.moons = moons || 0;
  }

  _createClass(Planet, [{
    key: 'reportMoons',
    value: function reportMoons() {
      console.log('I have ' + this.moons + ' moons.');
    }
  }]);

  return Planet;
}();
```

> You'll notice that there are no ES2015 features. const variables get
> converted to carefully scoped var declarations; class is converted to
> an old-school function constructor; and the template string desugars
> to simple string concatenation.
>

Therefore, transpiler is also a way to map these advanced features
into more vanilla form so it will improve compatibility (and
reliability?). The one name I have seen over and over is the
[Babel][11], and there is even an [live babel][15].


# module loader

Coding is complex, and you need to break them up into
**modules**, but then, who is going to piece them together!? That's
the module loader. Two dominant ones &mdash;
[CommonJS][12], and [Asynchronous Module Definition][13] (AMD). This
[article][22] explains it very well. 

So, these two are again, just methodologies, philosophies. An
implementation of `commonJS` is `Node.js`, and for AMD you get
[require.js][14].

I bet by now you start to see how these names fall into its own place
and start to make sense, hopefully.


# Reference

1. [ES6 vs ES2015 - What to call a JavaScript version?][21]
2. [JavaScript Module Systems Showdown: CommonJS vs AMD vs ES2015][22]
3. [avaScript Transpilers: What They Are & Why We Need Them][23]


[1]: https://en.wikipedia.org/wiki/ECMAScript
[2]: https://en.wikipedia.org/wiki/ECMAScript#6th_Edition_-_ECMAScript_2015
[3]: https://en.wikipedia.org/wiki/JScript
[4]: https://en.wikipedia.org/wiki/CoffeeScript
[5]: https://en.wikipedia.org/wiki/Microsoft_TypeScript
[6]: https://en.wikipedia.org/wiki/ActionScript
[7]: https://en.wikipedia.org/wiki/JavaScript_engine
[8]: https://en.wikipedia.org/wiki/Browser_engine
[9]: https://kangax.github.io/compat-table/es6/
[10]: https://github.com/jashkenas/coffeescript/wiki/List-of-languages-that-compile-to-JS
[11]: https://babeljs.io/
[12]: https://en.wikipedia.org/wiki/CommonJS
[13]: https://en.wikipedia.org/wiki/Asynchronous_module_definition
[14]: https://requirejs.org/
[15]: https://babeljs.io/repl/

[21]: https://bytearcher.com/articles/es6-vs-es2015-name/
[22]: https://auth0.com/blog/javascript-module-systems-showdown/
[23]: https://scotch.io/tutorials/javascript-transpilers-what-they-are-why-we-need-them
