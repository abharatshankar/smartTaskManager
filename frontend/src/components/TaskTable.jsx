import React from 'react'

function priorityBadge(priority) {
  if (priority === 'High') return 'badge-priority high'
  if (priority === 'Low') return 'badge-priority low'
  return 'badge-priority medium'
}

function statusBadge(status) {
  if (status === 'Completed') return 'badge-status completed'
  if (status === 'In Progress') return 'badge-status progress'
  return 'badge-status pending'
}

export default function TaskTable({ tasks, onEdit, onDelete }) {
  return (
    <div className="card custom-card task-table-card" id="tasks">
      <div className="table-header-row">
        <h4>Your Tasks</h4>
      </div>

      <div className="table-responsive">
        <table className="table align-middle">
          <thead>
            <tr>
              <th>#</th>
              <th>Title</th>
              <th>Description</th>
              <th>Priority</th>
              <th>Status</th>
              <th>Created Date</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {tasks.length === 0 ? (
              <tr>
                <td colSpan="7" className="empty-row">
                  No tasks yet. Add your first task from the form.
                </td>
              </tr>
            ) : tasks.map((task, index) => (
              <tr key={task.id}>
                <td>{index + 1}</td>
                <td>{task.title}</td>
                <td>{task.description || ''}</td>
                <td><span className={priorityBadge(task.priority)}>{task.priority}</span></td>
                <td><span className={statusBadge(task.status)}>{task.status}</span></td>
                <td>{task.created_date}</td>
                <td className="action-cell">
                  <button className="icon-btn edit" type="button" onClick={() => onEdit(task)} title="Edit">
                    <i className="bi bi-pencil-square"></i>
                  </button>
                  <button className="icon-btn delete" type="button" onClick={() => onDelete(task.id)} title="Delete">
                    <i className="bi bi-trash"></i>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}
