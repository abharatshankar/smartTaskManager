import React from 'react'

export default function Sidebar({ onLogout }) {
  return (
    <aside className="sidebar">
      <div className="logo">
        <h2>✔ Smart Task Manager</h2>
      </div>

      <nav className="menu">
        <a href="#dashboard" className="active"><i className="bi bi-house-door"></i> Dashboard</a>
        <a href="#tasks"><i className="bi bi-list-check"></i> My Tasks</a>
        <a href="#add-task"><i className="bi bi-plus-circle"></i> Add Task</a>
        <a href="#analytics"><i className="bi bi-bar-chart-line"></i> Analytics</a>
        <a href="#profile"><i className="bi bi-person"></i> Profile</a>
        <button type="button" className="sidebar-logout" onClick={onLogout}>
          <i className="bi bi-box-arrow-right"></i> Logout
        </button>
      </nav>

      <div className="sidebar-illustration">
        <div className="clipboard">
          <i className="bi bi-clipboard-check"></i>
        </div>
        <div className="clock-badge">
          <i className="bi bi-clock"></i>
        </div>
      </div>
    </aside>
  )
}
