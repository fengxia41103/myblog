Title: Snapshot anything w/ Selenium
Date: 2019-09-25 10:35
Tags: dev
Slug: snapshot selenium
Author: Feng Xia


In my previous notes on [analyzing Angular 1.x code][1], I have stuck at
how to create snapshots of rendered components for my documentation
purpose. In the manual data file `.json`, I allowed an entry to plug
in snapshot file taken by human testers. As an example, the code below
shows a block documenting:

1. module: `mwc.mapping`
2. its components as a LIST, and each has a key `screenshot` that is a
   path to the snapshot file.

```json
{
  "components": [
    {
      "source file": "../app/topology/components/mappings.component.ts",
      "name": "mwc-mappings",
      "screenshot": "./screenshots/mwc-mappings.png",
      "used by": null,
      "using": [
        "mwc-create-flash-pool-button",
        "mwc-flash-pool-actions-button",
        "mwc-create-migration-zone-button",
        "mwc-migration-zone-actions-button"
      ],
      "class": "MappingsComponent"
    }
  ],
  "module": "mwc.mappings"
},

```

Well, this gets me going to create the [example doc][2], but to have
human hunting down screenshots always give me a fishy feeling &mdash;
you know how deeply I do not trust human to be **exhaustive** and
**deterministic** &mdash; on a good day or w/ a capable person, yes,
you get a pretty satisfactory result, but even then, it's no guarantee
his/her next day's delivery will be the same. Not to mention,
executing a task such as "finding all the HTML tag matching this
pattern, and take a screenshot of it, and save it here, and update the
file here..." is tedious, boring, and no fun &larr; I would hate to do
something like this, not even for once, certainly not for 10th time or
daily. Computer can do this, a lot better, quicker. After all, the
component has been written and computer is rendering it for human to
look at, then why can't computer just capture the _look_ of it
automatically?

Of course it can. The idea is this:

1. Use Selenium to launch a browser.
2. Use XPATH to select the element(s) you want.
3. Enumerate through the element, determine where to save the file
   &mdash; file path, file name convention.
4. `element.snapshot(file_path)` will write to `file_path` onto the file system.

<figure class="col s12">
  <img src="images/selenium%20snapshot.gif"/>
</figure>

Window on the right hand side is monitoring folder on the file system
for screenshots. It starts w/ an empty directory. Window on the top
left is the terminal where you will see printout from the script when
it finds the interested element and takes its snapshot, eg. `smile:
mwc-support-mode-modal`. Window on the bottom left is the browser
window launched by Selenium which gives you an idea how the computer
is working. The browser is shown only for demo purpose. It can be
turned into **headless** mode.


# context

One thing of taking snapshot is to provide a context to viewer &mdash;
in which page/panel/container this component is being used. Believe or
not, some components I'm dealing w/ is nothing but a small green dot
(see below)! Therefore, it will be pretty useless if I'm just giving
you an image of itself.


<figure class="col s12">
  <img src="images/mwc-network-hardware-status-icon.png"/>
  <figcaption>
  Example of an element becoming much more meaningful when given a
  context than only by itself.
  </figcaption>
</figure>


On the other hand, by taking the snapshot of a _higher_ level element
and use a RED square to highlight your target, you have a context of
its usage. The trick is to use the `ancestor` axes in XPATH. Say we
are to search any HTML tag starts with `feng`: `target_xpath =
"*[starts-with(local-name(), 'feng-')]"`, then I want to find its
context matching the same HTML tag pattern: `ancestor_xpath =
"ancestor::%s[position()=1]" % target_xpath`.

## snapshot in a context

Taking snapshot to illustrate a context thus taking two steps:

1. Take a snapshot of the context element, eg. an ancestor, and save
   the file.
2. Open this file, and using Python Image Library to draw a rectangle
   using the `location` and `size` of your target element.

Example of a code snippet is shown below. **Note** that you must adjust the
element `c` location based on the ancestor's because once we took a
snapshot of the ancestor, its origin becomes the new `(0,0)`.

