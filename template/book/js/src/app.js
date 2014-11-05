(function(){

  var pages = document.getElementsByClassName('page'),

      progressBarEl = document.getElementById('progress-bar'),
      currentPageEl = document.getElementById('current-page-number'),
      pageTotalEl = document.getElementById('page-total'),

      prevPageBtn = document.getElementById('prev-page-btn'),
      nextPageBtn = document.getElementById('next-page-btn'),

      currPageIdx = 0,

      switchPage = function(currPageIdx, newPageIdx){
         B(pages[ currPageIdx ]).removeClass('visible');
         B(pages[ newPageIdx ]).addClass('visible');

         window.scrollTo(0, 0);

         //update footer indicators
         currentPageEl.innerText = newPageIdx+1;
         progressBarEl.style.width = 100/pages.length*(newPageIdx+1)+'%';
      },

      nextPage = function(currPageIdx){
        var nextPageIdx = pages[currPageIdx+1] !== undefined ? currPageIdx+1 : 0;

        switchPage(currPageIdx, nextPageIdx);
        history.pushState([(nextPageIdx+1), 0], 'Page: '+(nextPageIdx+1), '?page='+(nextPageIdx+1));

        return nextPageIdx;
      },

      prevPage = function(currPageIdx){
        var prevPageIdx = pages[currPageIdx-1] !== undefined ? currPageIdx-1 : pages.length-1;

        switchPage(currPageIdx, prevPageIdx);
        history.pushState([(prevPageIdx+1), 0], 'Page: '+(prevPageIdx+1), '?page='+(prevPageIdx+1));

        return prevPageIdx;
      },

      goToState = function(pageIdx){
        switchPage(currPageIdx, pageIdx);
        currPageIdx = pageIdx;
      };

  //if hash available
  //extract pageIdx
  if(location.search !== ''){

    var hash = location.search,
        pageIdx = Number(hash.match(/page\=(\d+)/)[1])-1;

    goToState(pageIdx);

  } else {
    //make first slide visible
    B(pages[currPageIdx]).addClass('visible');
  }

  //set total number of pages
  pageTotalEl.innerText = pages.length;

  //listen for back or forward button on browser
  window.addEventListener('popstate', function(e){

    var state = e.state;

    if(state !== null) {
      goToState(state[0]-1);
    } else {
      goToState(0);
    }

  });

  document.addEventListener('keyup', function(e){

    if(e.keyCode === 39){
      //next (arrow or space)
      currPageIdx = nextPage(currPageIdx);
    } else if(e.keyCode === 37){
      //prev
      currPageIdx = prevPage(currPageIdx);
    }

  }, false);

  B(prevPageBtn).click(function(e){
    e.preventDefault();
    currPageIdx = prevPage(currPageIdx);
  });

  B(nextPageBtn).click(function(e){
    e.preventDefault();
    currPageIdx = nextPage(currPageIdx);
  });

}());