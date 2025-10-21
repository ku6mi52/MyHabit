import Chart from 'chart.js/auto';
(() => {
  const el = document.getElementById('acquisitions');
  if (!el) return;
console.log({ labels, weights, rates })
  const { labels = [], weights = [], rates = [] } =
    JSON.parse(el.dataset.chart || "{}");

  new Chart(el, {
    type: 'bar',
    data: {
      labels,
      datasets: [
        { type: 'bar',  label: '習慣達成率', data: rates,  order: 1,
          backgroundColor: 'rgba(54,162,235,0.35)', borderColor: 'rgb(54,162,235)' },
        { type: 'line', label: '体重',       data: weights, order: 0,
          borderColor: 'rgb(255,99,132)', pointRadius: 3, tension: 0.3, fill: false, spanGaps: true }
      ]
    },
    options: { scales: { y: { min: 0, max: 100, ticks: { stepSize: 10 } } } }
  });
})();

