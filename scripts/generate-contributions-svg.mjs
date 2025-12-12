import fs from "node:fs/promises";

const DEFAULT_LOGIN = "Reotech736";
const OUTPUT_PATH = new URL("../assets/images/contributions.svg", import.meta.url);

function requireEnv(name) {
  const value = process.env[name];
  if (!value) throw new Error(`Missing required env var: ${name}`);
  return value;
}

function clamp(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function escapeXml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&apos;");
}

async function fetchContributionCalendar({ token, login }) {
  const query = `
    query($login: String!) {
      user(login: $login) {
        contributionsCollection {
          contributionCalendar {
            weeks {
              contributionDays {
                date
                contributionCount
              }
            }
          }
        }
      }
    }
  `;

  const res = await fetch("https://api.github.com/graphql", {
    method: "POST",
    headers: {
      Authorization: `bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ query, variables: { login } }),
  });

  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`GitHub GraphQL error: ${res.status} ${res.statusText} ${text}`);
  }

  const json = await res.json();
  if (json.errors?.length) {
    throw new Error(`GitHub GraphQL errors: ${JSON.stringify(json.errors)}`);
  }

  const weeks = json?.data?.user?.contributionsCollection?.contributionCalendar?.weeks;
  if (!Array.isArray(weeks)) throw new Error("Unexpected API response: weeks missing");
  return weeks;
}

function getLevel(count) {
  if (count <= 0) return 0;
  if (count <= 3) return 1;
  if (count <= 7) return 2;
  if (count <= 14) return 3;
  return 4;
}

function renderSvg({ login, weeks }) {
  const cell = 11;
  const gap = 3;
  const cols = weeks.length;
  const rows = 7;
  const width = cols * (cell + gap) + gap;
  const height = rows * (cell + gap) + gap + 18;

  const palette = [
    "#e6f2f4", // level 0 (very light, matches bg)
    "#bfe1e8", // level 1
    "#7eb3bf", // level 2 (site --light)
    "#3ba3c5", // level 3 (site --accent)
    "#087b8a", // level 4 (site --primary)
  ];

  let maxCount = 0;
  for (const week of weeks) {
    for (const day of week.contributionDays) {
      if (day.contributionCount > maxCount) maxCount = day.contributionCount;
    }
  }
  maxCount = clamp(maxCount, 0, 999);

  const title = `${login} contributions`;
  const subtitle = `Max daily contributions: ${maxCount}`;

  let rects = "";
  weeks.forEach((week, x) => {
    week.contributionDays.forEach((day, y) => {
      const level = getLevel(day.contributionCount);
      const fill = palette[level] ?? palette[0];
      const rx = 2;
      const ry = 2;
      const px = gap + x * (cell + gap);
      const py = gap + y * (cell + gap);
      rects += `<rect x="${px}" y="${py}" width="${cell}" height="${cell}" rx="${rx}" ry="${ry}" fill="${fill}"><title>${escapeXml(day.date)}: ${day.contributionCount}</title></rect>`;
    });
  });

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img" aria-label="${escapeXml(title)}">
  <title>${escapeXml(title)}</title>
  <desc>${escapeXml(subtitle)}</desc>
  <rect x="0" y="0" width="${width}" height="${height}" fill="white" />
  <g>
    ${rects}
  </g>
  <text x="${gap}" y="${height - 6}" font-size="11" fill="#6c757d" font-family="Segoe UI, Tahoma, Geneva, Verdana, sans-serif">${escapeXml(subtitle)}</text>
</svg>
`;
}

async function main() {
  const token = requireEnv("GITHUB_TOKEN");
  const login = process.env.GITHUB_LOGIN || DEFAULT_LOGIN;

  const weeks = await fetchContributionCalendar({ token, login });
  const svg = renderSvg({ login, weeks });
  await fs.mkdir(new URL("../assets/images/", import.meta.url), { recursive: true });
  await fs.writeFile(OUTPUT_PATH, svg, "utf8");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});