```python
# looking for the first ancestor matching the xpath
ancestor_xpath = "ancestor::%s[position()=1]" % context
ancestors = c.find_elements_by_xpath(ancestor_xpath)
if ancestors:
    parent = ancestors[0]

    # take snapshot of the ancestor
    if not self._take_snapshot(parent, filename):
        continue

    # draw a red rectangle around this component
    with Image.open(filename) as im:
        draw = ImageDraw.Draw(im)
        x1 = int(c.location["x"]) - int(parent.location["x"])
        y1 = int(c.location["y"]) - int(parent.location["y"])
        x2 = x1 + int(c.size["width"])
        y2 = y1 + int(c.size["height"])
        draw.rectangle(
            [(x1, y1), (x2, y2)],
            outline="red",
            width=3
        )
        del draw
        im.save(filename)

else:
    self._take_snapshot(c, filename)
```

# dropdown menu

Dropdown is tricky. You don't see the dropdown menu unless user
clicks. However, like the green dot example above, it's not meaningful
you only show the trigger because many times it's only an icon (not
even a button w/ text!). So depending on how dropdown is being
implemented in your code, you have to think of a way to _open_ the
dropdown, and take a snapshot of it **together w/ its trigger**:

<figure class="col l6 m6 s12">
  <img src="images/mwc-network-controller-actions-button.png"/>
  <figcaption>
  
  An example of dropdown menu whose trigger is only a small icon. Thus
  by programmatically open the dropdown, we can take a snapshot of the
  menu and the trigger together, giving it a context.
  
  </figcaption>
</figure>

# modal dialog

<figure class="col l6 m6 s12">
  <img src="images/mwc-host-enable-maintenance-mode-modal.png"/>
  <figcaption>
  
  An example of modal dialog half-rendered when we don't wait for its visibility.
  
  </figcaption>
</figure>


Modals are evil! There are many challenges:

1. We need to identify it's trigger pattern &larr; what can trigger a
   modal to appear. In many cases the modal trigger code is already attached
   to DOM, but is invisible. So XPATH can pick them up, but
   `element.click()` will fail. Instead, use the brute force way to
   click: `driver.execute_script("arguments[0].click();", element)`.
2. Modal dialog takes time to become _present_ in DOM and _visible_. You have
   to wait for both. Waiting only for presence will give a snapshot
   that the modal is half gray-ed out because it is still in the
   process of rendering &larr; this is the difference between a human
   and a computer &mdash; computer can take the snapshot much quicker
   than human can even though the element is not yet _humanly visible
   (but is already perfectly valid because it has attached to DOM!).
3. Modal is often used to prompt user for an action with common option
   of _do sth_ or **cancel**. In our snapshot effort, I don't want to
   change anything in the application, but only for the loop of a
   modal. Thus, we should trigger it to appear, and **always click the CANCEL**!

We deliberately ignore Modal's context because a popup usually takes
over the entire screen asset (w/ a gray-ed out background over the
original page), thus is viewed as a stand-alone entity anyway. And
another good news &mdash; modal can not be nested. Thus, we are only
dealing one at a time (if we religiously clicked the CANCEL each time!).

# code

Script is [here][3]. 

## installation

### chrome driver

`apt search chromedriver`, then install the one you found:

1. on Ubuntu 16.04: `apt install chromedriver`
2. on Ubuntu 18.04: `apt install chromium-chromedriver`

### firefox webdriver (aka. geckodriver)

```shell
export GV=v0.25.0
wget "https://github.com/mozilla/geckodriver/releases/download/$GV/geckodriver-$GV-linux64.tar.gz"
tar xvzf geckodriver-$GV-linux64.tar.gz 
chmod +x geckodriver
sudo cp geckodriver /usr/local/bin/
```



[1]: {filename}/dev/analyze%20angular%201x.md
[2]: {static}/downloads/webapp.pdf
[3]: https://github.com/fengxia41103/dev/tree/master/snapshot

