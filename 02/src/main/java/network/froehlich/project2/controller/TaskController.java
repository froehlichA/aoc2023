package network.froehlich.project2.controller;

import network.froehlich.project2.calculator.Task1Calculator;
import network.froehlich.project2.calculator.Task2Calculator;
import network.froehlich.project2.service.TaskService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TaskController {

    private final TaskService taskService;

    private final Task1Calculator calculator1;

    private final Task2Calculator calculator2;

    public TaskController(TaskService taskService, final Task1Calculator calculator1, final Task2Calculator calculator2) {
        this.taskService = taskService;
        this.calculator1 = calculator1;
        this.calculator2 = calculator2;
    }

    @GetMapping("/task/1")
    public String task1() {
        return this.taskService.getResult(this.calculator1);
    }

    @GetMapping("/task/2")
    public String task2() {
        return this.taskService.getResult(this.calculator2);
    }
}
