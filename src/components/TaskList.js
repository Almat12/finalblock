import React from 'react';
import TaskItem from './TaskItem';

const TaskList = ({ tasks, markComplete }) => {
  return (
    <ul>
      {tasks.map((task) => (
        <TaskItem key={task.id} task={task} markComplete={markComplete} />
      ))}
    </ul>
  );
};

export default TaskList;
