Title: Make passport photo in Gimp
Date: 2019-06-23 18:59
Tags: thoughts
Slug: make passport photo in gimp
Author: Feng Xia
Modified: 2019-07-05 21:15

<figure class="col l5 m5 s12">
  <img src="images/temperature.jpg"/>
</figure>


Once a while I need to make a 2x2 for official document such as
passport. It's annoying if I need to go CVS paying $15 for a digital
while myself owns a whole bunch of lenses and am proud of myself of
taking good photos.. well, I guess this is exaggerated feeling, it's
like saying that doctors shouldn't let other doctors treat them. 

Ok. So out of curiosity, I have always fallen back to GIMP to make a
4x6, thus 6 of 2x2, and print it for like 27 cents. So much
satisfying! But since I don't do this for a living, it's totally new
each time I need to do this. So, let's write this down once for all,
so I can look it up next time, quickly.

Steps is straightforward:

1. Pick a photo with not-too-noisy background, because we will select
   using the [intelligent scissor][1] in GIMP. So the more contrast or
   clean the person is in this photo, the easier.
   
2. Select scissor (`i`) and be patient. Close the loop by click left
   mouse on the very first point &larr; the mouse icon will change
   when you hover over that point. But honest, the point is so small
   that I can hardly follow it.
   
3. Click **anywhere** inside the loop &larr; this is the step I keep
   forgetting. By doing so, the selection will blink with dash line,
   now we are in business.
   
4. Paste selection into a `new` file. Now you should see only the
   selection, with like transparent background.
   
5. Crop (`r`) to a roughly square shape &rarr; this is the step you
   can position your head in the way that passport photo wants &mdash;
   so much for the head room, show some shoulders:

    There is a tiny reading at the right bottom of the window when you
    resize the crop overlap, eg. `0.98:1`, so you are aiming for `1:1`
    to be square. Don't worry if it's not mathematically square, just
    approximation is fine.

6. Some math ([reference][2]). Measure (`m`) from the top of your
   head/hair to the bottom of your chin &rarr; 1172 pixels, for
   example &rarr; resolution of the new photo = `1172/1.1875 = 987
   (pixels/in)`.

7. Create a new image:
    * size: 6 x 4 in
    * Under `Advanced`, resolution to `987` (see step above) &larr;
      ignore the warning that you are creating some 200+M file. It's ok.

8. `Image` &rarr; [Configure grid][3], sec to 2x2 in, and `view` to show
   grid. Tried grid offset to 10px, can't see the difference.

9. Select ALL of the cropped new photo (step #4), copy and paste, six
   times, in the grids. You see the result now.

10. Grid line won't print. Use `Filters > Render > Pattern > Grid` to
    add an exact grid line overlay (will be printed as a light gray
    line, perfect!):
     1. width: `1 px`
     2. spacing: `2 in`
     3. offset: `10 px`

10. Save the `.xcf` file (as source), and export to a JPG.

Now just find a place and print a 4x6. Done, done, done!!

[1]: https://docs.gimp.org/en/gimp-tool-iscissors.html
[2]: http://www.robotgeek.org/articles/passport_tutorial/tutorial.html
[3]: https://docs.gimp.org/2.10/en/gimp-image-configure-grid.html
