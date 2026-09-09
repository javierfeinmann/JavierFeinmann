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

// === Events ===
// Upcoming talks only: anything whose date has already passed is filtered out
// automatically, so the section never goes stale on its own.

const MONTHS_SHORT = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

// Parse "YYYY-MM-DD" as a LOCAL date. `new Date("2026-10-15")` would be parsed as
// UTC midnight, which renders as the previous day in negative-offset timezones.
const parseLocalDate = (s) => {
  const m = typeof s === 'string' && s.trim().match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (!m) return null;
  const d = new Date(+m[1], +m[2] - 1, +m[3]);
  return isNaN(d) ? null : d;
};

const startOfToday = () => {
  const n = new Date();
  return new Date(n.getFullYear(), n.getMonth(), n.getDate());
};

// The date badge. Same-month ranges collapse into "3-5"; anything wider keeps the
// start date here and spells the full range out next to the location.
const renderEventBadge = (start, end) => {
  if (!start) {
    return `<div class="event-date"><span class="event-month">Date</span><span class="event-tbc">TBC</span></div>`;
  }
  const sameMonth = end && end.getMonth() === start.getMonth() && end.getFullYear() === start.getFullYear();
  const day = sameMonth && end.getDate() !== start.getDate()
    ? `${start.getDate()}-${end.getDate()}`
    : `${start.getDate()}`;
  return `
    <div class="event-date">
      <span class="event-month">${MONTHS_SHORT[start.getMonth()]}</span>
      <span class="event-day">${day}</span>
      <span class="event-year">${start.getFullYear()}</span>
    </div>`;
};

const fullDate = (d) => `${MONTHS_SHORT[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;

fetchJSON('events.json').then(data => {
  const section = document.getElementById('events');
  const list    = document.getElementById('listEvents');
  if (!section || !list) return;

  const today = startOfToday();

  const upcoming = data
    .map(el => {
      const start = parseLocalDate(el.date);
      const end   = parseLocalDate(el.endDate) || start;
      return { el, start, end };
    })
    // Keep it while the event is still running, not just before it starts.
    // Entries with no usable date are treated as "to be confirmed" and always kept.
    .filter(e => !e.start || e.end >= today)
    .sort((a, b) => {
      if (!a.start) return 1;   // undated entries sink to the bottom
      if (!b.start) return -1;
      return a.start - b.start;
    });

  // An empty "Events" heading looks broken, so drop the section and its nav link.
  if (upcoming.length === 0) {
    section.remove();
    const navLink = document.querySelector('.nav-link[href="#events"]');
    if (navLink) navLink.closest('.nav-item')?.remove();
    return;
  }

  upcoming.forEach(({ el, start, end }) => {
    const item = document.createElement('li');
    item.className = 'event-card';

    const crossesMonths = start && end && end > start &&
      (end.getMonth() !== start.getMonth() || end.getFullYear() !== start.getFullYear());

    const kindHTML  = el.kind ? `<span class="event-kind">${el.kind}</span>` : '';
    const rangeHTML = crossesMonths ? `<div class="event-range">${fullDate(start)} - ${fullDate(end)}</div>` : '';
    const locHTML   = el.location ? `<div class="event-location">${el.location}</div>` : '';

    const label = (el.linkLabel && el.linkLabel.trim()) || 'Slides';
    const linkHTML = (el.link && el.link.trim())
      ? ` <b>[<a href="${el.link}" target="_blank" rel="noopener noreferrer">${label}</a>]</b>`
      : '';

    // A literal "TBD" is a placeholder, not a title: render it as muted plain text
    // so it doesn't read like a paper actually called TBD.
    const paperText = (el.paper || '').trim();
    const paperHTML = !paperText
      ? ''
      : /^(tbd|tba|tbc)$/i.test(paperText)
        ? `<div class="event-paper event-paper-tbc">Paper to be confirmed</div>`
        : `<div class="event-paper"><i>${paperText}</i>${linkHTML}</div>`;

    item.innerHTML = `
      ${renderEventBadge(start, end)}
      <div class="event-info">
        <div class="event-name">${el.event || ''}${kindHTML}</div>
        ${rangeHTML}
        ${locHTML}
        ${paperHTML}
      </div>
    `;

    list.appendChild(item);
  });
});

// === Data & Codes directory toggles ===
document.querySelectorAll('.folder').forEach(folder => {
  folder.addEventListener('click', function () {
    const subMenu = this.nextElementSibling;
    if (subMenu) subMenu.classList.toggle('show');
  });
});