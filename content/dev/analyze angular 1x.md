Title: Analyzing Angular 1.x code
Date: 2019-09-01 17:58
Tags: angular, lenovo
Slug: analyzing angular 1x
Author: Feng Xia
Modified: 2019-09-25 10:33

[Compodoc][1] can generate component hierarchy diagrams, call chains,
but it didn't work for Angular 1.x code. 

The goal is to **create a lookup/catalogue between code and visual**
because everyone on the team, including UI devs, can only engage a
discussion using the visual (the rendered look) &mdash; so far, I
haven't been able to develop the capability to _see_ how it will look
like by just staring at code.

This issue gets compounded when components are calling each other
&mdash; some pages are calling all kinds of components, and these
components are in turn used in all sorts of _parent_ pages. This
presents an issue how to knows its effect when, say, I'm taking a task
to change this component? Without such a cross reference, I'm
completely in the dark. Think about this, if component A is used in 3
places, we should have 3 test cases just to be sure it doesn't break
the visual.

This leads me to a google search and I think the term for what I'm
thinking is [visual regression][2]. I'm surprised to see how new this
concept appears to be by looking at how young a few mentioned
libraries/services are. Maybe I'm just behind the curve. Nonetheless,
here I am, and I'm catching up, fast.

[jest-image-snapshot][3] mentions of saving
snapshot in some dir &mdash; maybe I can use this to get a snapshot of
component. But it's saving them for future comparison purpose, which
I'm not ready yet to embark this level of testing. So keep the notes
here for now.


My way is extremely hacky because I'm going to parse `.ts` file using
Python regex. So embrace yourself.

# how to find module definition

Module is the core grouping method in Angular:

1. `export .... module('module.name')`
2. `export .... angular.module('module.name')`

Pretty straightforward, two variations.

# how to find component definition

Component is messy. Just how many ways one can define a component?

1. `export const A: IComponentOptions`
2. `class A implements ng.IOnInit`
3. `class A implements angular.IOnInit`
4. `export class A`, just a plain class
5. `export const A = {`

# component hierarchy

Strategy of getting component call chain is to parse HTML file. This
relies on a certain naming convention, eg. all your tags are prefixed
with `feng-` so that HTHM parser will pick up any tags with this
prefix, and identify inside which HTML tree this is being used, thus
formulating a hierarchy. 

# utility

Script is maintained [here][6]. 


1. `pip install click lxml`
2. to create `.md`: `python code_analysis.py build-doc --manual-data webapp.json --dump-md-to webapp.md --template-header header.md`

    This will parse `webapp.json` as an input, and merge w/ machine
    scanned version created by `walk` the code tree for all `.ts` and
    `.html` files.

    The merged data set will be written back to `webapp.json`, and create
    a Pandoc version of `webapp.md` ready for conversion to `.html` and
    other formats.

3. to find missing screenshots: `check-screenshots --data <data>.json`


# example doc

Once you piece these together, you can get a really impressive doc by
producing a Pandoc `.md`. Also, you can dump data into `.json` or
`.yml` for machine parsing and to incorporate manual generated data
such as screenshot (as of writing 9/4/2019, we are relying on human to
take screenshot by painfully finding the component rendered in a
browser).

All in all, take a look [this sample][5] and enjoy ~~

[1]: https://github.com/compodoc/compodoc
[2]: https://storybook.js.org/docs/testing/automated-visual-testing/
[3]: https://github.com/americanexpress/jest-image-snapshot
[4]: {filename}/dev/pandoc.md
[5]: {static}/downloads/webapp.pdf
[6]: https://github.com/fengxia41103/dev/blob/master/code%20analysis/analyze_angular_1x.py
