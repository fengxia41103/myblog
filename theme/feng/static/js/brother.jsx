import React, { StrictMode, useState, useEffect, useMemo } from "react";
import { createRoot } from "react-dom/client";
import { debounce, isUndefined, isEmpty, range } from "lodash";

const OneBox = (props) => {
  // props
  const { onClick, image, displayList, setImage, showMore } = props;

  return (
    <div>
      {showMore ? (
        <div id="showMore" onClick={onClick}>
          <i className="fa fa-expand"></i>
          Show all
        </div>
      ) : null}

      <div className="row center-align">
        <img src={image?.full} className="col s12 z-depth-5" />
        <DisplayListBox displayList={displayList} onClick={setImage} />
      </div>
    </div>
  );
};

const DisplayListBox = (props) => {
  const { displayList, onClick } = props;

  const imageThumbs = displayList.map((img) => (
    <img
      key={img.key}
      onClick={onClick.bind(null, img)}
      className="mythumbnail"
      src={img.thumb}
    />
  ));

  return (
    <div className="col s12">
      {imageThumbs}
      <div>
        <strong>Tips</strong>: use keyboard &larr; & &rarr; to flip.
      </div>
    </div>
  );
};

const ImageField = (props) => {
  const { img, onClick } = props;

  return (
    <div style={{ display: "block" }} className="hoverable">
      <span onClick={onClick.bind(null, img)}>
        <img src={img.thumb} width="95%" />
      </span>
    </div>
  );
};

export default function PresentationBox(props) {
  const loadingImages = useMemo(
    () =>
      [...range(1, 125)].map((i) => {
        const pad = "0000";
        const str = "" + i;
        const name = pad.substring(0, pad.length - str.length) + str;
        return {
          key: i,
          thumb: "images/memory/" + name + "-small.jpg",
          full: "images/memory/" + name + ".jpg",
        };
      }),
    []
  );
  const [images, setImages] = useState(loadingImages);
  const [showing, setShowing] = useState(loadingImages[70]);
  const [showMore, setShowMore] = useState(true);
  const [displayList, setDisplayList] = useState([]);

  // event handlers
  const handleKeyNavigation = (e) => {
    switch (e.keyCode) {
      case 37:
        // left arrow key
        onPrev();
        break;
      case 39:
        // right arrow key
        onNext();
        break;
    }
  };

  const handleImageFieldClick = (img) => {
    setShowing(img);

    // toggle show more
    toggleShowMore();
  };

  const onNext = () => {
    const next = showing.key + 1;

    if (next === images.length) {
      // Circle back to beginning
      setShowing(images[0]);
    } else {
      // set current to next
      setShowing(images[next]);
    }
  };

  const onPrev = () => {
    if (showing.key == 1) {
      // Circle back
      setShowing(images[images.length - 1]);
    } else {
      // set current to next
      setShowing(images[showing.key - 2]);
    }
  };

  // effects

  useEffect(() => {
    // register key event to allow
    // navigation using arrow keys
    document.onkeydown = handleKeyNavigation;

    // populate display list
    _handleUpdate();
  }, [showing]);

  // helpers
  const toggleShowMore = () => setShowMore(!showMore);

  const _handleUpdate = () => {
    // Always show odd number of photos
    const MYLENGTH = 11;
    let start = Math.max(0, showing?.key || 0 - Math.floor(MYLENGTH / 2));
    let end = Math.min(
      showing?.key || 0 + Math.floor(MYLENGTH / 2),
      images.length - 1
    );

    let tmp = images.slice(start, end);

    // if we are at the end of array, rotate back to beginning
    if (MYLENGTH - tmp.length > 0) {
      tmp = images.slice(0, MYLENGTH - tmp.length);
    }

    setDisplayList(tmp);
  };

  // render
  if (isEmpty(images) || isUndefined(showing)) return null;

  const imageFields = images.map((img) => (
    <ImageField
      img={img}
      onClick={(e) => handleImageFieldClick(img)}
      key={img?.key}
    />
  ));

  return (
    <div>
      {showMore ? (
        <OneBox
          image={showing}
          onClick={toggleShowMore}
          setImage={setShowing}
          {...{ showMore, onNext, onPrev, displayList }}
        />
      ) : (
        <div className="my-multicol-3">{imageFields}</div>
      )}
    </div>
  );
}

const rootElem = document.getElementById("sth");
const root = createRoot(rootElem);
root.render(
  <StrictMode>
    <PresentationBox />
  </StrictMode>
);
