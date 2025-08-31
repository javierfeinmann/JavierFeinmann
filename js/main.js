// === Grabs ===
const accordionPapers   = document.getElementById('accordionPanelsStayOpenPapers');
const accordionProgress = document.getElementById('accordionPanelsStayOpenProgress');
const listPolicy        = document.getElementById('listPolicy');

// === Helpers ===
const fetchJSON = (url) => fetch(url).then(r => r.json());

// === Working Papers ===
fetchJSON('wp.json').then(data => {
  data.forEach(element => {
    // Wrapper item
    const item = document.createElement('div');
    item.className = 'accordion-item';

    // Header
    const headingId = `panelsStayOpen-heading-${element.id}`;
    const collapseId = `panelsStayOpen-collapse-${element.id}`;

    item.innerHTML = `
      <h2 class="accordion-header" id="${headingId}">
        <button class="accordion-button collapsed" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#${collapseId}"
                aria-expanded="false"
                aria-controls="${collapseId}">
          ${element.title}
        </button>
      </h2>
    `;

    // Body
    const body = document.createElement('div');
    body.id = collapseId;
    body.className = 'accordion-collapse collapse';
    body.setAttribute('aria-labelledby', headingId);
    body.innerHTML = `
      <div class="accordion-body">
        <div class="row accordion-content">
          <div class="col-sm-4 d-flex justify-content-center">
            <img class="accordion-img" src="./img/research/working_papers/${element.img}.jpg"
                 alt="Figure for: ${element.title}">
          </div>
          <div class="col-sm-8 accordion-text">
            <i>${element.coauthor}</i>
            <b> ${element.subtitle}</b>
            <b>[<a href="${element.link}" target="_blank" rel="noopener noreferrer">Working paper</a>]</b>
            <p>${element.text}</p>
          </div>
        </div>
      </div>
    `;

    item.appendChild(body);
    accordionPapers.appendChild(item);
  });
});

// === Advanced Work in Progress ===
fetchJSON('progress.json').then(data => {
  data.forEach(element => {
    const item = document.createElement('div');
    item.className = 'accordion-item';

    const headingId = `panelsStayOpen-heading-${element.id}`;
    const collapseId = `panelsStayOpen-collapse-${element.id}`;

    item.innerHTML = `
      <h2 class="accordion-header" id="${headingId}">
        <button class="accordion-button collapsed" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#${collapseId}"
                aria-expanded="false"
                aria-controls="${collapseId}">
          ${element.title}
        </button>
      </h2>
    `;

    const body = document.createElement('div');
    body.id = collapseId;
    body.className = 'accordion-collapse collapse';
    body.setAttribute('aria-labelledby', headingId);
    body.innerHTML = `
      <div class="accordion-body accordion-text">
        <i>${element.coauthor}</i>
        <b> ${element.subtitle}</b>
        <b>[<a href="${element.slides}" target="_blank" rel="noopener noreferrer">${element.type}</a>]</b>
        <p>${element.text}</p>
      </div>
    `;

    item.appendChild(body);
    accordionProgress.appendChild(item);
  });
});

// === Policy ===
fetchJSON('policy.json').then(data => {
  data.forEach(element => {
    const item = document.createElement('li');
    item.className = 'list-group-item';
    item.innerHTML = `<a href="${element.link}" target="_blank" rel="noopener noreferrer">${element.title}</a>`;
    listPolicy.appendChild(item);
  });
});

// === Data & Codes directory toggles ===
document.querySelectorAll('.folder').forEach(folder => {
  folder.addEventListener('click', function () {
    const subMenu = this.nextElementSibling;
    if (subMenu) subMenu.classList.toggle('show');
  });
});