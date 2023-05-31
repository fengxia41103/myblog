Title: Fedex API generating label
Date: 2023-05-31 11:33
Slug: fedex api generating label
Author: Feng Xia

[Fedex API][1] is complex. A few things you want to watch out:

1. When googling Fedex API, the top returns are usually 3rd API who
   _supports_ Fedex. **Not covered here**.

2. **Always**, use the **test** credentials and API endpoints for
   development. Switch to production when you are ready for
   production.

3. Once you generate a _test_ label, it requires a **verification**
   step by Fedex team. Email it to them and wait for approval. This is
   a human process I guess.

4. It appears to be a micro-service architecture because each service
   gets its own API endpoint. This makes integration a bit tedious
   because each endpoint requires a different learning curve. Not for
   a faint heart. For label, use [ship API][2]. It's a long doc, but
   not difficult to understand once you get a feel of it.

To generate a label, 5 steps:

1. Get an authentication token from API
2. Compose sender info
3. Compose recipients info
4. Set shipment method values. Many are `enumeration` values specified
   by the Fedex doc (they are in CAPITAL letters!).
5. Call API. If successful, returning JSON body has: tracking number,
   ship date stamp, and URL to download the label PDF

## Get authentication token

Once you create an account on the dev portal, you would be given a
`key` and `secret`. Use these to get a token:

```python

def get_new_token(self):
    headers = {"content-type": "application/x-www-form-urlencoded"}
    token_req_payload = {
        "grant_type": "client_credentials",
        "client_id": FEDEX_KEY,
        "client_secret": FEDEX_SECRET,
    }

    response = requests.post(
        f"{FEDEX_API}/oauth/token",
        headers=headers,
        data=token_req_payload,
        verify=False,
        allow_redirects=False,
    )
    return response.json().get("access_token")
```

## HTTP header

Once you have the token, you need to include it in all the
consecutive calls. Note that you **must set `x-locale`**.

```python
token = self.get_new_token()
self.headers = {
    "content-type": "application/json",
    "x-locale": "en-US",
    "Authorization": f"Bearer {token}",
}
```

## sender

Two basic info to setup sender: `address` and `contact`. The bits
below are the minimal to keep the API happy:

```python
me = {
    "address": {
        "streetLines": ["xxx"],
        "city": "xxx",
        "stateOrProvinceCode": "NC",
        "postalCode": "27713",
        "countryCode": "US",
    },
    "contact": {
        "personName": "xxx",
        "emailAddress": "xxx",
        "phoneNumber": "xxx",
        "companyName": "xxx",
    },
}
```

## recipients

It's a **list**. Again, minimal below to keep the API happy:

```python
recipients = [
    {
        "address": {
            "streetLines": [for_whom.street_address],
            "city": for_whom.city,
            "stateOrProvinceCode": for_whom.state,
            "postalCode": for_whom.zipcode,
            "countryCode": "US",
        },
        "contact": {
            "personName": for_whom.last_name_then_first_name,
            "emailAddress": for_whom.email
            "phoneNumber": for_whom.phone[-10:]
        },
    }
]

```

## shipping method

Tweak based on your shipment preference. These are the minimal info
needed for my purpose.

```python
shipment = {
    "shipper": me,
    "recipients": recipients,
    "pickupType": "DROPOFF_AT_FEDEX_LOCATION",
    "serviceType": "FEDEX_EXPRESS_SAVER",
    "packagingType": "FEDEX_ENVELOPE",
    "shippingChargesPayment": {"paymentType": "SENDER"},
    "labelSpecification": {
        "labelStockType": "PAPER_4X6",
        "imageType": "PDF",
    },
    "requestedPackageLineItems": [{"weight": {"units": "LB", "value": 1}}],
}
```

## call API

Now we have all the pieces to call the API to give us a label.

```python
response = requests.post(
    f"{FEDEX_API}/ship/v1/shipments",
    headers=self.headers,
    data=json.dumps(
        {
            "accountNumber": {"value": FEDEX_ACCOUNT},
            "labelResponseOptions": "URL_ONLY",
            "requestedShipment": shipment,
        }
    ),
)

resp = response.json()

# error
if not resp or not resp.get("output"):
    logger.error(response)
    return
```

## response

In response, if successful, will be a JSON which has a master tracking
number, a ship date stamp, and a URL to download label in PDF. The URL
is by choice. You could also receive the PDF as a file directly, I
think. But I think it's better to save the URL in my app instead of
storing the file. **Note** that the URL expires after, I think, 48
hours? There is no harm to generate a new label. The unused one will
be deprecated and has no charge. So in my case, I let the user to
click a button on UI to generate label, put this request to a celery
queue which in turn calls the API, then the URL is shown as a link on
the UI, then user can download whenever.

```python
info = resp.get("output").get("transactionShipments")[0]
master_tracking = info.get("masterTrackingNumber")
shipping_date = info.get("shipDatestamp")

info = info.get("pieceResponses")[0]
pdf_url = info.get("packageDocuments")[0].get("url")
```

Seems simple!? Cause I have done the hard part. Thank me.

[1]: https://developer.fedex.com/api/en-us/get-started.html
[2]: https://developer.fedex.com/api/en-us/catalog/ship/v1/docs.html
