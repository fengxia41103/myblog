import React, { StrictMode, useState, useEffect, useMemo } from "react";
import { createRoot } from "react-dom/client";
import { debounce, isUndefined, isEmpty, range, filter } from "lodash";

const randomId = () => {
  return "MY" + (Math.random() * 1e32).toString(12);
};

const ItemBox = (props) => {
  // this is absolute path already!
  const { title, url, tags } = props;

  return (
    <div className="section">
      <div className="row">
        <div className="col l2 m2 s12">
          <i className="fa fa-tag">&nbsp;</i>
          {tags}
        </div>
        <div className="col l7 m7 s8 myhighlight">{title}</div>
        <div className="col l3 m3 s4 right-align">
          <a href={url}>read more</a>
        </div>
      </div>
      <div className="divider" />
    </div>
  );
};

export default function SearchBox(props) {
  const [inSearch, setInSearch] = useState("");
  const [articles, setArticles] = useState([]);

  useEffect(() => {
    // TODO: this is a hardcoded path to this `.json`.
    // Should be resolved by SITEURL.
    fetch("tipuesearch_content.json")
      .then((resp) => resp.json())
      .then((data) => {
        setArticles(data);
      });
  }, []);

  let items = articles?.pages;
  if (inSearch) {
    items = filter(
      items,
      (p) => p.title.search(inSearch) > 0 || p.text.search(inSearch) > 0
    );
  }

  // display all pages or filtered items
  if (items) {
    items = items.map((p) => {
      return <ItemBox key={p.url} {...p} />;
    });
  }

  // render
  return (
    <div>
      <SearchInput handleChange={(event) => setInSearch(event.target.value)} />
      {items}
    </div>
  );
}

const SearchInput = (props) => {
  const { handleChange } = props;
  return (
    <div className="input-field">
      <input type="text" placeholder="Search content" onChange={handleChange} />
    </div>
  );
};

const rootElem = document.getElementById("search");
if (rootElem) {
  const root = createRoot(rootElem);
  root.render(
    <StrictMode>
      <SearchBox />
    </StrictMode>
  );
}
