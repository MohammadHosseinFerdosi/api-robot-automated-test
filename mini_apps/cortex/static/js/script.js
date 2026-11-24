
function applyLogicToAllForms() {
    document.querySelectorAll(".allocation-form").forEach(form => {
        let s1 = form.querySelector(".allocation-type");
        let s2 = form.querySelector(".fund-providers");
        let s3 = form.querySelector(".fee-types");
        let amountInput = form.querySelector(".amount"); 

        if (s1) {
            s1.addEventListener("change", function () {
                updateDropdownOptions(form);
            });
        }

        if (s2) {
            s2.addEventListener("change", function () {
                updateDropdownOptions(form);
            });
        }

        if (amountInput) {
            amountInput.min = 1;
            amountInput.max = 500000;

            amountInput.addEventListener("input", function () {
                if (this.value < 1) {
                    this.value = 1;
                } else if (this.value > 500000) {
                    this.value = 500000;
                }
            });
        }

        updateDropdownOptions(form);
    });
}

function updateDropdownOptions(form) {
    let s1 = form.querySelector(".allocation-type").value;
    let s2 = form.querySelector(".fund-providers");
    let s3 = form.querySelector(".fee-types");

    let previousS2 = s2.value;
    let previousS3 = s3.value;

    let newS2Options = [];
    if (s1 === "1PAY" || s1 === "XPAY" || s1 === "INSTALLMENT_SALE" || s1 === "3PAY") {
        newS2Options = [{ value: "DP", text: "Platform" }];
    } else if (s1 === "CREDIT") {
        newS2Options = [
            { value: "TB", text: "Tejarat" },
            { value: "SD", text: "Saderat" },
            { value: "MLT", text: "Mellat" },
            { value: "GR", text: "Gardeshgari" },
            { value: "CO", text: "Company" }
        ];
    } else {
        newS2Options = [
            { value: "DP", text: "Platform" },
            { value: "TB", text: "Tejarat" },
            { value: "SD", text: "Saderat" },
            { value: "MLT", text: "Mellat" },
            { value: "GR", text: "Gardeshgari" },
            { value: "CO", text: "Company" }
        ];
    }

    s2.innerHTML = "";
    newS2Options.forEach(opt => {
        let option = document.createElement("option");
        option.value = opt.value;
        option.textContent = opt.text;
        s2.appendChild(option);
    });

    let validS2Values = newS2Options.map(opt => opt.value);
    if (validS2Values.includes(previousS2)) {
        s2.value = previousS2;
    } else {
        s2.value = newS2Options[0].value;
    }
    let newS3Options = [];
    if (s1 === "1PAY") {
        newS3Options = [
            { value: "ZERO_FEE", text: "No Fee" },
            { value: "ZERO_FEE_AND_MANUAL_SETTLE", text: "No Fee with Manual Settlement" },
            { value: "ZERO_FEE_AND_MANUAL_OVERDUE", text: "No Fee with Manual Overdue" }
        ];
    } else if (s1 === "3PAY") {
        newS3Options = [
            { value: "ZERO_FEE", text: "No Fee" },
            { value: "ZERO_FEE_AND_MANUAL_SETTLE", text: "No Fee with Manual Settlement" },
            { value: "ZERO_FEE_AND_MANUAL_OVERDUE", text: "No Fee with Manual Overdue" }
        ];
    } else if (s1 === "XPAY") {
        newS3Options = [
            { value: "ZERO_FEE", text: "No Fee" },
            { value: "FEE_ON_PURCHASE", text: "Fee On Purchase" },
            { value: "FEE_ON_INSTALLMENT", text: "Fee On Installment" },
            { value: "FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE", text: "Fee On Installment with Manual Settlement" },
            { value: "FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE", text: "Fee On Installment with Manual Overdue" },
            { value: "FEE_ON_ALLOCATION", text: "Fee On Allocation" }
        ];
    } else if (s1 === "INSTALLMENT_SALE") {
        newS3Options = [
            { value: "ZERO_FEE", text: "No Fee" },
            { value: "ZERO_FEE_AND_MANUAL_SETTLE", text: "No Fee with Manual Settlement" },
            { value: "ZERO_FEE_AND_MANUAL_OVERDUE", text: "No Fee with Manual Overdue" },
            { value: "FEE_ON_PURCHASE", text: "Fee On Purchase" },
            { value: "FEE_ON_INSTALLMENT", text: "Fee On Installment" },
            { value: "FEE_ON_ALLOCATION", text: "Fee On Allocation" }
        ];
    } else if (s1 === "CREDIT") {
        if (s2.value === "CO") {
            newS3Options = [{ value: "FEE_ON_PURCHASE", text: "Fee On Purchase" }];
        } else {
            newS3Options = [
                { value: "ZERO_FEE", text: "No Fee" },
                { value: "FEE_ON_PURCHASE", text: "Fee On Purchase" },
                { value: "FEE_ON_INSTALLMENT", text: "Fee On Installment" },
                { value: "FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE", text: "Fee On Installment with Manual Settlement" },
                { value: "FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE", text: "Fee On Installment with Manual Overdue" },
                { value: "FEE_ON_ALLOCATION", text: "Fee On Allocation" }
            ];
        }
    } else {
        newS3Options = [
            { value: "ZERO_FEE", text: "No Fee" },
            { value: "FEE_ON_PURCHASE", text: "Fee On Purchase" },
            { value: "FEE_ON_INSTALLMENT", text: "Fee On Installment" },
            { value: "FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE", text: "Fee On Installment with Manual Settlement" },
            { value: "FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE", text: "Fee On Installment with Manual Overdue" },
            { value: "FEE_ON_ALLOCATION", text: "Fee On Allocation" }
        ];
    }

    s3.innerHTML = "";
    newS3Options.forEach(opt => {
        let option = document.createElement("option");
        option.value = opt.value;
        option.textContent = opt.text;
        s3.appendChild(option);
    });

    let validS3Values = newS3Options.map(opt => opt.value);
    if (validS3Values.includes(previousS3)) {
        s3.value = previousS3;
    } else {
        s3.value = newS3Options[0].value;
    }
}

