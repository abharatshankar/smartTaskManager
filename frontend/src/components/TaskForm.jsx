import React from 'react'

export default function TaskForm({
  form,
  setForm,
  onSubmit,
  editingId,
  onCancelEdit,
  submitting
}) {
  return (
    <div className="card custom-card task-form-card" id="add-task">
      <h4 id="formTitle">
        <i className="bi bi-pencil-square"></i>
        {editingId ? 'Edit Task' : 'Add New Task'}
      </h4>

      <form onSubmit={onSubmit}>
        <div className="mb-3">
          <label className="form-label">Title</label>
          <input
            type="text"
            className="form-control"
            placeholder="Enter task title"
            value={form.title}
            onChange={(e) => setForm((s) => ({ ...s, title: e.target.value }))}
            required
          />
        </div>

        <div className="mb-3">
          <label className="form-label">Description</label>
          <textarea
            className="form-control"
            rows="3"
            placeholder="Enter task description"
            value={form.description}
            onChange={(e) => setForm((s) => ({ ...s, description: e.target.value }))}
          />
        </div>

        <div className="row">
          <div className="col-md-6 mb-3">
            <label className="form-label">Priority</label>
            <select
              className="form-select"
              value={form.priority}
              onChange={(e) => setForm((s) => ({ ...s, priority: e.target.value }))}
            >
              <option>High</option>
              <option>Medium</option>
              <option>Low</option>
            </select>
          </div>

          <div className="col-md-6 mb-3">
            <label className="form-label">Status</label>
            <select
              className="form-select"
              value={form.status}
              onChange={(e) => setForm((s) => ({ ...s, status: e.target.value }))}
            >
              <option>Pending</option>
              <option>In Progress</option>
              <option>Completed</option>
            </select>
          </div>
        </div>

        <div className="d-flex gap-2">
          <button type="submit" className="btn btn-primary add-btn flex-grow-1" disabled={submitting}>
            <i className={`bi ${submitting ? 'bi-arrow-repeat spin' : (editingId ? 'bi-check2' : 'bi-plus-lg')}`}></i>
            {submitting ? 'Saving...' : (editingId ? 'Update Task' : 'Add Task')}
          </button>
          {editingId && (
            <button type="button" className="btn btn-outline-secondary" onClick={onCancelEdit}>
              Cancel
            </button>
          )}
        </div>
      </form>
    </div>
  )
}
