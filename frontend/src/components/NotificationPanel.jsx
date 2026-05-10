import React from 'react'

export default function NotificationPanel({ notifications }) {
  return (
    <div className="card custom-card notification-card">
      <h4>Live Notifications</h4>
      <div id="notifications">
        {notifications.length === 0 ? (
          <div className="notify info">No notifications yet.</div>
        ) : notifications.map((n) => (
          <div key={n.id} className={`notify ${n.type}`}>{n.text}</div>
        ))}
      </div>
      <div className="view-all">View all notifications <i className="bi bi-arrow-right"></i></div>
    </div>
  )
}
