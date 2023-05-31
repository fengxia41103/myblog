Title: Python handling PDF
Date: 2023-05-31 10:34
Slug: python handling pdf
Author: Feng Xia

It was a task I encountered in the China visa job whereas I need to
extract info from a PDF file that has been generated from the online
website. In its reverse, business also needs to generate PDF doc such
as an invoice so we could email them to customer. Since these tasks
are handled by backend and my backend is usually Django, it's
important to figure out a general solution to handle PDF parsing and
generation.

# Generate a PDF

There are two ways to generate PDF: generate a HTML and print to PDF
using browser, or generate a PDF in backend and (auto) download. The
first one is universal. It has no issue of many of the quirks such as
fonts. It's an WYSIWYG solution. The second one, on the other hand, is
relying on [xhtml2pdf][1], which comes a few things you need to know.

Why we opt for one versus the other? In short, the printer solution is
easiest but it keeps no record of a user's action. This is fine for
docs such as manuals, instructions, those general-purpose docs. But in
the visa business, we are passing onto prospective customers of some
docs/forms that we wanted them to fill and used in their later
application. Therefore, these docs, most of them, bear some customer
info in the doc such as their name. For these we wanted to keep them
as a track record of a customer engagement so that we know what have
been sent to a customer. So the PDF, if sent, was saved. Therefore,
it makes sense to let backend: generate the file &rarr; storage &rarr;
link to customer's account w/ timestamp and other meta &rarr; customer
downloads it (could be on-the-spot or a download link).


## workflow

The general workflow is the same for both solutions because you are
always generating a HTML version of the doc first. Therefore, in
Django there is always a template, CSS and so on. The different would
be that:

1. templates: `xhtml2pdf` solution takes some additional CSS in order
   to work (see "Asian fonts" below). Printer solution, on the other
   hand, works pretty much as-is because the PDF is rendered as an
   image (I believe). So as long as the HTML looks right, the PDF will
   be fine.

2. download/email: these are only available when using `xhtml2pdf`
   because backend now has the chance to handle different _action_
   depending on the function we want to provide. Printer solution has
   no control over the generation step, thus having no such capability.

## Asian fonts, inconsistency

When using `xhtml2pdf`, you have to set to use [these fonts][2] if
your doc is in Chinese. This, however, will make the generated doc
looks **different** from the HTML version! I don't have a solution for
this. Additionally, because of the fonts I had to enlarge some
`font-size` as shown below in order to make them easy to read. These
are side effects.


```css
<style type="text/css">
 body {
   font-family: STSong-Light;
   margin-left: 1cm;
   margin-right: 1cm;
   margin-top: 1cm;
 }

 h1 {
   font-size: 16pt;
 }

 li, p {
   font-size: 12pt;
 }

</style>
```

## html from template

I won't go into details of a Django template setup. My basic setup has
a `pdf_layout.html` which inherits a `base.html`. Then, individual PDF
doc's template is inheriting the `pdf_layout.html`, mostly just now
filling in different segments of contents based on the doc's purpose.

Once you have these, prepare Django for the rendering:

```python
def pdf_visa_cancellation(request, application_id, action):
    application = Application.objects.get(id=application_id)
    person = application.for_whom
    context = {"application": application, "person": person, "today": date.today()}
    template = "pdf_visa_cancellation.html"

    # render html
    return render(request, template, context)
```

## PDF generator class

First, we define a generator class as the engine. Given `context` and
`template`, it would have enough info to generate a HTML. Then the
`filename` determines the actual file being persisted in file storage
based on the `MEDIA_ROOT`. You can read more [here][3].

```python

import os

from django.conf import settings
from django.contrib.staticfiles import finders
from django.http import HttpResponse
from django.template.loader import get_template
from xhtml2pdf import pisa


class PDFGenerator:
    def __init__(self, context, template, filename):
        self.context = context
        self.template = template
        self.filename = filename

    # https://xhtml2pdf.readthedocs.io/en/latest/usage.html#using-xhtml2pdf-in-django
    def link_callback(self, uri, rel):
        """
        Convert HTML URIs to absolute system paths so xhtml2pdf can access those
        resources
        """
        result = finders.find(uri)
        if result:
            if not isinstance(result, (list, tuple)):
                result = [result]
            result = list(os.path.realpath(path) for path in result)
            path = result[0]
        else:
            sUrl = settings.STATIC_URL  # Typically /static/
            sRoot = settings.STATIC_ROOT  # Typically /home/userX/project_static/
            mUrl = settings.MEDIA_URL  # Typically /media/
            mRoot = (
                settings.MEDIA_ROOT
            )  # Typically /home/userX/project_static/media/

            if uri.startswith(mUrl):
                path = os.path.join(mRoot, uri.replace(mUrl, ""))
            elif uri.startswith(sUrl):
                path = os.path.join(sRoot, uri.replace(sUrl, ""))
            else:
                return uri

        # make sure that file exists
        if not os.path.isfile(path):
            raise Exception("media URI must start with %s or %s" % (sUrl, mUrl))
        return path

    def export(self):
        # proceed to create PDF
        # Create a Django response object, and specify content_type as pdf
        response = HttpResponse(content_type="application/pdf")
        response[
            "Content-Disposition"
        ] = f'attachment; filename="{self.filename}.pdf"'
        template = get_template(self.template)
        html = template.render(self.context)

        # create a pdf
        pisa_status = pisa.CreatePDF(
            html, dest=response, link_callback=self.link_callback, encoding="UTF-8"
        )

        # if error then show some funny view
        if pisa_status.err:
            return HttpResponse("We had some errors <pre>" + html + "</pre>")
        return response

```

