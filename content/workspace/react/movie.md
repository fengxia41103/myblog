Title: Feng's movie browser
Date: 2020-03-18 09:25
Slug: movie browser
Category: REACT
Tags: react
Author: Feng Xia


[Go to live demo](https://fengxia41103.github.io/movie/)

<figure class="s12 center">
  <img src="images/movie.gif"/>
    <figcaption>Movie browser demo</figcaption>
</figure>

# Background

Posted a challenge to build a _search_/browser for movie
fan. Initially was given a static data set to display. So on top of
that, I start to pull in a few other data sources to spice things
up. Coded in React, which I found the ES6 syntax much cleaner.


# Development

1. Install `nvm` and node (tested 9.4, 12.1).
2. `npm install`: to pull all dependencies.
3. `npm run build` because static files will be served from `/dist`
   (defined in `webpack.config`) by default. However, they can also be
   served outside the application entirely. See `Deploy` section for
   more info.
4. `npm run dev`.
5. Browse `localhost:8080`, browser will auto-refresh when webpack
   detects a change to source files.

# Deploy

## using github pages

1. Setup your github repo to allow pages, select using `MASTER`.
2. Setup `develop` as default branch.
3. `npm run deploy`
4. At prompt, login your github account.
5. Go to `<yourname>.github.com/<repo>`.

## using your static file hosting

1. `npm run build`
2. Push `/dist` to your static file hosting service.
3. Verify on a browser.

**Note**: static data JSONs can be hosted in other locations instead
of packaged in this application. In that case, you need to modify the
`json_data_server` setting in `movie.jsx`:

```javascript
this.state = {
  json_data_server: "data/", <-- change this to an absolute URL
  ...
};
```

Of course, this value can be further manifested in a config so the
source code has minimal change. This, for the time being, is really
minor so I'm letting it be assuming all data json will be packaged
together. Fundamentally, the app is also a set of static files, so
serving them and data using the same mechanics seem quite logical if
we own both the app and the data anyway.

# Design

This is a SPA w/o routing. Idea is to integrate multiple data sources
into a single view. Internal data is hoisted in top level component so
its change will trickle down to all subcomponent which is responsible
for render its content.

## Data sources

1. [JSON data set][ibm]: data set composed offline.
1. [OMDB API][omdbapi]: When speaking of movies, one immediately thinks
   of [IMDB][imdb], Surprisingly IMDB doesn't have an official
   API. There is an third-party offering called [omdbapi][omdbapi],
   sounds pretty copycat. Data set is fairly simple once you get an
   [API key][omdbapi key] (free for 1000 calls per day) and examine
   the data comparing to what is displayed on a IMDB page.

        ```javascript
        api = http://www.omdbapi.com/?apikey=c6638eb9&t=Wall%20E
        ```

[imdb]: https://www.imdb.com/
[omdbapi]: http://www.omdbapi.com/
[omdbapi key]: http://www.omdbapi.com/apikey.aspx
[ibm]: https://ibm.box.com/s/ufnb4dlv5hmfln58lt37563l0yvdw4xt 

## Toolset

<figure class="col l8 m8 s12 center">
  <img src="images/movie/technology.png"/>
    <figcaption>Toolset stack</figcaption>
</figure>


It's always amazing to me how many different technologies/libraries
one has to pull together in order to make an application, even a
simple one like this. 

* [REACT][]: core
* [React Bootstrap][bootstrap]: map boostrap components into React,
  eg. use `<Button` which will render bootstrap buttons.
* [Materialize CSS][materialize]: "A modern responsive front-end framework based on Material Design" by their words.
* [lodash][]: nice lib for data struct manipulation.
* [webpack][]: new module builder that is making lot of buzz these days.
* [fetch][]: a new way to talk to API endpoints instead of `jQuery AJAX`.

[materialize]: http://materializecss.com/
[react]: https://facebook.github.io/react/
[webpack]: https://webpack.github.io/
[fetch]: https://github.com/github/fetch
[bootstrap]: https://react-bootstrap.github.io/
[lodash]: https://lodash.com/


## Presentation Layout & Components

> Naming following `<name>Box` is a Component.

Layout follows 3-section approach: header, content, and footer, in a
vertical split. The `Content` is a logical group of a list of sub
components and some static information (displayed in
YELLOW). 


<figure class="col l6 m6 s12 center">
  <img src="images/movie/layout.png"/>
    <figcaption>View layout</figcaption>
</figure>

- `HeaderBox`: Place to put things such as navigation, logos. Stick to
  top.
- `FooterBox`: Place to put more navigation to external resources,
  static pagers such as credits. Stick to bottom. 
- `SearchBox`: Search movie by title. Multiple matches will result in
  multiple `MovieBox`.
- `MovieBox`: Represent content of a single movie, thus it has movie's data.
- `Movie title`: Title is rendered as static information. No component is needed.
- `SubtitleBox`: Subtitle includes a mix of facts and opinionated info:
  - movie rating by IMDB and other sources (Note: these are
    opinionated scores, mostly by voluntary voters).
  - time length
  - production year
  - movie [rating][] (**Note**: since contents cover international movies,
    not all of them have this info).
  - original language released (**Note**: this does not cover
    translated versions done after its release).
- `Description`: Description is rendered as static information. No
  component is needed.
- `GalleryBox`: Movie poster and other images.
- `CrewBox`: Component for genre, director, starring, and writer.
- `RatingBox`: Component for opinionated ratings, eg. IMDB rating.
- `LocationBox`: Location where scenes were taken. Presented as fun
  facts.
- `QuoteBox`: Critic reviews.
- `SnippetsBox`: Make a fun quiz game using lines from the movie.
- `EpisodeBox`: For series, list episodes and their ratings.

[rating]: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system

## SearchBox

Search is case insensitive. Given movie title (and this can be
partial) will result in either a list of IMDB IDs, or nothing. The
more precise your query is, the more likely it will return what you
are looking for. 

There are two error conditions:

1. **No match**: I have no control over the content of the search API
   backend. Thus not only a meaningless query such as "lkjsljdflkj"
   will result in an empty result, some seemingly useful one will
   result in the same no hit. For example, try an international title.
   
2. **Too many**: Given an ambiguous query such as a two-letter `st`
   will result in a "too many results" error. 

So overall, search is an act of art. Suggestion to get you going:

1. `star` or `star war` &rarr; no explanation needed
2. `wall`: &rarr; Wall E
3. `sound` &rarr; Sound of Music

<figure class="col s12 center">
  <img src="images/movie/search%20sequence.png"/>
    <figcaption>SearchBox sequence diagram</figcaption>
</figure>

## MovieBox

This represents a single movie. When given an IMDB ID, it will
retrieve movie meta data from external sources such as OMDB API. If
not it will load local data source file, eg. `data/en-US.json`. In
general, it knows how to get data from different data sources and
how to handle their info.

<figure class="col s12 center">
  <img src="images/movie/movie%20box%20sequence.png"/>
    <figcaption>MovieBox sequence diagram</figcaption>
</figure>

A key piece of this entire application is an internal data structure
representing a movie's info. When dealing w/ multiple data sources,
normalizing data is a MUST to make it clean, as well as to make error
handler possible (just about any piece of info can be `null` or
`undefined`, or having no value `[]{}""`! But I don't want to have all
those inline `if-else` littering inside the `jsx` sections), thus
trying to assigning them a valid value. This is especially important
to `undefined` because React render will fail silently w/o much
meaning error stack trace. 

```javascript
let normalized = {
  title: title,
  description: data.description || data.Plot,
  locations: data.locations || [],
  quote: data.quote || {},
  snippets: data.snippets || [],
  gallery: data.gallery || [{"src":data.Poster, "text":title}],
  video: data["video-embed"] || [],
  episodes: data["episode-list"] || [],
  year: data.Year || "",
  runtime: data.Runtime || "",
  director: data.Director || "",
  released: data.Released || "",
  genres: data.Genre || "",
  writers: data.Writer || "",
  actors: data.Actors || "",
  language: data.Language || "",
  country: data.Country || "",
  awards: data.Awards || "",
  ratings: data.Ratings || [],
  metaScore: data.Metascore || "",
  imdbRating: parseFloat(data.imdbRating || ""),
  imdbVotes: parseInt(data.imdbVotes || ""),
  imdbID: data.imdbID,
  type: data.Type || "",
  dvd: data.DVD || "",
  boxOffice: data.BoxOffice || "",
  production: data.Production || "",
  rated: data.Rated || ""
}
```

Apparently there are many loop holes in this. **The only assumption I'm
making is that `data.imdbID` won't be null, so that we are looking at
a real movie**. Fair?

## GalleryBox

There are many ways to implement a gallery box, eg. carousel. I chose
to write one myself that will:

1. display one image as main
2. if there are multiple image, mouse over or click will switch to the
   next one.
3. it circles back to the beginning of the array once at the end

I haven't spent much time to get image into the same size so view
doesn't shift when it displays a longer or wider image. A quick google
revealed `object-fit` CSS. Later.

## SnippetsBox

Snippets are fun. Instead of displaying them as static strings, I
decided to make a quiz game out of it by randomly taking out a few
words from the snippet, then ask user to fill them in.

The game is a bit rudimentary that it has to be an exact match
including symbols `'` and such, which is quite annoying. However as
POC, this is sufficient.

<figure class="col l6 m6 s12 center">
  <img src="images/movie/snippet.png"/>
    <figcaption>Snippet game components</figcaption>
</figure>

- `part 1 & 2`: are what are left of the snippet line after taking out
  the riddle piece.
- `riddle`: randomly select a section of the snippet line as riddle.
- `show hint` will break down the riddle into a list of words, and
  show one at a time. Hints will be displayed, but not replacing the
  user input, so user still needs to type them in.

## EpisodeBox

Episode data are rather pale &mdash; it has episode name and a rating
number. So I decided to try out two different presentations: as a
list, and as a chart. So far I like the list format better.

Rating are sorted in descending order. Chart is using Highcharts
`bar`. I'd like to have a better data source for this, or a way to
make each episode a link to a better information.