document.addEventListener("DOMContentLoaded", applyLogicToAllForms);

// =========================================
// THEME HANDLING
// =========================================

const THEME_COOKIE_KEY = "cortexTheme";
const DEFAULT_THEME = "legacy";

const ALLOWED_THEMES = [
    "neon",
    "legacy",
    "dark",
    "ocean",
    "forest",
    "sunset",
    "terminal",
    "pastel",
    "grayscale",
    "midnight",
    "cyberpunk",
    "aurora",
    "desert",
    "candy",
    "ice",
    "lava",
    "blueprint",
    "solarized",
    "lavender"
];

// Set a cookie
function setCookie(name, value, days) {
    const date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    const expires = "expires=" + date.toUTCString();
    document.cookie =
        name + "=" + value + ";" + expires + ";path=/;SameSite=Lax";
}

// Get a cookie
function getCookie(name) {
    const cookieName = name + "=";
    const decodedCookie = decodeURIComponent(document.cookie);
    const cookieArray = decodedCookie.split(";");
    for (let i = 0; i < cookieArray.length; i++) {
        let cookie = cookieArray[i].trim();
        if (cookie.indexOf(cookieName) === 0) {
            return cookie.substring(cookieName.length, cookie.length);
        }
    }
    return "";
}

// Apply a theme by name
function applyTheme(themeName) {
    const theme = ALLOWED_THEMES.includes(themeName) ? themeName : DEFAULT_THEME;
    document.documentElement.setAttribute("data-theme", theme);
    setCookie(THEME_COOKIE_KEY, theme, 365);

    const select = document.getElementById("themeSelect");
    if (select && select.value !== theme) {
        select.value = theme;
    }
}

// Init theme on page load
document.addEventListener("DOMContentLoaded", function () {
    const select = document.getElementById("themeSelect");
    const savedTheme = getCookie(THEME_COOKIE_KEY) || DEFAULT_THEME;

    applyTheme(savedTheme);

    if (select) {
        select.value = savedTheme;
        select.addEventListener("change", function () {
            applyTheme(select.value);
        });
    }
});

