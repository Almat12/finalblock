import React from 'react';

const TaskItem = ({ task, markComplete }) => {
  return (
    <li style={{ textDecoration: task.completed ? 'line-through' : 'none' }}>
      <input
        type="checkbox"
        onChange={() => markComplete(task.id)}
        checked={task.completed}
      />
      {task.text}
    </li>
  );
};

export default TaskItem;