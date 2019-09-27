Title: Dev structure
Date: 2019-06-24 14:06
Tags: thoughts
Slug: dev structure
Author: Feng Xia

<figure class="col l5 m5 s12">
  <img src="images/moses.jpg"/>
  <figcaption>If the Bible story happens today</figcaption>
</figure>


This is a common question any team/project will have to address
&mdash; how to structure the knowledge we know of a project so that we
are not missing things? Each project/application, of course, is
different. But the overall is actually quite common. Here is a
structure I'm proposing that is applicable not only during initial
learning phase, but can guide the design and development as well.

Take an example that we are building a portal, which has frontend and
backend &mdash; the `backend` is showing more levels than the
`frontend`, the idea is the same:

```bash
Portal
  Frontend
    Design
    Build/packaging
    Dev breakdown (incl. unit tests)
    Tests

  Backend
    Design
      Logical view => components
                   => key technology stack
      Components
        REST API
        web portal
        another..
        another..


    Build/packaging
      for dev
      for production => CICD integration   


    Dev breakdown (incl. unit tests)
      component A
      component B
      ....


    Tests
      all non-dev covered tests => QA
        code static analysis (LINT, style check, best practice)
        scenario tests (incl. "integration" tests)
      machinary => CICD integration
```

The key is to compose a design/component view so that we can
categorize work into component, which also speaks of key
technology/implementation. Until this is identified, we can say for
sure we don't have 100% coverage of this code base yet.