// =========================================
// THEME + OCCASION HANDLING (Cortex)
// =========================================
(function () {
  const THEME_COOKIE_KEY = 'qaCortexTheme';
  const DEFAULT_THEME = 'neon';

  const root = document.documentElement;
  const selectEl = document.getElementById('themeSelect');
  const effectsRoot = document.getElementById('occasion-effects-root');

  // We use data-theme for Cortex (CSS must read [data-theme="..."])
  const THEME_ATTR = 'data-theme';

  const allowedThemes = [
    'neon',
    'occasional',
    'legacy',
    'dark',
    'ocean',
    'forest',
    'sunset',
    'terminal',
    'pastel',
    'grayscale',
    'midnight',
    'cyberpunk',
    'aurora',
    'desert',
    'candy',
    'ice',
    'lava',
    'blueprint',
    'solarized',
    'lavender'
  ];

  // Holidays (±7 days)
  const HOLIDAY_EVENTS = [
    {
      id: 'christmas',
      displayName: 'Christmas',
      baseTheme: 'ocean',
      priority: 100,
      date: year => new Date(year, 11, 25) // Dec 25
    },
    {
      id: 'halloween',
      displayName: 'Halloween',
      baseTheme: 'sunset',
      priority: 90,
      date: year => new Date(year, 9, 31) // Oct 31
    },
    {
      id: 'norouz',
      displayName: 'Norouz',
      baseTheme: 'pastel',
      priority: 80,
      date: year => new Date(year, 2, 20) // ~Mar 20
    },
    {
      id: 'easter',
      displayName: 'Easter',
      baseTheme: 'forest',
      priority: 70,
      date: year => computeWesternEaster(year)
    }
  ];

  // For debug: include seasons as "virtual events"
  const ALL_EVENT_DEFS = HOLIDAY_EVENTS.concat([
    { id: 'spring',  displayName: 'Spring',  baseTheme: 'pastel',  priority: 20 },
    { id: 'summer',  displayName: 'Summer',  baseTheme: 'forest',  priority: 20 },
    { id: 'autumn',  displayName: 'Autumn',  baseTheme: 'sunset',  priority: 20 },
    { id: 'winter',  displayName: 'Winter',  baseTheme: 'ocean',   priority: 20 }
  ]);

  // -------------- Cookie helpers --------------
  function getCookie(name) {
    const parts = ('; ' + document.cookie).split('; ' + name + '=');
    if (parts.length === 2) {
      return parts.pop().split(';').shift();
    }
    return null;
  }

  function setCookie(name, value, days) {
    const date = new Date();
    date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
    document.cookie =
      name +
      '=' +
      value +
      '; expires=' +
      date.toUTCString() +
      '; path=/; SameSite=Lax';
  }

  // -------------- Occasion detection --------------
  function detectOccasion(date) {
    const year = date.getFullYear();
    const t = date.getTime();
    const holidayCandidates = [];

    // 1) Holidays with ±7-day window
    for (const ev of HOLIDAY_EVENTS) {
      const evDate = ev.date(year);
      const start = new Date(evDate.getTime());
      const end = new Date(evDate.getTime());

      start.setDate(start.getDate() - 7);
      end.setDate(end.getDate() + 7);

      if (t >= start.getTime() && t <= end.getTime()) {
        holidayCandidates.push({
          id: ev.id,
          displayName: ev.displayName,
          baseTheme: ev.baseTheme,
          priority: ev.priority
        });
      }
    }

    if (holidayCandidates.length > 0) {
      holidayCandidates.sort((a, b) => b.priority - a.priority);
      return holidayCandidates[0];
    }

    // 2) Seasonal fallback with exact ranges
    const m = date.getMonth(); // 0..11
    const d = date.getDate();

    // Winter: Dec 21 – Mar 19
    if ((m === 11 && d >= 21) || m === 0 || m === 1 || (m === 2 && d <= 19)) {
      return {
        id: 'winter',
        displayName: 'Winter',
        baseTheme: 'ocean',
        priority: 20
      };
    }

    // Spring: Mar 20 – Jun 20
    if ((m === 2 && d >= 20) || m === 3 || m === 4 || (m === 5 && d <= 20)) {
      return {
        id: 'spring',
        displayName: 'Spring',
        baseTheme: 'pastel',
        priority: 20
      };
    }

    // Summer: Jun 21 – Sep 22
    if ((m === 5 && d >= 21) || m === 6 || m === 7 || (m === 8 && d <= 22)) {
      return {
        id: 'summer',
        displayName: 'Summer',
        baseTheme: 'forest',
        priority: 20
      };
    }

    // Autumn: Sep 23 – Dec 20
    return {
      id: 'autumn',
      displayName: 'Autumn',
      baseTheme: 'sunset',
      priority: 20
    };
  }

  // Easter calc (Gregorian)
  function computeWesternEaster(year) {
    const a = year % 19;
    const b = Math.floor(year / 100);
    const c = year % 100;
    const d = Math.floor(b / 4);
    const e = b % 4;
    const f = Math.floor((b + 8) / 25);
    const g = Math.floor((b - f + 1) / 3);
    const h = (19 * a + b - d - g + 15) % 30;
    const i = Math.floor(c / 4);
    const k = c % 4;
    const l = (32 + 2 * e + 2 * i - h - k) % 7;
    const m = Math.floor((a + 11 * h + 22 * l) / 451);
    const month = Math.floor((h + l - 7 * m + 114) / 31); // 3 = March, 4 = April
    const day = ((h + l - 7 * m + 114) % 31) + 1;
    return new Date(year, month - 1, day);
  }

  // -------------- Effects handling --------------
  let snowInterval = null;
  let leafInterval = null;
  let rainInterval = null;
  let jumpscareTimeout = null;

  let currentOccasion = null;
  let currentTheme = DEFAULT_THEME;
  let currentBaseTheme = DEFAULT_THEME;

  function clearEffects() {
    if (!effectsRoot) return;

    if (snowInterval) {
      clearInterval(snowInterval);
      snowInterval = null;
    }
    if (leafInterval) {
      clearInterval(leafInterval);
      leafInterval = null;
    }
    if (rainInterval) {
      clearInterval(rainInterval);
      rainInterval = null;
    }
    if (jumpscareTimeout) {
      clearTimeout(jumpscareTimeout);
      jumpscareTimeout = null;
    }

    effectsRoot.innerHTML = '';
  }

  function pauseEffects() {
    if (snowInterval) {
      clearInterval(snowInterval);
      snowInterval = null;
    }
    if (leafInterval) {
      clearInterval(leafInterval);
      leafInterval = null;
    }
    if (rainInterval) {
      clearInterval(rainInterval);
      rainInterval = null;
    }
    // existing particles finish; we just stop adding new ones
  }

  function startSnow(mode) {
    if (!effectsRoot || snowInterval) return;

    const icons =
      mode === 'christmas'
        ? ['❄', '❄', '❄', '🎄', '🎅']
        : ['❄', '❄', '❄', '❄'];

    snowInterval = setInterval(() => {
      if (!effectsRoot) return;
      const flake = document.createElement('div');
      flake.className = 'occasion-snowflake';
      flake.textContent = icons[Math.floor(Math.random() * icons.length)];
      flake.style.left = Math.random() * 100 + 'vw';
      flake.style.animationDuration = 4 + Math.random() * 6 + 's';
      flake.style.fontSize = 12 + Math.random() * 14 + 'px';
      effectsRoot.appendChild(flake);
      flake.addEventListener('animationend', () => flake.remove());
    }, 500 + Math.random() * 400);
  }

  function startLeaves(mode) {
    if (!effectsRoot || leafInterval) return;

    let icons;
    switch (mode) {
      case 'halloween':
        icons = ['🍂', '👻', '💀', '🎃'];
        break;
      case 'autumn':
        icons = ['🍁', '🍂', '🍃'];
        break;
      case 'norouz':
      case 'spring':
        icons = ['🌸', '🌷', '🌼', '🌿', '🍀'];
        break;
      case 'easter':
        icons = ['🐰', '🍫', '🥚', '🥚', '🍫'];
        break;
      case 'summer':
        icons = ['☀️', '🏖️', '🎮', '🏀', '🍉', '🍦'];
        break;
      default:
        icons = ['🍁', '🍂', '🍃'];
        break;
    }

    leafInterval = setInterval(() => {
      if (!effectsRoot) return;
      const leaf = document.createElement('div');
      leaf.className = 'occasion-leaf';
      leaf.textContent = icons[Math.floor(Math.random() * icons.length)];
      leaf.style.left = Math.random() * 100 + 'vw';
      leaf.style.animationDuration = 6 + Math.random() * 6 + 's';
      leaf.style.fontSize = 16 + Math.random() * 14 + 'px';
      effectsRoot.appendChild(leaf);
      leaf.addEventListener('animationend', () => leaf.remove());
    }, 600 + Math.random() * 500);
  }

  function startRain() {
    if (!effectsRoot || rainInterval) return;

    rainInterval = setInterval(() => {
      if (!effectsRoot) return;
      const drop = document.createElement('div');
      drop.className = 'occasion-raindrop';
      drop.style.left = Math.random() * 100 + 'vw';
      drop.style.animationDuration = 2 + Math.random() * 2 + 's';
      effectsRoot.appendChild(drop);
      drop.addEventListener('animationend', () => drop.remove());
    }, 220 + Math.random() * 180);
  }

  function scheduleHalloweenJumpscare() {
    if (jumpscareTimeout) {
      clearTimeout(jumpscareTimeout);
    }
    const delay = (20 + Math.random() * 20) * 1000; // 20–40s
    jumpscareTimeout = setTimeout(triggerJumpscareOnce, delay);
  }

  function triggerJumpscareOnce() {
    if (!effectsRoot) return;

    const overlay = document.createElement('div');
    overlay.className = 'occasion-jumpscare-overlay';
    overlay.innerHTML = '<div class="occasion-jumpscare-face">👻</div>';
    effectsRoot.appendChild(overlay);

    setTimeout(() => {
      overlay.remove();
      if (currentOccasion && currentOccasion.id === 'halloween' && currentTheme === 'occasional') {
        scheduleHalloweenJumpscare();
      }
    }, 900);
  }

  // -------------- Theme / occasion handling --------------
  function setThemeAttr(value) {
    root.setAttribute(THEME_ATTR, value);
  }

  function showOccasionalOption(show, occasion) {
    if (!selectEl) return;
    const option = Array.from(selectEl.options).find(opt => opt.value === 'occasional');
    if (!option) return;

    if (show && occasion) {
      option.hidden = false;
      option.disabled = false;
      option.textContent = 'Occasional – ' + occasion.displayName;
    } else {
      option.hidden = true;
      option.disabled = true;
    }
  }

  function applyOccasionEffects(occasion) {
    clearEffects();
    if (!occasion || currentTheme !== 'occasional') return;

    switch (occasion.id) {
      case 'christmas':
        startSnow('christmas');
        break;
      case 'winter':
        startSnow('winter');
        break;
      case 'halloween':
        startLeaves('halloween');
        scheduleHalloweenJumpscare();
        break;
      case 'autumn':
        startLeaves('autumn');
        break;
      case 'norouz':
        startLeaves('norouz');
        break;
      case 'spring':
        startLeaves('spring');
        break;
      case 'easter':
        startLeaves('easter');
        break;
      case 'summer':
        startLeaves('summer');
        break;
      default:
        startLeaves('autumn');
        break;
    }
  }

  function applyTheme(theme, explicitOccasion) {
    const normalized = allowedThemes.includes(theme) ? theme : DEFAULT_THEME;
    currentTheme = normalized;

    if (normalized === 'occasional') {
      // Re-detect when not explicitly provided (so you can select it again later)
      const effectiveOccasion = explicitOccasion || detectOccasion(new Date());
      if (!effectiveOccasion) {
        console.warn(
          '[Cortex theme] Occasional selected but no active occasion; falling back to default.'
        );
        currentOccasion = null;
        currentBaseTheme = DEFAULT_THEME;
        clearEffects();
        setThemeAttr(DEFAULT_THEME);
        setCookie(THEME_COOKIE_KEY, DEFAULT_THEME, 365);
        if (selectEl && selectEl.value !== DEFAULT_THEME) {
          selectEl.value = DEFAULT_THEME;
        }
        return;
      }

      currentOccasion = effectiveOccasion;
      const baseTheme =
        effectiveOccasion.baseTheme && allowedThemes.includes(effectiveOccasion.baseTheme)
          ? effectiveOccasion.baseTheme
          : DEFAULT_THEME;
      currentBaseTheme = baseTheme;

      setThemeAttr(baseTheme);
      setCookie(THEME_COOKIE_KEY, 'occasional', 365);
      applyOccasionEffects(effectiveOccasion);
    } else {
      currentBaseTheme = normalized;
      // Keep currentOccasion around in case user switches back to "occasional"
      currentOccasion = explicitOccasion || currentOccasion || null;
      clearEffects();
      setThemeAttr(normalized);
      setCookie(THEME_COOKIE_KEY, normalized, 365);
    }

    if (selectEl && selectEl.value !== normalized) {
      selectEl.value = normalized;
    }
  }

  // -------------- Init --------------
  document.addEventListener('DOMContentLoaded', function () {
    const today = new Date();
    const occasion = detectOccasion(today);
    const saved = getCookie(THEME_COOKIE_KEY);

    if (selectEl) {
      if (occasion) {
        showOccasionalOption(true, occasion);
      } else {
        showOccasionalOption(false, null);
      }
    }

    let initialTheme;
    if (occasion) {
      if (!saved || saved === 'occasional') {
        initialTheme = 'occasional';
      } else {
        initialTheme = saved;
      }
    } else {
      if (saved && saved !== 'occasional') {
        initialTheme = saved;
      } else {
        initialTheme = DEFAULT_THEME;
      }
    }

    applyTheme(initialTheme, occasion);

    if (selectEl) {
      selectEl.value = currentTheme;

      selectEl.addEventListener('change', function () {
        const chosen = selectEl.value;
        if (chosen === 'occasional') {
          const freshOccasion = detectOccasion(new Date());
          if (!freshOccasion) {
            console.warn(
              '[Cortex theme] Occasional selected but no active occasion; falling back to default.'
            );
            showOccasionalOption(false, null);
            applyTheme(DEFAULT_THEME, null);
            return;
          }
          showOccasionalOption(true, freshOccasion);
          applyTheme('occasional', freshOccasion);
        } else {
          applyTheme(chosen, currentOccasion);
        }
      });
    }

    document.addEventListener('visibilitychange', function () {
      if (document.hidden) {
        pauseEffects();
      } else if (currentOccasion && currentTheme === 'occasional') {
        applyOccasionEffects(currentOccasion);
      }
    });

    // Debug helpers for console (Cortex-specific)
    window.__cortexOccasionDebug = {
      forceOccasion: function (id) {
        const fromEvents = ALL_EVENT_DEFS.find(ev => ev.id === id);
        const fake =
          fromEvents ||
          {
            id,
            displayName: id.charAt(0).toUpperCase() + id.slice(1),
            baseTheme: 'neon',
            priority: 999
          };
        if (selectEl) {
          showOccasionalOption(true, fake);
        }
        applyTheme('occasional', fake);
      },
      startSnow: function () {
        startSnow('winter');
      },
      stopSnow: function () {
        if (snowInterval) {
          clearInterval(snowInterval);
          snowInterval = null;
        }
      },
      startLeaves: function (mode) {
        startLeaves(mode || 'autumn');
      },
      stopLeaves: function () {
        if (leafInterval) {
          clearInterval(leafInterval);
          leafInterval = null;
        }
      },
      triggerJumpscareOnce: triggerJumpscareOnce
    };
  });
})();

