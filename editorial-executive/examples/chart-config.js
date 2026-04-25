/* =============================================================================
 * CHART CONFIGURATIONS — Editorial Executive design system
 *
 * All chart colors are read from CSS variables so charts respond to theme toggle.
 * Call rerenderAllCharts() inside toggleTheme() to swap colors live.
 *
 * Includes:
 *   1. cssVar()                    — read CSS custom property at runtime
 *   2. baseChartOptions()          — shared scales/grid/font config
 *   3. createLineChart()           — single-line equity / time series
 *   4. createMultiLineChart()      — comparison overlays (strategy vs benchmark)
 *   5. createBarChart()            — categorical bars (yearly returns, by-segment)
 *   6. createDistributionChart()   — histogram of trade returns or P&L
 *   7. createDivergingBarSVG()     — wins-up / losses-down stacked bars (custom SVG)
 *   8. renderHeatmap()             — diverging color heatmap (matrix data)
 *   9. setupChartTheming()         — wires re-render to theme toggle
 *
 * Requires Chart.js 4.x via CDN:
 *   <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
 * ============================================================================= */

// -----------------------------------------------------------------------------
// 1. Read a CSS custom property — used by every chart
// -----------------------------------------------------------------------------
function cssVar(name) {
  return getComputedStyle(document.documentElement).getPropertyValue(name).trim();
}

// -----------------------------------------------------------------------------
// 2. Shared base options — never override these without good reason
// -----------------------------------------------------------------------------
function baseChartOptions(extra = {}) {
  return {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: extra.showLegend ?? false,
        labels: {
          color: cssVar('--ink-soft'),
          font: { family: 'Geist', size: 11 },
          boxWidth: 12, boxHeight: 12, padding: 16
        }
      },
      tooltip: {
        backgroundColor: cssVar('--ink'),
        titleColor: cssVar('--bg'),
        bodyColor: cssVar('--bg'),
        titleFont: { family: 'Geist', size: 11, weight: '600' },
        bodyFont:  { family: 'JetBrains Mono', size: 11 },
        padding: 10,
        cornerRadius: 0,           // square corners — design system rule
        displayColors: false,
        borderColor: cssVar('--accent'),
        borderWidth: 1
      }
    },
    scales: {
      x: {
        ticks: {
          color: cssVar('--ink-soft'),
          font: { family: 'JetBrains Mono', size: 10 },
          maxTicksLimit: 8
        },
        grid: { color: cssVar('--line'), drawBorder: false }
      },
      y: {
        ticks: {
          color: cssVar('--ink-soft'),
          font: { family: 'JetBrains Mono', size: 10 }
        },
        grid: { color: cssVar('--line'), drawBorder: false }
      }
    },
    ...extra.options
  };
}

// -----------------------------------------------------------------------------
// 3. Single-line chart (equity curves, time series, smooth metrics)
// -----------------------------------------------------------------------------
function createLineChart(canvasId, labels, values, options = {}) {
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  return new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label: options.label ?? 'Series',
        data: values,
        borderColor: cssVar('--accent'),
        borderWidth: 1.5,           // never thicker — thin lines are load-bearing
        backgroundColor: 'transparent',
        pointRadius: 0,             // no dots — clutter
        pointHoverRadius: 4,
        pointHoverBackgroundColor: cssVar('--accent'),
        pointHoverBorderColor: cssVar('--bg'),
        pointHoverBorderWidth: 2,
        tension: options.tension ?? 0.1   // tiny smoothing, never cartoon curves
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 4. Multi-line comparison (strategy vs benchmark, A vs B)
//    Use accent for the primary series, gold for benchmark/baseline.
// -----------------------------------------------------------------------------
function createMultiLineChart(canvasId, labels, series, options = {}) {
  // series: [{ label, data, color: 'accent'|'gold'|'ink-soft' }, ...]
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  const colorMap = {
    accent:   cssVar('--accent'),
    gold:     cssVar('--gold'),
    'ink-soft': cssVar('--ink-soft'),
    positive: cssVar('--positive'),
    negative: cssVar('--negative')
  };

  return new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: series.map((s, i) => ({
        label: s.label,
        data: s.data,
        borderColor: colorMap[s.color] ?? cssVar('--accent'),
        borderWidth: i === 0 ? 1.5 : 1.2,    // primary series slightly heavier
        borderDash: s.dashed ? [4, 4] : [],   // dashed for benchmarks
        backgroundColor: 'transparent',
        pointRadius: 0, pointHoverRadius: 4,
        tension: 0.1
      }))
    },
    options: baseChartOptions({ showLegend: true, ...options })
  });
}