## download immediately

Then, generating a PDF and return a `HTTPResponse` object which will
trigger an **immediate download** on the browser end.

```python
# find the template and render it.
pdf_filename = f"{application.cova}-visa-cancellation"
generator = PDFGenerator(context, template, pdf_filename)
pdf = generator.export()

# download immediately
return pdf

```

## email body & as attachment

The HTML template can generate an email body directly. Here I'm
showing how to attach the generated PDF as an email attachment.

```python
message = EmailMessage(
    subject="Chinese Visa Application Supplementary Doc: Deprecate Old
    Visa",

    # email body generated from template
    body=get_template(template).render(context),

    from_email="chinesevisaexpress1@gmail.com",
    to=[application.for_whom.email],
    reply_to=["chinesevisaexpress1@gmail.com"],
)
message.content_subtype = "html"

# attach generated PDF
message.attach(pdf_filename, pdf.content, "application/pdf")
message.send()
```

# Parse a PDF

Extracting info out of a PDF isn't an easy one. Here I'm using the
[py-pdf-parser][4]. The trick mostly lies in the structure of the file
itself that what you think the element should be isn't.

There isn't a general solution to this. You will be dealing w/ a lot
of data anomaly such as index of the info you want, empty/null data,
matching data broken to multiple lines, things like these. The general
capability of reading the doc in general is there. I would say it
works 90+% of the time. Hey, if it could parse a Chinese-made PDF, I
would certainly expect it to handle other (better structured) docs,
better.

```python

import logging
import re

from py_pdf_parser.loaders import load_file

from visa.utils.normalizer import Normalizer

logger = logging.getLogger("visa")


class MyPDFParser(Normalizer):
    def __init__(self, filename):
        self.filename = filename
        self.doc = load_file(filename)
        self.data = [el.text() for el in self.doc.elements]

    def parse(
        self,
        title,
        force_to_index=None,
        direction="below",
        split_index=0,
        delimiter="\n",
    ):
        logger.debug("-" * 50)
        logger.debug(f"Parsing: {title}")

        found = None

        # search
        full_list = self.doc.elements
        for el in full_list:
            if title in el.text():
                if direction == "below":
                    found = full_list.below(el)
                elif direction == "right":
                    found = full_list.to_the_right_of(el)
                elif direction == "above":
                    found = full_list.above(el)
                break

        if found:
            # logger.debug([x.text() for x in found])
            result = [x.text() for x in found][force_to_index or 0]
        else:
            result = ""

        # cleansing
        result = result.split(delimiter)[split_index]
        result = "" if "/" in result else result

        logger.debug(f"{title}: {result}")
        return re.sub(r"\s+", " ", result).strip()

    def parseByIndex(self, index):
        # TODO: no data!?
        if not self.data:
            print(f"{self.filename}: no data")
            return

        return self.data[index].split(r"：")[-1]

    def parseByKey(self, keys):
        logger.debug("-" * 50)
        logger.debug(f"Parsing: {keys}")

        pat = re.compile(rf"{keys[-1]}\s?[:：]\s?(?P<value>\S+)")

        result = ""
        full_list = self.doc.elements
        content = ""
        for index, el in enumerate(full_list):
            content = el.text()

            if all([key in content for key in keys]):
                content = "\n".join([x.text() for x in full_list[index:]])

                break

        tmp = pat.search(content)
        if tmp:
            result = tmp.group("value")

            logger.debug(f"{keys}: {result}")
            return re.sub(r"\s+", " ", result).strip()
        return ""

```

[1]: https://xhtml2pdf.readthedocs.io/en/latest/
[2]: https://xhtml2pdf.readthedocs.io/en/latest/reference.html#asian-fonts-support
[3]: https://xhtml2pdf.readthedocs.io/en/latest/usage.html
[4]: https://py-pdf-parser.readthedocs.io/en/latest/