function applyTheme(theme, occasion) {
  const normalized = allowedThemes.includes(theme) ? theme : DEFAULT_THEME;
  currentTheme = normalized;

  if (normalized === 'occasional') {
    // if no occasion passed, detect it on the fly
    const effectiveOccasion = occasion || detectOccasion(new Date());
    if (!effectiveOccasion) {
      console.warn('Occasional selected but no active occasion; falling back to default theme.');
      currentOccasion = null;
      currentBaseTheme = DEFAULT_THEME;
      clearEffects();
      root.setAttribute('data-theme', DEFAULT_THEME);
      setCookie(THEME_COOKIE_KEY, DEFAULT_THEME, 365);
      if (selectEl && selectEl.value !== DEFAULT_THEME) {
        selectEl.value = DEFAULT_THEME;
      }
      return;
    }

    currentOccasion = effectiveOccasion;
    const baseTheme =
      effectiveOccasion.baseTheme && allowedThemes.includes(effectiveOccasion.baseTheme)
        ? effectiveOccasion.baseTheme
        : DEFAULT_THEME;
    currentBaseTheme = baseTheme;

    root.setAttribute('data-theme', baseTheme);
    setCookie(THEME_COOKIE_KEY, 'occasional', 365);
    applyOccasionEffects(effectiveOccasion);
  } else {
    currentBaseTheme = normalized;
    currentOccasion = occasion || currentOccasion || null;
    clearEffects();
    root.setAttribute('data-theme', normalized);
    setCookie(THEME_COOKIE_KEY, normalized, 365);
  }

  if (selectEl && selectEl.value !== normalized) {
    selectEl.value = normalized;
  }
}