// -----------------------------------------------------------------------------
// 5. Categorical bar chart (yearly returns, segment performance)
//    Auto-colors bars positive (green) / negative (red) based on value sign.
// -----------------------------------------------------------------------------
function createBarChart(canvasId, labels, values, options = {}) {
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  const colors = values.map(v =>
    v >= 0 ? cssVar('--positive') : cssVar('--negative')
  );

  return new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: options.label ?? 'Value',
        data: values,
        backgroundColor: colors,
        borderColor: colors,
        borderWidth: 0,
        borderRadius: 0,           // square corners — design system rule
        barPercentage: 0.7,
        categoryPercentage: 0.85
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 6. Distribution / histogram (return distribution, P&L spread)
// -----------------------------------------------------------------------------
function createDistributionChart(canvasId, bins, counts, options = {}) {
  // bins: array of bin labels (e.g. ['-3%', '-2%', ...])
  // counts: array of frequencies
  const ctx = document.getElementById(canvasId);
  if (!ctx) return null;

  // Color each bin: negative bins red, positive bins green, zero bin muted
  const zeroIdx = bins.findIndex(b => parseFloat(b) >= 0);
  const colors = bins.map((b, i) => {
    const v = parseFloat(b);
    if (Math.abs(v) < 0.01) return cssVar('--muted');
    return v < 0 ? cssVar('--negative') : cssVar('--positive');
  });

  return new Chart(ctx, {
    type: 'bar',
    data: {
      labels: bins,
      datasets: [{
        data: counts,
        backgroundColor: colors,
        borderWidth: 0,
        borderRadius: 0,
        barPercentage: 0.95,
        categoryPercentage: 0.95
      }]
    },
    options: baseChartOptions(options)
  });
}

// -----------------------------------------------------------------------------
// 7. Diverging bar SVG (wins-up / losses-down with optional overlay line)
//    Returns an SVG string. Inject with element.innerHTML = result.
//    Drives all colors from CSS classes so it responds to theme toggle.
// -----------------------------------------------------------------------------
function createDivergingBarSVG(data, options = {}) {
  // data: [{ label, up, down, marker (optional, 0..1 for overlay dot) }]
  if (!data || data.length === 0 || data.every(d => d.up === 0 && d.down === 0)) {
    return '<svg viewBox="0 0 800 60" xmlns="http://www.w3.org/2000/svg">' +
           '<text class="dow-empty" x="400" y="35">No data to display</text></svg>';
  }

  const W = options.width  ?? 800;
  const H = options.height ?? 320;
  const PAD_L = options.padL ?? 60, PAD_R = options.padR ?? 60;
  const PAD_T = options.padT ?? 40, PAD_B = options.padB ?? 60;
  const CHART_W = W - PAD_L - PAD_R;
  const CHART_H = H - PAD_T - PAD_B;
  const ZERO_Y  = PAD_T + CHART_H * 0.55;

  const maxCount = Math.max(...data.map(d => Math.max(d.up, d.down))) || 1;
  const aboveH = ZERO_Y - PAD_T;
  const belowH = (PAD_T + CHART_H) - ZERO_Y;
  const pxAbove = aboveH / maxCount;
  const pxBelow = belowH / maxCount;
  const band = CHART_W / data.length;
  const barW = band * 0.55;

  let svg = `<svg viewBox="0 0 ${W} ${H}" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid meet">`;

  // Grid lines + count labels at quartiles
  for (const frac of [0.25, 0.5, 0.75, 1.0]) {
    const yUp = ZERO_Y - frac * aboveH;
    const yDn = ZERO_Y + frac * belowH;
    const cnt = Math.round(frac * maxCount);
    svg += `<line class="dow-axis-line" x1="${PAD_L}" y1="${yUp.toFixed(1)}" x2="${W-PAD_R}" y2="${yUp.toFixed(1)}" opacity="0.3"/>`;
    svg += `<line class="dow-axis-line" x1="${PAD_L}" y1="${yDn.toFixed(1)}" x2="${W-PAD_R}" y2="${yDn.toFixed(1)}" opacity="0.3"/>`;
    svg += `<text class="dow-axis-label" x="${PAD_L-8}" y="${(yUp+4).toFixed(1)}" text-anchor="end">${cnt}</text>`;
    svg += `<text class="dow-axis-label" x="${PAD_L-8}" y="${(yDn+4).toFixed(1)}" text-anchor="end">${cnt}</text>`;
  }

  // Zero line
  svg += `<line class="dow-zero-line" x1="${PAD_L}" y1="${ZERO_Y}" x2="${W-PAD_R}" y2="${ZERO_Y}"/>`;

  // Side labels
  svg += `<text class="dow-stat-label" x="${PAD_L-8}" y="${PAD_T-12}" text-anchor="end">${options.upLabel ?? 'Up'} ↑</text>`;
  svg += `<text class="dow-stat-label" x="${PAD_L-8}" y="${H-PAD_B+18}" text-anchor="end">${options.downLabel ?? 'Down'} ↓</text>`;

  // Bars + labels
  const markerPts = [];
  data.forEach((d, i) => {
    const cx = PAD_L + band * i + band / 2;
    const x  = cx - barW / 2;
    const upH   = d.up   * pxAbove;
    const downH = d.down * pxBelow;

    if (d.up > 0) {
      svg += `<rect class="dow-bar-win" x="${x.toFixed(1)}" y="${(ZERO_Y - upH).toFixed(1)}" width="${barW.toFixed(1)}" height="${upH.toFixed(1)}" rx="0"/>`;
      if (upH > 18) {
        svg += `<text class="dow-bar-label" x="${cx.toFixed(1)}" y="${(ZERO_Y - upH + 13).toFixed(1)}">${d.up}</text>`;
      } else {
        svg += `<text class="dow-axis-label" x="${cx.toFixed(1)}" y="${(ZERO_Y - upH - 6).toFixed(1)}" text-anchor="middle" style="fill:var(--positive);font-weight:600">${d.up}</text>`;
      }
    }
    if (d.down > 0) {
      svg += `<rect class="dow-bar-loss" x="${x.toFixed(1)}" y="${ZERO_Y.toFixed(1)}" width="${barW.toFixed(1)}" height="${downH.toFixed(1)}" rx="0"/>`;
      if (downH > 18) {
        svg += `<text class="dow-bar-label" x="${cx.toFixed(1)}" y="${(ZERO_Y + downH - 5).toFixed(1)}">${d.down}</text>`;
      } else {
        svg += `<text class="dow-axis-label" x="${cx.toFixed(1)}" y="${(ZERO_Y + downH + 14).toFixed(1)}" text-anchor="middle" style="fill:var(--negative);font-weight:600">${d.down}</text>`;
      }
    }

    svg += `<text class="dow-day-label" x="${cx.toFixed(1)}" y="${(H-PAD_B+38).toFixed(1)}" text-anchor="middle">${d.label}</text>`;
    if (d.sublabel) {
      svg += `<text class="dow-stat-label" x="${cx.toFixed(1)}" y="${(H-PAD_B+52).toFixed(1)}" text-anchor="middle">${d.sublabel}</text>`;
    }

    if (typeof d.marker === 'number') {
      const my = ZERO_Y - d.marker * aboveH;
      markerPts.push({ x: cx, y: my, value: d.marker });
    }
  });

  // Marker overlay line (e.g. win-rate line on top of win/loss bars)
  if (markerPts.length > 1) {
    const path = 'M ' + markerPts.map(p => `${p.x.toFixed(1)},${p.y.toFixed(1)}`).join(' L ');
    svg += `<path class="dow-winrate-line" d="${path}"/>`;
  }
  markerPts.forEach(p => {
    svg += `<circle class="dow-winrate-dot" cx="${p.x.toFixed(1)}" cy="${p.y.toFixed(1)}" r="4.5"/>`;
    svg += `<text class="dow-stat-value" x="${p.x.toFixed(1)}" y="${(p.y - 10).toFixed(1)}" text-anchor="middle" style="fill:var(--gold)">${(p.value * 100).toFixed(0)}%</text>`;
  });

  // Legend
  if (options.showLegend !== false) {
    const lgY = 18;
    svg += `<rect class="dow-bar-win"  x="${PAD_L}"     y="${lgY-9}" width="14" height="10" rx="0"/>`;
    svg += `<text class="dow-stat-label" x="${PAD_L+20}" y="${lgY}">${options.upLabel ?? 'Wins'}</text>`;
    svg += `<rect class="dow-bar-loss" x="${PAD_L+80}"  y="${lgY-9}" width="14" height="10" rx="0"/>`;
    svg += `<text class="dow-stat-label" x="${PAD_L+100}" y="${lgY}">${options.downLabel ?? 'Losses'}</text>`;
    if (markerPts.length > 0) {
      svg += `<circle class="dow-winrate-dot" cx="${PAD_L+180}" cy="${lgY-3}" r="4.5"/>`;
      svg += `<text class="dow-stat-label" x="${PAD_L+192}" y="${lgY}">${options.markerLabel ?? 'Rate'}</text>`;
    }
  }

  svg += '</svg>';
  return svg;
}

// Required CSS classes for the diverging bar SVG (add to your <style>):
//
//   .dow-bar-win   { fill: var(--positive); }
//   .dow-bar-loss  { fill: var(--negative); }
//   .dow-axis-line { stroke: var(--line); stroke-width: 1; }
//   .dow-zero-line { stroke: var(--ink-soft); stroke-width: 1; opacity: 0.4; }
//   .dow-axis-label { fill: var(--muted); font-family: "JetBrains Mono", monospace;
//                     font-size: 11px; }
//   .dow-day-label  { fill: var(--ink); font-family: "Fraunces", serif;
//                     font-size: 14px; font-weight: 500; }
//   .dow-stat-label { fill: var(--muted); font-family: "Geist", sans-serif;
//                     font-size: 9px; letter-spacing: 0.1em; text-transform: uppercase; }
//   .dow-stat-value { fill: var(--ink); font-family: "JetBrains Mono", monospace;
//                     font-size: 12px; font-weight: 500; }
//   .dow-bar-label  { fill: var(--surface); font-family: "JetBrains Mono", monospace;
//                     font-size: 10px; font-weight: 600; text-anchor: middle; }
//   .dow-winrate-line { stroke: var(--gold); stroke-width: 1.5;
//                       stroke-dasharray: 3 3; fill: none; }
//   .dow-winrate-dot  { fill: var(--gold); stroke: var(--bg); stroke-width: 2; }
//   .dow-empty { fill: var(--muted); font-family: "Fraunces", serif;
//                font-size: 11px; font-style: italic; text-anchor: middle; }

// -----------------------------------------------------------------------------
// 8. Diverging-color heatmap (matrix data — months × years, hours × days, etc.)
//    Renders into a parent div via innerHTML.
// -----------------------------------------------------------------------------
function renderHeatmap(containerId, data, options = {}) {
  // data: { rowLabels: ['2021','2022',...], colLabels: ['Jan','Feb',...],
  //         matrix: [[v1, v2, ...], ...] }   // null cells allowed
  const container = document.getElementById(containerId);
  if (!container) return;

  const flat = data.matrix.flat().filter(v => v !== null && v !== undefined);
  if (flat.length === 0) {
    container.innerHTML = '<p style="padding:24px;color:var(--muted);text-align:center;">No data</p>';
    return;
  }

  const vmax = Math.max(Math.abs(Math.min(...flat)), Math.abs(Math.max(...flat))) || 1;
  const decimals = options.decimals ?? 1;

  let html = '<div class="heatmap" style="display:grid;gap:2px;font-size:11px;font-family:\'JetBrains Mono\',monospace;">';
  // Header row
  html += `<div class="heatmap-row" style="display:grid;grid-template-columns:60px repeat(${data.colLabels.length},1fr);gap:2px;">`;
  html += '<div class="heatmap-cell label" style="background:transparent;color:var(--muted);"></div>';
  data.colLabels.forEach(c => {
    html += `<div class="heatmap-cell label" style="background:transparent;color:var(--muted);text-align:center;padding:8px 4px;font-size:10px;letter-spacing:0.1em;">${c}</div>`;
  });
  html += '</div>';

  // Data rows
  data.rowLabels.forEach((rowLabel, i) => {
    html += `<div class="heatmap-row" style="display:grid;grid-template-columns:60px repeat(${data.colLabels.length},1fr);gap:2px;">`;
    html += `<div class="heatmap-cell label" style="background:transparent;color:var(--muted);padding:10px 4px;font-weight:500;display:flex;align-items:center;">${rowLabel}</div>`;
    data.matrix[i].forEach(v => {
      if (v === null || v === undefined) {
        html += '<div class="heatmap-cell" style="padding:10px 4px;text-align:center;background:var(--surface);opacity:0.25;min-height:36px;">·</div>';
      } else {
        const intensity = Math.min(Math.abs(v) / vmax, 1.0);
        const bg = v >= 0
          ? `rgba(27,94,32,${0.10 + intensity * 0.55})`
          : `rgba(184,52,26,${0.10 + intensity * 0.55})`;
        const color = intensity > 0.4
          ? (v >= 0 ? '#0a3d10' : '#5a1a0a')
          : 'var(--ink)';
        const display = options.asPercent
          ? `${(v >= 0 ? '+' : '')}${(v * 100).toFixed(decimals)}`
          : v.toFixed(decimals);
        html += `<div class="heatmap-cell" style="padding:10px 4px;text-align:center;min-height:36px;background:${bg};color:${color};">${display}</div>`;
      }
    });
    html += '</div>';
  });
  html += '</div>';
  container.innerHTML = html;
}

// -----------------------------------------------------------------------------
// 9. Theme-aware re-rendering — wire this to the toggle button
// -----------------------------------------------------------------------------
const _chartRegistry = [];

function registerChart(chartInstance, rebuilderFn) {
  // rebuilderFn: () => Chart (a closure that reconstructs the chart)
  _chartRegistry.push({ chart: chartInstance, rebuild: rebuilderFn });
}

function rerenderAllCharts() {
  _chartRegistry.forEach(entry => {
    if (entry.chart && typeof entry.chart.destroy === 'function') {
      entry.chart.destroy();
    }
    entry.chart = entry.rebuild();
  });
}

// Wire into theme toggle. Replace the body of toggleTheme in your HTML with:
//
//   function toggleTheme() {
//     const c = document.documentElement.getAttribute('data-theme');
//     document.documentElement.setAttribute('data-theme', c === 'dark' ? 'light' : 'dark');
//     rerenderAllCharts();
//   }
//
// Then for each chart you create, register a rebuilder closure:
//
//   const rebuildEquity = () => createLineChart('eq-canvas', dates, values);
//   registerChart(rebuildEquity(), rebuildEquity);

// =============================================================================
// USAGE EXAMPLES
// =============================================================================
/*
// --- Single line chart ---
const rebuildEquity = () => createLineChart(
  'equity-canvas',
  ['Jan','Feb','Mar','Apr','May'],
  [1.00, 1.04, 1.02, 1.08, 1.12]
);
registerChart(rebuildEquity(), rebuildEquity);

// --- Multi-line comparison ---
const rebuildCompare = () => createMultiLineChart(
  'compare-canvas',
  ['2021','2022','2023','2024','2025'],
  [
    { label: 'Strategy',  data: [1.00, 1.18, 1.32, 1.55, 1.74], color: 'accent' },
    { label: 'Benchmark', data: [1.00, 1.08, 1.15, 1.22, 1.28], color: 'gold', dashed: true }
  ],
  { showLegend: true }
);
registerChart(rebuildCompare(), rebuildCompare);

// --- Bar chart with auto pos/neg coloring ---
const rebuildYears = () => createBarChart(
  'yearly-canvas',
  ['2021','2022','2023','2024','2025'],
  [12.4, -3.2, 8.7, 15.1, 6.8]
);
registerChart(rebuildYears(), rebuildYears);

// --- Diverging bar SVG (wins/losses by category) ---
document.getElementById('dow-chart').innerHTML = createDivergingBarSVG(
  [
    { label: 'Mon', up: 8,  down: 3, marker: 0.73, sublabel: 'n=11' },
    { label: 'Tue', up: 5,  down: 7, marker: 0.42, sublabel: 'n=12' },
    { label: 'Wed', up: 7,  down: 4, marker: 0.64, sublabel: 'n=11' },
    { label: 'Thu', up: 6,  down: 5, marker: 0.55, sublabel: 'n=11' },
    { label: 'Fri', up: 4,  down: 8, marker: 0.33, sublabel: 'n=12' }
  ],
  { upLabel: 'Wins', downLabel: 'Losses', markerLabel: 'Win rate' }
);

// --- Heatmap ---
renderHeatmap('monthly-heatmap', {
  rowLabels: ['2023','2024','2025'],
  colLabels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
  matrix: [
    [0.012, -0.005, 0.022, 0.018, -0.003, 0.011, 0.015, 0.024, -0.008, 0.019, 0.007, 0.013],
    [0.018, 0.022, -0.012, 0.015, 0.025, -0.005, 0.018, 0.011, 0.028, -0.014, 0.022, 0.017],
    [0.025, 0.018, 0.012, -0.008, 0.019, 0.024, null, null, null, null, null, null]
  ]
}, { asPercent: true, decimals: 1 });
*/
