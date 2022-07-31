"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _slicedToArray = (function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; })();

exports["default"] = PresentationBox;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _react = require("react");

var _react2 = _interopRequireDefault(_react);

var _lodash = require("lodash");

var OneBox = function OneBox(props) {
  // props
  var onClick = props.onClick;
  var image = props.image;
  var displayList = props.displayList;
  var setImage = props.setImage;

  (0, _react.useEffect)(function () {
    j$(".materialboxed").materialbox();
  });

  return _react2["default"].createElement(
    "div",
    null,
    undefined.props.showMore ? _react2["default"].createElement(
      "div",
      { id: "showMore", onClick: onClick },
      _react2["default"].createElement("i", { className: "fa fa-expand" }),
      "Show all"
    ) : null,
    _react2["default"].createElement(
      "div",
      { className: "row center-align" },
      _react2["default"].createElement("img", { src: image.full, className: "col s12 z-depth-5 materialboxed" }),
      _react2["default"].createElement(DisplayListBox, { displayList: displayList, onClick: setImage })
    )
  );
};

var DisplayListBox = function DisplayListBox(props) {
  var displayList = props.displayList;

  var imageThumbs = displayList.map(function (img) {
    return _react2["default"].createElement("img", {
      key: img.key,
      onClick: undefined.props.onClick.bind(null, img),
      className: "mythumbnail",
      src: img.thumb
    });
  });

  return _react2["default"].createElement(
    "div",
    { className: "col s12" },
    imageThumbs,
    _react2["default"].createElement(
      "div",
      null,
      _react2["default"].createElement(
        "strong",
        null,
        "Tips"
      ),
      ": use keyboard ← & → to flip."
    )
  );
};

var ImageField = function ImageField(props) {
  var img = props.img;
  var onClick = props.onClick;

  return _react2["default"].createElement(
    "div",
    { style: { display: "block" }, className: "hoverable" },
    _react2["default"].createElement(
      "span",
      { onClick: onClick.bind(null, img) },
      _react2["default"].createElement("img", { src: img.thumb, width: "95%" })
    )
  );
};

function PresentationBox(props) {
  var _useState = (0, _react.useState)([]);

  var _useState2 = _slicedToArray(_useState, 2);

  var images = _useState2[0];
  var setImages = _useState2[1];

  var _useState3 = (0, _react.useState)(images[70]);

  var _useState32 = _slicedToArray(_useState3, 2);

  var showing = _useState32[0];
  var setShowing = _useState32[1];

  var _useState4 = (0, _react.useState)(true);

  var _useState42 = _slicedToArray(_useState4, 2);

  var showMore = _useState42[0];
  var setShowMore = _useState42[1];

  var _useState5 = (0, _react.useState)([]);

  var _useState52 = _slicedToArray(_useState5, 2);

  var displayList = _useState52[0];
  var setDisplayList = _useState52[1];

  var handleUpdate = null;

  // event handlers
  var handleKeyNavigation = function handleKeyNavigation(e) {
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
  var handleImageFieldClick = function handleImageFieldClick(img) {
    setShowiing(img);

    // toggle show more
    toggleShowMore();
  };

  var onNext = function onNext() {
    if (showing.key === images.length) {
      // Circle back to beginning
      setShowing(images[0]);
    } else {
      // set current to next
      setShowing(images[showing.key]);
    }

    handleUpdate();
  };

  var onPrev = function onPrev() {
    if (showing.key == 1) {
      // Circle back
      setShowing(images[images.length - 1]);
    } else {
      // set current to next
      setShowing(images[current.key - 2]);
    }

    handleUpdate();
  };

  // effects
  (0, _react.useEffect)(function () {
    setImages([].concat(_toConsumableArray(Array(125).keys())).map(function (i) {
      var pad = "0000";
      var str = "" + i;
      var name = pad.substring(0, pad.length - str.length) + str;
      return {
        key: i,
        thumb: "images/memory/" + name + "-small.jpg",
        full: "images/memory/" + name + ".jpg"
      };
    }));

    // register key event to allow
    // navigation using arrow keys
    document.onkeydown = handleKeyNavigation;

    // populate display list
    handleUpdate = (0, _lodash.debounce)(_handleUpdate, 1000);
    handleUpdate();
  });

  var toggleShowMore = function toggleShowMore() {
    return setShowMore(!showMore);
  };

  var _handleUpdate = function _handleUpdate() {
    // Always show odd number of photos
    var MYLENGTH = 11;
    var start = Math.max(0, showing.key - Math.floor(MYLENGTH / 2));
    var end = Math.min(showing.key + Math.floor(MYLENGTH / 2), images.length - 1);

    var tmp = images.slice(start, end);

    // if we are at the end of array, rotate back to beginning
    if (MYLENGTH - tmp.length > 0) {
      tmp = images.slie(0, MYLENGTH - tmp.length);
    }
    setDisplayList(tmp);
  };

  var imageFields = images.map(function (img) {
    return _react2["default"].createElement(ImageField, { img: img, onClick: handleImageFieldClick, key: img.key });
  });

  return _react2["default"].createElement(
    "div",
    null,
    showMore ? _react2["default"].createElement(OneBox, _extends({
      image: showing,
      onClick: toggleShowMore,
      setImage: setShowing
    }, { showMore: showMore, onNext: onNext, onPrev: onPrev, displayList: displayList })) : _react2["default"].createElement(
      "div",
      { className: "my-multicol-3" },
      imageFields
    )
  );
}

_react.ReactDOM.render(_react2["default"].createElement(PresentationBox, null), document.getElementById("sth"));
module.exports = exports["default"];