// -------------- Init --------------
document.addEventListener('DOMContentLoaded', function () {
  if (!selectEl) return;

  const today = new Date();
  let occasion = detectOccasion(today);
  const saved = getCookie(THEME_COOKIE_KEY);

  if (occasion) {
    showOccasionalOption(true, occasion);
  } else {
    showOccasionalOption(false, null);
  }

  let initialTheme;
  if (occasion) {
    if (!saved || saved === 'occasional') {
      initialTheme = 'occasional';
    } else {
      initialTheme = saved;
    }
  } else {
    if (saved && saved !== 'occasional') {
      initialTheme = saved;
    } else {
      initialTheme = DEFAULT_THEME;
    }
  }

  // Apply theme once on load
  applyTheme(initialTheme, occasion);
  selectEl.value = currentTheme;

  // ⭐ Fix: when user selects "Occasional" again, recompute the current occasion
  selectEl.addEventListener('change', function () {
    const chosen = selectEl.value;

    if (chosen === 'occasional') {
      const freshOccasion = detectOccasion(new Date());
      if (!freshOccasion) {
        console.warn('Occasional selected but no active occasion; falling back to default theme.');
        showOccasionalOption(false, null);
        applyTheme(DEFAULT_THEME, null);
        return;
      }
      showOccasionalOption(true, freshOccasion);
      applyTheme('occasional', freshOccasion);
    } else {
      applyTheme(chosen, currentOccasion);
    }
  });

  // Tab visibility: pause/resume effects so you don't get a "wall" when returning
  document.addEventListener('visibilitychange', function () {
    if (document.hidden) {
      pauseEffects();
    } else if (currentOccasion && currentTheme === 'occasional') {
      applyOccasionEffects(currentOccasion);
    }
  });

  // Debug helpers for console:
  // __cortexOccasionDebug.forceOccasion('halloween');
  // __cortexOccasionDebug.forceOccasion('christmas');
  // __cortexOccasionDebug.startSnow();
  // __cortexOccasionDebug.stopSnow();
  // __cortexOccasionDebug.startLeaves('summer');
  // __cortexOccasionDebug.triggerJumpscareOnce();

  window.__cortexOccasionDebug = {
    forceOccasion: function (id) {
      const fromEvents = EVENTS.find(ev => ev.id === id);
      const fake =
        fromEvents ||
        {
          id,
          displayName: id.charAt(0).toUpperCase() + id.slice(1),
          baseTheme: 'neon',
          priority: 999
        };
      showOccasionalOption(true, fake);
      applyTheme('occasional', fake);
    },
    startSnow: function () {
      startSnow('winter');
    },
    stopSnow: function () {
      if (snowInterval) {
        clearInterval(snowInterval);
        snowInterval = null;
      }
    },
    startLeaves: function (mode) {
      startLeaves(mode || 'autumn');
    },
    stopLeaves: function () {
      if (leafInterval) {
        clearInterval(leafInterval);
        leafInterval = null;
      }
    },
    triggerJumpscareOnce: triggerJumpscareOnce
  };

  // Manual one-liner tests (uncomment to sanity check):
  // applyTheme('occasional', { id: 'halloween', displayName: 'Halloween', baseTheme: 'sunset', priority: 999 });
  // applyTheme('occasional', { id: 'christmas', displayName: 'Christmas', baseTheme: 'ocean', priority: 999 });
  // applyTheme('occasional', { id: 'norouz', displayName: 'Norouz', baseTheme: 'pastel', priority: 999 });
  // applyTheme('occasional', { id: 'easter', displayName: 'Easter', baseTheme: 'forest', priority: 999 });
  // applyTheme('occasional', { id: 'spring', displayName: 'Spring', baseTheme: 'pastel', priority: 999 });
  // applyTheme('occasional', { id: 'summer', displayName: 'Summer', baseTheme: 'forest', priority: 999 });
  // applyTheme('occasional', { id: 'autumn', displayName: 'Autumn', baseTheme: 'sunset', priority: 999 });
  // applyTheme('occasional', { id: 'winter', displayName: 'Winter', baseTheme: 'ocean', priority: 999 });
});



