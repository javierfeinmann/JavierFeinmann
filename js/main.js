// === Grabs ===
const accordionPapers   = document.getElementById('accordionPanelsStayOpenPapers');
const accordionProgress = document.getElementById('accordionPanelsStayOpenProgress');
const listPolicy        = document.getElementById('listPolicy');

// === Helpers ===
const fetchJSON = (url) => fetch(url).then(r => r.json());

const renderCoauthors = (el) => {
  if (Array.isArray(el.coauthors) && el.coauthors.length) {
    const links = el.coauthors
      .map(c => (c.url && c.url.trim())
        ? `<a href="${c.url}" target="_blank" rel="noopener noreferrer">${c.name}</a>`
        : `${c.name}`)
      .join(', ');
    return `<div class="paper-coauthors"><i>Joint with ${links}</i></div>`;
  }
  if (el.coauthor) return `<div class="paper-coauthors"><i>${el.coauthor}</i></div>`;
  return '';
};

const renderBullets = (el) => {
  if (!Array.isArray(el.bullets) || el.bullets.length === 0) return '';
  const items = el.bullets.map(b => `<li>${b}</li>`).join('');
  return `<ul class="paper-bullets">${items}</ul>`;
};

// === Working Papers ===
fetchJSON('wp.json').then(data => {
  data.forEach(element => {
    // Wrapper
    const item = document.createElement('div');
    item.className = 'accordion-item';

    // Header IDs
    const headingId = `panelsStayOpen-heading-${element.id}`;
    const collapseId = `panelsStayOpen-collapse-${element.id}`;

    // Header
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

    // Assemble text column content in your desired order:
    // 1) italic "Joint with …" (names clickable)
    // 2) subtitle (small, optional)
    // 3) bullet points (small font)
    // 4) link to working paper
    // 5) abstract
    const coauthorsHTML = renderCoauthors(element);
    const subtitleHTML  = element.subtitle ? `<div class="paper-subtitle">${element.subtitle}</div>` : '';
    const bulletsHTML   = renderBullets(element);
    const linkHTML      = element.link ? `<div class="paper-link"><b>[<a href="${element.link}" target="_blank" rel="noopener noreferrer">Working paper</a>]</b></div>` : '';
    const abstractHTML  = element.text ? `<p class="paper-abstract">${element.text}</p>` : '';

    body.innerHTML = `
      <div class="accordion-body">
        <div class="row accordion-content">
          <div class="col-sm-4 d-flex justify-content-center">
            <img class="accordion-img" src="./img/research/working_papers/${element.img}.webp"
                 alt="Figure for: ${element.title}">
          </div>
          <div class="col-sm-8 accordion-text">
            ${coauthorsHTML}
            ${subtitleHTML}
            ${bulletsHTML}
            ${linkHTML}
            ${abstractHTML}
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

    // Header
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

    // Reuse the same helpers as papers
    const coauthorsHTML = renderCoauthors(element);  // uses element.coauthors or falls back to element.coauthor
    const subtitleHTML  = element.subtitle ? `<div class="paper-subtitle">${element.subtitle}</div>` : '';
    const bulletsHTML   = renderBullets(element);    // renders <ul> if element.bullets exists

    // Link label: use element.type (strip outer brackets if present), else 'Slides'
    const rawLabel = (element.type || '').trim();
    const label = rawLabel ? rawLabel.replace(/^\[|\]$/g, '') : 'Slides';
    const linkHTML = (element.slides && element.slides.trim())
      ? `<div class="paper-link"><b>[<a href="${element.slides}" target="_blank" rel="noopener noreferrer">${label}</a>]</b></div>`
      : '';

    const abstractHTML = element.text ? `<p class="paper-abstract">${element.text}</p>` : '';

    // No image column for WIP
    body.innerHTML = `
      <div class="accordion-body">
        <div class="accordion-content">
          <div class="accordion-text">
            ${coauthorsHTML}
            ${subtitleHTML}
            ${bulletsHTML}
            ${linkHTML}
            ${abstractHTML}
          </div>
        </div>
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