Title: REACT in website
Date: 2022-11-15 14:19
Tags: dev
Slug: react in website
Author: Feng Xia

This is to answer the question of "how to use REACT with your
website?" For example, I'm using Pelican to generate this blog
site. These are static files. So if I want to utilize my REACT skill
to write some _web application_, how to incorporate that into this
website?

The idea is straightforward &mdash; REACT is a Javascript. So, if I
can package my REACT application into a `.js`, can't I just import it
using the `<script...` HTML syntax? Yes I can! The key is
[rollup.js][1]. So the idea is this: rollup will package your REACT
files into a single `bundle.js`, and you import it in your HTML. The
connection between REACT code and HTML page will be a HTML **id**.

# React component

Use my `quote.jsx` for example. In here I define the REACT component
however I will do:

```javascript
import React, { StrictMode, useState, useEffect } from "react";
import { createRoot } from "react-dom/client";
import fetchJsonp from "fetch-jsonp";

export default function QuoteBox(props) {
  const [quote, setQuote] = useState(null);
  const [img, setImg] = useState(null);
  const [loading, setLoading] = useState(false);

  const getImage = () => {
    setLoading(true);

    // AJAX
    const min = 1,
      max = 1743; // 1743 is from manual testing
    const id = Math.floor(Math.random() * (max - min) + min);

    // NOTE: must use `https` if using github page, which is
    // served in https (is a setting option, however).
    const apiUrl = `https://dynamic.xkcd.com/api-0/jsonp/comic/${id}`;
    fetchJsonp(apiUrl)
      .then((resp) => resp.json())
      .then((data) => {
        setQuote(data.title);
        setImg(data.img);
        setLoading(false);
      });
  };

  useEffect(() => getImage(), []);

  return (
    <div>
      <figure onClick={getImage}>
        <img src={img} className="center img-responsive" />
        <figcaption>
          {quote}
          <span style={{ marginLeft: "1em", float: "none" }}>
            <i
              className={loading ? "fa fa-spinner" : "fa fa-angle-right"}
              style={{ paddingLeft: "1em", marginRight: "1em" }}
            ></i>
          </span>
        </figcaption>
      </figure>
    </div>
  );
}
```

Then at the end of this component, I must use `createRoot` to add an
element to the DOM, thus making this component's render appear to the
HTML page. The `getElementById("quote")` is where this component will
be put under.


```javascript
const rootElem = document.getElementById("quote");
if (rootElem) {
  const root = createRoot(rootElem);
  root.render(
    <StrictMode>
      <QuoteBox />
    </StrictMode>
  );
}
```

# HTML element

Next, in my `.md` (Pelican uses `.md` to render `html`), all I need is
an element w/ ID `"quote"`. Apparently now I can plug in the component
above to anywhere in the page, so you can make some really neat
component and plug it into your running text to make the page interesting.

```markdown
Title: Quote
Tags: quote
Slug: quote
Author: Feng Xia

<div id="quote"></div>
```

# rollup

Now enters the `rollup`. First is its config. Two key values: `input:
"index.jsx"`, which defines the list of components we are to package,
and `output: "bundle.js"` which is the final package name we are to
import in HTML.


```javascript
import serve from "rollup-plugin-serve";
import livereload from "rollup-plugin-livereload";
import babel from "@rollup/plugin-babel";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import replace from "@rollup/plugin-replace";
export default {
  input: "index.jsx",  <==== !!
  output: {
    file: "bundle.js", <====  !!
    format: "iife",
    sourcemap: true,
  },
  plugins: [
    nodeResolve({
      extensions: [".js"],
    }),
    replace({
      "process.env.NODE_ENV": JSON.stringify("development"),
    }),
    babel({
      presets: ["@babel/preset-react"],
    }),
    commonjs(),
    serve({
      open: true,
      verbose: true,
      contentBase: ["", "public"],
      host: "localhost",
      port: 3000,
    }),
    livereload({ watch: "." }),
  ],
};
```
Now in the same folder w/ this config file, you need an `index.jsx`.
This doesn't need much explanation. You can put components in a
different file structure also, or even make them like a storybook kind
library, and import the ones you need here.

```javascript
import QuoteBox from "./quote.jsx";
import SearchBox from "./search.jsx";
import PresentationBox from "./brother.jsx";
```

Next, let's roll these components into a single `.js`: `npx rollup -c
js/rollup.config.js -w`. You should now see a `bundle.js` in the same
folder as the config.

# use `bundle.js` in html

Last step is to import this `bundle.js` in HTML. Really now you can
serve this `bundle.js` from anywhere. It's just another JS.

```html
<script
  type="text/javascript"
  src="{{ SITEURL }}/theme/js/bundle.js"
></script>
```

Now once the page w/ the given ID is rendered, JS will take effect and
insert the REACT component to that spot. Neat.

[1]: https://rollupjs.org/guide/en/