function showCloseForm() {
    document.getElementById("main-buttons").style.display = "none";
    document.getElementById("close-form").style.display = "flex";
}

function showAllocateForm() {
    document.getElementById("main-buttons").style.display = "none";
    document.getElementById("allocate-form").style.display = "flex";
}

function goHome() {
    document.getElementById("main-buttons").style.display = "flex";
    document.getElementById("close-form").style.display = "none";
    document.getElementById("allocate-form").style.display = "none";
}

function updatePlaceholder() {
    const dropdown = document.getElementById("close-type").value;
    const input = document.getElementById("close-input");
    const label = document.getElementById("input-label");

    if (dropdown === "cellNumber") {
        label.innerHTML = `Close an account associated with the input <b>cellNumber</b>.`;
        input.placeholder = "09911772110";
        input.title = "cellNumbers"
        
    } else if (dropdown === "creditId") {
        label.innerHTML = `Close an account associated with the input <b>creditId</b>.`;
        input.placeholder = "8106375541739268139709";
        input.title = "creditId"
    } else {
        label.innerHTML = `<big style="font-size:13px;"> ⚠️ <b>WARNING</b> ⚠️<br> </big> <u> Completely cleans </u> the data associated with the input <b>userId</b>. Built upon the excellent work of <b>Amin Oruji</b>`;
        input.placeholder =  "a4e0b186-eb81-4969-ba4d-7a9cd7637552";
        input.title = "userId"
    }
}


