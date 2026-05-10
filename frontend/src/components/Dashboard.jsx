import React, { useEffect, useMemo, useState } from 'react'
import { io } from 'socket.io-client'
import Sidebar from './Sidebar'
import TaskForm from './TaskForm'
import TaskTable from './TaskTable'
import StatsCard from './StatsCard'
import NotificationPanel from './NotificationPanel'
import { apiFetch } from '../api'

const socket = io(window.location.origin, { withCredentials: true })

const initialForm = {
  title: '',
  description: '',
  priority: 'Medium',
  status: 'Pending'
}

export default function Dashboard() {
  const [profile, setProfile] = useState({ username: 'User' })
  const [tasks, setTasks] = useState([])
  const [notifications, setNotifications] = useState([])
  const [editingId, setEditingId] = useState('')
  const [form, setForm] = useState(initialForm)
  const [submitting, setSubmitting] = useState(false)
  const [loading, setLoading] = useState(true)

  const analytics = useMemo(() => {
    const total = tasks.length
    const completed = tasks.filter((t) => t.status === 'Completed').length
    const pending = total - completed
    const pct = total === 0 ? 0 : Math.round((completed / total) * 100)
    return { total, completed, pending, pct }
  }, [tasks])

  function pushNotification(text, type = 'info') {
    setNotifications((prev) => [{ id: crypto.randomUUID(), text, type }, ...prev].slice(0, 8))
  }

  async function refreshAll() {
    const [me, taskData] = await Promise.all([
      apiFetch('/api/auth/me'),
      apiFetch('/api/tasks')
    ])
    setProfile({ username: me.username })
    setTasks(taskData)
  }

  useEffect(() => {
    const init = async () => {
      try {
        await refreshAll()
      } catch (err) {
        window.location.href = '/login'
        return
      } finally {
        setLoading(false)
      }
    }

    init()

    socket.on('task_update', (payload) => {
      if (payload?.message) {
        pushNotification(`🔔 ${payload.message}`, 'info')
      }
      refreshAll().catch(() => {})
    })

    return () => {
      socket.off('task_update')
    }
  }, [])

  async function handleSubmit(e) {
    e.preventDefault()
    setSubmitting(true)

    try {
      if (!form.title.trim()) {
        pushNotification('Task title is required', 'warning')
        return
      }

      const url = editingId ? `/api/tasks/${editingId}` : '/api/tasks'
      const method = editingId ? 'PUT' : 'POST'

      const saved = await apiFetch(url, {
        method,
        body: JSON.stringify(form)
      })

      pushNotification(
        editingId
          ? `✏️ Task "${saved.title}" updated successfully`
          : `📌 Task "${saved.title}" added successfully`,
        'success'
      )

      setForm(initialForm)
      setEditingId('')
      await refreshAll()
    } catch (err) {
      pushNotification(err.message || 'Task operation failed', 'warning')
    } finally {
      setSubmitting(false)
    }
  }

  async function handleDelete(taskId) {
    try {
      await apiFetch(`/api/tasks/${taskId}`, { method: 'DELETE' })
      pushNotification('🗑️ Task deleted successfully', 'warning')
      if (editingId === String(taskId)) {
        setEditingId('')
        setForm(initialForm)
      }
      await refreshAll()
    } catch (err) {
      pushNotification(err.message || 'Task deletion failed', 'warning')
    }
  }

  function handleEdit(task) {
    setEditingId(String(task.id))
    setForm({
      title: task.title || '',
      description: task.description || '',
      priority: task.priority || 'Medium',
      status: task.status || 'Pending'
    })
    pushNotification(`✏️ Editing "${task.title}"`, 'info')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  async function handleLogout() {
    try {
      await apiFetch('/api/auth/logout', { method: 'POST' })
    } catch {}
    window.location.href = '/login'
  }

  if (loading) {
    return (
      <div className="loading-screen">
        <div className="spinner"></div>
      </div>
    )
  }

  return (
    <div className="layout" id="dashboard">
      <Sidebar onLogout={handleLogout} />

      <main className="main-content">
        <div className="topbar">
          <div>
            <h1>Dashboard</h1>
            <p>Welcome back, {profile.username} 👋</p>
          </div>

          <div className="topbar-right">
            <div className="notification-bell">
              <i className="bi bi-bell"></i>
              <span className="badge-dot">{notifications.length || 3}</span>
            </div>
            <div className="profile-pill">
              <div className="avatar">{profile.username?.[0]?.toUpperCase() || 'M'}</div>
              <span>{profile.username}</span>
              <i className="bi bi-chevron-down"></i>
            </div>
          </div>
        </div>

        <div className="top-grid">
          <TaskForm
            form={form}
            setForm={setForm}
            onSubmit={handleSubmit}
            editingId={editingId}
            onCancelEdit={() => { setEditingId(''); setForm(initialForm) }}
            submitting={submitting}
          />

          <div className="analytics-wrapper">
            <div className="analytics-grid" id="analytics">
              <StatsCard
                tone="blue"
                icon={<i className="bi bi-clipboard-data-fill"></i>}
                title="Total Tasks"
                value={analytics.total}
                subtitle="All tasks created"
              />
              <StatsCard
                tone="green"
                icon={<i className="bi bi-check-circle-fill"></i>}
                title="Completed Tasks"
                value={analytics.completed}
                subtitle="Completed tasks"
              />
              <StatsCard
                tone="orange"
                icon={<i className="bi bi-clock-fill"></i>}
                title="Pending Tasks"
                value={analytics.pending}
                subtitle="Tasks in progress"
              />
              <StatsCard
                tone="purple"
                icon={<i className="bi bi-graph-up-arrow"></i>}
                title="Completion Percentage"
                value={`${analytics.pct}%`}
                subtitle="Overall completion"
              />
            </div>

            <div className="card custom-card chart-card">
              <h5>Task Completion Overview</h5>
              <div className="progress-wrapper">
                <div
                  className="circle"
                  style={{
                    background: `conic-gradient(#22c55e ${analytics.pct}%, #f59e0b ${analytics.pct}% 100%)`
                  }}
                >
                  <span>{analytics.pct}%</span>
                </div>

                <div className="legend">
                  <p><span className="dot green-dot"></span> Completed <span>{analytics.completed}</span></p>
                  <p><span className="dot orange-dot"></span> Pending <span>{analytics.pending}</span></p>
                  <p className="total-line">Total <strong>{analytics.total}</strong></p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="bottom-grid">
          <TaskTable tasks={tasks} onEdit={handleEdit} onDelete={handleDelete} />
          <NotificationPanel notifications={notifications} />
        </div>

        <footer className="footer-note">© 2025 Smart Task Manager. All rights reserved.</footer>
      </main>
    </div>
  )
}
