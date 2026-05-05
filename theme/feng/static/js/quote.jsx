import React, { StrictMode, useState, useEffect } from "react";
import { createRoot } from "react-dom/client";

export default function QuoteBox(props) {
  const [quote, setQuote] = useState(null);
  const [img, setImg] = useState(null);
  const [loading, setLoading] = useState(false);

  const getImage = () => {
    setLoading(true);

    const min = 1,
      max = 2900;
    const id = Math.floor(Math.random() * (max - min) + min);

    const apiUrl = `https://xkcd.vercel.app/?comic=${id}`;
    fetch(apiUrl)
      .then((resp) => resp.json())
      .then((data) => {
        setQuote(data.title);
        setImg(data.img);
        setLoading(false);
      })
      .catch(() => setLoading(false));
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