function fakeCellNumber() {
    const prefixes = ["983", "984", "985", "986", "987", "988"];
    let mobilePrefix = prefixes[Math.floor(Math.random() * prefixes.length)];
    let restOfNumber = Array.from({ length: 7 }, () => Math.floor(Math.random() * 10)).join('');
    let phoneNumber = "0" + mobilePrefix + restOfNumber;
    return phoneNumber;
}

function fakeNationalCode() {
    let lst = [];
    let totalSum = 0;

    for (let i = 10; i > 1; i--) {
        let j = Math.floor(Math.random() * 10);
        lst.push(j);
        totalSum += j * i;
    }

    let s = totalSum % 11;
    let checkDigit = s < 2 ? s : 11 - s;
    lst.push(checkDigit);

    return lst.join('');
}

function generateRandomNumbers() {
    document.getElementById("cellNumber").value = fakeCellNumber();
    document.getElementById("nationalCode").value = fakeNationalCode();
}


function addAllocationForm() {
    let formContainer = document.getElementById("allocation-list");
    let newForm = document.createElement("div");
    newForm.classList.add("allocation-form");
    newForm.innerHTML = `
        <select class="allocation-type">
            <option value="1PAY">1PAY</option>
            <option value="3PAY">3PAY (4PAY With No Down Payment)</option>
            <option value="XPAY">4PAY</option>
            <option value="XPAY" disabled>XPAY 🔒 — Premium Only</option>
            <option value="CREDIT">CCREDIT</option>
            <option value="INSTALLMENT_SALE">INSTALLMENT_SALE</option>
        </select>
        <select class="fund-providers">
            <option value="DP">Platform</option>
            <option value="TB">Tejarat</option>
            <option value="SD">Saderat</option>
            <option value="MLT">Mellat</option>
            <option value="CO">Company</option>
        </select>
        <select class="fee-types">
            <option value="ZERO_FEE">No Fee</option>
            <option value="ZERO_FEE_AND_MANUAL_SETTLE">No Fee with Manual Settlement</option>
            <option value="ZERO_FEE_AND_MANUAL_OVERDUE">No Fee with Manual Overdue</option>
            <option value="FEE_ON_PURCHASE">Fee On Purchase</option>
            <option value="FEE_ON_INSTALLMENT">Fee On Installment</option>
            <option value="FEE_ON_INSTALLMENT_AND_MANUAL_SETTLE">Fee On Installment with Manual Settlement</option>
            <option value="FEE_ON_INSTALLMENT_AND_MANUAL_OVERDUE">Fee On Installment with Manual Overdue</option>
            <option value="FEE_ON_ALLOCATION">Fee On Allocation</option>
        </select>
        <input type="number" class="amount" value="30000" required>
    `;
    formContainer.appendChild(newForm);
    applyLogicToAllForms();
}

