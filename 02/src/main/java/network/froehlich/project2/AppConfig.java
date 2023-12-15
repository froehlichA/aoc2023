package network.froehlich.project2;

import network.froehlich.project2.calculator.Task1Calculator;
import network.froehlich.project2.calculator.Task2Calculator;
import network.froehlich.project2.parser.GameCollectionParser;
import network.froehlich.project2.service.TaskService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class AppConfig {

    @Bean
    public GameCollectionParser gameCollectionParser() {
        return new GameCollectionParser();
    }

    @Bean
    public TaskService taskService() {
        return new TaskService();
    }

    @Bean
    public Task1Calculator task1Calculator() throws IOException {
        return new Task1Calculator(this.gameCollectionParser());
    }

    @Bean
    public Task2Calculator task2Calculator() throws IOException {
        return new Task2Calculator(this.gameCollectionParser());
    }

}
