// ==UserScript==
// @name Comic Reader
// @namespace Local
// @match http://www.girlgeniusonline.com/comic.php*
// @grant none
// ==/UserScript==
// 
//

function createLink (url, text) {
  let link = document.createElement("a");
  if(url) {
    link.href = url;
  }
  link.innerHTML = text;
  return link;
}

function readUrlFromA (selector) {
  let ae = document.querySelector(selector);
  if(ae !== null) {
    return ae.href;
  } else {
    return false;
  }
}

function initReadMode (
  {
    overlayId = 'myreader',
    next = false,
    prev = false,
    first = false,
    last = false,
    content = false
  } = {}) {
  
  let css = `
  #${overlayId} {
    position: fixed;
    display: block;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0,0,0,0.7); /* Black background with opacity */
    z-index: 999; /* Specify a stack order in case you're using a different order for other elements */
    text-align: center;
  }

  #${overlayId} .container {
    display: flex;
    flex-wrap: nowrap;
    height: 100%;
    width: 100%;
    overflow-x: auto;
  }

  #${overlayId} .container > *{
    margin-top: 1em;
    margin-bottom: 1em;
  }
  
  #${overlayId} a {
    color: white;
  }

  #${overlayId} a:hover[href] {
    text-decoration: underline;
  }

  #${overlayId} a:not([href]) {
    text-decoration: line-through;
  }

  #${overlayId} .prev {
    text-align: left;
    padding-right: 1em;
    margin-left:auto;
  }

  #${overlayId} .next {
    text-align: right;
    padding-left: 1em;
    margin-right:auto;
  }

  #${overlayId} .comic {
    display: inline-block;
    overflow-y: auto;
    min-width: 60rem;
  }

  #${overlayId} .comic > * {
    margin: auto;
  }

  #${overlayId} .comic p {
    max-width: 60em;
    color: white;
  }
  `

  console.log('Initializing read mode');
  
  var head = document.getElementsByTagName('head')[0];
  if (head) {
    var newCss = document.createElement('style');
    newCss.type = "text/css";
    newCss.innerHTML = css;
    head.appendChild(newCss); 
  }
  
  let overlay = document.createElement("div");
  overlay.setAttribute('id', overlayId);
  
  let container = document.createElement("div");
  container.classList.add('container');
  
  let prefFirst = document.createElement("div");
  prefFirst.classList.add('prev');
  prefFirst.appendChild(createLink(prev, '◀'));
  prefFirst.appendChild(document.createElement('br'));
  prefFirst.appendChild(createLink(first, '◀◀'));
  container.appendChild(prefFirst);
  
  let comic = document.createElement('div');
  if(content.length) {
    for(let i = 1; i < content.length; i++) {
      comic.appendChild(content[i].cloneNode(true));
    }
  } else {
    comic.appendChild(content.cloneNode(true));
  }
  comic.classList.add('comic');
  container.appendChild(comic);
  
  let nextLast = document.createElement("div");
  nextLast.classList.add('next');
  nextLast.appendChild(createLink(next, '▶'));
  nextLast.appendChild(document.createElement('br'));
  nextLast.appendChild(createLink(last, '▶▶'));
  nextLast.appendChild(document.createElement('br'));
  let closeLink = createLink('#', 'Close');
  closeLink.addEventListener('click', e => {
    overlay.parentNode.removeChild(overlay);
    document.body.style = '';
  });
  nextLast.appendChild(closeLink);
  container.appendChild(nextLast);
  
  overlay.appendChild(container);
  
  document.body.appendChild(overlay);
  
  document.body.style = 'overflow: hidden;'

  document.addEventListener('keyup', e => {
    switch(e.key) {
      case 'ArrowRight':
        window.location = next;
        break;
      case 'ArrowLeft':
        window.location = prev;
    }
  });
}

var currentLoc = document.location;

var configs = [
  {
    url: /http:\/\/www.girlgeniusonline.com\/comic.php*/,
    get next() {
      return readUrlFromA('#bottomnext');
    },
    get prev() {
      return readUrlFromA('#bottomprev');
    },
    get first () {
      return readUrlFromA('#bottomfirst');
    },
    get last () {
      return readUrlFromA('#bottomlast');
    },
    get content () {
      return document.getElementById('comicbody').children;
    }
  }
]

let config = {};

for(let i = 0; i < configs.length; i++) {
  config = configs[i];
  if(configs[i].url.test(window.location)){
    config[i] = config;
  }
}

initReadMode(config);