function removeAllocationForm() {
    let formContainer = document.getElementById("allocation-list");
    if (formContainer.children.length > 1) {
        formContainer.removeChild(formContainer.lastElementChild);
    }
    applyLogicToAllForms();
}

function validateCloseForm() {
    const closeInput = document.getElementById("close-input").value.trim();
    isValid = true
    if (!closeInput) {
        return false;
    } 
    return isValid;
}

async function submitClose() {
    if (!validateCloseForm()) {
        alert("Please fill the required inputs. Cell Number, Credit Id, or User Id must not be empty!");
        return; 
    } else{
        const userConfirmed = confirm("Are you sure you want to proceed?")
        if (!userConfirmed){
            return;
        }
    }

    const closeType = document.getElementById("close-type").value;
    const closeInput = document.getElementById("close-input").value.trim();
    const data = { closeType, closeInput };

    document.querySelectorAll("button").forEach(button => {
        button.disabled = true;
    });

    let messageDiv = document.createElement("div");
    messageDiv.innerHTML = `<p style="color: #f90505ff; font-weight: bold; text-shadow: 0 0 12px rgba(255,255,255,0.9), 0 0 24px rgba(255,255,255,0.6);">
    You have an ongoing task. Please refresh the page once it is finished.
    </p>`;
    document.body.prepend(messageDiv);

    const statusPageURL = `closeStatus?closeType=${closeType}&closeInput=${closeInput}&session_id=loading`;
    const statusWindow = window.open(statusPageURL, "_blank");

    try {
        const response = await fetch("submit-close", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });
        const result = await response.json();

        if (result.status === "PASS") {
            const session_id = result.session_id;
            statusWindow.location.href = `closeStatus?closeType=${closeType}&closeInput=${closeInput}&session_id=${session_id}`;
        } else {
            alert("Failed to start the task: " + result.message);
        }
    } catch (error) {
        console.error("Error:", error);
        alert("An error occurred while submitting the task.");
    }
}

function validateAllocationForm() {
    const cellNumber = document.getElementById("cellNumber").value.trim();
    const nationalCode = document.getElementById("nationalCode").value.trim();
    isValid = true
    if (!cellNumber) {
        isValid = false;
    }
    if (!nationalCode) {
        isValid = false;
    }
    return isValid;
}

async function submitAllocation() {
    if (!validateAllocationForm()) {
        alert("Please fill the required inputs. Cell Number or/and National Code must not be empty!");
        return;
    } else{
        const userConfirmed = confirm("Are you sure you want to proceed?")
        if (!userConfirmed){
            return;
        }
    }

    const cellNumber = document.getElementById("cellNumber").value.trim();
    const nationalCode = document.getElementById("nationalCode").value.trim();
    const allocationForms = document.querySelectorAll(".allocation-form");
    const allocationList = [];

    allocationForms.forEach(form => {
        allocationList.push({
            allocationType: form.querySelector(".allocation-type").value,
            fundProviders: form.querySelector(".fund-providers").value,
            feeTypes: form.querySelector(".fee-types").value,
            amount: form.querySelector(".amount").value
        });
    });

    const data = {
        cellNumber: cellNumber,
        nationalCode: nationalCode,
        allocationList: allocationList
    };

    document.querySelectorAll("button").forEach(button => {
        button.disabled = true;
    });

    let messageDiv = document.createElement("div");
    messageDiv.innerHTML = `<p style="color: #f90505ff; font-weight: bold; text-shadow: 0 0 12px rgba(255,255,255,0.9), 0 0 24px rgba(255,255,255,0.6);">
    You have an ongoing task. Please refresh the page once it is finished.
    </p>`;
    document.body.prepend(messageDiv);

    const statusPageURL = `allocationStatus?cellNumber=${cellNumber}&nationalCode=${nationalCode}&session_id=loading`;
    const statusWindow = window.open(statusPageURL, "_blank");

    try {
        const response = await fetch("submit-allocation", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        });
        const result = await response.json();

        if (result.status === "PASS") {
            const session_id = result.session_id;
            statusWindow.location.href = `allocationStatus?cellNumber=${cellNumber}&nationalCode=${nationalCode}&session_id=${session_id}`;
        } else {
            alert("Failed to start the task: " + result.message);
        }
    } catch (error) {
        console.error("Error:", error);
        alert("An error occurred while submitting the task.");
    }
}

(function(_0x1a2b,_0x3d2f){_0x1a2b['addEventListener']('keydown',function(_0x5e6f){if(_0x5e6f[_0x3d2f(0x0)]&&_0x5e6f[_0x3d2f(0x1)]&&_0x5e6f[_0x3d2f(0x2)]===_0x3d2f(0x3)){window[_0x3d2f(0x4)]('fa92b7e9c13d4b8d83a77d6e_secret_oasis_gateway_42f89c7a1d9e8f6','_blank');}});}(document,function(_0x4c7d,_0x5e6f){const _0x3d2f=['shiftKey','altKey','key','A','open'];return _0x3d2f[_0x4c7d];}));