import React from 'react'

export default function StatsCard({ icon, title, value, subtitle, tone = 'blue' }) {
  return (
    <div className={`analytics-card ${tone}`}>
      <div className="analytics-icon">{icon}</div>
      <h5>{title}</h5>
      <h2>{value}</h2>
      <p>{subtitle}</p>
    </div>
  )
}
