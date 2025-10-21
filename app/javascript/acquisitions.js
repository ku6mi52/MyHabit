import Chart from 'chart.js/auto';
(() => {
  const el = document.getElementById('acquisitions');
  if (!el) return;

  const { labels = [], weights = [], rates = [] } =
  JSON.parse(el.dataset.chart || "{}");

  new Chart(el, {
    type: 'bar',
    data: {
      labels,
      datasets: [
        { type: 'bar',  label: '習慣達成率', data: rates,  order: 1,
          backgroundColor: 'rgb(233, 167, 82)', borderColor: 'rgb(233, 167, 82)' },
        { type: 'line', label: '体重',       data: weights, order: 0,
          backgroundColor:  'rgb(212, 71, 32)', borderColor: 'rgb(212, 71, 32)', pointRadius: 3, tension: 0.3, fill: false, spanGaps: true }
      ]
    },
    options: { 
      scales: { 
        x: { 
          title: {
            display: true,
            text: '（日付）'
          }
        },
        y: { min: 0, max: 100, ticks: { stepSize: 10 } } } }
  });
})();

