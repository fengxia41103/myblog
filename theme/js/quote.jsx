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

const rootElem = document.getElementById("quote");
if (rootElem) {
  const root = createRoot(rootElem);
  root.render(
    <StrictMode>
      <QuoteBox />
    </StrictMode>
  );
}
