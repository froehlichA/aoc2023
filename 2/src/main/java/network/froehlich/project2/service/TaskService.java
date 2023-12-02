package network.froehlich.project2.service;

import network.froehlich.project2.calculator.Calculator;

public class TaskService implements Service {
    @Override
    public String getResult(Calculator calculator) {
        return calculator.getResult();
    }
}
