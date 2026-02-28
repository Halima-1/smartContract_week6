// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;


contract Todo {
    
struct Task{
uint8 id;
string title;
bool isComplete;
uint timestamp;
}

Task [] public tasks;
uint8 todo_id;
function addTask(string memory _title) public{
    todo_id = todo_id +1;
    Task memory task =(Task({id: todo_id, title:_title, isComplete:false, timestamp:0}));
    tasks.push(task);
}

// getting the tasks
function getTask () external view returns (Task[] memory){
    return tasks;
}

// to mark complete task
function markComplete (uint8 _id)external {
for (uint8 i; i < tasks.length; i++){
    if(tasks[i].id == _id){
        tasks[i].isComplete =true;
        tasks[i].timestamp =block.timestamp;
    }
}
}

// to delete task

function deleteTask(uint8 _id) external{
    for(uint8 i; i < tasks.length; i++){
        if(tasks[i].id == _id){
            tasks[i] = tasks[tasks.length - 1];
            tasks.pop();
        }
    }
}

// to update tasks
function updateTask(uint8 _id, string memory _title) external {
for (uint8 i; i < tasks.length; i++){
    if (tasks[i].id == _id){
        tasks[i].title = _title;
        break;
    }
}
}
}
