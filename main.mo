actor TaskManager {
    type TaskId = Nat;
    type Task = {
        id: TaskId;
        description: Text;
        completed: Bool;
    };

    var tasks: [Task] = [];
    var nextId: TaskId = 0;

    public shared func addTask(description: Text): TaskId {
        let newTask: Task = {
            id = nextId;
            description = description;
            completed = false;
        };
        tasks := Array.append(tasks, [newTask]);
        nextId := nextId + 1;
        return newTask.id;
    };

    public query func getTasks(): [Task] {
        return tasks;
    };

    public shared func completeTask(id: TaskId): async ?Task {
        let taskOpt = Array.find(tasks, func(task) { task.id == id });
        switch (taskOpt) {
            case (?task) {
                let updatedTask: Task = {
                    id = task.id;
                    description = task.description;
                    completed = true;
                };
                tasks := Array.map(tasks, func(t) {
                    if (t.id == id) { updatedTask } else { t }
                });
                return ?updatedTask;
            };
            case null {
                return null;
            };
        }
    };
};
